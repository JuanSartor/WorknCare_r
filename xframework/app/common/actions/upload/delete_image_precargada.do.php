<?php

  /**
   * Método utilizada para eliminar las imágenes precargadas del dropzone
   * 
   */
  $managerStr = $this->request["manager"];

  $manager = $this->getManager($managerStr);
  
  $delete = $manager->deleteDropzone($this->request);
  
  $this->finish($manager->getMsg());