<?php

  /**
   * Action >> Cancelar un turno desde la creación del mismo
   */
  $manager = $this->getManager("ManagerTurno");

  $result = $manager->cancelarTurnoFromPaciente($this->request);

  $this->finish($manager->getMsg());
  