<?php

/**
 *
 *  Modulo form remmbolso
 *
 */
$manager = $this->getManager("ManagerArchivosReembolsoBeneficiario");
$imagenes = $manager->getImagenesReembolso($this->request["id"]);
//print_r($imagenes);
$this->assign("list_imagenes", $imagenes);

// proceso para obtener los programas asociados que pueden acceder el beneficiario
$reembolso = $this->getManager("ManagerReembolso")->get($this->request["id"]);
$this->assign("reembolso", $reembolso);
// esto es para llegar hasta le id de la empresa correspondiente al beneficiario del reembolso
$paciente = $this->getManager("ManagerPaciente")->getByField("usuarioweb_idusuarioweb", $reembolso["usuarioWeb_idusuarioweb"]);
$paciente_empresa = $this->getManager("ManagerPacienteEmpresa")->getByField("paciente_idpaciente", $paciente["idpaciente"]);

// ahora le paso el id de la empresa y obtengo los programas exceptuados
$excepciones_programa = $this->getManager("ManagerProgramaSaludExcepcion")->getByField("empresa_idempresa", $paciente_empresa["empresa_idempresa"]);

// obtengo todos los programas del pass
$listado_grupo_programas = $this->getManager("ManagerProgramaSaludGrupo")->getListadoGrupoProgramas();

$lista_parte_inicial = Array();
$lista_parte_final = Array();
$array_excepciones = explode(",", $excepciones_programa["programa_salud_excepcion"]);

foreach ($listado_grupo_programas as &$grupo) {
    foreach ($grupo["listado_programas"] as &$elemento) {

        if (in_array($elemento["idprograma_salud"], $array_excepciones)) {
            array_push($lista_parte_final, $elemento);
        } else {
            array_push($lista_parte_inicial, $elemento);
        }
    }
}
$arreglo_final = array_merge($lista_parte_inicial, $lista_parte_final);
$this->assign("listado_grupo_programas", $arreglo_final);

// con lo siguiente armo el array de programas para los programas de socios
$lista_programas_socios = Array();
if ($arreglo_final == "") {
    $lista_programas_socios = "";
} else {
    foreach ($arreglo_final as &$programa) {
        if (!in_array($programa["idprograma_salud"], $array_excepciones)) {
            array_push($lista_programas_socios, $programa);
        }
    }
}
$this->assign("listado_grupo_programas_socios", $lista_programas_socios);
