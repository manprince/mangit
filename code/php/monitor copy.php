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
          echo '<tr> 
                  <td>' . $field1name . '</td> 
                  '?>
                  <div class="panel panel-default">
    <div class="panel-heading" role="tab" id="headingOne">
      <h4 class="panel-title">
        <a role="button" data-toggle="collapse" data-parent="#accordion" href="#collapseOne" aria-expanded="true" aria-controls="collapseOne">
        <?php ' . $field1name . ' ?>
        </a>
      </h4>
    </div>
                  <?php '
                  <td>' . $field2name . '</td> 
                  <td>' . $field3name . '</td> 
                  <td>' . $field4name . '</td> 
                  <td>' . $field5name . '</td> 
              </tr>';
        }
        $result->free();
      }

      ?>
  </table>
</body>

</html>

    <div id="collapseOne" class="panel-collapse collapse in" role="tabpanel" aria-labelledby="headingOne">
      <div class="panel-body">
        Anim pariatur cliche reprehenderit, enim eiusmod high life accusamus terry richardson ad squid. 3 wolf moon officia aute, non cupidatat skateboard dolor brunch. Food truck quinoa nesciunt laborum eiusmod. Brunch 3 wolf moon tempor, sunt aliqua put a bird on it squid single-origin coffee nulla assumenda shoreditch et. Nihil anim keffiyeh helvetica, craft beer labore wes anderson cred nesciunt sapiente ea proident. Ad vegan excepteur butcher vice lomo. Leggings occaecat craft beer farm-to-table, raw denim aesthetic synth nesciunt you probably haven't heard of them accusamus labore sustainable VHS.
      </div>
    </div>
  </div>