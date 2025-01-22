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
    $paciente["vc_disponibles"] = (int) $plan_contratado["cant_videoconsulta"] - (int) $paciente_empresa["cant_videoconsulta"];
}
$this->assign("paciente", $paciente);
//metodos de pago cargados en Stripe
$metodo_pago_list = $this->getManager("ManagerCustomerStripe")->get_listado_metodos_pago($cuenta_paciente["paciente_idpaciente"]);
$this->assign("metodo_pago_list", $metodo_pago_list["data"]);

//obtenemos la consulta

if (isset($this->request["idvideoconsulta"]) && $this->request["idvideoconsulta"] != "") {

    $VideoConsulta = $this->getManager("ManagerVideoConsulta")->get($this->request["idvideoconsulta"]);
    $this->assign("VideoConsulta", $VideoConsulta);

    //tipo: todos profesionales red
    if ($VideoConsulta["tipo_consulta"] == "0") {
        $filtro = $this->getManager("ManagerFiltrosBusquedaVideoConsulta")->getByField("videoconsulta_idvideoconsulta", $VideoConsulta["idvideoconsulta"]);
        $this->assign("filtro", $filtro);
        $especialidad = $this->getManager("ManagerEspecialidades")->get($filtro["especialidad_idespecialidad"]);
        $this->assign("especialidad", $especialidad);

        if ($paciente_empresa) {
            //verificamos si el programa está incluido en los planes cubiertos por la empresa
            $programa_bonificado = $this->getManager("ManagerProgramaSaludExcepcion")->verificar_programa_bonificado($filtro["idprograma_categoria"], $paciente_empresa["empresa_idempresa"]);
            if ($programa_bonificado) {
                $this->assign("programa_bonificado", 1);
            }
        }
        //seteamos la cantidad de medicos en la bolsa
        $bolsa = explode(',', $VideoConsulta["ids_medicos_bolsa"]);
        $this->assign("cant_profesionales_bolsa", count($bolsa) - 2); //resto 2 por el primer y ultimo lugar vacio en el array
    } else {
        //tipo: profesional en particular
        $especialidades_medico = $this->getManager("ManagerEspecialidadMedico")->getEspecialidadesMedico($VideoConsulta["medico_idmedico"]);

        $this->assign("especialidades_medico", $especialidades_medico);

        $medico = $this->getManager("ManagerMedico")->get($VideoConsulta["medico_idmedico"], true);

        //verificamos si es medico de cabecera
        $prof_frecuente = $this->getManager("ManagerProfesionalesFrecuentesPacientes")->getByFieldArray(["paciente_idpaciente", "medico_idmedico"], [$paciente["idpaciente"], $medico["idmedico"]]);
        if ($prof_frecuente["medico_cabecera"] == 1) {
            $medico["medico_cabecera"] = 1;
        } else {
            $medico["medico_cabecera"] = 0;
        }

        $this->assign("medico", $medico);
        if ($paciente_empresa) {
            //verificamos si el medico está incluido en los planes cubiertos por la empresa
            $medico_bonificado = $this->getManager("ManagerProgramaSaludExcepcion")->verificar_medico_bonificado($medico["idmedico"], $paciente_empresa["empresa_idempresa"], $VideoConsulta["idprograma_categoria"]);
            if ($medico_bonificado) {
                $this->assign("medico_bonificado", 1);
            }
        }

        $tarifa_videconsulta = $this->getManager("ManagerGrilla")->getTarifaVideoConsulta($paciente, $medico);
        $this->assign("tarifa_videconsulta", $tarifa_videconsulta);
    }
}

$ManagerProgramaSaludCategoria = $this->getManager("ManagerProgramaSaludCategoria");
$ProgramaSaludCategoria = $ManagerProgramaSaludCategoria->get($VideoConsulta["idprograma_categoria"]);


$recompensa = $this->getManager("ManagerCuestionario")->obtenerGratisOnoGanado($ProgramaSaludCategoria["programa_salud_idprograma_salud"]);
$this->assign("recompensa", $recompensa);


