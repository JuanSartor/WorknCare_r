<?php

/** 	
 * 	Accion: Registración de las empresas contratistas de una plan
 * 	
 */
$this->start();
$manager = $this->getManager("ManagerUsuarioEmpresa");


//$manager->debug();
$result = $manager->insert($this->request);
//$this->finish($manager->getMsg());
// si es el plan mini start por defecto solo debe aparecer este tildado del lado de la empresa
// entonces tengo que poner todo el resto de los planes como excepcion para que no aparezcan tildados
if ($this->request["plan_idplan"] == '18' || $this->request["plan_idplan"] == '19') {
    $ManagerProgramaSalud = $this->getManager("ManagerProgramaSalud");
    $ids = $ManagerProgramaSalud->getListadoIDProgramasMenosRequest("49");
    $cad = '';
    foreach ($ids as $id) {
        $cad = $cad . ',' . $id["idprograma_salud"];
    }

    $parametros["ids"] = substr($cad, 1);

    $ManagerEmpresa = $this->getManager("ManagerEmpresa");
    $idEmpresa = $ManagerEmpresa->getUltimoIdEmpresa();
    $parametros["idEmpresa"] = $idEmpresa["idempresa"];

    // creo el registro de excepciones
    $ManagerProgramaSaludExcepcion = $this->getManager("ManagerProgramaSaludExcepcion");
    $ManagerProgramaSaludExcepcion->registrar_programa_excepcion($parametros);
    $ManagerProgramaSaludExcepcion->registrar_programa_excepcion($parametros);
    $this->finish($manager->getMsg());
} else {
    $this->finish($manager->getMsg());
}
    