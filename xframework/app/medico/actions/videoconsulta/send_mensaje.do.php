<?php

  
  $ManagerMensajeVideoConsulta = $this->getManager("ManagerMensajeVideoConsulta");
  
  $result = $ManagerMensajeVideoConsulta->insert($this->request);
  
  $this->finish($ManagerMensajeVideoConsulta->getMsg());