<?php

/**
 *  cargar video
 */
//print_r($this->request);
$Manager = $this->getManager("ManagerVideoCapsula");

if ($this->request["banderaGenerica"] == '0') {
    $result = $Manager->processVideo($this->request);
} else {
    $result = $Manager->processVideoGenerico($this->request);
}
$msje = $Manager->getMsg();

$dir = $url . "entreprises/capsuleresready/" . $msje["hash"] . ".html";
header("Location:" . $dir);
exit;

//$this->finish($Manager->getMsg());
