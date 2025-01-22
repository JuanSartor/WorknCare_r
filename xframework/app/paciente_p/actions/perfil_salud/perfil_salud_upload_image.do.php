<?php

 
  /**
   * Action para subir la imagen al temporal
   */
  $this->start();
    
  $ManagerPerfilSaludEstudio = $this->getManager("ManagerPerfilSaludEstudios");
  
  $result = $ManagerPerfilSaludEstudio->processImage($this->request);
  
  $this->finish($ManagerPerfilSaludEstudio->getMsg());