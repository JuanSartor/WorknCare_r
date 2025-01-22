<?php

  /**
   * Eliminación de la asoción entre un médico y un paciente
   */
  $manager = $this->getManager("ManagerMedicoMisPacientes");

  $result = $manager->deleteAsociacion($this->request);

  $this->finish($manager->getMsg());
  