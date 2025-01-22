<?php

 /**
   * Cron utilizado para actualizar los estados de la CE vencidas y procesar devolucion de dinero e informar por mail
   */
  $ManagerConsultaExpress = $this->getManager("ManagerConsultaExpress");
  $ManagerConsultaExpress->debug();
  
  $ersultado = $ManagerConsultaExpress->actualizarEstados();
  