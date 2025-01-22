<?php

/**
 *  elimino el registro de la tabla
 */
$this->start();
$manager = $this->getManager("ManagerProgramaSaludGrupoEmpresaAsociacion");

// $manager->debug();
$result = $manager->delete($this->request["id"], true);
$this->finish($manager->getMsg());
