<?php

  $link = mysql_connect('localhost', 'root', '123');
  if (!$link) {
    die('Could not connect: ' . mysql_error());
  }

  $sql = 'CREATE DATABASE php_test_db';
  if (mysql_query($sql, $link)) {
    echo "Database php_test_db created successfully<br>\n";
  } else {
    echo 'Error creating database php_test_db: ' . mysql_error() . "<br>\n";
  }


  if (mysql_select_db("php_test_db")) {
    echo "Database selected successfully<br>\n";
  } else {
    echo 'Error selecting database: ' . mysql_error() . "<br>\n";
  }

  if (mysql_query("CREATE TABLE sample_table(id INT NOT NULL AUTO_INCREMENT,
                   PRIMARY KEY(id),
                   name VARCHAR(30),
                   age INT)")) {
    echo "Table sample_table created<br>\n";
  } else {
    echo 'Error creating table sample_table: ' . mysql_error() . "<br>\n";
  }

  // Insert a row of information into the table "example"
  if (mysql_query("INSERT INTO sample_table (name, age) VALUES('lamp_user', '12345' ) ")) {
    echo "Data inserted into table<br>\n";
  } else {
    echo 'Error inserting data into table: ' . mysql_error() . "<br>\n";
  }

  $sql = 'DROP DATABASE php_test_db';
  if (mysql_query($sql, $link)) {
    echo "Database deleted successfully<br>\n";
  } else {
    echo 'Error deleting database: ' . mysql_error() . "<br>\n";
  }

  //////////////////////////////////////////////////////////////////////

  // Create connection
  $sql = mysqli_connect("localhost", "root", "123");

  // Check connection
  if (mysqli_connect_errno()) {
    echo "Failed to connect to MySQL: " . mysqli_connect_error();
  }

  /* print server version */
  printf("Server version: %s\n", $sql->server_info);
  echo "<p>";

  $query = "SHOW TABLES FROM information_schema";
  $result = $sql->query($query);
  if (!$result) {
    printf("Query failed: %s\n", $mysqli->error);
    exit;
  }

  while($row = $result->fetch_assoc()){
    print_r($row);
    echo $row['username'] . '<br />';
  }

  while($row = $result->fetch_row()) {
    $rows[]=$row;
  }
  $result->close();
  $sql->close();




  $connect=mysql_connect("localhost", "root", "123") or die("Unable to Connect");
  //$connect=mysql_connect("127.0.0.1:3306","root","123") or die("Unable to Connect");
  mysql_select_db("information_schema") or die("Could not open the db");
  $showtablequery="SHOW TABLES FROM information_schema";

  $query_result=mysql_query($showtablequery);

  while($showtablerow = mysql_fetch_array($query_result)) {
    echo $showtablerow[0]." ";
    echo "<p>";
  }
?>
