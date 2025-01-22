<?php

 
  /**
   * Action para subir la archivos al temporal
   */
  $this->start();
    
  $ManagerPerfilSaludReceta = $this->getManager("ManagerPerfilSaludReceta");
  
  $result = $ManagerPerfilSaludReceta->process_receta($this->request);
  
  $this->finish($ManagerPerfilSaludReceta->getMsg());