<?php 
  
  $this->start();
  $ManagerPeriodoPago = $this->getManager("ManagerPeriodoPago");
  $ManagerPeriodoPago->getPDF($this->request);
  
  
?>