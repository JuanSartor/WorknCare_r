<?php

$this->start();

$manager=$this->getManager("ManagerMedicoPrestador");

$manager->respuesta_invitacion_prestador($this->request);
$this->finish($manager->getMsg());