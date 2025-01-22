<?php

$ManagerConsultaExpress=$this->getManager("ManagerConsultaExpress");
$result=$ManagerConsultaExpress->processConsultaExpressStep1($this->request);
$this->finish($ManagerConsultaExpress->getMsg());

