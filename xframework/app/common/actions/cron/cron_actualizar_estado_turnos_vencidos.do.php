<?php

/**
   * Cron utilizado para actualizar los estados de los turno que han sido reservados y pasaron 5 minutos sin confirmarse por el paciente
   */
  $ManagerTurno=$this->getManager("ManagerTurno");
  $ManagerTurno->debug();
  $ManagerTurno->cronActualizarEstadoTurnosVencidos();