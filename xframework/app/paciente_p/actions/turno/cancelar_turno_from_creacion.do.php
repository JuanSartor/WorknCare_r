<?php

  /**
   * Action >> Cancelar un turno desde la creación del mismo
   */
  $manager = $this->getManager("ManagerTurno");

  $result = $manager->cancelarTurnoFromCreacion($this->request);

  $this->finish($manager->getMsg());
  