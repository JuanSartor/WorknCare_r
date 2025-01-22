<?php

  
  $manager = $this->getManager("ManagerPaciente");
  
  $rdo = $manager->cropAndChangeImage($this->request);
  
  $this->finish($manager->getMsg());