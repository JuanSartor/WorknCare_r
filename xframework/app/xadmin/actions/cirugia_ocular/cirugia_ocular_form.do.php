<?php

  /** 	
   * 	Accion: Alta de las Cirugias Oculares
   * 	
   */
  $this->start();

  $manager = $this->getManager("ManagerCirugiaOcular");

  $result = $manager->process($this->request);

  $this->finish($manager->getMsg());
  