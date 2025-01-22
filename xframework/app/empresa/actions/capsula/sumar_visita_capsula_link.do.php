<?php

$managerV = $this->getManager("ManagerCapsulaRegistroVisitas");
$reqV["capsula_idcapsula"] = $this->request["idcapsula"];
$managerV->process($reqV);
$manager = $this->getManager("ManagerCapsula");
$capsula = $manager->get($this->request["idcapsula"]);
$rdoSum = $capsula["cant_visitas"] + 1;
$manager->update(["cant_visitas" => $rdoSum], $capsula["idcapsula"]);

