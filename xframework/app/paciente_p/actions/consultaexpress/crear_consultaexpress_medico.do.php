<?php

$ManagerConsultaExpress=$this->getManager("ManagerConsultaExpress");

$result=$ManagerConsultaExpress->createConsultaExpressByMedico($this->request["medico_idmedico"]);
$this->finish($ManagerConsultaExpress->getMsg());


