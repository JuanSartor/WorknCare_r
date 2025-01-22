<?php

  /**
   * Action para el autosuggest de OBra Social
   */
  $manager = $this->getManager("ManagerEspecialidades");

  $records = $manager->getAutosuggest($this->request,1);

  echo $records;