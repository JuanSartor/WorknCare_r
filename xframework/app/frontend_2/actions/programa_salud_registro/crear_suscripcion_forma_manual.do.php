<?php

/**
 *  action que crea la suscripcion de forma manual para las obras sociales
 */
$this->start();
$manager = $this->getManager("ManagerEmpresa");
$manager->crear_suscripcion_forma_manual($this->request);
$this->finish($manager->getMsg());
