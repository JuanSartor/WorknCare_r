<?php

  /**
   * Action de crear una nueva suscripcion premium y obtener la preferencia de pago de MercadoPago
   */
  $this->start();

  $ManagerSuscripcionPremium = $this->getManager("ManagerSuscripcionPremium");
  $suscripcion = $ManagerSuscripcionPremium->nuevaSuscripcion($this->request);
   $this->finish($ManagerSuscripcionPremium->getMsg());
