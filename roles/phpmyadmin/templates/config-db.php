<?php
# {{ ansible_managed }}

$dbuser='phpmyadmin';
$dbpass='{{ random_password.stdout }}';
$basepath='';
$dbname='phpmyadmin';
$dbserver='';
$dbport='';
$dbtype='mysql';
