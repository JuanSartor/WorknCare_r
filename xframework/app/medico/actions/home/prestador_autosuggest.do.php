<?php

  /**
   * Action para el autosuggest de Prestador
   */
  $manager = $this->getManager("ManagerPrestador");

  $records = $manager->getAutosuggest($this->request);

  echo $records;
?>
