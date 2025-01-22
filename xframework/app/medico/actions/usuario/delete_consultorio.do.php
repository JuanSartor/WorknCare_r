<?php

  $managerConsultorio = $this->getManager("ManagerConsultorio");
  
  $result = $managerConsultorio->deleteConsultorioFromMedico($this->request);
  
  $this->finish($managerConsultorio->getMsg());

