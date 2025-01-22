<?php

/** 	
 * 	Accion: Grilla de pacientes beneficiarios de la empresa
 * 	
 */$hoy = date("Y-m-d");
$manager = $this->getManager("ManagerProgramaSaludSuscripcion");
$manager->update(["pack_pago_pendiente" => "2", "fecha_pago_factura" => $hoy], $this->request["idSus"]);

$suscripcion_pendiente = $manager->get($this->request["idSus"]);

$ManagerEmpresa = $this->getManager("ManagerEmpresa");
$empresa = $ManagerEmpresa->get($this->request["idempresa"]);
//sumamos ca cantidad de la recompra de pack, mas los beneficiarios iniciales de la OS
$record["cant_empleados"] = (int) $empresa["cant_empleados"] + (int) $suscripcion_pendiente["pack_recompra"];
$upd = $ManagerEmpresa->update($record, $this->request["idempresa"]);


$this->finish($manager->getMsg());
?>
