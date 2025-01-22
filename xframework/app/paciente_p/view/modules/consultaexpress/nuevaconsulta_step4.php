<?php

//Paciente que se encuentra en el array de SESSION de header paciente
$ManagerPaciente = $this->getManager("ManagerPaciente");
$paciente = $ManagerPaciente->getPacienteXHeader();


//obtenemos la cuenta del paciente para verificar el saldo
$cuenta_paciente = $this->getManager("ManagerCuentaUsuario")->getCuentaPaciente($paciente["idpaciente"]);
$this->assign("cuenta_paciente", $cuenta_paciente);
$this->assign("STRIPE_APIKEY_PUBLIC", STRIPE_APIKEY_PUBLIC);
//obtenermos si es paciente empresa y cuantas consultas tiene
$paciente_empresa = $this->getManager("ManagerPacienteEmpresa")->getByField("paciente_idpaciente", $cuenta_paciente["paciente_idpaciente"]);
if ($paciente_empresa) {
    $plan_contratado = $this->getManager("ManagerProgramaSaludPlan")->get($paciente_empresa["plan_idplan"]);
    $this->assign("paciente_empresa", $paciente_empresa);
    $this->assign("plan_contratado", $plan_contratado);
    $paciente["ce_disponibles"] = (int) $plan_contratado["cant_consultaexpress"] - (int) $paciente_empresa["cant_consultaexpress"];
}

$this->assign("paciente", $paciente);
//metodos de pago cargados en Stripe
$metodo_pago_list = $this->getManager("ManagerCustomerStripe")->get_listado_metodos_pago($cuenta_paciente["paciente_idpaciente"]);
$this->assign("metodo_pago_list", $metodo_pago_list["data"]);
//obtenemos la consulta

if (isset($this->request["idconsultaExpress"]) && $this->request["idconsultaExpress"] != "") {

    $ConsultaExpress = $this->getManager("ManagerConsultaExpress")->get($this->request["idconsultaExpress"]);
    $this->assign("ConsultaExpress", $ConsultaExpress);

    if ($ConsultaExpress["tipo_consulta"] == "0") {
        $filtro = $this->getManager("ManagerFiltrosBusquedaConsultaExpress")->getByField("consultaExpress_idconsultaExpress", $ConsultaExpress["idconsultaExpress"]);
        $this->assign("filtro", $filtro);
        $especialidad = $this->getManager("ManagerEspecialidades")->get($filtro["especialidad_idespecialidad"]);
        $this->assign("especialidad", $especialidad);

        if ($paciente_empresa) {
            //verificamos si el medico está incluido en los planes cubiertos por la empresa
            $programa_bonificado = $this->getManager("ManagerProgramaSaludExcepcion")->verificar_programa_bonificado($filtro["idprograma_categoria"], $paciente_empresa["empresa_idempresa"]);
            if ($programa_bonificado) {
                $this->assign("programa_bonificado", 1);
            }
        }

        //seteamos la cantidad de medicos en la bolsa
        $bolsa = explode(',', $ConsultaExpress["ids_medicos_bolsa"]);
        $this->assign("cant_profesionales_bolsa", count($bolsa) - 2); //resto 2 por el primer y ultimo lugar vacio en el array
    } else {

        $especialidades_medico = $this->getManager("ManagerEspecialidadMedico")->getEspecialidadesMedico($ConsultaExpress["medico_idmedico"]);

        $this->assign("especialidades_medico", $especialidades_medico);

        $medico = $this->getManager("ManagerMedico")->get($ConsultaExpress["medico_idmedico"]);
        $this->assign("medico", $medico);
        if ($paciente_empresa) {
            //verificamos si el medico está incluido en los planes cubiertos por la empresa
            $medico_bonificado = $this->getManager("ManagerProgramaSaludExcepcion")->verificar_medico_bonificado($medico["idmedico"], $paciente_empresa["empresa_idempresa"], $ConsultaExpress["idprograma_categoria"]);
            if ($medico_bonificado) {
                $this->assign("medico_bonificado", 1);
            }
        }
    }
    $paciente_sin_cargo = $this->getManager("ManagerMedicoMisPacientes")->is_paciente_sin_cargo($ConsultaExpress["paciente_idpaciente"], $ConsultaExpress["medico_idmedico"]);
    $this->assign("paciente_sin_cargo", $paciente_sin_cargo);
}
  
  
