<?php

//$this->start();
  $manager = $this->getManager("ManagerUsuarioWeb");
  
  $rdo = $manager->processActivacion($this->request);
  $msg=$manager->getMsg();
  $this->assign("respuesta_activacion", $msg);

 
