<?php

/**
 *  Perfiles - Nuevo/Editar
 * 
 * */
$manager = $this->getManager("ManagerUsuarios");

if (isset($this->request["id"]) && $this->request["id"] > 0) {

    $record = $manager->get($this->request["id"]);

    if (isset($this->request["do_copy"]) && $this->request["do_copy"] == 1) {

        unset($record["id"]);
        unset($record["username"]);
        unset($record["email"]);
    }

    $this->assign("record", $record);
    $listado_usuario_acceso = $this->getManager("ManagerUsuarioAcceso")->getByUsuario($this->request["id"]);

    $this->assign("listado_usuario_acceso", $listado_usuario_acceso);
}


$this->assign("combo_usuario_menu", $this->getManager("ManagerUsuarioMenu")->getCombo());
?>