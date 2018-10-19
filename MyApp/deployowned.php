<?php

$connect = mysqli_connect("localhost", "team063", "team063");
if (!$connect) {
    die("Failed to connect to database");
}
mysqli_select_db($connect, "cs6400_team063") or die("Unable to select database");

session_start();
if (!isset($_SESSION['incidentID'])) {
    print '<p class="error">Error: No incidentID provided </p>';
    exit();
}

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
//if (isset($_POST['submit'])) {
    $resourceID = $_GET['ID'];
    // validate returnBy format and it is after current date
    if (is_date($_POST['returnBy']) && strtotime($_POST['returnBy']) > strtotime('now') ) {
        $returnBy = $_POST['returnBy'];
    }
    else {
        print '<p class="error">Error: Provide valid date </p>';
        exit();
    }

    $query = "INSERT INTO Request (incidentID_Req, resourceID_Req, returnBy) ".
        "VALUES ('{$_SESSION['incidentID']}', '$resourceID', '$returnBy')";
    if (!mysqli_query($connect, $query)) {
        print '<p class="error">Error: Failed to submit the request. ' . mysqli_error($connect) . '</p>';
        exit();
    }
    $requestID = mysqli_insert_id($connect);
    $startDate = date('Y-m-d');
    $query = "INSERT INTO Deploy (requestID_D, startDate_D) ".
        "VALUES ('$requestID', '$startDate') ";
    if (!mysqli_query($connect, $query)) {
        print '<p class="error">Error: Failed to deploy the request. ' . mysqli_error($connect) . '</p>';
        exit();
    }
    $availableDate = date('Y-m-d', strtotime($returnBy ." + 1 days"));
    $query = "UPDATE Resource ".
        "SET status =  'in use', availableDate = '$availableDate' ".
        "WHERE resourceID = '$resourceID'";
    if (!mysqli_query($connect, $query)) {
        print '<p class="error">Error: Failed to update the resource status. ' . mysqli_error($connect) . '</p>';
        exit();
    }
    echo "<script>window.close();</script>";
}

function is_date($date)
{
    $d = DateTime::createFromFormat('Y-m-d', $date);
    return $d && $d->format('Y-m-d') === $date;
}

?>

<html>
<body>
<form action="" method="post">
    Return By: <input type="text" name="returnBy"><br>
    <input type="submit" name="submit" value="Deploy">
    <input type=button onClick="self.close();" value="Cancel">
</form>

</body>
</html>