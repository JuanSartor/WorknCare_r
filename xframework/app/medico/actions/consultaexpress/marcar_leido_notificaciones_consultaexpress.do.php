<?php

 
  $ManagerConsultaExpress = $this->getManager("ManagerConsultaExpress");
  
  $result = $ManagerConsultaExpress->setNotificacionesLeidasMedico($this->request);
  
  $this->finish($ManagerConsultaExpress->getMsg());