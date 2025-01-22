<?php


  $ManagerConsultaExpress = $this->getManager("ManagerConsultaExpress");
  
  $result = $ManagerConsultaExpress->marcarVisto($this->request["id"]);
  
  $this->finish($ManagerConsultaExpress->getMsg());