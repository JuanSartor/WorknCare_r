<?php

 // Ejecución cada 1 vez por hora
  $ManagerNotificacion = $this->getManager("ManagerNotificacion");
  $ManagerNotificacion->debug();
  $ManagerNotificacion->cronCreacionNotificacionesControlesYChequeos();
  
  