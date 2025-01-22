<?php

  /**
   * Action para el autosuggest de OBra Social
   */
  $manager = $this->getManager("ManagerPrestador");

  $records = $manager->getAutosuggest($this->request);

  echo $records;
?>
