<?php

/**
 * 	@autor Xinergia
 * 	@version 1.0	29/05/2014
 * 	Manager de los packs de SMS del Médico
 *
 */
class ManagerSolicitudRenovacionPerfilSaludMedicamento extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "solicitudrenovacionperfilsaludmedicamento", "idsolicitudRenovacionPerfilSaludMedicamento");
    }

    public function insert($record) {
        $record["aceptado"] = 0;
        $record["fechaSolicitud"] = date("Y-m-d H:i:s");


        $rdo = parent::insert($record);
        if ($rdo) {
            //Debo crear la notificación para el médico cuando el paciente pida la renovación de una determinada receta
            $ManagerNotificacion = $this->getManager("ManagerNotificacion");
            $record["idsolicitudRenovacionPerfilSaludMedicamento"] = $rdo;
            $rdo_notificacion = $ManagerNotificacion->processNotificacionSolicitudRenovacion($record);

            return $rdo;
        } else {
            return false;
        }
    }

    /**
     * Método utilizado para aceptar la solicitud de renovación de receta por parte del médico
     * @param type $request
     */
    public function aceptarSolicitudRenovacion($request) {

        $idmedico = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];

        if ($request["fecha_inicio"] == "") {
            $this->setMsg([ "msg" => "Error. Debe ingresar la fecha de inicio de renovación de receta", "result" => false]);
            return false;
        }

        //Busco la solicitud sobre la que se va a aceptar la renovación
        $solicitud = $this->get($request[$this->id]);
        if ($solicitud) {

            $ManagerPerfilSaludMedicamento = $this->getManager("ManagerPerfilSaludMedicamento");
            $ps_medicamento = $ManagerPerfilSaludMedicamento->get($solicitud["perfilSaludMedicamento_idperfilSaludMedicamento"]);

            //Corroboro que haya perfil de salud de medicamento y pertenezca al médico que se encuentra en $_SESSION
            if ($ps_medicamento && $ps_medicamento["medico_idmedico"] == $idmedico) {
                //Debo controlar que la fecha de inicio no sea mayor a la fecha de inicio del medicamento anterior
                $calendar = new Calendar();
                $is_mayor = $calendar->isMayor($ps_medicamento["fecha_inicio"], $this->sqlDate($request["fecha_inicio"]));
                if ($is_mayor == 1) {
                    $this->setMsg([ "msg" => "Error. No hay coherencia con la fecha con la receta anterior", "result" => false]);
                    return false;
                } else {
                    //Inserto el nuevo perfil de medicamento, 
                    $ps_medicamento["fecha_inicio"] = $request["fecha_inicio"];
                    $ps_medicamento["fecha_fin"] = $request["fecha_fin"] == "" ? "" : $request["fecha_fin"];

                    $this->db->StartTrans();

                    unset($ps_medicamento["idperfilSaludMedicamento"]);
                    $process = $ManagerPerfilSaludMedicamento->processFromMedico($ps_medicamento);
                    if (!$process) {
                        $this->setMsg($ManagerPerfilSaludMedicamento->getMsg());

                        $this->db->FailTrans();
                        $this->db->CompleteTrans();
                        return false;
                    }



                    $request["notificarRetiroReceta"] = isset($request["notificarRetiroReceta"]) && (int) $request["notificarRetiroReceta"] == 1 ? 1 : 0;
                    $request["fechaAceptacion"] = date("Y-m-d H:i:s");
                    $request["perfilSaludMedicamento_idperfilSaludMedicamento_aceptado"] = $process;
                    $request["aceptado"] = 1;

                    //Actualizo el registro de renovación de perfil de salud..
                    $update = parent::update($request, $request[$this->id]);
                    if ($update) {
                        //Debo crear la notificación para el médico cuando el paciente pida la renovación de una determinada receta
                        $request["idsolicitudRenovacionPerfilSaludMedicamento"] = $request[$this->id];
                        $request["descripcion"] = $ps_medicamento["motivo"];
                        $ManagerNotificacion = $this->getManager("ManagerNotificacion");
                        $rdo_notificacion = $ManagerNotificacion->processNotificacionAceptacionSolicitudRenovacion($request);

                        if (!$rdo_notificacion) {
                            $this->db->FailTrans();
                            $this->db->CompleteTrans();
                            $this->setMsg([ "msg" => "Error. No se pudo procesar la renovación de la receta, intente nuevamente.", "result" => false]);
                            return false;
                        }


                        $this->db->CompleteTrans();
                        $this->setMsg([ "msg" => "Se renovó la receta con éxito", "result" => true, "id" => $update]);
                        return $update;
                    } else {
                        $this->db->FailTrans();
                        $this->db->CompleteTrans();
                        $this->setMsg([ "msg" => "Error. No se pudo procesar la renovación de la receta, intente nuevamente.", "result" => false]);
                        return false;
                    }
                }
            }
        }
        //Si vino hasta acá es que no se procesó en algún lugar dió error
        $this->setMsg([ "msg" => "Error. No se encontró la receta a rechazar.", "result" => false]);
        return false;
    }

    /**
     * Método utilizado para rechazar la solicitud de renovaciónn por parte del médico
     * @param type $request
     */
    public function rechazarSolicitudRenovacion($request) {
        $idmedico = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];

        $solicitud = $this->get($request[$this->id]);
        if ($solicitud) {


            $ManagerPerfilSaludMedicamento = $this->getManager("ManagerPerfilSaludMedicamento");
            $ps_medicamento = $ManagerPerfilSaludMedicamento->get($solicitud["perfilSaludMedicamento_idperfilSaludMedicamento"]);

            if ($ps_medicamento && $ps_medicamento["medico_idmedico"] == $idmedico) {
                $request["aceptado"] = 2;
                $request["fechaAceptacion"] = date("Y-m-d H:i:s");

                $rdo = parent::update($request, $request[$this->id]);
                if ($rdo) {
                    $ManagerNotificacion = $this->getManager("ManagerNotificacion");
                    $request["perfilSaludMedicamento_idperfilSaludMedicamento"] = $solicitud["perfilSaludMedicamento_idperfilSaludMedicamento"];
                    $rdo_notificacion = $ManagerNotificacion->processNotificacionRechazoSolicitudRenovacion($request);


                    $this->setMsg([ "msg" => "La solicitud fue rechazada con éxito", "result" => true, "id" => $rdo]);
                    return $rdo;
                } else {
                    $this->setMsg([ "msg" => "Error. No se pudo rechazar la solicitud de receta seleccionada.", "result" => false]);
                    return false;
                }
            }
        }
        //Si vino hasta acá es que no se procesó en algún lugar dió error
        $this->setMsg([ "msg" => "Error. No se encontró la receta a rechazar.", "result" => false]);
        return false;
    }

    /**
     * Método que obtiene las solicitudes de renovación para el médico
     * @param type $idmedico
     */
    public function getListSolicitudFromMedico($idmedico = null) {

        if (is_null($idmedico)) {
            $idmedico = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];
        }

        $query = new AbstractSql();

        $query->setSelect("
                        srp.*, 
                        psm.*, 
                        uwm.nombre as nombre_medico, 
                        uwm.apellido as apellido_medico, 
                        uwp.nombre as nombre_paciente, 
                        uwp.apellido as apellido_paciente
                    ");

        $query->setFrom("$this->table srp 
                            INNER JOIN perfilsaludmedicamento psm ON (srp.perfilSaludMedicamento_idperfilSaludMedicamento = psm.idperfilSaludMedicamento)
                            INNER JOIN medico m ON (psm.medico_idmedico = m.idmedico)
                            INNER JOIN usuarioweb uwm ON (uwm.idusuarioweb = m.usuarioweb_idusuarioweb)
                            INNER JOIN paciente p ON (psm.paciente_idpaciente = p.idpaciente)
                            INNER JOIN usuarioweb uwp ON (uwp.idusuarioweb = p.usuarioweb_idusuarioweb)
                    ");

        $query->setWhere("psm.medico_idmedico = $idmedico");

        $query->addAnd("srp.visto_medico = 0");


        $listado = $this->getList($query);


        if ($listado && count($listado) > 0) {
            require_once path_helpers('base/general/Calendar.class.php');
            $calendar = new Calendar();
            foreach ($listado as $key => $value) {
                if ($value["fechaSolicitud"] != "") {
                    $date_explode = explode(" ", $value["fechaSolicitud"]);
                    if (count($date_explode) == 2) {
                        list($y, $m, $d) = preg_split("[-]", $date_explode[0]);
                        $mes = $calendar->getMonthsShort((int) $m);
                        $listado[$key]["fechaSolicitud_format"] = "$d $mes $y " . $date_explode[1];
                    }
                }
            }
            return $listado;
        } else {
            return false;
        }
    }

    /**
     * Método que obtiene las solicitudes de renovación para el paciente
     * @param type $idpaciente
     */
    public function getListSolicitudFromPaciente($idpaciente = null) {

        if (is_null($idpaciente)) {
            $ManagerPaciente = $this->getManager("ManagerPaciente");
            $paciente = $ManagerPaciente->getPacienteXHeader();
            $idpaciente = $paciente["idpaciente"];
        }

        $query = new AbstractSql();

        $query->setSelect("
                        srp.*, 
                        psm.*, 
                        uwm.nombre as nombre_medico, 
                        uwm.apellido as apellido_medico, 
                        uwp.nombre as nombre_paciente, 
                        uwp.apellido as apellido_paciente
                    ");

        $query->setFrom("$this->table srp 
                            INNER JOIN perfilsaludmedicamento psm ON (srp.perfilSaludMedicamento_idperfilSaludMedicamento = psm.idperfilSaludMedicamento)
                            INNER JOIN medico m ON (psm.medico_idmedico = m.idmedico)
                            INNER JOIN usuarioweb uwm ON (uwm.idusuarioweb = m.usuarioweb_idusuarioweb)
                            INNER JOIN paciente p ON (psm.paciente_idpaciente = p.idpaciente)
                            INNER JOIN usuarioweb uwp ON (uwp.idusuarioweb = p.usuarioweb_idusuarioweb)
                    ");

        $query->setWhere("psm.paciente_idpaciente = $idpaciente");

        $query->addAnd("srp.visto_paciente = 0");

        $listado = $this->getList($query);

        if ($listado && count($listado) > 0) {
            require_once path_helpers('base/general/Calendar.class.php');
            $calendar = new Calendar();
            foreach ($listado as $key => $value) {
                if ($value["fechaSolicitud"] != "") {
                    $date_explode = explode(" ", $value["fechaSolicitud"]);
                    if (count($date_explode) == 2) {
                        list($y, $m, $d) = preg_split("[-]", $date_explode[0]);
                        $mes = $calendar->getMonthsShort((int) $m);
                        $listado[$key]["fechaSolicitud_format"] = "$d $mes $y " . $date_explode[1];
                    }
                }
            }
            return $listado;
        } else {
            return false;
        }
    }

}

//END_class
?>