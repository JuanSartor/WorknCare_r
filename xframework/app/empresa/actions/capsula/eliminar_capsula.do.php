<?php


$manager = $this->getManager("ManagerCapsula");
//$manager->debug();
$manager->update(["estado" => "4"], $this->request["idcapsula"]);

$this->finish($manager->getMsg());


