<?php

/** 	
 * 	Accion: Grilla de pacientes beneficiarios de la empresa
 * 	
 */
$manager = $this->getManager("ManagerUsuarioEmpresa");
// $manager->debug();
$records = $manager->getUsuariosJSON($this->request, "usuarios_secundarios_listado_" . $this->request["idempresa"]);

echo $records;
?>