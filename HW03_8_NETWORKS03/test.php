<?php
header( 'Content-Type: text/plain' );
echo 'Host: ' . $_SERVER['HTTP_HOST'] . "\n";
echo 'Remote Address: ' . $_SERVER['REMOTE_ADDR'] . "\n";
echo 'X-Forwarded-For: ' . $_SERVER['HTTP_X_FORWARDED_FOR'] . "\n";
echo 'X-Forwarded-Proto: ' . $_SERVER['HTTP_X_FORWARDED_PROTO'] . "\n";
echo 'Server Address: ' . $_SERVER['SERVER_ADDR'] . "\n";
echo 'Server Port: ' . $_SERVER['SERVER_PORT'] . "\n\n";
?>
