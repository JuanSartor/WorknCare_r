<?php


  $manager = $this->getManager("ManagerPaciente");

  $manager->change_member_session($this->request);
  
  $this->finish($manager->getMsg());
  