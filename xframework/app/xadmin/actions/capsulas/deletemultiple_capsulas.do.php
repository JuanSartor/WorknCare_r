<?php

/** 	
 * 	Accion: Elimino la fmailia, cuestionarios y preguntas asociadas
 * en realidad no es multiple solo permito eliminar una familia
 *
 *
 */
$manager = $this->getManager("ManagerCapsula");
$manager->deleteMultiple($this->request['ids']);
$this->finish($manager->getMsg());
