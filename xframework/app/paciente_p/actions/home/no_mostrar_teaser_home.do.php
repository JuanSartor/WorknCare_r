<?php
$ManagerPaciente=$this->getManager("ManagerPaciente");
$ManagerPaciente->no_mostrar_teaser_home($this->request);
$this->finish($ManagerPaciente->getMsg());
