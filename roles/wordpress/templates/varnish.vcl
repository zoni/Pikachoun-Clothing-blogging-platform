backend default {
    .host = "127.0.0.1";
    .port = "{{ wordpress_http_to_fastscgi_port }}";
}

acl purge {
    "127.0.0.1";
}

sub vcl_recv {
  if (req.request == "PURGE") {
    if (!client.ip ~ purge) {
      error 405 "Not allowed.";
    }
    return (lookup);
  }
 
  if (req.url ~ "\.(gif|jpg|jpeg|swf|css|js|flv|mp3|mp4|pdf|ico|png)(\?.*|)$") {
    unset req.http.cookie;
    set req.url = regsub(req.url, "\?.*$", "");
  }

  if (req.url ~ "\?(utm_(campaign|medium|source|term)|adParams|client|cx|eid|fbid|feed|ref(id|src)?|v(er|iew))=") {
    set req.url = regsub(req.url, "\?.*$", "");
  }

  if (req.url ~ "wp-(login|admin)" || req.url ~ "preview=true" || req.url ~ "xmlrpc.php" || req.url ~ "/no-cache-") {
    return (pass);
  }

  if (req.http.cookie) {
    if (req.http.cookie ~ "(wordpress_|wp-settings-)") {
      return(pass);
    } else {
      unset req.http.cookie;
    }
  }
}

sub vcl_fetch {
  set beresp.grace = {{ wordpress_varnish_grace }};
  if (beresp.status == 500) {
      set beresp.saintmode = 5s;
      return(restart);
  }

  if ( (!(req.url ~ "(wp-(login|admin)|login)")) || (req.request == "GET") ) {
    unset beresp.http.set-cookie;
    set beresp.ttl = {{ wordpress_varnish_ttl }};
  }

  if (req.url ~ "\.(gif|jpg|jpeg|swf|css|js|flv|mp3|mp4|pdf|ico|png)(\?.*|)$") {
    set beresp.ttl = 365d;
  }

  if (!(beresp.status == 200 || beresp.status == 301)) {
    set beresp.ttl = 5s;
  }
}

sub vcl_deliver {
   if (obj.hits > 0) {
     set resp.http.X-Cache = "HIT";
   } else {
     set resp.http.X-Cache = "MISS";
   }
}
sub vcl_hit {
  if (req.request == "PURGE") {
    purge;
    error 200 "OK";
  }
}

sub vcl_miss {
  if (req.request == "PURGE") {
    purge;
    error 404 "Not cached";
  }
}

sub vcl_hash {
    hash_data(req.url);
    hash_data(req.http.host);
    hash_data(req.http.X-Forwarded-Proto);
}
