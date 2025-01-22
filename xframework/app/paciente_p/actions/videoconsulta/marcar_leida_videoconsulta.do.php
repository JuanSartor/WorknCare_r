<?php

 
  $ManagerVideoConsulta = $this->getManager("ManagerVideoConsulta");
  
  $result = $ManagerVideoConsulta->setNotificacionesLeidasPaciente($this->request);


  $this->finish($ManagerVideoConsulta->getMsg());