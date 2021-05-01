<?php

$db_host = "rds_end_point";
$db_user = "val_db_user";
$db_pass = "val_db_pass";
$db_name = "val_db_name";

try {    
    //create PDO connection 
    $db = new PDO("mysql:host=$db_host;dbname=$db_name", $db_user, $db_pass);
} catch(PDOException $e) {
    //show error
    die("Terjadi masalah: " . $e->getMessage());
}
