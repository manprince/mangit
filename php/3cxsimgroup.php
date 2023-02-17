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
<?php echo date('Y-m-d h:i:s'); ?>
  <?php
  $conn_string = "host=172.255.160.20 port=5480 dbname=database_single user=phonesystem password=tMoJJn7wFz30s options='--client_encoding=UTF8'";
  $dbconn = pg_connect($conn_string);
  if(!$dbconn) {
      echo "Error: Unable to open database\n";
      } else {
      echo "Opened database successfully\n";
      }
  
  $sql="select g.idgrp ,g.name,e.fkiddn ,e.authid
fromgrp g
inner join dngrp d on
	 g.idgrp = d.fkidgrp
inner join extension e on 
    e.fkiddn =d.fkiddn 
where
	d.fkidgrp in (86,87,88,89,90,91,92,93)";
  
  $selectqq = pg_query($sql) or die('Query failed: ' . pg_last_error());
  while($row = pg_fetch_assoc($selectqq)){


  ?>
  <table class="table" border="0" cellspacing="0" cellpadding="0" style="font-size:25pt;">
    <td colspan="5" style="text-align: center">สรุป ตาราง Ticker ค้าง update <?php echo date('Y-m-d h:i:s'); ?></td>
    <tr>
      <th text-align: center;>FirstName</th>
      <th text-align: center;>Lastname</th>
      <th text-align: center;>Team</th>
      <th text-align: center;>Progress</th>
      <th text-align: center;>Pending</th>
      <th text-align: center;>details</th>
      <th text-align: center;></th>
      <th text-align: center;></th>
    <tr>
      <?php
      if ($result = pg_query($sql)) {
        while ($row = pg_fetch_assoc($selectqq)) {
          $field1name = $row["idgrp"];
          $field2name = $row["name"];
          $field3name = $row["fkiddn"];
          $field4name = $row["authid"];
   
		  echo '<tr> 
                  <td>' . $field1name . '</td> 
                  <td>' . $field2name . '</td> 
                  <td>' . $field3name . '</td> 
                  <td>' . $field4name . '</td> 
      
              </tr>';
        }
        $result->free();
      }

      ?>
  </table>
</body>

</html>
