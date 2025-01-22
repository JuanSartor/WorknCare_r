<?php


      /** 	
     * 	Accion: Creación/Edición de horario de antencion
     * 	
     */
    $this->start();
    $manager = $this->getManager("ManagerConfiguracionAgenda");
    $result = $manager->delete($this->request["id"]);
    $this->finish($manager->getMsg());
