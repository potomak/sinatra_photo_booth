<?PHP
//This project is done by vamapaull: http://blog.vamapaull.com/
//The php code is done with some help from Mihai Bojin: http://www.mihaibojin.com/

$DirPath = "../images/";

if (($handle = opendir($DirPath))) {
  $files = array();
  $times = array();
  while ($node = readdir($handle)) {
    $nodebase = basename($node);
    if ($nodebase != "." && $nodebase != "..") {
      if(!is_dir($DirPath.$node)) {
        $jpg = strrpos($node,".jpg");
        $png = strrpos($node,".png");
        if($jpg === false && $png === false) {}
        else {
          //export to xml
          $filestat = stat($DirPath.$node);
          $times[] = $filestat['mtime'];
          $files[] = $DirPath.$node;
          array_multisort($times, SORT_NUMERIC, SORT_DESC, $files);
        }
      }
    }
  }
}

$mydir_list = "";

foreach($files as $file) {
  $mydir_list.="<image src=\"".$file."\" />\n";
}

echo $mydir_list;

?>