<?php

$this->start();
$manager=$this->getManager("ManagerProfesionalesFrecuentesPacientes");
$manager->eliminar_medico_cabecera($this->request["idmedico"]);
$this->finish($manager->getMsg());
