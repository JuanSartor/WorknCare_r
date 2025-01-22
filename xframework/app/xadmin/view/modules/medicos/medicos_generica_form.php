<?php

/**
 *  Médicos >>  Alta / Modificación
 *  
 * */
if (isset($this->request["id"]) && $this->request["id"] > 0) {
    $manager = $this->getManager("ManagerMedico");
    $record = $manager->get($this->request["id"],true);

    $this->assign("record", $record);


 

    $listado = $this->getManager("ManagerDocumentacionMedico")->getListadoDocumentacion($this->request["id"]);
    $this->assign("listado_documentacion", $listado);
    $imagenes_tarjetas = $manager->getImagenesIdentificacion($this->request["id"]);

    $this->assign("imagenes_tarjetas", $imagenes_tarjetas);
}
$ManagerProvincia = $this->getManager("ManagerProvincia");
$this->assign("provincias", $ManagerProvincia->getComboProvinciasArgentinas());

$managerEspecialidades = $this->getManager("ManagerEspecialidades");
$this->assign("combo_especialidades", $managerEspecialidades->getCombo());
