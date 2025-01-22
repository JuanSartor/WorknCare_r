<?php

  /**
   * Action para enviar recetas por mail
   */
  $this->start();
    
  $ManagerPerfilSaludReceta = $this->getManager("ManagerPerfilSaludReceta");
  
  $result = $ManagerPerfilSaludReceta->enviar_receta($this->request);
  
  $this->finish($ManagerPerfilSaludReceta->getMsg());