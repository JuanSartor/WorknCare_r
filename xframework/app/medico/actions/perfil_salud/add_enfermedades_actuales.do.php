<?php

  /**
   * Action >> Antecedentes Patología Familiar
   */
  if ($this->request["enfermedad"] == "1") {
      $manager = $this->getManager("ManagerEnfermedadesActualesEnfermedad");

      $result = $manager->processFromPatologias($this->request);

      $this->finish($manager->getMsg());
  } else {
      $manager = $this->getManager("ManagerEnfermedadesActualesTipoEnfermedad");

      $result = $manager->processFromPatologias($this->request);

      $this->finish($manager->getMsg());
  }
  
  
  
  