<?php

  $manager = $this->getManager("ManagerPacienteGrupoFamiliar");

  $manager->countMembers($this->request);
  
  $this->finish($manager->getMsg());
  