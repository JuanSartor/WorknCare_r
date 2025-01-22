<?php

$ManagerConsultaExpress=$this->getManager("ManagerConsultaExpress");
$result=$ManagerConsultaExpress->processConsultaExpressStep2ProfesionalRed($this->request);
$this->finish($ManagerConsultaExpress->getMsg());

