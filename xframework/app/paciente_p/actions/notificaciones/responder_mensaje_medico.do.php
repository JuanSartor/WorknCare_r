<?php

 
  $manager = $this->getManager("ManagerNotificacion");
  
  $result = $manager->createNotificacionFromRespuestaMensajePaciente($this->request);

  $this->finish($manager->getMsg());