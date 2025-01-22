<?php

/**
 *  cargar video
 */
//print_r($this->request);
$Manager = $this->getManager("ManagerVideoCapsula");


$result = $Manager->processVideo($this->request);
$msje = $Manager->getMsg();


$dir = $url . "xadmin";
header("Location:" . $dir);
exit;





