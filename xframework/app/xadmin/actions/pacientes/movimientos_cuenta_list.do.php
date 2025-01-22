<?php

/** 	
 * 	Accion: Grilla de los movimientos de cuenta del paciente
 * 	
 */
$manager = $this->getManager("ManagerMovimientoCuenta");
// $manager->debug();
$records = $manager->getListadoMovimientosPacienteJson($this->request, "listado_movimientos_" . $this->request["idpaciente"]);

echo $records;
?>
