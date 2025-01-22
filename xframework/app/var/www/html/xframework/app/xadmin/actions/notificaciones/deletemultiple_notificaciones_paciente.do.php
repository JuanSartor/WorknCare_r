<?php

    $manager = $this->getManager("ManagerNotificacionSistema");
   
    $manager->deleteMultiple($this->request['ids'], true);    
    
    $this->finish($manager->getMsg());
