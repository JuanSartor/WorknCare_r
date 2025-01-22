<?php

  
  $manager = $this->getManager("ManagerMedico");
  
  $rdo = $manager->cropAndChangeImage($this->request);
  
  $this->finish($manager->getMsg());