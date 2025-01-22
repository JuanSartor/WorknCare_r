<?php

/**
 * 	
 *  Nuevo/Editar
 *
 * 	@author Emanuel del Barco
 *
 */
$this->start();
$manager = $this->getManager("ManagerEmpresa");
$empresa = $manager->get($this->request["idempresa"]);
// lo de abajo lo comente el 05-10-2022 porque era lo que generaba el error cuando 
// queria actualizar los datos de la empresa desde el xadmin

if (($empresa["plan_idplan"] == '21' || $empresa["plan_idplan"] == '22') && $empresa["plan_idplan_siguiente"] != '') {
    $this->request["bandera_fecha"] = 1;
    $this->request["plan_idplan"] = $empresa["plan_idplan_siguiente"];
    $empresa["fecha_adhesion"] = date("Y-m-d");
    $this->request["fecha_adhesion"] = date("Y-m-d");
    $this->request["fecha_vencimiento"] = date("Y-m-d", strtotime($empresa["fecha_adhesion"] . "+ 1 year"));
}
$result = $manager->updateFromAdmin($this->request, $this->request["idempresa"]);
$this->finish($manager->getMsg());
?>
