<?php


  $ManagerVideoConsulta = $this->getManager("ManagerVideoConsulta");
  
  $result = $ManagerVideoConsulta->marcarVisto($this->request["id"]);
  
  $this->finish($ManagerVideoConsulta->getMsg());