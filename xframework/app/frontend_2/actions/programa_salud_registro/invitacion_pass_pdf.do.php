<?php 
  
  $this->start();
  $ManagerEmpresa = $this->getManager("ManagerEmpresa");
  $ManagerEmpresa->getInvitacionPassPDF($this->request);
  
  
?>