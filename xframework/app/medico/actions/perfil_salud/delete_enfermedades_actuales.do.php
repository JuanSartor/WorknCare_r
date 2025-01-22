<?php

  /**
   * Action >> DELETE >> Antecedentes Patología Familiar
   */
  $manager = $this->getManager("ManagerEnfermedadesActuales");

  $result = $manager->deletePatologiaFamiliar($this->request);

  $this->finish($manager->getMsg());
