<?php

/** 	
 * 	Accion: Elimino la fmailia, cuestionarios y preguntas asociadas
 * en realidad no es multiple solo permito eliminar una familia
 *
 *
 */
$manager = $this->getManager("ManagerFamiliaCapsula");
$manager->deleteMultipleFamiliasCapsulas($this->request['ids']);
$this->finish($manager->getMsg());
