<?php

require_once(path_libs('libs_php/barcode-master/barcode.php'));
$generator = new barcode_generator();

$generator->output_image($this->request["f"],$this->request["s"],$this->request["d"],$this->request);


