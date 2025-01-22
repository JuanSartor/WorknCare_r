<?php

  /**
   * Módulo que retorna las imágenes de los mensajes
   */
  if (isset($this->request["id"]) && (int) $this->request["id"] > 0) {

      $ManagerArchivosMensajeTurno= $this->getManager("ManagerArchivosMensajeTurno");
      $listado = $ManagerArchivosMensajeTurno->getListImages($this->request["id"]);

      if ($listado && count($listado) > 0) {
          $this->assign("listado", $listado);
      }
  }