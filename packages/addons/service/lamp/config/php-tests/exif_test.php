<img src="test1.jpg" alt="sample exif image"><br/>
<b>EXIF data for image: test1.jpg</b><br/>
<?php
	// http://www.exiv2.org/sample.html
	$exif = exif_read_data('test1.jpg', 0, true);
	foreach ($exif as $key => $section) {
	    foreach ($section as $name => $val) {
	        echo "$key.$name: $val<br />\n";
	    }
	}
?>
