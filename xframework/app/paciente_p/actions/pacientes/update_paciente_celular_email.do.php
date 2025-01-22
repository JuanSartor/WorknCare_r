<?php

  $manager = $this->getManager("ManagerPaciente");
  
  $manager->updateFromPerfilPacienteCelEmail($this->request);
  
  $this->finish($manager->getMsg());
  