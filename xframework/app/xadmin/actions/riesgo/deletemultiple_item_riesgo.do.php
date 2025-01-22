<?php

/** 	
 * 	Accion: Elimino la fmailia, cuestionarios y preguntas asociadas
 * en realidad no es multiple solo permito eliminar una familia
 *
 *
 */
$manager = $this->getManager("ManagerItemRiesgo");
$manager->deleteItem($this->request['ids']);
$this->finish($manager->getMsg());
