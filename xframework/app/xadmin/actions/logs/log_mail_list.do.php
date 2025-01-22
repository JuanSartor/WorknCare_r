<?php

$manager = $this->getManager("ManagerMail");

$records = $manager->getListadoJSON($this->request, $manager->getDefaultPaginate());

echo $records;
?>
