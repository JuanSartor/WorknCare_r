<?php

  
  $manager = $this->getManager("ManagerPaciente");
  
  $rdo = $manager->cropAndChangeImageHash($this->request);
  
  $this->finish($manager->getMsg());