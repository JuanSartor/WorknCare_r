<?php

$this->start();
$manager = $this->getManager("ManagerProgramaSaludMedicoReferente");
// $manager->debug();
$result = $manager->delete($this->request["idprograma_medico_referente"],true);
$this->finish($manager->getMsg());
