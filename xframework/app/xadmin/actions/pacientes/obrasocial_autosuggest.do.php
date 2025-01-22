<?php

  /**
   * Action para el autosuggest de OBra Social
   */
  $manager = $this->getManager("ManagerObrasSociales");

  $records = $manager->getAutosuggest($this->request);

  echo $records;
?>
