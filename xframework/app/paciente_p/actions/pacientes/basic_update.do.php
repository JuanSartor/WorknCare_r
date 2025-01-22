<?php

 
  $this->start();
  $manager = $this->getManager("ManagerPaciente");

  $result = $manager->basic_update($this->request, $this->request["idpaciente"]);
  $this->finish($manager->getMsg());

