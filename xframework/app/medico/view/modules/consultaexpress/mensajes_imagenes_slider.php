<?php

  /**
   * Módulo que retorna las imágenes de los mensajes
   */
  if (isset($this->request["id"]) && (int) $this->request["id"] > 0) {

      $ManagerArchivosMensajeConsultaExpress = $this->getManager("ManagerArchivosMensajeConsultaExpress");
      $listado = $ManagerArchivosMensajeConsultaExpress->getListImages($this->request["id"]);

      if ($listado && count($listado) > 0) {
          $this->assign("listado", $listado);
      }
  }