<?php

$this->start();
$manager = $this->getManager("ManagerProgramaSaludMedicoComplementario");
// $manager->debug();
$result = $manager->delete($this->request["idprograma_medico_complementario"],true);
$this->finish($manager->getMsg());
