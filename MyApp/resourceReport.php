<?php
$connect = mysqli_connect("localhost", "team063", "team063", "cs6400_team063");
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

    $query = "select ESF.ESFNumber, ESF.ESFDescription, coalesce(tot.ResTotal, 0) as 'ResourceTot', coalesce(inuse.ResInUse, 0) as 'ResourceInUse' " .
        " from " .
        "	ESF " .
        " left join " .
        " 	(select ESFNumber, ESFDescription, count(status) AS 'ResInUse' from Resource JOIN ESF on ESFNumber=esfNumber_R where status='in use' AND username_R = '".$_SESSION['username']."' GROUP BY ESFNumber) inuse " .
        " on " .
        "     ESF.ESFNumber = inuse.ESFNumber " .
        " left join " .
        " 	(select ESFNumber, ESFDescription, count(*) AS 'ResTotal' from Resource JOIN ESF on ESFNumber=esfNumber_R where username_R = '".$_SESSION['username']."' GROUP BY ESFNumber) tot " .
        " on " .
        "      ESF.ESFNumber = tot.ESFNumber ORDER BY ESF.ESFNumber;";


    $result = mysqli_query($connect, $query);



    if (!$result) {
        print "<p>Error: No data returned from database. </p>";

    }


?>

<!DOCTYPE html>
<html>

    <head>
        <title>Resource Status</title>
        <link rel="stylesheet" type="text/css" href="style.css"/>
    </head>
        <body>


        <div id="main_container">

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

        <div id="header">

            <div class="logo"><img src="images/ERMS.png" border="0" alt="" title=""/>
            <h1><font color='white'>Resource Report</font></h1>

            </div>



            <div class="center_content">

            <center><h2>Resource Report by Primary Emergency Support Funciton</h2>


         <?php

            print   "<table border='1' class = 'searchresults' width='80%'>";
            print    "<tr>";
            print    "<th align='left'>#</th>";
            print    "<th>Primary Emergency Support Function</th>";
            print    "<th>Total Resources</th>";
            print    "<th>Resources in Use</th>";
            print    "</tr>";

                $res_total = 0;
                $res_inuse = 0;


        while ($row = mysqli_fetch_array($result)) {
            print "<tr>";
            print "<td align='center' style='padding-right: 70px'>" . $row['ESFNumber'] . "</td>";
            print "<td align='left'>" . $row['ESFDescription'] . "</td>";
            print "<td align='center'>" . $row['ResourceTot'] . "</td>";
            print "<td align='center'>" . $row['ResourceInUse'] . "</td>";
            print "</tr>";
                $res_total += $row['ResourceTot'];
                $res_inuse += $row['ResourceInUse'];
        }


             print   '<tr>';
             print    '<th> </th>';
             print    "<th>total</th>";
             print    "<th>$res_total</th>";
             print    "<th>$res_inuse</th>";
             print "</tr>";


            print  "</table>";


?>

                </center>
        </div>

</div>

</body>
</html>