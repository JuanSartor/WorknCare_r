<?php

  /**
   * Módulo que retorna los estudios de imagen de los estudios de imágenes 
   */
  if (isset($this->request["id"]) && (int) $this->request["id"] > 0) {
      
      $ManagerPerfilSaludEstudiosImagen = $this->getManager("ManagerPerfilSaludEstudiosImagen");
      $listado = $ManagerPerfilSaludEstudiosImagen->getListImages($this->request["id"]);

      $ManagerPerfilSaludEstudios = $this->getManager("ManagerPerfilSaludEstudios");
      $estudio = $ManagerPerfilSaludEstudios->get($this->request["id"]);

      if ($estudio) {
          $this->assign("estudio", $estudio);
      }

      if ($listado && count($listado) > 0) {
          $this->assign("listado", $listado);
      }
  }