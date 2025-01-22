<?php 
  
  $this->start();
  $ManagerMedico = $this->getManager("ManagerMedico");
  $ManagerMedico->getResumenConsultaParticularPDF($this->request);
  
  
?>