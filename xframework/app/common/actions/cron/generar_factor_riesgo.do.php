<?php

// Ejecución 1 vez por hora.
$ManagerNotificacion = $this->getManager("ManagerNotificacion");
$ManagerNotificacion->debug();
$ManagerNotificacion->cronFactorRiesgoGripe();

  