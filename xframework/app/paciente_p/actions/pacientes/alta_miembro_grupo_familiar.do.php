<?php

  $this->start();
  $manager = $this->getManager("ManagerPacienteGrupoFamiliar");

  $result = $manager->insert($this->request);
  $this->finish($manager->getMsg());

  