<?php

  $this->start();
  $ManagerInformacionComercialMedico = $this->getManager("ManagerInformacionComercialMedico");

  
  $result = $ManagerInformacionComercialMedico->process($this->request);
  $this->finish($ManagerInformacionComercialMedico->getMsg());