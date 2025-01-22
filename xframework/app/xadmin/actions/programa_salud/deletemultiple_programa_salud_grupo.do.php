<?php

/** 	
 * 	Accion: Eliminacion mutiple grupos
 *
 *
 */
$manager = $this->getManager("ManagerProgramaSaludGrupo");
$manager->deleteMultiple($this->request['ids'], true);
$this->finish($manager->getMsg());
