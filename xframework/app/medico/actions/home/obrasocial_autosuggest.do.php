<?php

  /**
   * Action para el autosuggest de Prestador
   */
  $manager = $this->getManager("ManagerObrasSociales");

  $records = $manager->getAutosuggest($this->request);

  echo $records;
?>
