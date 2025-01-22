<?php

/**
   * Action >> elimina el registro de status y recalcula el puntaje
   */
  $manager = $this->getManager("ManagerPerfilSaludStatus");
$manager->debug();
  $result = $manager->actualizarStatus($this->request["idpaciente"]);


  