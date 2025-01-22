<?php

 
  /**
   * Confirmación del turno
   *
   * */
  $this->start();
  $ManagerTurno = $this->getManager("ManagerTurno");
//$ManagerTurno->debug();
  $ManagerTurno->confirmarPagoTurno($this->request);
  $this->finish($ManagerTurno->getMsg());
?>
