<?php

//Paciente que se encuentra en el array de SESSION de header paciente
$ManagerPaciente = $this->getManager("ManagerPaciente");
$paciente = $ManagerPaciente->getPacienteXHeader();
//obtenermos si es paciente empresa y cuantas consultas tiene
$paciente_empresa = $this->getManager("ManagerPacienteEmpresa")->getByField("paciente_idpaciente", $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["paciente"]["idpaciente"]);
if ($paciente_empresa) {
    $plan_contratado = $this->getManager("ManagerProgramaSaludPlan")->get($paciente_empresa["plan_idplan"]);
    $this->assign("paciente_empresa", $paciente_empresa);
    $this->assign("plan_contratado", $plan_contratado);
    $paciente["ce_disponibles"] = (int) $plan_contratado["cant_consultaexpress"] - (int) $paciente_empresa["cant_consultaexpress"];
    $paciente["vc_disponibles"] = (int) $plan_contratado["cant_videoconsulta"] - (int) $paciente_empresa["cant_videoconsulta"];
}
$this->assign("paciente", $paciente);
if ($this->request["delete_item"] != "") {
    if ($_SESSION[URL_ROOT][CONTROLLER]["request_busqueda_medico"][$this->request["delete_item"]]) {
        unset($_SESSION[URL_ROOT][CONTROLLER]["request_busqueda_medico"][$this->request["delete_item"]]);

        //Si elimino item de los tags inputs, reseteo el paginador
        $this->request["do_reset"] = 1;
    }
}


$idpaginate = "paginacion_medico";
$this->assign("idpaginate", $idpaginate);
$request_anterior = (array) $_SESSION[URL_ROOT][CONTROLLER]["request_busqueda_medico"];

$ManagerMedico = $this->getManager("ManagerMedico");
//  $ManagerMedico->print_r($request_anterior);
$request_anterior["current_page"] = $this->request["current_page"];
if ($this->request["do_reset"] == 1) {
    $request_anterior["do_reset"] = $this->request["do_reset"];
}
$listado = $ManagerMedico->getMedicosListFromBusquedaPaginado($request_anterior, $idpaginate);





$ManagerProgramaSaludExcepcion = $this->getManager("ManagerProgramaSaludExcepcion");
if ($listado["rows"] && count($listado["rows"]) > 0) {
    //inicialiamos los ids de consultorio para los mapas
    $id_consultorios = "";
    foreach ($listado["rows"] as $key => $value) {
        if ($value["idconsultorio"] != "") {
            $id_consultorios .= "{$value["idconsultorio"]},";
        }

        if ($value["list_consultorios"] != "") {
            foreach ($value["list_consultorios"] as $consultorio) {
                if ($value["idconsultorio"] != "") {
                    $id_consultorios .= "{$consultorio["idconsultorio"]},";
                }
            }
        }
        //verificamos sl consultorio es virutal
        if ($value["is_virtual"] == 1) {

            $preferencia = $this->getManager("ManagerPreferencia")->getPreferenciaMedico($value["medico_idmedico"]);

            //verificamos si el medico solo ofrece videoconsultas a sus pacientes y es frecuente 
            if ($preferencia["pacientesVideoConsulta"] == "2") {

                $is_paciente = $this->getManager("ManagerMedicoMisPacientes")->getRelacion($value["medico_idmedico"], $paciente["idpaciente"]);

                if (!$is_paciente) {
                    $listado["rows"][$key]["videoconsulta_no_disponible"] = 1;
                }
            }
        }

        //verificamos si el medico está incluido en los planes cubiertos por la empresa
        if ($paciente_empresa["empresa_idempresa"] != "") {

            $medico_bonificado = $ManagerProgramaSaludExcepcion->verificar_medico_bonificado($value["idmedico"], $paciente_empresa["empresa_idempresa"], $request_anterior["idprograma_categoria"]);
            if ($medico_bonificado) {
                $listado["rows"][$key]["medico_bonificado"] = 1;
            }
        }
    }
    if (strlen($id_consultorios) > 0) {
        $id_consultorios = substr($id_consultorios, 0, strlen($id_consultorios) - 1);
    }
    $this->assign("id_consultorios", $id_consultorios);
}
$this->assign("listado_consultorios", $listado);
$cuenta_paciente = $this->getManager("ManagerCuentaUsuario")->getCuentaPaciente($_SESSION[URL_ROOT][CONTROLLER]['logged_account']["paciente"]["idpaciente"]);
$this->assign("cuenta_paciente", $cuenta_paciente);

//marcamos el programa seleccionado
$this->assign("idprograma_categoria_seleccionado", $request_anterior["idprograma_categoria"]);


// obtengo el id del programa mediante la categoria
$ManagerProgramaSaludCategoria = $this->getManager("ManagerProgramaSaludCategoria");
$ProgramaSaludCategoria = $ManagerProgramaSaludCategoria->get($request_anterior["idprograma_categoria"]);
$idProgramaSalud = $ProgramaSaludCategoria["programa_salud_idprograma_salud"];

// obtengo el programa salud
$ManagerProgramaSalud = $this->getManager("ManagerProgramaSalud");
$this->assign("programa_salud", $ManagerProgramaSalud->get($idProgramaSalud));

$recompensa = $this->getManager("ManagerCuestionario")->obtenerGratisOnoGanado($idProgramaSalud);
$this->assign("recompensa", $recompensa);
