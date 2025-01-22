<?php

 
  /**
   * Action para subir la archivos al temporal
   */
  $this->start();
    
  $ManagerPerfilSaludAdjunto = $this->getManager("ManagerPerfilSaludAdjunto");
  
  $result = $ManagerPerfilSaludAdjunto->process_adjunto($this->request);
  
  $this->finish($ManagerPerfilSaludAdjunto->getMsg());