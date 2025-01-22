<?php

  $this->start();
  $manager = $this->getManager("ManagerEventoPaciente");

  
  $result = $manager->process($this->request);
  $this->finish($manager->getMsg());
  