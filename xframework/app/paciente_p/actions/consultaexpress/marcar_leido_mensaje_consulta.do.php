<?php

 
  $ManagerMensajeConsultaExpress = $this->getManager("ManagerMensajeConsultaExpress");
  
  $result = $ManagerMensajeConsultaExpress->setMensajesLeidosAll($this->request["id"]);
  
  $this->finish($ManagerMensajeConsultaExpress->getMsg());