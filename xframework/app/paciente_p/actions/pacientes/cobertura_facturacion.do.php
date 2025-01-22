<?php

 
  $this->start();
  $manager = $this->getManager("ManagerPaciente");

  $result = $manager->configurar_cobertura_factuacion_inicial($this->request);
  $this->finish($manager->getMsg());

