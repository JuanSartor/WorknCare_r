<?php

/** 	
 * 	Accion: Grilla de pacientes beneficiarios de la empresa
 * 	
 */
$manager = $this->getManager("ManagerPacienteEmpresa");
// $manager->debug();
$records = $manager->getListadoBeneficiariosJSON($this->request, "beneficiarios_listado_" . $this->request["idempresa"]);

echo $records;
?>
