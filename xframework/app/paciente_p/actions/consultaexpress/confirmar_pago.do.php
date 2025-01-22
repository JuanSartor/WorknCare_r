<?php

$ManagerConsultaExpress=$this->getManager("ManagerConsultaExpress");
$result=$ManagerConsultaExpress->confirmarPago($this->request);
$this->finish($ManagerConsultaExpress->getMsg());

