<?php

  $manager = $this->getManager("ManagerMedico");

  $manager->inicializarPacienteFromMedico($this->request["id"]);
  
  $this->finish($manager->getMsg());
  