<?php

  $this->start();
  $manager = $this->getManager("ManagerPacienteGrupoFamiliar");

  $result = $manager->dropMiembro($this->request);
  $this->finish($manager->getMsg());

  