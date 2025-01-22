<?php

$Manager = $this->getManager("ManagerPaciente");

$this->request["idpaciente"]=$this->request["id"];
$Manager->checkValidacionCelular($this->request);
$this->finish($Manager->getMsg());

