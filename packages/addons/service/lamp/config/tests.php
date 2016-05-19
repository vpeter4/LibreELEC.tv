<html>
<head>
<title>LAMP tests</title>
</head>
<body>
<h1>LAMP tests</h1>

<?php
  $thisServerHttp = $_SERVER['SERVER_NAME'] . ':' . $_SERVER['SERVER_PORT'];
  $thisServerHttps = $_SERVER['SERVER_NAME'];
?>
  
<h2>HTTP</h1>
<a href="http://<?php echo $thisServerHttp; ?>/php-tests/phpinfo.php" target="_blank">phpinfo.php</a><br>
<a href="http://<?php echo $thisServerHttp; ?>/php-tests/exif_test.php" target="_blank">exif_test.php</a><br>
<a href="http://<?php echo $thisServerHttp; ?>/php-tests/db_test.php" target="_blank">db_test.php</a><br>
<a href="http://<?php echo $thisServerHttp; ?>/php-tests/mail_test.php" target="_blank">mail_test.php</a> fix msmtprc config file (restart httpd) and mail_test.php<br>
<a href="http://<?php echo $thisServerHttp; ?>/phpMyAdmin/index.php" target="_blank">phpMyAdmin/index.php</a>user/pass: root/123<br>

<br>
<h2>HTTPS</h1>
<a href="https://<?php echo $thisServerHttps; ?>/php-tests/phpinfo.php" target="_blank">phpinfo.php</a><br>
<a href="https://<?php echo $thisServerHttps; ?>/php-tests/exif_test.php" target="_blank">exif_test.php</a><br>
<a href="https://<?php echo $thisServerHttps; ?>/php-tests/db_test.php" target="_blank">db_test.php</a><br>
<a href="https://<?php echo $thisServerHttps; ?>/php-tests/mail_test.php" target="_blank">mail_test.php</a> fix msmtprc config file and mail_test.php<br>
<a href="https://<?php echo $thisServerHttps; ?>/phpMyAdmin/index.php" target="_blank">phpMyAdmin/index.php</a> user/pass: root/123<br>

</body>
</html>
