<html>

<head>
  <title>Ticker Monitor Support </title>
</head>
<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
<meta http-equiv="refresh" content="5" />
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>

<body>
  <?php
  //connection_aborted
  $server = "172.255.152.112";
  $username = "glpi";
  $password = "glpi";
  $database = "glpi";
  $mysqli = new mysqli($server, $username, $password, $database);
  //test qurey table php support infra gov

  $sumsql = "SELECT * FROM glpi.sumticket order by g_name,total,firstname";

  ?>
  <table class="table" border="0" cellspacing="0" cellpadding="0" style="font-size:25pt;">
    <td colspan="5" style="text-align: center">สรุป ตาราง Ticker ค้าง update <?php echo date('Y-m-d h:i:s'); ?></td>
    <tr>
      <th text-align: center;>FirstName</th>
      <th text-align: center;>Lastname</th>
      <th text-align: center;>Team</th>
      <th text-align: center;>Progress</th>
      <th text-align: center;>Pending</th>
      <th text-align: center;></th>
      <th text-align: center;></th>
      <th text-align: center;></th>
    <tr>
      <?php
      if ($result = $mysqli->query($sumsql)) {
        while ($row = $result->fetch_assoc()) {
          $field1name = $row["firstname"];
          $field2name = $row["realname"];
          $field3name = $row["g_name"];
          $field4name = $row["assig"];
          $field5name = $row["pend"];
          $sumQuery = mysql_query($sumsql) or die("Error Query [" . $sumsql . "]");
          echo "<tr> 
                  <td>' . $field1name . '</td> 
                  <td>' . $field2name . '</td> 
                  <td>' . $field3name . '</td> 
                  <td>' . $field4name . '</td> 
                  <td>' . $field5name . '</td> 
              </tr>";
        }
        $result->free();
      }

      ?>
  </table>
</body>

</html>