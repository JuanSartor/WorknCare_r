<?php

$ManagerConsultaExpress=$this->getManager("ManagerConsultaExpress");
$result=$ManagerConsultaExpress->publicarConsultaExpress($this->request);
$this->finish($ManagerConsultaExpress->getMsg());

