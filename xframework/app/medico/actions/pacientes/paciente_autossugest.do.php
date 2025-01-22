<?php
  /**
   * Autossugest de los pacientes
   */
  $manager = $this->getManager("ManagerPaciente");

  $records = $manager->getAutosuggestAgregarMiembro($this->request);

  echo $records;
  