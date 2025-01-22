<?php

$manager = $this->getManager("ManagerLogSMS");

$records = $manager->getListadoJSON($this->request, $manager->getDefaultPaginate());

echo $records;
?>
