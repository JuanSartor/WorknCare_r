<?php


      /** 	
     * 	Accion: Creación/Edición de horario de antencion
     * 	
     */
    $this->start();
    $manager = $this->getManager("ManagerConfiguracionAgenda");
    $result = $manager->process($this->request);
    $this->finish($manager->getMsg());
