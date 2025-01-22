<?php

  /**
   * Autossugest de los medicamentos
   */
  $manager = $this->getManager("ManagerMedicamento");

  $records = $manager->getAutosuggest($this->request);

  echo $records;
  