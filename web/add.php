<?php
if ($_POST['title']) {
	include_once 'utility.php';
	
	// ...
	
	/*
	<label for="title">Title:</label> <input type="text" name="title" /><br />
<label for="description">Description:</label><br />
<textarea name="description" rows="20" cols="30" onfocus="this.value=''; this.onfocus=null;">We can list nonfinancial and nonenvironmental benefits here too. For example, less wear on clothes...</textarea>
<!--rows="10" cols="30"-->
<br />
<label for="setupcost">Setup cost:</label> <input type="text" name="setupcost" /><br />
<label for="setuptime">Setup time:</label> <input type="text" name="setuptime" /><br />
<label for="savings">Savings for each</label> <input type="text" name="eventname" value="event" />: <input type="text" name="savings" /><br />
<label for="eventspermonth">Typical # of events per month:</label> <input type="text" name="eventspermonth" /><br />
<label for="ongoingcost">Ongoing cost per event:</label> <input type="text" name="ongoingcost" /><br />
<label for="ongoingtime">Ongoing time per event:</label> <input type="text" name="ongoingtime" /><br />
	
	
	
	
	
	$model = $_POST['model'];
$deviceuid = $_POST['deviceuid'];
$date = $_POST['date'];
$validationSalt = 'aaaaaaaaaaaaaaaaaaaaaa';
$validationKey = md5($validationSalt . $model . $deviceuid . $date);
if ($validationKey != $_POST['validationKey'])
	die('Invalid data. Contact energysaver@greengar.com');

$link = wb_connect();
	
	
	
	$query = sprintf("INSERT INTO drawings (model, date, ip, deviceuid, md5) VALUES ('%s', '".date ("Y-m-d H:i:s")."', INET_ATON('".$_SERVER['REMOTE_ADDR']."'), '%s', '%s')",
		mysql_real_escape_string($model),
		//mysql_real_escape_string($date),
		mysql_real_escape_string($deviceuid),
		mysql_real_escape_string($new_md5));
	run_query($query);
	
	$count = mysql_insert_id();
	
	$uploaddir = './uploads/';
	$file = $count . '.png'; //basename($_FILES['userfile']['name']);
	$uploadfile = $uploaddir . $file;
	
	if (move_uploaded_file($_FILES['userfile']['tmp_name'], $uploadfile)) {
		//echo "http://www.aaaaaaaa.aaa/{$file}";
		// Echo a secret key based on the ID (ID.png) and Device UID so the user can add:
		// - Drawing title
		// - Artist name
		// - Description
		//$secretKeySalt = 'aaaaaaaaaaaaaaaaaaaaaaaa';
		$secretKey = md5(secretKeySalt() . $count . $deviceuid);
		echo $count . '|' . $secretKey;
	} else {
		echo 'Upload failed. Contact energysaver@greengar.com';
	}
	
	*/
	
} else {
?>
<style>
/*
html { overflow-y: scroll; background: #d9d3cf; }
*/
body { font: 18px/1.5 "myriad-pro-1","myriad-pro-2", HelveticaNeue, Helvetica, Arial, serif; }
/*
label {
        float: left;
        text-align: right;
        margin-right: 15px;
        width: 100px;
        display:block;
}
textarea:focus, input:focus {
        border: 2px solid #900;
}
*/
input.submitbutton {
/* ... */
}
</style>
<form method="post" action="add.php">
<label for="title">Title:</label> <input type="text" name="title" /><br />
<label for="description">Description:</label><br />
<textarea name="description" rows="20" cols="30" onfocus="this.value=''; this.onfocus=null;">We can list nonfinancial and nonenvironmental benefits here too. For example, less wear on clothes...</textarea>
<!--rows="10" cols="30"-->
<br />
<label for="setupcost">Setup cost:</label> <input type="text" name="setupcost" /><br />
<label for="setuptime">Setup time:</label> <input type="text" name="setuptime" /><br />
<label for="savings">Savings for each</label> <input type="text" name="eventname" value="event" />: <input type="text" name="savings" /> cents<br />
<label for="eventspermonth">Typical # of events per month:</label> <input type="text" name="eventspermonth" /><br />
<label for="ongoingcost">Ongoing cost per event:</label> <input type="text" name="ongoingcost" /><br />
<label for="ongoingtime">Ongoing time per event:</label> <input type="text" name="ongoingtime" /><br />
<input type="submit" name="mysubmit" class="submitbutton" value="Save EnergyBuster" style="font-size:24px; width:500px; height:50px" />
</form>


<?php
}
exit;
?>
