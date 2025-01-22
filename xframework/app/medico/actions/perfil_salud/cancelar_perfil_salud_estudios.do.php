<?php

  /**
   * Action para la eliminación 
   */
  $manager = $this->getManager("ManagerPerfilSaludEstudiosImagen");

  $result = $manager->cancelarUploadMultiple($this->request["id"]);

  $this->finish($manager->getMsg());
  