<?php

//Paciente que se encuentra en el array de SESSION de header paciente
$ManagerPaciente = $this->getManager("ManagerPaciente");
$paciente = $ManagerPaciente->getPacienteXHeader();
$this->assign("paciente", $paciente);



//obtenemos la consulta
if (isset($this->request["idconsultaExpress"]) && $this->request["idconsultaExpress"] != "") {

    $ConsultaExpress = $this->getManager("ManagerConsultaExpress")->get($this->request["idconsultaExpress"]);
    $this->assign("ConsultaExpress", $ConsultaExpress);

    $mensaje = $this->getManager("ManagerMensajeConsultaExpress")->getListadoMensajes($this->request["idconsultaExpress"]);
    $this->assign("mensaje", $mensaje[0]);

    $listado_imagenes_mensajes = $this->getManager("ManagerArchivosMensajeConsultaExpress")->getListImages($mensaje[0]["idmensajeConsultaExpress"]);
    $this->assign("listado_imagenes_mensajes", $listado_imagenes_mensajes);
}
if ($ConsultaExpress["tipo_consulta"] == "1" && $ConsultaExpress["medico_idmedico"] != "") {
    $medico = $this->getManager("ManagerMedico")->get($ConsultaExpress["medico_idmedico"], true);
    $this->assign("medico", $medico);
    //calculamos si tiene acceso al perfil de salud el medico
    $this->assign("acceso_perfil_salud", $medico["mis_especialidades"][0]["acceso_perfil_salud"]);

//modal cambio privacidad
    //si el paciente no tiene el perfil de salud visible para todos y no es frecuente, mostramos el modal de alerta
    $this->assign("txt_change_privacidad", "Professionnels Fréquents et Favoris");
    if ($paciente["privacidad_perfil_salud"] == 0) {
        $this->assign("mostrar_cambio_privacidad", 1);
        $this->assign("perfil_privado", 1);
    } else {
        $this->assign("mostrar_cambio_privacidad", 0);
        $this->assign("perfil_privado", 0);
    }

    //buscamos los motivos para la especialidad
    $motivos = $this->getManager("ManagerMotivoConsultaExpress")->getComboByEspecialidad($medico["mis_especialidades"][0]["idespecialidad"]);
    $this->assign("combo_motivos", $motivos);

    //verificamos si tiene un consulta pendiente con el mismo medico
    $consulta_pendiente_exist = $this->getManager("ManagerConsultaExpress")->getByFieldArray(["medico_idmedico", "paciente_idpaciente", "estadoConsultaExpress_idestadoConsultaExpress", "tipo_consulta"], [$medico["idmedico"], $paciente["idpaciente"], 1, 1]);
    if ($consulta_pendiente_exist) {
        $this->assign("consulta_pendiente_exist", $consulta_pendiente_exist);
    }
    //buscamos el programa al que pertenece
    if ((int) $ConsultaExpress["idprograma_categoria"] > 0) {
        $programa_categoria = $this->getManager("ManagerProgramaSaludCategoria")->get($ConsultaExpress["idprograma_categoria"]);
        $programa_salud = $this->getManager("ManagerProgramaSalud")->get($programa_categoria["programa_salud_idprograma_salud"]);
        $this->assign("programa_categoria", $programa_categoria);
        $this->assign("programa_salud", $programa_salud);

        //buscamos los motivos para la especialidad
        $motivos = $this->getManager("ManagerMotivoConsultaExpress")->getComboByProgramaCategoria($ConsultaExpress["idprograma_categoria"]);
        $this->assign("combo_motivos", $motivos);
    } else {
        //si no se selecciono el programa mostramos el select para elegirlo
        $ManagerProgramaSaludCategoria = $this->getManager("ManagerProgramaSaludCategoria");
        $combo_programas = $ManagerProgramaSaludCategoria->getComboFullCategoriasByMedico($ConsultaExpress["medico_idmedico"]);
        $this->assign("combo_programas", $combo_programas);

        //obtenermos si es paciente empresa y cuantas consultas tiene
        $paciente_empresa = $this->getManager("ManagerPacienteEmpresa")->getByField("paciente_idpaciente", $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["paciente"]["idpaciente"]);
        if ($paciente_empresa) {
            $plan_contratado = $this->getManager("ManagerProgramaSaludPlan")->get($paciente_empresa["plan_idplan"]);

            $paciente["ce_disponibles"] = (int) $plan_contratado["cant_consultaexpress"] - (int) $paciente_empresa["cant_consultaexpress"];
            $paciente["vc_disponibles"] = (int) $plan_contratado["cant_videoconsulta"] - (int) $paciente_empresa["cant_videoconsulta"];

            //obtenermos si es paciente empresa y los programas bonificados
            if ((int) $paciente["ce_disponibles"] > 0) {
                $ManagerProgramaSaludExcepcion = $this->getManager("ManagerProgramaSaludExcepcion");
                $excepciones_programa = $ManagerProgramaSaludExcepcion->getByField("empresa_idempresa", $paciente_empresa["empresa_idempresa"]);
                if ($excepciones_programa["programa_salud_excepcion"] != "") {
                    $this->assign("ids_excepciones_programa", $excepciones_programa["programa_salud_excepcion"]);
                } else {
                    $this->assign("ids_excepciones_programa", "ALL");
                }
            }
        }
    }
} else {
    $filtro = $this->getManager("ManagerFiltrosBusquedaConsultaExpress")->getByField("consultaExpress_idconsultaExpress", $ConsultaExpress["idconsultaExpress"]);

    if ($filtro["especialidad_idespecialidad"] != "") {
        $especialidad = $this->getManager("ManagerEspecialidades")->get($filtro["especialidad_idespecialidad"]);
        $this->assign("especialidad", $especialidad);
        $this->assign("acceso_perfil_salud", $especialidad["acceso_perfil_salud"]);

        //buscamos los motivos para la especialidad
        $motivos = $this->getManager("ManagerMotivoConsultaExpress")->getComboByEspecialidad($filtro["especialidad_idespecialidad"]);
        $this->assign("combo_motivos", $motivos);
    }
    //buscamos el programa al que pertenece
    if ((int) $filtro["idprograma_categoria"] > 0) {
        $programa_categoria = $this->getManager("ManagerProgramaSaludCategoria")->get($filtro["idprograma_categoria"]);
        $programa_salud = $this->getManager("ManagerProgramaSalud")->get($programa_categoria["programa_salud_idprograma_salud"]);
        $this->assign("programa_categoria", $programa_categoria);
        $this->assign("programa_salud", $programa_salud);

        //buscamos los motivos para la especialidad
        $motivos = $this->getManager("ManagerMotivoConsultaExpress")->getComboByProgramaCategoria($filtro["idprograma_categoria"]);
        $this->assign("combo_motivos", $motivos);
    }

    if ((int) $filtro["idprograma_salud"] > 0) {
        $programa_salud = $this->getManager("ManagerProgramaSalud")->get($filtro["idprograma_salud"]);
        $this->assign("programa_salud", $programa_salud);
    }




//si el paciente no tiene el perfil de salud visible para todos, mostramos el modal de alerta
    $this->assign("txt_change_privacidad", "Tous les Professionnels");
    if ($paciente["privacidad_perfil_salud"] != 2) {
        $this->assign("mostrar_cambio_privacidad", 1);
        $this->assign("perfil_privado", 2);
    } else {
        $this->assign("mostrar_cambio_privacidad", 0);
        $this->assign("perfil_privado", 0);
    }
}
  
  
  
