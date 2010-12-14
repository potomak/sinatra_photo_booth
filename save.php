<?php
//This project is done by vamapaull: http://blog.vamapaull.com/
//The php code is done with some help from Mihai Bojin: http://www.mihaibojin.com/

if(isset($GLOBALS["HTTP_RAW_POST_DATA"])){
	$jpg = $GLOBALS["HTTP_RAW_POST_DATA"];
	$img = $_GET["img"];
	//$filename = "images/poza_". mktime(). ".jpg";
	$filename = "images/poza_". mktime(). ".png";
	file_put_contents($filename, $jpg);
} else{
	echo "Encoded JPEG information not received.";
}
?>