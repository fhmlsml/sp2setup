<?php

$db_host = "rdsendpoint";
$db_user = "valdbuser";
$db_pass = "valdbpass";
$db_name = "valdbname";

try {    
    //create PDO connection 
    $db = new PDO("mysql:host=$db_host;dbname=$db_name", $db_user, $db_pass);
} catch(PDOException $e) {
    //show error
    die("Terjadi masalah: " . $e->getMessage());
}
