<?php

$this->start();
$manager=$this->getManager("ManagerProfesionalesFrecuentesPacientes");
$manager->agregar_medico_cabecera($this->request["idmedico"]);
$this->finish($manager->getMsg());
