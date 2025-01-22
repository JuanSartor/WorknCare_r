<?php

$ManagerConsultaExpress=$this->getManager("ManagerConsultaExpress");

$result=$ManagerConsultaExpress->delete($this->request["idconsultaExpress"],true);

  $this->finish($ManagerConsultaExpress->getMsg());