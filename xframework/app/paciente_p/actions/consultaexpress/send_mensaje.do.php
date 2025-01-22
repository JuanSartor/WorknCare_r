<?php

  
  $ManagerMensajeConsultaExpress = $this->getManager("ManagerMensajeConsultaExpress");
  
  $result = $ManagerMensajeConsultaExpress->insert($this->request);
  
  $this->finish($ManagerMensajeConsultaExpress->getMsg());