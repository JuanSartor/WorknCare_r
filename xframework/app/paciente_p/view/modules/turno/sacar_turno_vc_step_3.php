<?php

$idturno = (int) $this->request["turno"];
$ManagerTurno = $this->getManager("ManagerTurno");

if ((int) $idturno > 0) {
    $turno = $ManagerTurno->getTurno($idturno);
    $this->assign("turno", $turno);

    if ($turno["paciente_idpaciente"] != "") {
        $paciente = $this->getManager("ManagerPaciente")->get($turno["paciente_idpaciente"]);
    }


    $medico = $this->getManager("ManagerMedico")->get($turno["medico_idmedico"], true);
    //verificamos si es medico de cabecera
    $prof_frecuente = $this->getManager("ManagerProfesionalesFrecuentesPacientes")->getByFieldArray(["paciente_idpaciente", "medico_idmedico"], [$paciente["idpaciente"], $turno["medico_idmedico"]]);
    if ($prof_frecuente["medico_cabecera"] == 1) {
        $medico["medico_cabecera"] = 1;
    } else {
        $medico["medico_cabecera"] = 0;
    }
    $this->assign("medico", $medico);

    $consultorio = $this->getManager("ManagerConsultorio")->get($turno["consultorio_idconsultorio"]);
    $this->assign("consultorio", $consultorio);


    $cuenta_paciente = $this->getManager("ManagerCuentaUsuario")->getCuentaPaciente($_SESSION[URL_ROOT][CONTROLLER]['logged_account']["paciente"]["idpaciente"]);
    $preferencia = $this->getManager("ManagerPreferencia")->getPreferenciaMedico($consultorio["medico_idmedico"]);

    $tarifa_videconsulta = $this->getManager("ManagerGrilla")->getTarifaVideoConsulta($paciente, $medico);

    $this->assign("cuenta_paciente", $cuenta_paciente);
    $this->assign("STRIPE_APIKEY_PUBLIC", STRIPE_APIKEY_PUBLIC);
    //obtenermos si es paciente empresa y cuantas consultas tiene
    $paciente_empresa = $this->getManager("ManagerPacienteEmpresa")->getByField("paciente_idpaciente", $cuenta_paciente["paciente_idpaciente"]);
    if ($paciente_empresa) {
        $plan_contratado = $this->getManager("ManagerProgramaSaludPlan")->get($paciente_empresa["plan_idplan"]);
        $this->assign("paciente_empresa", $paciente_empresa);
        $this->assign("plan_contratado", $plan_contratado);
        $paciente["vc_disponibles"] = (int) $plan_contratado["cant_videoconsulta"] - (int) $paciente_empresa["cant_videoconsulta"];
        //verificamos si el medico está incluido en los planes cubiertos por la empresa
        $medico_bonificado = $this->getManager("ManagerProgramaSaludExcepcion")->verificar_medico_bonificado($medico["idmedico"], $paciente_empresa["empresa_idempresa"], $turno["idprograma_categoria"]);
        if ($medico_bonificado) {
            $this->assign("medico_bonificado", 1);
        }
    }



    $this->assign("paciente", $paciente);

    //metodos de pago cargados en Stripe
    $metodo_pago_list = $this->getManager("ManagerCustomerStripe")->get_listado_metodos_pago($cuenta_paciente["paciente_idpaciente"]);
    $this->assign("metodo_pago_list", $metodo_pago_list["data"]);

    $this->assign("preferencia", $preferencia);
    $this->assign("tarifa_videconsulta", $tarifa_videconsulta);
    //buscamos el programa al que pertenece
    if ((int) $turno["idprograma_categoria"] > 0) {
        $programa_categoria = $this->getManager("ManagerProgramaSaludCategoria")->get($turno["idprograma_categoria"]);
        $programa_salud = $this->getManager("ManagerProgramaSalud")->get($programa_categoria["programa_salud_idprograma_salud"]);
        $this->assign("programa_categoria", $programa_categoria);
        $this->assign("programa_salud", $programa_salud);

    }
}
