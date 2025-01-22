<?php

$manager = $this->getManager("ManagerCapsula");
//$manager->debug();
$manager->update(["estado" => "3"], $this->request["idcapsula"]);

$this->finish($manager->getMsg());

