<?php

  /**
   * Action para la eliminación 
   */
   $manager = $this->getManager("ManagerPerfilSaludRecetaArchivo");

  $result = $manager->cancelarUploadArchivo($this->request["id"]);

  $this->finish($manager->getMsg());
  