<?php

    $this->start();

  	$ManagerSuscripcionPremium = $this->getManager("ManagerSuscripcionPremium");
  	$suscripcion = $ManagerSuscripcionPremium->cancelarSuscripcion($this->request["id"]);
  	$this->finish($ManagerSuscripcionPremium->getMsg());