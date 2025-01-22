<?php

  
  /**
   * Action para enviar
   */
  $manager = $this->getManager("ManagerPerfilSaludRecetaArchivo");
  
  $result = $manager->enviar_recetas($this->request["ids"]);
  
  $this->finish($manager->getMsg());


