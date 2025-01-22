<?php

$manager = $this->getManager("ManagerLog");

$records = $manager->getListadoJSON($this->request, $manager->getDefaultPaginate());

echo $records;
?>
