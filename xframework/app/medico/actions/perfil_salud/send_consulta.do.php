<?php

  $this->start();

  $manager = $this->getManager("ManagerMedicoCompartirEstudio");

  $result = $manager->sendConsulta($this->request);

  $this->finish($manager->getMsg());
  