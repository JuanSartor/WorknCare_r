<?php

$ManagerPerfilSaludRecetaArchivo = $this->getManager("ManagerPerfilSaludRecetaArchivo");
$receta = $ManagerPerfilSaludRecetaArchivo->getByField("codigo", $this->request["code"]);
if ($receta && $receta["procesada"]==0) {
    $ManagerPerfilSaludRecetaArchivo->update(["procesada"=>1],$receta["idperfilSaludRecetaArchivo"]);
$ManagerPerfilSaludRecetaArchivo->get_receta_electronica($this->request["code"]);
}
