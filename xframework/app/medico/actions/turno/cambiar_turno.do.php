<?php


  $ManagerTurno = $this->getManager("ManagerTurno");
  if($this->request["estado"]!="2"){
      $result = $ManagerTurno->updateFromFrontendTurno($this->request, $this->request["idturno"]);
  }else{
    $result = $ManagerTurno->cancelarTurnoFromMedico($this->request);  
  }

  $this->finish($ManagerTurno->getMsg());
  