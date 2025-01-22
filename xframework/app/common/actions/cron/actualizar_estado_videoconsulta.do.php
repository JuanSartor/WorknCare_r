<?php

 /**
   * Cron utilizado para actualizar los estados de la VC vencidas y procesar devolucion de dinero e informar por mail
   */
  $ManagerVideoConsulta = $this->getManager("ManagerVideoConsulta");
  $ManagerVideoConsulta->debug();
  
  $resultado = $ManagerVideoConsulta->actualizarEstados();
  