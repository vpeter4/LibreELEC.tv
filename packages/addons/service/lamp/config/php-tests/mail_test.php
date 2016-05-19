<?php 
  ini_set( 'display_errors', 1 );
  error_reporting( E_ALL );
  
  $from = "user@gmail.com";
  $to = "user@gmail.com";
  $subject = "PHP Mail Test script";
  $message = "This is a test to check the PHP Mail functionality";
  $headers = "From:" . $from;
  if (mail($to,$subject,$message, $headers))
    echo 'Mail sent';
  else
    echo 'Error. Please check error log.';
?>
