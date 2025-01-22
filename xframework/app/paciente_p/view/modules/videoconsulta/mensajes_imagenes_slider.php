<?php

/**
 * Módulo que retorna las imágenes de los mensajes
 */
if (isset($this->request["id"]) && (int) $this->request["id"] > 0) {

    $ManagerArchivosMensajeVideoConsulta = $this->getManager("ManagerArchivosMensajeVideoConsulta");
    $listado = $ManagerArchivosMensajeVideoConsulta->getListImages($this->request["id"]);

    if ($listado && count($listado) > 0) {
        $this->assign("listado", $listado);
    }
}