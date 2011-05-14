<?php
/**
 * Utility Functions
 * *****************
 * wb_connect()     : mysql_connect() with error handling
 * run_query($query): mysql_query() with error handling
 * 
 */

function secretKeySalt() {
	return 'J3t92YHE7kqLCx37cCX0iwnIBinbXXRw9Qb6sSZAVF5BL6IE7VJpUPXbszZcdCe';
}

function flagThreshold() {
	return 1;
}

function wb_connect() {
	$dbhost = 'mysql50-84.wc2.dfw1.stabletransit.com';
	$dbuser = '549152_whiteboar';
	$dbpass = 'ZGY6AWWGheBEZRpsZDsk';
	$dbname = '549152_whiteboardg';
	
	// TODO: return -1 on error?
	$conn = @mysql_connect($dbhost, $dbuser, $dbpass);
	if (!$conn) {
		die('error code 157. failed connecting to database');
	}
	mysql_select_db($dbname);
	return $conn;
}

function run_query($query) {
	//echo 'QUERY = ' . $query . '<br>';
	$result = mysql_query($query);
	if (!$result) {
		//echo 'Could not run query: '.$query."<br>\n";
		echo 'MySQL error: '.mysql_error();
		exit;
	}
	return $result;
}

function wp_connect() {
	$dbhost = 'mysql50-84.wc2.dfw1.stabletransit.com';
	$dbuser = '549152_wpu';
	$dbpass = 'EvmD9EBfLj5k6hs9aqzC';
	$dbname = '549152_wpuser';
	
	// TODO: return -1 on error?
	$conn = @mysql_connect($dbhost, $dbuser, $dbpass);
	if (!$conn) {
		die('error code 158. failed connecting to database, ' . mysql_error());
	}
	mysql_select_db($dbname);
	return $conn;
}


function style($option = 'default') {
	if ($option == 'default') {
		return '	<style>
			.drawingbox {
				display:inline-block;
				width:280px;
				height:500px;
				background-color:#EFEFEF;
				text-align:center;
				margin-left:5px;
				margin-top:5px;
				vertical-align: top;
			}
			body {
				margin:0 0 0 0;
			}
			</style>';
	} else {
		return '	<style>
			.drawingbox {
				display:inline-block;
				width:180px;
				height:350px;
				background-color:#EFEFEF;
				text-align:center;
				margin-left:5px;
				margin-top:5px;
				vertical-align: top;
			}
			body {
				margin:0 0 0 0;
			}
			</style>';
	}
}

function admin_logged_in() {
	$logged_in = false;
	$secret_value = 'Dvba06YxTN4NwghOjb3JVBWt53iI';
	if ($_COOKIE['admin_cookie']) {
		if ($_COOKIE['admin_cookie'] === $secret_value) {
			echo 'Already logged in<br>';
			$logged_in = true;
		} else {
			echo 'Cookie set, but invalid<br>';
		}
	}
	return $logged_in;
}

function admin_auth_username_password($username, $password) {
    return TRUE;
}

function admin_auth_logged_in_id() {
    return 1;
}

function drawing_change_log($userid, $drawingid, $change) {
    $query = sprintf(
           
            "INSERT INTO drawing_change_log (userid, drawingid, change_log) VALUES ('%s', '%s', '%s')",
            mysql_real_escape_string($userid),
            mysql_real_escape_string($drawingid),
            mysql_real_escape_string($change)
    );
    echo $query . "<br>";
    run_query($query);
}
