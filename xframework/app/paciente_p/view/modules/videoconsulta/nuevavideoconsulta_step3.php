<?php

//Paciente que se encuentra en el array de SESSION de header paciente
$ManagerPaciente = $this->getManager("ManagerPaciente");
$paciente = $ManagerPaciente->getPacienteXHeader();
$this->assign("paciente", $paciente);

$motivos = $this->getManager("ManagerMotivoVideoConsulta")->getCombo();
$this->assign("combo_motivos", $motivos);

//obtenemos la consulta
if (isset($this->request["idvideoconsulta"]) && $this->request["idvideoconsulta"] != "") {

    $VideoConsulta = $this->getManager("ManagerVideoConsulta")->get($this->request["idvideoconsulta"]);
    $this->assign("VideoConsulta", $VideoConsulta);

    $mensaje = $this->getManager("ManagerMensajeVideoConsulta")->getListadoMensajes($this->request["idvideoconsulta"]);
    $this->assign("mensaje", $mensaje[0]);

    $listado_imagenes_mensajes = $this->getManager("ManagerArchivosMensajeVideoConsulta")->getListImages($mensaje[0]["idmensajeVideoConsulta"]);
    $this->assign("listado_imagenes_mensajes", $listado_imagenes_mensajes);
}
if ($VideoConsulta["tipo_consulta"] == "1" && $VideoConsulta["medico_idmedico"] != "") {
    $medico = $this->getManager("ManagerMedico")->get($VideoConsulta["medico_idmedico"], true);
    $this->assign("medico", $medico);

    //calculamos si tiene acceso al perfil de salud el medico
    $this->assign("acceso_perfil_salud", $medico["mis_especialidades"][0]["acceso_perfil_salud"]);
    //modal cambio privacidad
    $this->assign("txt_change_privacidad", "Professionnels Fréquents et Favoris");
    if ($paciente["privacidad_perfil_salud"] == 0) {
        $this->assign("mostrar_cambio_privacidad", 1);
        $this->assign("perfil_privado", 1);
    } else {
        $this->assign("mostrar_cambio_privacidad", 0);
        $this->assign("perfil_privado", 0);
    }

    //buscamos los motivos pòr especialidad
    $motivos = $this->getManager("ManagerMotivoVideoConsulta")->getComboByEspecialidad($medico["mis_especialidades"][0]["idespecialidad"]);
    $this->assign("combo_motivos", $motivos);

    //verificamos si tiene un consulta pendiente con el mismo medico
    $consulta_pendiente_exist = $this->getManager("ManagerVideoConsulta")->getByFieldArray(["medico_idmedico", "paciente_idpaciente", "estadoVideoConsulta_idestadoVideoConsulta", "tipo_consulta"], [$medico["idmedico"], $paciente["idpaciente"], 1, 1]);
    if ($consulta_pendiente_exist) {
        $this->assign("consulta_pendiente_exist", $consulta_pendiente_exist);
    }
    //buscamos el programa al que pertenece
    if ((int) $VideoConsulta["idprograma_categoria"] > 0) {
        $programa_categoria = $this->getManager("ManagerProgramaSaludCategoria")->get($VideoConsulta["idprograma_categoria"]);
        $programa_salud = $this->getManager("ManagerProgramaSalud")->get($programa_categoria["programa_salud_idprograma_salud"]);
        $this->assign("programa_categoria", $programa_categoria);
        $this->assign("programa_salud", $programa_salud);

        //buscamos los motivos para la especialidad
        $motivos = $this->getManager("ManagerMotivoVideoConsulta")->getComboByProgramaCategoria($VideoConsulta["idprograma_categoria"]);
        $this->assign("combo_motivos", $motivos);
    } else {
        //si no se selecciono el programa mostramos el select para elegirlo
        $ManagerProgramaSaludCategoria = $this->getManager("ManagerProgramaSaludCategoria");
        $combo_programas = $ManagerProgramaSaludCategoria->getComboFullCategoriasByMedico($VideoConsulta["medico_idmedico"]);
        $this->assign("combo_programas", $combo_programas);

        //obtenermos si es paciente empresa y cuantas consultas tiene
        $paciente_empresa = $this->getManager("ManagerPacienteEmpresa")->getByField("paciente_idpaciente", $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["paciente"]["idpaciente"]);
        if ($paciente_empresa) {
            $plan_contratado = $this->getManager("ManagerProgramaSaludPlan")->get($paciente_empresa["plan_idplan"]);

            $paciente["ce_disponibles"] = (int) $plan_contratado["cant_consultaexpress"] - (int) $paciente_empresa["cant_consultaexpress"];
            $paciente["vc_disponibles"] = (int) $plan_contratado["cant_videoconsulta"] - (int) $paciente_empresa["cant_videoconsulta"];

            //obtenermos si es paciente empresa y los programas bonificados
            if ((int) $paciente["vc_disponibles"] > 0) {
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
    $filtro = $this->getManager("ManagerFiltrosBusquedaVideoConsulta")->getByField("videoconsulta_idvideoconsulta", $VideoConsulta["idvideoconsulta"]);

    if ($filtro["especialidad_idespecialidad"] != "") {
        $especialidad = $this->getManager("ManagerEspecialidades")->get($filtro["especialidad_idespecialidad"]);
        $this->assign("especialidad", $especialidad);
        $this->assign("acceso_perfil_salud", $especialidad["acceso_perfil_salud"]);

        //buscamos los motivos para la especialidad
        $motivos = $this->getManager("ManagerMotivoVideoConsulta")->getComboByEspecialidad($filtro["especialidad_idespecialidad"]);
        $this->assign("combo_motivos", $motivos);
    }
    //buscamos el programa al que pertenece
    if ((int) $filtro["idprograma_categoria"] > 0) {
        $programa_categoria = $this->getManager("ManagerProgramaSaludCategoria")->get($filtro["idprograma_categoria"]);
        $programa_salud = $this->getManager("ManagerProgramaSalud")->get($programa_categoria["programa_salud_idprograma_salud"]);
        $this->assign("programa_categoria", $programa_categoria);
        $this->assign("programa_salud", $programa_salud);

        //buscamos los motivos para la especialidad
        $motivos = $this->getManager("ManagerMotivoVideoConsulta")->getComboByProgramaCategoria($filtro["idprograma_categoria"]);
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
  
  
  
