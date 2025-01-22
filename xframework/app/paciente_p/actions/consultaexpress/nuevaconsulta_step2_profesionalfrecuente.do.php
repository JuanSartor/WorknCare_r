<?php

$ManagerConsultaExpress=$this->getManager("ManagerConsultaExpress");
$result=$ManagerConsultaExpress->processConsultaExpressStep2ProfesionalFrecuente($this->request);
$this->finish($ManagerConsultaExpress->getMsg());

