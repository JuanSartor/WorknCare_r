<?php

$ManagerConsultaExpress=$this->getManager("ManagerConsultaExpress");
$result=$ManagerConsultaExpress->cancelarPago($this->request);
$this->finish($ManagerConsultaExpress->getMsg());

