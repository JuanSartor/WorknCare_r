<?php

  if ($this->request["filter_selected"] == "self") {
      $manager = $this->getManager("ManagerPaciente");
  } else {
      $manager = $this->getManager("ManagerPacienteGrupoFamiliar");
  }

  $manager->update($this->request);
  $this->finish($manager->getMsg());
?>