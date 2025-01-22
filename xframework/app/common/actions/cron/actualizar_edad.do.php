<?php

 /**
   * Cron utilizado para actulizar la edad del paciente
   */
  $ManagerPaciente = $this->getManager("ManagerPaciente");
  $ManagerPaciente->debug();
  
  $ersultado = $ManagerPaciente->cronActualizarEdad();
  