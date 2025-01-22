<?php

 
  $manager = $this->getManager("ManagerNotificacion");
  
  $result = $manager->createNotificacionFromRespuestaMensaje($this->request);

  $this->finish($manager->getMsg());