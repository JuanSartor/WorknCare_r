<?php

 
  $ManagerVideoConsulta = $this->getManager("ManagerVideoConsulta");
  
  $result = $ManagerVideoConsulta->setNotificacionesLeidasMedico($this->request);


  $this->finish($ManagerVideoConsulta->getMsg());