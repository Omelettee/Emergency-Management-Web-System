<?php
$connect = mysqli_connect("localhost", "team063", "team063");
if (!$connect) {
    die("Failed to connect to database");
}
mysqli_select_db($connect, "cs6400_team063") or die("Unable to select database");

session_start();


if (!isset($_SESSION['username'])) {

    header('Location: login.php');
    exit();
} else {

    $username = $_SESSION['username'];

}


//find out current user's information

$query1 = "SELECT* FROM Individual WHERE username_Ind='{$_SESSION['username']}'";
$query2 = "SELECT* FROM Municipality WHERE username_M='{$_SESSION['username']}'";
$query3 = "SELECT* FROM Company WHERE username_C='{$_SESSION['username']}'";
$query4 = "SELECT* FROM GovermentAgency WHERE username_G='{$_SESSION['username']}'";


$result1 = mysqli_query($connect, $query1);
$result2 = mysqli_query($connect, $query2);
$result3 = mysqli_query($connect, $query3);
$result4 = mysqli_query($connect, $query4);

if (mysqli_num_rows($result1) > 0) {
    $row = mysqli_fetch_array($result1);
    $array_1 = "Hello!       " . $row[0];
    $array_2 = " Position: " . $row[1] . ", working from    " . $row[2] . "";
} elseif (mysqli_num_rows($result2) > 0) {
    $row = mysqli_fetch_array($result2);
    $array_1 = "Hello!       " . $row[0];
    $array_2 = " Population size:  " . $row[1];
} elseif (mysqli_num_rows($result3) > 0) {
    $row = mysqli_fetch_array($result3);
    $array_1 = "Hello!       " . $row[0];
    $array_2 = " Headquater Location:  " . $row[1];
} else {
    $row = mysqli_fetch_array($result4);
    $array_1 = "Hello!       " . $row[0];
    $array_2 = " Jurisdiction:  " . $row[1];
}


// if the info is not found out.

if (!$row) {
    print "<p>Error: No data returned from database. </p>";

}

?>


<!DOCTYPE html >
<html>
<head>
    <title>Main Menu</title>
    <link rel="stylesheet" type="text/css" href="style.css"/>
</head>

<body>

<div id="main_container">

         <div id="header">
            <div class="logo"><img src="images/ERMS.png" border="0" alt="" title=""/>

            </div>


        <div class="menu">
            <ul>

                <li><a href="XXXX">Add Resource</a></li>
                <li><a href="XXXX.php">Add Emergency Incident</a></li>
                <li><a href="searchresource.php">Search Resources</a></li>
                <li><a href="resourcestatus.php">Resources Status</a></li>
                <li><a href="resourceReport.php">Resource Report</a></li>
                <li><a href="logout.php">log out</a></li>

            </ul>
        </div>


        <div class="center_content">

            <center>
                <h1> Welcome to ERMS! </h1>
                <h3>   <?php echo $array_1 . "<br>";
                echo $array_2; ?> <h3>
            </center>
        </div>

    </div>
</body>
</html>				
