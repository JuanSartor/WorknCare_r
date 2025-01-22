<?php

require_once(path_libs("libs_php/ElephantIO/Client.php"));
require_once(path_libs("libs_php/ElephantIO/Engine/SocketIO/Version1X.php"));

use ElephantIO\Client as ElephantClient;
use ElephantIO\Engine\SocketIO\Version1X;

/**
 * 	@autor Xinergia
 * 	@version 1.0	29/05/2014
 * 	Manager de los packs de SMS del Médico
 *
 */
class ManagerNotificacion extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "notificacion", "idnotificacion");
    }

    /**
     * Método que retorna la cantidad de notificaciones pertenecientes a los médicos
     * @param type $idmedico
     * @return int
     */
    public function getCantidadNotificacionesMedico($idmedico) {
        $query = new AbstractSql();

        $query->setSelect("t.*");

        $query->setFrom("$this->table t");

        $query->setWhere("(t.medico_idmedico = $idmedico )");

        $query->addAnd("t.leido = 0");

        $listado = $this->getList($query);

        if ($listado && count($listado) > 0) {
            return count($listado);
        } else {
            return 0;
        }
    }

    /**
     * Metodo que retorna un listado paginado ordenado por fecha sobre las solicitudes no leídas de los médicos
     * "TAB 1"
     * @param array $request
     * @param type $idpaginate
     * @return type
     */
    public function getListadoPaginadoMedico($request, $idpaginate = null) {

        if (isset($request["do_reset"]) && $request["do_reset"] == 1) {
            $this->resetPaginate($idpaginate);
        }

        if (!is_null($idpaginate)) {
            $this->paginate($idpaginate, 20);
        }

        $idmedico = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];

        //Seteo el current page
        $request["current_page"] = $request["current_page"] != "" ? $request["current_page"] : 1;
        SmartyPaginate::setCurrentPage($request["current_page"], $idpaginate);

        $query = new AbstractSql();

        $query->setSelect("
                            if (t.notificacion_idnotificacionRespuesta is null, t.idnotificacion,t.notificacion_idnotificacionRespuesta) as idgroup,
                            t.*,
                            tn.*,
                          
                            CASE WHEN t.estado_turno = 0 THEN 'Rendez-vous Demandé'
                                WHEN t.estado_turno = 1 THEN 'Rendez-vous Confirmé'
                                WHEN t.estado_turno = 2 THEN 'Rendez-vous Annulé'
                                WHEN t.estado_turno = 3 THEN 'Rendez-vous Décliné'
                                WHEN t.estado_turno = 5 THEN 'Patient Absent'
                                WHEN t.estado_turno = 6 THEN 'Rendez-vous Reporté'
                            END AS estado_format,
                            
                            
                            
                            srr.nombre_medico as nombre_medico_renovacion, 
                            srr.apellido_medico as apellido_medico_renovacion, 
                            srr.nombre_paciente as nombre_paciente_renovacion, 
                            srr.apellido_paciente as apellido_paciente_renovacion,
                            srr.mensajePaciente,
                            srr.nombre_medicamento,
                            srr.posologia,
                            srr.fecha_fin,
                            srr.fecha_inicio,
                            srr.aceptado,
                            srr.tipoTomaMedicamentos_idtipoTomaMedicamentos,
                            
                            ce.nombre as nombre_medico_ce,
                            ce.apellido as apellido_medico_ce,
                            ce.consulta,
                            ce.ids,
                            
                            uw.nombre as nombre_medico,
                            uw.apellido as apellido_medico,
                            
                            ns.url
                            ");

        $query->setFrom("$this->table t
                            INNER JOIN tiponotificacion tn ON (
                                    t.tipoNotificacion_idtipoNotificacion = tn.idtipoNotificacion
                            )
                            INNER JOIN medico m ON (
                                    m.idmedico = t.medico_idmedico
                            )
                            INNER JOIN usuarioweb uw ON (
                                    m.usuarioweb_idusuarioweb = uw.idusuarioweb
                            )
                            LEFT JOIN v_solicitudrenovacionreceta srr ON (
                                    t.idsolicitudRenovacionPerfilSaludMedicamento = srr.idsolicitudRenovacionPerfilSaludMedicamento
                            )
                            
                            LEFT JOIN v_compartirestudio ce ON (
                                    t.medicoCompartirEstudio_idmedicoCompartirEstudio = ce.idmedicoCompartirEstudio
                            )
                            LEFT JOIN notificacionsistema ns ON (t.notificacionSistema_idnotificacionSistema = ns.idnotificacionSistema)
                        ");

        $query->setWhere("(t.medico_idmedico = $idmedico ) and t.archivar <> 1");

        //$query->addAnd("t.leido = 0");

        $query->setGroupBy("t.idnotificacion");

        $query->setOrderBy("t.fechaNotificacion DESC");

        /*         * agreupàmos las notificaciones que son respuestas de mensajes en una sola notificacion */
        $query2 = new AbstractSql();
        $query2->setSelect("T1.*");
        $query2->setFrom("({$query->getSql()}) T1");
        $query2->setGroupBy("T1.idgroup");
        $query2->setOrderBy("T1.fechaNotificacion DESC");
        $listado = $this->getListPaginado($query2, $idpaginate);
        if ($listado && count($listado["rows"])) {
            $ManagerTurno = $this->getManager("ManagerTurno");
            $ManagerTipoTomaMedicamentos = $this->getManager("ManagerTipoTomaMedicamentos");
            $ManagerMedico = $this->getManager("ManagerMedico");
            $ManagerPerfilSaludEstudiosImagen = $this->getManager("ManagerPerfilSaludEstudiosImagen");
            $ManagerMensajeTurno = $this->getManager("ManagerMensajeTurno");
            require_once path_helpers('base/general/Calendar.class.php');
            $calendar = new Calendar();
            foreach ($listado["rows"] as $key => $notificacion) {

                if ($notificacion["fechaNotificacion"] != "") {
                    //TODO: Poner formato notificaciones médico
                    if ($notificacion["fechaNotificacion"] != "") {
                        $date_explode = explode(" ", $notificacion["fechaNotificacion"]);
                        if (count($date_explode) == 2) {
                            list($y, $m, $d) = preg_split("[-]", $date_explode[0]);
                            list($hs, $mn, $sg) = preg_split("[:]", $date_explode[1]);
                            $mes = $calendar->getMonthsShort((int) $m);
                            $listado["rows"][$key]["fechaNotificacion_format"] = "$d $mes $hs:$mn ";
                        }
                    }
                }

                //Si es de tipo de toma de medicamentos
                if ((int) $notificacion["tipoNotificacion_idtipoNotificacion"] == 1) {

                    $listado["rows"][$key]["tipo_toma_medicamentos"] = $ManagerTipoTomaMedicamentos->get($notificacion["tipoTomaMedicamentos_idtipoTomaMedicamentos"]);
                }

                //Si es de tipo de turno
                if ((int) $notificacion["tipoNotificacion_idtipoNotificacion"] == 3 && $notificacion["turno_idturno"] != "") {
                    $turno = $ManagerTurno->get($notificacion["turno_idturno"]);
                    if (strtotime($turno["fecha"] . " " . $turno["horarioInicio"]) < strtotime(date("Y-m-d H:i:s"))) {
                        $turno["turno_pasado"] = 1;
                    }
                    $listado["rows"][$key]["turno"] = $turno;
                    $listado["rows"][$key]["mensajes"] = $ManagerMensajeTurno->getListadoMensajes($notificacion["turno_idturno"], $notificacion["paciente_idpaciente_emisor"]);
                }

                //Si es de tipo compartir estudio -> Tengo que buscar si hay notificaciones anteriores como respuestas
                if ((int) $notificacion["tipoNotificacion_idtipoNotificacion"] == 2) {

                    if ($notificacion["medico_idmedicoRespuesta"] != "") {

                        $medico = $ManagerMedico->get($notificacion["medico_idmedicoRespuesta"]);
                        $listado["rows"][$key]["nombre_medico_respuesta"] = $medico["nombre"];
                        $listado["rows"][$key]["apellido_medico_respuesta"] = $medico["apellido"];
                    }


                    //buscamos los mensajes anteriores relacionados
                    $listado["rows"][$key]["mensajes_anteriores"] = array();
                    if ($notificacion["notificacion_idnotificacionRespuesta"] != "") {
                        $listado["rows"][$key]["mensajes_anteriores"] = $this->getNotificacionesMensajesAnteriores($notificacion["notificacion_idnotificacionRespuesta"]);
                    }
                }


                /**
                 * NOTIFICACIONES COMPARTIR ESTUDIO
                 */
                if ($notificacion["medicoCompartirEstudio_idmedicoCompartirEstudio"] != "") {


                    /**
                     * Busco las imágenes de los estudios compartidos
                     */
                    $list_ids = explode(",", $notificacion["ids"]);

                    if (count($list_ids) > 0) {



                        $attach = array();

                        foreach ($list_ids as $key2 => $id) {
                            if ((int) $id > 0) {

                                $imagenes = $ManagerPerfilSaludEstudiosImagen->getListImages((int) $id);

                                // $filename = path_entity_files("estudios_imagenes/$id/" . $estudio["nombre_archivo"] . ".jpg");
                            }
                        }
                        $registro["file"] = $imagenes;
                    }

                    $listado["rows"][$key]["file"][] = $registro["file"];
                }
            }

            // print_r($listado);
            return $listado;
        } else {
            return false;
        }
    }

    /**
     * Listado paginado de las notificaciones de renovación de recetas..
     * @param array $request
     * @param type $idpaginate
     * @return string|boolean
     */
    public function getNotificacionesRenovacion($request, $idpaginate = null) {
        if (isset($request["do_reset"]) && $request["do_reset"] == 1) {
            $this->resetPaginate($idpaginate);
        }

        if (!is_null($idpaginate)) {
            $this->paginate($idpaginate, 20);
        }

        $idmedico = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];

        //Seteo el current page
        $request["current_page"] = $request["current_page"] != "" ? $request["current_page"] : 1;
        SmartyPaginate::setCurrentPage($request["current_page"], $idpaginate);

        $query = new AbstractSql();

        $query->setSelect("t.*,
                            tn.*,
                            srr.nombre_medico as nombre_medico_renovacion, 
                            srr.apellido_medico as apellido_medico_renovacion, 
                            srr.nombre_paciente as nombre_paciente_renovacion, 
                            srr.apellido_paciente as apellido_paciente_renovacion,
                            srr.mensajePaciente,
                            srr.aceptado,
                            srr.nombre_medicamento,
                            srr.posologia,
                            srr.tipoTomaMedicamentos_idtipoTomaMedicamentos,
                            srr.fecha_fin,
                            srr.fecha_inicio
                            ");

        $query->setFrom("$this->table t
                            INNER JOIN tiponotificacion tn ON (
                                    t.tipoNotificacion_idtipoNotificacion = tn.idtipoNotificacion
                            )  
                            INNER JOIN v_solicitudrenovacionreceta srr ON (
                                    t.idsolicitudRenovacionPerfilSaludMedicamento = srr.idsolicitudRenovacionPerfilSaludMedicamento
                            )
                        ");

        $query->setWhere("(t.medico_idmedico = $idmedico )");

        $query->setGroupBy("t.idnotificacion");

        $query->setOrderBy("t.fechaNotificacion DESC");

        $listado = $this->getListPaginado($query, $idpaginate);

        if ($listado && count($listado["rows"])) {
            require_once path_helpers('base/general/Calendar.class.php');
            $calendar = new Calendar();
            foreach ($listado["rows"] as $key => $notificacion) {

                if ($notificacion["fechaNotificacion"] != "") {
                    //TODO: Poner formato notificaciones médico
                    if ($notificacion["fechaNotificacion"] != "") {
                        $date_explode = explode(" ", $notificacion["fechaNotificacion"]);
                        if (count($date_explode) == 2) {
                            list($y, $m, $d) = preg_split("[-]", $date_explode[0]);
                            list($hs, $mn, $sg) = preg_split("[:]", $date_explode[1]);
                            $mes = $calendar->getMonthsShort((int) $m);
                            $listado["rows"][$key]["fechaNotificacion_format"] = "$d $mes $hs:$mn ";
                        }
                    }
                }

                $ManagerTipoTomaMedicamentos = $this->getManager("ManagerTipoTomaMedicamentos");
                $listado["rows"][$key]["tipo_toma_medicamentos"] = $ManagerTipoTomaMedicamentos->get($notificacion["tipoTomaMedicamentos_idtipoTomaMedicamentos"]);
            }

            return $listado;
        } else {
            return false;
        }
    }

    /**
     * Listado pagina de los mensajes pertenecientes a los médicos. Sobre todo en el tema de compartir estudios
     * @param array $request
     * @param type $idpaginate
     * @return boolean
     */
    public function getNotificacionesMensajes($request, $idpaginate = null) {

        if (isset($request["do_reset"]) && $request["do_reset"] == 1) {
            $this->resetPaginate($idpaginate);
        }

        if (!is_null($idpaginate)) {
            $this->paginate($idpaginate, 20);
        }

        $idmedico = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];

        //Seteo el current page
        $request["current_page"] = $request["current_page"] != "" ? $request["current_page"] : 1;
        SmartyPaginate::setCurrentPage($request["current_page"], $idpaginate);

        $query = new AbstractSql();

        $query->setSelect("
                            if (t.notificacion_idnotificacionRespuesta is null, t.idnotificacion,t.notificacion_idnotificacionRespuesta) as idgroup,
                            t.*,
                            tn.*,
                            ce.nombre as nombre_medico_ce,
                            ce.apellido as apellido_medico_ce,
                            ce.consulta,
                            ce.ids,
                            
                            uw.nombre as nombre_medico,
                            uw.apellido as apellido_medico,
                            ns.url
                            ");

        $query->setFrom("$this->table t
                            INNER JOIN tiponotificacion tn ON (
                                    t.tipoNotificacion_idtipoNotificacion = tn.idtipoNotificacion
                            )  
                            INNER JOIN medico m ON (
                                    m.idmedico = t.medico_idmedico
                            )
                            INNER JOIN usuarioweb uw ON (
                                    m.usuarioweb_idusuarioweb = uw.idusuarioweb
                            )
                            LEFT JOIN v_compartirestudio ce ON (
                                    t.medicoCompartirEstudio_idmedicoCompartirEstudio = ce.idmedicoCompartirEstudio 
                            )
                            LEFT JOIN notificacionsistema ns ON (t.notificacionSistema_idnotificacionSistema = ns.idnotificacionSistema)
                        ");

        $query->setWhere("(t.medico_idmedico = $idmedico )");

        $query->addAnd("t.tipoNotificacion_idtipoNotificacion = 2");

        $query->setGroupBy("t.idnotificacion");
        $query->setOrderBy("t.fechaNotificacion DESC");
        /*         * agreupàmos las notificaciones que son respuestas de mensajes en una sola notificacion */
        $query2 = new AbstractSql();
        $query2->setSelect("T1.*");
        $query2->setFrom("({$query->getSql()}) T1");
        $query2->setGroupBy("T1.idgroup");
        $query2->setOrderBy("T1.fechaNotificacion DESC");

        $listado = $this->getListPaginado($query2, $idpaginate);

        if ($listado && count($listado["rows"])) {
            require_once path_helpers('base/general/Calendar.class.php');
            $calendar = new Calendar();
            foreach ($listado["rows"] as $key => $notificacion) {

                if ($notificacion["fechaNotificacion"] != "") {
                    //TODO: Poner formato notificaciones médico
                    if ($notificacion["fechaNotificacion"] != "") {
                        $date_explode = explode(" ", $notificacion["fechaNotificacion"]);
                        if (count($date_explode) == 2) {
                            list($y, $m, $d) = preg_split("[-]", $date_explode[0]);
                            list($hs, $mn, $sg) = preg_split("[:]", $date_explode[1]);
                            $mes = $calendar->getMonthsShort((int) $m);
                            $listado["rows"][$key]["fechaNotificacion_format"] = "$d $mes $hs:$mn ";
                        }
                    }
                }

                if ($notificacion["medico_idmedicoRespuesta"] != "") {
                    $ManagerMedico = $this->getManager("ManagerMedico");
                    $medico = $ManagerMedico->get($notificacion["medico_idmedicoRespuesta"]);
                    $listado["rows"][$key]["nombre_medico_respuesta"] = $medico["nombre"];
                    $listado["rows"][$key]["apellido_medico_respuesta"] = $medico["apellido"];
                }

                if ((int) $notificacion["tipoNotificacion_idtipoNotificacion"] == 2) {
                    //obtenemos los mensajes anteriores relacionados
                    $listado["rows"][$key]["mensajes_anteriores"] = array();
                    if ($notificacion["notificacion_idnotificacionRespuesta"] != "") {
                        $listado["rows"][$key]["mensajes_anteriores"] = $this->getNotificacionesMensajesAnteriores($notificacion["notificacion_idnotificacionRespuesta"]);
                    }

                    //traemos las fotos si se compartio un 
                    if ($notificacion["medicoCompartirEstudio_idmedicoCompartirEstudio"] != "") {
                        $registro = $this->getManager("ManagerMedicoCompartirEstudio")->get($notificacion["medicoCompartirEstudio_idmedicoCompartirEstudio"]);


                        if ($registro["ids"] != "") {

                            $ids = substr($registro["ids"], 1);
                            $list_ids = explode(",", $ids);

                            if (count($list_ids) > 0) {

                                $ManagerPerfilSaludEstudiosImagen = $this->getManager("ManagerPerfilSaludEstudiosImagen");

                                $attach = array();

                                foreach ($list_ids as $key2 => $id) {
                                    if ((int) $id > 0) {

                                        $imagenes = $ManagerPerfilSaludEstudiosImagen->getListImages((int) $id);

                                        // $filename = path_entity_files("estudios_imagenes/$id/" . $estudio["nombre_archivo"] . ".jpg");
                                    }
                                }
                                $registro["file"] = $imagenes;
                            }
                        }
                        $listado["rows"][$key]["file"][] = $registro["file"];
                    }
                }
            }

            return $listado;
        } else {
            return false;
        }
    }

    /**
     * Listado paginado de las notificaciones de información del sistema
     * @param array $request
     * @param type $idpaginate
     * @return string|boolean
     */
    public function getNotificacionesInfo($request, $idpaginate = null) {
        if (isset($request["do_reset"]) && $request["do_reset"] == 1) {
            $this->resetPaginate($idpaginate);
        }

        if (!is_null($idpaginate)) {
            $this->paginate($idpaginate, 20);
        }

        $idmedico = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];

        //Seteo el current page
        $request["current_page"] = $request["current_page"] != "" ? $request["current_page"] : 1;
        SmartyPaginate::setCurrentPage($request["current_page"], $idpaginate);

        $query = new AbstractSql();

        $query->setSelect("t.*,
                            tn.*,
                            ns.url
                            ");

        $query->setFrom("$this->table t
                            INNER JOIN tiponotificacion tn ON (
                                    t.tipoNotificacion_idtipoNotificacion = tn.idtipoNotificacion
                            )  
                            LEFT JOIN notificacionsistema ns ON (t.notificacionSistema_idnotificacionSistema = ns.idnotificacionSistema)
                        ");

        $query->setWhere("(t.medico_idmedico = $idmedico )");

        $query->addAnd("(t.notificacionSistema_idnotificacionSistema IS NOT NULL OR tipoNotificacion_idtipoNotificacion = 4 OR tipoNotificacion_idtipoNotificacion = 5 )");

        $query->setGroupBy("t.idnotificacion");

        $query->setOrderBy("t.fechaNotificacion DESC");

        $listado = $this->getListPaginado($query, $idpaginate);

        if ($listado && count($listado["rows"])) {
            require_once path_helpers('base/general/Calendar.class.php');
            $calendar = new Calendar();
            foreach ($listado["rows"] as $key => $notificacion) {

                if ($notificacion["fechaNotificacion"] != "") {
                    //TODO: Poner formato notificaciones médico
                    if ($notificacion["fechaNotificacion"] != "") {
                        $date_explode = explode(" ", $notificacion["fechaNotificacion"]);
                        if (count($date_explode) == 2) {
                            list($y, $m, $d) = preg_split("[-]", $date_explode[0]);
                            list($hs, $mn, $sg) = preg_split("[:]", $date_explode[1]);
                            $mes = $calendar->getMonthsShort((int) $m);
                            $listado["rows"][$key]["fechaNotificacion_format"] = "$d $mes $hs:$mn ";
                        }
                    }
                }
            }

            return $listado;
        } else {
            return false;
        }
    }

    public function insert($request) {
        $request["fechaNotificacion"] = date("Y-m-d H:i:s");

        $rdo = parent::insert($request);

        if ($rdo) {

            //notificamos el evento al socket
            $client = new XSocketClient();
            $client->emit('notificacion_creada_php', $request);
        }
        return $rdo;
    }

    /**
     * Método que procesa las notificaciones del sistema pertenecientes a los médicos
     * @param type $request
     * @return boolean
     */
    public function processNotificacionSistemaMedico($request) {

        if (isset($request["fechaVencimiento"]) && $request["fechaVencimiento"] != "") {
            $request["fechaVencimiento"] = $this->sqlDate($request["fechaVencimiento"]);
        }

        //$rdo = $this->process($request);


        $list_ids_medicos = explode(",", $request["ids"]);
        $cantidad = 0;

        if (count($list_ids_medicos) > 0) {
            $client = new XSocketClient();
            foreach ($list_ids_medicos as $key => $id) {

                $insert = $this->insert(array(
                    "medico_idmedico" => $id,
                    "leido" => 0,
                    "titulo" => $request["titulo"],
                    "descripcion" => $request["descripcion"],
                    "fechaVencimiento" => $request["fechaVencimiento"],
                    "notificacionSistema_idnotificacionSistema" => $request["idnotificacionSistema"],
                    "tipoNotificacion_idtipoNotificacion" => 4
                ));

                if ($insert) {
                    $cantidad++;
                    //notify



                    $notify["title"] = " Notification";
                    $notify["text"] = "Vous avez reçu une notification de WorknCare!";
                    $notify["style"] = "notificacion";
                    $notify["type"] = "notificacion";
                    $notify["medico_idmedico"] = $id;
                    $client->emit('notify_php', $notify);
                }
            }
        }

        $this->setMsg(["msg" => "La notification a été envoyée à  [[$cantidad]] Professionnels", "result" => true]);

        return true;
    }

    /**
     * Método que procesa las notificaciones del sistema pertenecientes a los paciente
     * @param type $request
     * @return boolean
     */
    public function processNotificacionSistemaPaciente($request) {

        if (isset($request["fechaVencimiento"]) && $request["fechaVencimiento"] != "") {
            $request["fechaVencimiento"] = $this->sqlDate($request["fechaVencimiento"]);
        }

        //$rdo = $this->process($request);


        $list_ids_pacientes = explode(",", $request["ids"]);
        $cantidad = 0;

        if (count($list_ids_pacientes) > 0) {
            $client = new XSocketClient();
            foreach ($list_ids_pacientes as $key => $id) {

                $insert = $this->insert(array(
                    "paciente_idpaciente" => $id,
                    "leido" => 0,
                    "titulo" => $request["titulo"],
                    "descripcion" => $request["descripcion"],
                    "fechaVencimiento" => $request["fechaVencimiento"],
                    "notificacionSistema_idnotificacionSistema" => $request["idnotificacionSistema"],
                    "tipoNotificacion_idtipoNotificacion" => 4
                ));

                if ($insert) {

                    $cantidad++;

                    //notify


                    $paciente = $this->getManager("ManagerPaciente")->get($id);
                    $notify["title"] = "{$paciente["nombre"]} {$paciente["apellido"]} - Notification";
                    $notify["text"] = "Vous avez reçu une nouvelle notification de WorknCare !";
                    $notify["paciente_idpaciente"] = $id;
                    $notify["style"] = "notificacion";
                    $notify["type"] = "notificacion";
                    $client->emit('notify_php', $notify);
                }
            }
        }

        $this->setMsg(["msg" => "La notification a été envoyée à  [[$cantidad]] patients", "result" => true]);

        return true;
    }

    /**
     * Creación de la notificación al médico que se le comparte el estudio
     * @param type $request
     */
    public function processNotificacionCompartirEstudio($request) {
        $insert = array();
        $insert["medico_idmedicoRespuesta"] = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];
        $insert["medicoCompartirEstudio_idmedicoCompartirEstudio"] = $request["idmedicoCompartirEstudio"];
        $insert["tipoNotificacion_idtipoNotificacion"] = 2;
        $insert["medico_idmedico"] = $request["medico_idmedico_recibe"];
        $insert["descripcion"] = $request["consulta"];
        return parent::process($insert);
    }

    /**
     * Creación de la notificación al médico que lo agrega un prestador
     * @param type $request
     */
    public function processNotificacionPrestadorInvitacionMedico($request) {
        $insert = array();

        $prestador = $this->getManager("ManagerPrestador")->get($request["prestador_idprestador"]);
        $insert["tipoNotificacion_idtipoNotificacion"] = 4;
        $insert["medico_idmedico"] = $request["medico_idmedico"];
        $insert["prestador_idprestador"] = $request["prestador_idprestador"];
//        $insert["titulo"] ="{$prestador["nombre"]} desea incorporarlo como profesional asociado a su Institución";
//          $insert["descripcion"] ="¿Aceptar la invitación?";
        $insert["titulo"] = "{$prestador["nombre"]} vous a ajouté en tant que Professionnel associé à son institution";
        $insert["descripcion"] = "";
        return parent::process($insert);
    }

    /**
     * Creación de la notificación para la renovación de la receta de un médico
     * @param type $request
     */
    public function processNotificacionSolicitudRenovacion($request) {
        $insert = array();
        $insert["idsolicitudRenovacionPerfilSaludMedicamento"] = $request["idsolicitudRenovacionPerfilSaludMedicamento"];
        $insert["tipoNotificacion_idtipoNotificacion"] = 1;

        $ManagerPerfilSaludMedicamento = $this->getManager("ManagerPerfilSaludMedicamento");
        $perfil_salud_medicamento = $ManagerPerfilSaludMedicamento->get($request["perfilSaludMedicamento_idperfilSaludMedicamento"]);

        if ($perfil_salud_medicamento) {
            $insert["medico_idmedico"] = $perfil_salud_medicamento["medico_idmedico"];
            $insert["descripcion"] = $request["mensajePaciente"];
            $rdo = parent::process($insert);
            if ($rdo) {
                //notify
                $client = new XSocketClient();

                $paciente = $this->getManager("ManagerPaciente")->get($perfil_salud_medicamento["paciente_idpaciente"]);
                $notify["title"] = "{$paciente["nombre"]} {$paciente["apellido"]} - Notification";
                $notify["text"] = "Demande de renouvellement d’ordonnance !";
                $notify["medico_idmedico"] = $perfil_salud_medicamento["medico_idmedico"];
                $notify["style"] = "notificacion";
                $notify["type"] = "notificacion";
                $client->emit('notify_php', $notify);
            }
            return $rdo;
        } else {
            return false;
        }
    }

    /**
     * Aceptación de notificaciones de la solicitud de la renovación
     * @param type $request
     * @return boolean
     */
    public function processNotificacionAceptacionSolicitudRenovacion($request) {
        $insert = array();
        //Como id de la solicitud de la receta, pongo el perfil de salud de medicamento que fue aceptado
        $insert["tipoNotificacion_idtipoNotificacion"] = 1;

        $ManagerPerfilSaludMedicamento = $this->getManager("ManagerPerfilSaludMedicamento");
        $perfil_salud_medicamento = $ManagerPerfilSaludMedicamento->get($request["perfilSaludMedicamento_idperfilSaludMedicamento_aceptado"]);

        if ($perfil_salud_medicamento) {
            $insert["idsolicitudRenovacionPerfilSaludMedicamento"] = $request["idsolicitudRenovacionPerfilSaludMedicamento"];
            $insert["paciente_idpaciente"] = $perfil_salud_medicamento["paciente_idpaciente"];
            $insert["descripcion"] = $request["motivo"];
            $rdo = parent::process($insert);


            if ($rdo) {
                //notify
                $client = new XSocketClient();

                $paciente = $this->getManager("ManagerPaciente")->get($perfil_salud_medicamento["paciente_idpaciente"]);
                $notify["title"] = "{$paciente["nombre"]} {$paciente["apellido"]} - Notification";
                $notify["text"] = "Demande de renouvellement d’ordonnance acceptée!";
                $notify["medico_idmedico"] = $perfil_salud_medicamento["medico_idmedico"];
                $notify["style"] = "notificacion";
                $notify["type"] = "notificacion";
                $client->emit('notify_php', $notify);
            }
            return $rdo;
        } else {
            return false;
        }
    }

    /**
     * Rechazo de notificaciones de la solicitud de la renovación
     * @param type $request
     * @return boolean
     */
    public function processNotificacionRechazoSolicitudRenovacion($request) {
        $insert = array();
        //Como id de la solicitud de la receta, pongo el perfil de salud de medicamento que fue aceptado
        $insert["tipoNotificacion_idtipoNotificacion"] = 1;

        $ManagerPerfilSaludMedicamento = $this->getManager("ManagerPerfilSaludMedicamento");
        $perfil_salud_medicamento = $ManagerPerfilSaludMedicamento->get($request["perfilSaludMedicamento_idperfilSaludMedicamento"]);

        if ($perfil_salud_medicamento) {
            $insert["idsolicitudRenovacionPerfilSaludMedicamento"] = $request["idsolicitudRenovacionPerfilSaludMedicamento"];
            $insert["paciente_idpaciente"] = $perfil_salud_medicamento["paciente_idpaciente"];
            if ($perfil_salud_medicamento["nombre_medicamento"] != "") {
                $nombre_medicamento = $perfil_salud_medicamento["nombre_medicamento"];
            } else {
                $ManagerMedicamento = $this->getManager("ManagerMedicamento");
                $medicamento = $ManagerMedicamento->get($perfil_salud_medicamento["medicamento_idmedicamento"]);
                $nombre_medicamento = $medicamento["nombre_comercial"];
            }
            $insert["descripcion"] = "Demande de médicament ({$nombre_medicamento}) déclinée";
            $rdo = parent::process($insert);

            if ($rdo) {
                //notify
                $client = new XSocketClient();

                $paciente = $this->getManager("ManagerPaciente")->get($perfil_salud_medicamento["paciente_idpaciente"]);
                $notify["title"] = "{$paciente["nombre"]} {$paciente["apellido"]} - Notification";
                $notify["text"] = "Demande de renouvellement d’ordonnance déclinée!";
                $notify["medico_idmedico"] = $perfil_salud_medicamento["medico_idmedico"];
                $notify["style"] = "notificacion";
                $notify["type"] = "notificacion";
                $client->emit('notify_php', $notify);
            }
            return $rdo;
        } else {
            return false;
        }
    }

    /**
     * Método para marcar como leídas todas las notificaciones pertenecientes a los médicos
     * @param type $request
     * @return boolean
     */
    public function marcarLeido($request) {

        //Obtengo los records para eliminar
        $records = explode(",", $request["ids"]);

        if ($records || count($records) > 0) {
            if (CONTROLLER == "medico") {
                $id_entidad = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];
                $nombre_id = "medico_idmedico";
            } else {
                $ManagerPaciente = $this->getManager("ManagerPaciente");
                $paciente = $ManagerPaciente->getPacienteXHeader();
                $id_entidad = $paciente["idpaciente"];
                $nombre_id = "paciente_idpaciente";
            }
            //Recorro todo el listado de ids y le seteo el campo como leído
            foreach ($records as $key => $id) {
                if ((int) $id > 0) {
                    $registro = $this->get($id);
                    if ($registro && $registro[$nombre_id] == $id_entidad) {
                        $rdo = parent::update(["leido" => (int) $request["leido"]], $id);
                    }
                }
            }


            if ($request["leido"] == 1) {
                $this->setMsg(["msg" => "Se marcaron como leídas las notificaciones", "result" => true]);
            } else {
                $this->setMsg(["msg" => "Se marcaron como no leídas las notificaciones", "result" => true]);
            }

            return true;
        } else {
            $this->setMsg(["msg" => "Error. No hay notificaciones seleccionadas", "result" => false]);
            return false;
        }
    }

    /**
     * Método para archivar todas las notificaciones pertenecientes 
     * @param type $request
     * @return boolean
     */
    public function archivar($request) {

        //Obtengo los records para eliminar
        $records = explode(",", $request["ids"]);

        if ($records || count($records) > 0) {
            if (CONTROLLER == "medico") {
                $id_entidad = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];
                $nombre_id = "medico_idmedico";
            } else {
                $ManagerPaciente = $this->getManager("ManagerPaciente");
                $paciente = $ManagerPaciente->getPacienteXHeader();
                $id_entidad = $paciente["idpaciente"];
                $nombre_id = "paciente_idpaciente";
            }
            //Recorro todo el listado de ids y le seteo el campo como leído
            foreach ($records as $key => $id) {
                if ((int) $id > 0) {
                    $notificacion = $this->get($id);
                    if ($notificacion && $notificacion[$nombre_id] == $id_entidad) {

                        $this->db->Execute("UPDATE notificacion SET archivar = 1 - archivar WHERE {$nombre_id}=$id_entidad AND idnotificacion=$id");
                        //si es un chat, archivamos los mensajes anteriores
                        if ($notificacion["notificacion_idnotificacionRespuesta"] != "") {
                            $this->db->Execute("UPDATE notificacion SET archivar = 1 - archivar WHERE {$nombre_id}=$id_entidad AND (notificacion_idnotificacionRespuesta = {$notificacion["notificacion_idnotificacionRespuesta"]} OR idnotificacion = {$notificacion["notificacion_idnotificacionRespuesta"]}) and idnotificacion <> $id");
                        }
                    }
                }
            }

            $this->setMsg(["msg" => "Se archivaron las notificaciones", "result" => true]);

            return true;
        } else {
            $this->setMsg(["msg" => "Error. No hay notificaciones seleccionadas", "result" => false]);
            return false;
        }
    }

    /**
     * Método que retorna la cantidad de notificaciones pertenecientes a los médicos
     * @param type $idpaciente
     * @return int
     */
    public function getCantidadNotificacionesPaciente($idpaciente) {
        $query = new AbstractSql();

        $query->setSelect("t.*");

        $query->setFrom("$this->table t");

        $query->setWhere("(t.paciente_idpaciente = $idpaciente)");
        //quitamos las notificaciones de controles y chequeos = 6
        $query->addAnd("t.leido = 0 AND t.tipoNotificacion_idtipoNotificacion <> 6");

        $listado = $this->getList($query);

        if ($listado && count($listado) > 0) {
            return count($listado);
        } else {
            return 0;
        }
    }

    /**
     * Metodo que retorna un listado paginado ordenado por fecha sobre las solicitudes no leídas de los médicos
     * "TAB 1"
     * @param array $request
     * @param type $idpaginate
     * @return type
     */
    public function getListadoPaginadoPaciente($request, $idpaginate = null) {

        if (isset($request["do_reset"]) && $request["do_reset"] == 1) {
            $this->resetPaginate($idpaginate);
        }

        if (!is_null($idpaginate)) {
            $this->paginate($idpaginate, 20);
        }

        $ManagerPaciente = $this->getManager("ManagerPaciente");
        $paciente = $ManagerPaciente->getPacienteXHeader();
        $idpaciente = $paciente["idpaciente"];

        //Seteo el current page
        $request["current_page"] = $request["current_page"] != "" ? $request["current_page"] : 1;
        SmartyPaginate::setCurrentPage($request["current_page"], $idpaginate);

        $query = new AbstractSql();

        $query->setSelect("
                            if (t.notificacion_idnotificacionRespuesta is null, t.idnotificacion,t.notificacion_idnotificacionRespuesta) as idgroup,
                            t.*,
                            tn.*,                            
                            CASE WHEN t.estado_turno = 0 THEN 'Rendez-vous Demandé'
                                WHEN t.estado_turno = 1 THEN 'Rendez-vous Confirmé'
                                WHEN t.estado_turno = 2 THEN 'Rendez-vous Annulé'
                                WHEN t.estado_turno = 3 THEN 'Rendez-vous Décliné'
                                WHEN t.estado_turno = 5 THEN 'Patient Absent'
                                WHEN t.estado_turno = 6 THEN 'Rendez-vous Reporté'
                            END AS estado_format,
                            srr.nombre_medico as nombre_medico_renovacion, 
                            srr.apellido_medico as apellido_medico_renovacion, 
                            srr.nombre_paciente as nombre_paciente_renovacion, 
                            srr.apellido_paciente as apellido_paciente_renovacion,
                            srr.mensajePaciente,
                            srr.aceptado,
                            srr.motivo,
                            srr.tipoTomaMedicamentos_idtipoTomaMedicamentos,
                            srr.nombre_medicamento,
                            srr.posologia,
                            srr.fecha_fin,
                            srr.fecha_inicio,
                            ns.url,
                            mpi.estado as estado_invitacion
                            ");

        $query->setFrom("$this->table t
                            INNER JOIN tiponotificacion tn ON (
                                    t.tipoNotificacion_idtipoNotificacion = tn.idtipoNotificacion
                            )
                            LEFT JOIN v_solicitudrenovacionreceta srr ON (
                                    t.idsolicitudRenovacionPerfilSaludMedicamento = srr.idsolicitudRenovacionPerfilSaludMedicamento
                            )
                            LEFT JOIN notificacionsistema ns ON (t.notificacionSistema_idnotificacionSistema = ns.idnotificacionSistema)
                            LEFT JOIN medico_paciente_invitacion mpi ON (t.medico_paciente_invitacion_idmedico_paciente_invitacion = mpi.idmedico_paciente_invitacion)

                           
                        ");

        $query->setWhere("(t.paciente_idpaciente = $idpaciente) and t.archivar <> 1");
        //quitamos las notificaciones de controles y chequeos = 6
        $query->addAnd("t.tipoNotificacion_idtipoNotificacion <> 6");

        $query->setGroupBy("t.idnotificacion");

        $query->setOrderBy("t.fechaNotificacion DESC");

        /**
         *  agrupamos las notificaciones que son respuestas de mensajes en una sola notificacion 
         */
        $query2 = new AbstractSql();
        $query2->setSelect("T1.*");
        $query2->setFrom("({$query->getSql()}) T1");
        $query2->setGroupBy("T1.idgroup");
        $query2->setOrderBy("T1.fechaNotificacion DESC");

        $listado = $this->getListPaginado($query2, $idpaginate);


        if ($listado["rows"] && count($listado["rows"]) > 0) {

            require_once path_helpers('base/general/Calendar.class.php');
            $calendar = new Calendar();
            foreach ($listado["rows"] as $key => $notificacion) {

                if ($notificacion["fechaNotificacion"] != "") {
                    //TODO: Poner formato notificaciones médico
                    if ($notificacion["fechaNotificacion"] != "") {
                        $date_explode = explode(" ", $notificacion["fechaNotificacion"]);
                        if (count($date_explode) == 2) {
                            list($y, $m, $d) = preg_split("[-]", $date_explode[0]);
                            list($hs, $mn, $sg) = preg_split("[:]", $date_explode[1]);
                            $mes = $calendar->getMonthsShort((int) $m);
                            $listado["rows"][$key]["fechaNotificacion_format"] = "$d $mes $hs:$mn ";
                        }
                    }
                }

                //Si es de tipo de toma de medicamentos
                if ((int) $notificacion["tipoNotificacion_idtipoNotificacion"] == 1) {
                    $ManagerTipoTomaMedicamentos = $this->getManager("ManagerTipoTomaMedicamentos");
                    $listado["rows"][$key]["tipo_toma_medicamentos"] = $ManagerTipoTomaMedicamentos->get($notificacion["tipoTomaMedicamentos_idtipoTomaMedicamentos"]);
                }
                //si es de tipo mensaje médico a paciente - obtenemos los archivos
                if ((int) $notificacion["tipoNotificacion_idtipoNotificacion"] == 8) {
                    $path_dir = path_entity_files("archivos_mensaje_paciente/{$notificacion["medico_idmedico_emisor"]}/{$notificacion["paciente_idpaciente"]}/{$notificacion["idnotificacion"]}");
                    if (file_exists($path_dir)) {
                        $archivos = scandir($path_dir);
                        foreach ($archivos as $i => $archivo) {
                            if ($archivo == "." || $archivo == "..") {
                                unset($archivos[$i]);
                            }
                        }


                        $listado["rows"][$key]["archivos"] = $archivos;
                    }
                    //buscamos los mensajes anteriores relacionados
                    $listado["rows"][$key]["mensajes_anteriores"] = array();
                    if ($notificacion["notificacion_idnotificacionRespuesta"] != "") {
                        $listado["rows"][$key]["mensajes_anteriores"] = $this->getNotificacionesMensajesAnteriores($notificacion["notificacion_idnotificacionRespuesta"]);
                    }
                }
            }

            return $listado;
        } else {
            return false;
        }
    }

    /**
     * Metodo que retorna un listado paginado de las notificaciones de turnos
     * "TAB 1"
     * @param array $request
     * @param type $idpaginate
     * @return type
     */
    public function getListadoPaginadoNotificacionesTurno($request, $idpaginate = null) {


        if (isset($request["do_reset"]) && $request["do_reset"] == 1) {
            $this->resetPaginate($idpaginate);
        }

        if (!is_null($idpaginate)) {
            $this->paginate($idpaginate, 20);
        }




        //Seteo el current page
        $request["current_page"] = $request["current_page"] != "" ? $request["current_page"] : 1;
        SmartyPaginate::setCurrentPage($request["current_page"], $idpaginate);

        $query = new AbstractSql();

        $query->setSelect("t.*,
                            tn.*,
                            CASE WHEN t.estado_turno = 0 THEN 'Rendez-vous Demandé'
                                WHEN t.estado_turno = 1 THEN 'Rendez-vous Confirmé'
                                WHEN t.estado_turno = 2 THEN 'Rendez-vous Annulé'
                                WHEN t.estado_turno = 3 THEN 'Rendez-vous Décliné'
                                WHEN t.estado_turno = 5 THEN 'Patient Absent'
                                WHEN t.estado_turno = 6 THEN 'Rendez-vous Reporté'
                            END AS estado_format
                            
                            ");

        $query->setFrom("$this->table t
                            INNER JOIN tiponotificacion tn ON (t.tipoNotificacion_idtipoNotificacion = tn.idtipoNotificacion)
                          
                        ");
        if (CONTROLLER == "paciente_p") {
            $ManagerPaciente = $this->getManager("ManagerPaciente");
            $paciente = $ManagerPaciente->getPacienteXHeader();
            $idpaciente = $paciente["idpaciente"];
            $query->setWhere("(t.paciente_idpaciente = $idpaciente)");
        }
        if (CONTROLLER == "medico") {
            $idmedico = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];
            $query->setWhere("(t.medico_idmedico = $idmedico)");
        }

        $query->addAnd("t.tipoNotificacion_idtipoNotificacion=3");

        $query->setGroupBy("t.idnotificacion");

        $query->setOrderBy("t.fechaNotificacion DESC");

        $listado = $this->getListPaginado($query, $idpaginate);

        if ($listado && count($listado["rows"])) {
            $ManagerTurno = $this->getManager("ManagerTurno");
            require_once path_helpers('base/general/Calendar.class.php');
            $calendar = new Calendar();
            $ManagerMensajeTurno = $this->getManager("ManagerMensajeTurno");
            foreach ($listado["rows"] as $key => $notificacion) {

                if ($notificacion["fechaNotificacion"] != "") {
                    //TODO: Poner formato notificaciones médico
                    if ($notificacion["fechaNotificacion"] != "") {
                        $date_explode = explode(" ", $notificacion["fechaNotificacion"]);
                        if (count($date_explode) == 2) {
                            list($y, $m, $d) = preg_split("[-]", $date_explode[0]);
                            list($hs, $mn, $sg) = preg_split("[:]", $date_explode[1]);
                            $mes = $calendar->getMonthsShort((int) $m);
                            $listado["rows"][$key]["fechaNotificacion_format"] = "$d $mes $hs:$mn ";
                        }
                    }
                }

                if ($notificacion["turno_idturno"] != "") {
                    $turno = $ManagerTurno->get($notificacion["turno_idturno"]);
                    if (strtotime($turno["fecha"] . " " . $turno["horarioInicio"]) < strtotime(date("Y-m-d H:i:s"))) {
                        $turno["turno_pasado"] = 1;
                    }
                    $listado["rows"][$key]["turno"] = $turno;
                    $listado["rows"][$key]["mensajes"] = $ManagerMensajeTurno->getListadoMensajes($notificacion["turno_idturno"], $notificacion["paciente_idpaciente_emisor"]);
                }
            }

            return $listado;
        } else {
            return false;
        }
    }

    /**
     * Metodo que retorna un listado paginado de las peticiones de renovación de receta
     * "TAB 1"
     * @param array $request
     * @param type $idpaginate
     * @return type
     */
    public function getListadoPaginadoRenovacionRecetaPaciente($request, $idpaginate = null) {
        if (isset($request["do_reset"]) && $request["do_reset"] == 1) {
            $this->resetPaginate($idpaginate);
        }

        if (!is_null($idpaginate)) {
            $this->paginate($idpaginate, 20);
        }

        $ManagerPaciente = $this->getManager("ManagerPaciente");
        $paciente = $ManagerPaciente->getPacienteXHeader();
        $idpaciente = $paciente["idpaciente"];

        //Seteo el current page
        $request["current_page"] = $request["current_page"] != "" ? $request["current_page"] : 1;
        SmartyPaginate::setCurrentPage($request["current_page"], $idpaginate);

        $query = new AbstractSql();

        $query->setSelect("t.*,
                            tn.*,
                            srr.nombre_medico as nombre_medico_renovacion, 
                            srr.apellido_medico as apellido_medico_renovacion, 
                            srr.nombre_paciente as nombre_paciente_renovacion, 
                            srr.apellido_paciente as apellido_paciente_renovacion,
                            srr.mensajePaciente,
                            srr.aceptado,
                            srr.motivo,
                            srr.tipoTomaMedicamentos_idtipoTomaMedicamentos,
                            srr.nombre_medicamento,
                            srr.posologia,
                            srr.fecha_fin,
                            srr.fecha_inicio
                            ");

        $query->setFrom("$this->table t
                            INNER JOIN tiponotificacion tn ON (
                                    t.tipoNotificacion_idtipoNotificacion = tn.idtipoNotificacion
                            )
                            LEFT JOIN v_solicitudrenovacionreceta srr ON (
                                    t.idsolicitudRenovacionPerfilSaludMedicamento = srr.idsolicitudRenovacionPerfilSaludMedicamento
                            )
                        ");

        $query->setWhere("(t.paciente_idpaciente = $idpaciente)");

        $query->addAnd("t.tipoNotificacion_idtipoNotificacion = 1");

        $query->setGroupBy("t.idnotificacion");

        $query->setOrderBy("t.fechaNotificacion DESC");

        $listado = $this->getListPaginado($query, $idpaginate);

        if ($listado && count($listado["rows"])) {
            require_once path_helpers('base/general/Calendar.class.php');
            $calendar = new Calendar();
            foreach ($listado["rows"] as $key => $notificacion) {

                if ($notificacion["fechaNotificacion"] != "") {
                    //TODO: Poner formato notificaciones médico
                    if ($notificacion["fechaNotificacion"] != "") {
                        $date_explode = explode(" ", $notificacion["fechaNotificacion"]);
                        if (count($date_explode) == 2) {
                            list($y, $m, $d) = preg_split("[-]", $date_explode[0]);
                            list($hs, $mn, $sg) = preg_split("[:]", $date_explode[1]);
                            $mes = $calendar->getMonthsShort((int) $m);
                            $listado["rows"][$key]["fechaNotificacion_format"] = "$d $mes $hs:$mn ";
                        }
                    }
                }
                //Si es de tipo de toma de medicamentos
                if ((int) $notificacion["tipoNotificacion_idtipoNotificacion"] == 1) {
                    $ManagerTipoTomaMedicamentos = $this->getManager("ManagerTipoTomaMedicamentos");
                    $listado["rows"][$key]["tipo_toma_medicamentos"] = $ManagerTipoTomaMedicamentos->get($notificacion["tipoTomaMedicamentos_idtipoTomaMedicamentos"]);
                }
            }
            return $listado;
        } else {
            return false;
        }
    }

    /**
     * Metodo que retorna un listado paginado de las notas informativas del sistema "DP"
     * "TAB 1"
     * @param array $request
     * @param type $idpaginate
     * @return type
     */
    public function getListadoPaginadoInfoSistemaPaciente($request, $idpaginate = null) {
        if (isset($request["do_reset"]) && $request["do_reset"] == 1) {
            $this->resetPaginate($idpaginate);
        }

        if (!is_null($idpaginate)) {
            $this->paginate($idpaginate, 20);
        }

        $ManagerPaciente = $this->getManager("ManagerPaciente");
        $paciente = $ManagerPaciente->getPacienteXHeader();
        $idpaciente = $paciente["idpaciente"];

        //Seteo el current page
        $request["current_page"] = $request["current_page"] != "" ? $request["current_page"] : 1;
        SmartyPaginate::setCurrentPage($request["current_page"], $idpaginate);

        $query = new AbstractSql();

        $query->setSelect(" if (t.notificacion_idnotificacionRespuesta is null, t.idnotificacion,t.notificacion_idnotificacionRespuesta) as idgroup,
                            t.*,
                            tn.*,
                            ns.url,
                            mpi.estado as estado_invitacion
                            ");

        $query->setFrom("$this->table t
                            INNER JOIN tiponotificacion tn ON (
                                    t.tipoNotificacion_idtipoNotificacion = tn.idtipoNotificacion
                            )
                            LEFT JOIN notificacionsistema ns ON (t.notificacionSistema_idnotificacionSistema = ns.idnotificacionSistema)
                            LEFT JOIN medico_paciente_invitacion mpi ON (t.medico_paciente_invitacion_idmedico_paciente_invitacion = mpi.idmedico_paciente_invitacion)

                        ");

        $query->setWhere("(t.paciente_idpaciente = $idpaciente)");

        $query->addAnd("(t.notificacionSistema_idnotificacionSistema IS NOT NULL OR t.tipoNotificacion_idtipoNotificacion = 5 OR t.tipoNotificacion_idtipoNotificacion = 7 OR t.tipoNotificacion_idtipoNotificacion = 8)");

        $query->setGroupBy("t.idnotificacion");

        $query->setOrderBy("t.fechaNotificacion DESC");

        /*         * agreupàmos las notificaciones que son respuestas de mensajes en una sola notificacion */
        $query2 = new AbstractSql();
        $query2->setSelect("T1.*");
        $query2->setFrom("({$query->getSql()}) T1");
        $query2->setGroupBy("T1.idgroup");
        $query2->setOrderBy("T1.fechaNotificacion DESC");

        $listado = $this->getListPaginado($query2, $idpaginate);

        if ($listado && count($listado["rows"])) {
            require_once path_helpers('base/general/Calendar.class.php');
            $calendar = new Calendar();
            foreach ($listado["rows"] as $key => $notificacion) {

                if ($notificacion["fechaNotificacion"] != "") {
                    //TODO: Poner formato notificaciones médico
                    if ($notificacion["fechaNotificacion"] != "") {
                        $date_explode = explode(" ", $notificacion["fechaNotificacion"]);
                        if (count($date_explode) == 2) {
                            list($y, $m, $d) = preg_split("[-]", $date_explode[0]);
                            list($hs, $mn, $sg) = preg_split("[:]", $date_explode[1]);
                            $mes = $calendar->getMonthsShort((int) $m);
                            $listado["rows"][$key]["fechaNotificacion_format"] = "$d $mes $hs:$mn ";
                        }
                    }
                }
                if ($notificacion["tipoNotificacion_idtipoNotificacion"] == "8") {

                    $path_dir = path_entity_files("archivos_mensaje_paciente/{$notificacion["medico_idmedico_emisor"]}/{$notificacion["paciente_idpaciente"]}/{$notificacion["idnotificacion"]}");
                    if (file_exists($path_dir)) {
                        $archivos = scandir($path_dir);
                        foreach ($archivos as $i => $archivo) {
                            if ($archivo == "." || $archivo == "..") {
                                unset($archivos[$i]);
                            }
                        }


                        $listado["rows"][$key]["archivos"] = $archivos;
                    }

                    //buscamos los mensajes anteriores relacionados
                    $listado["rows"][$key]["mensajes_anteriores"] = array();
                    if ($notificacion["notificacion_idnotificacionRespuesta"] != "") {
                        $listado["rows"][$key]["mensajes_anteriores"] = $this->getNotificacionesMensajesAnteriores($notificacion["notificacion_idnotificacionRespuesta"]);
                    }
                }
            }

            return $listado;
        } else {
            return false;
        }
    }

    /**
     * Metodo que retorna un listado paginado de las notas informativas del sistema "DP"
     * "TAB 1"
     * @param array $request
     * @param type $idpaginate
     * @return type
     */
    public function getListadoPaginadoControlesChequeosPaciente($request, $idpaginate = null) {
        if (isset($request["do_reset"]) && $request["do_reset"] == 1) {
            $this->resetPaginate($idpaginate);
        }

        if (!is_null($idpaginate)) {
            $this->paginate($idpaginate, 20);
        }

        $ManagerPaciente = $this->getManager("ManagerPaciente");
        $paciente = $ManagerPaciente->getPacienteXHeader();
        $idpaciente = $paciente["idpaciente"];

        //Seteo el current page
        $request["current_page"] = $request["current_page"] != "" ? $request["current_page"] : 1;
        SmartyPaginate::setCurrentPage($request["current_page"], $idpaginate);

        $query = new AbstractSql();

        $query->setSelect("t.*,
                            tn.*
                            ");

        $query->setFrom("$this->table t
                            INNER JOIN tiponotificacion tn ON (
                                    t.tipoNotificacion_idtipoNotificacion = tn.idtipoNotificacion
                            )
                        ");
        //quitamos las notificaciones de controles y chequeos = 6
        $query->setWhere("(t.paciente_idpaciente = $idpaciente) AND FALSE");

        $query->addAnd("t.tipoNotificacion_idtipoNotificacion = 6");

        $query->setGroupBy("t.idnotificacion");

        $query->setOrderBy("t.fechaNotificacion DESC");

        $listado = $this->getListPaginado($query, $idpaginate);

        if ($listado && count($listado["rows"])) {
            require_once path_helpers('base/general/Calendar.class.php');
            $calendar = new Calendar();
            foreach ($listado["rows"] as $key => $notificacion) {

                if ($notificacion["fechaNotificacion"] != "") {
                    //TODO: Poner formato notificaciones médico
                    if ($notificacion["fechaNotificacion"] != "") {
                        $date_explode = explode(" ", $notificacion["fechaNotificacion"]);
                        if (count($date_explode) == 2) {
                            list($y, $m, $d) = preg_split("[-]", $date_explode[0]);
                            list($hs, $mn, $sg) = preg_split("[:]", $date_explode[1]);
                            $mes = $calendar->getMonthsShort((int) $m);
                            $listado["rows"][$key]["fechaNotificacion_format"] = "$d $mes $hs:$mn ";
                        }
                    }
                }
            }

            return $listado;
        } else {
            return false;
        }
    }

    /**
     * Metodo que retorna un listado paginado de las notas informativas del sistema "DP"
     * "TAB 1"
     * @param array $idpaciente
     * @return type
     */
    public function getListadoPaginadoControlesChequeosSinPaginarPaciente($idpaciente) {

        $query = new AbstractSql();

        $query->setSelect("t.*,
                            tn.*,
                            tcc.*
                            ");

        $query->setFrom("$this->table t
                            INNER JOIN tiponotificacion tn ON (
                                    t.tipoNotificacion_idtipoNotificacion = tn.idtipoNotificacion
                            )
                            INNER JOIN tipocontrolchequeo tcc ON (
                                    t.tipoControlChequeo_idtipoControlChequeo = tcc.idtipoControlChequeo
                            )
                        ");
        //quitamos las notificaciones de controles y chequeos = 6
        $query->setWhere("(t.paciente_idpaciente = $idpaciente) AND FALSE");

        $query->addAnd("t.tipoNotificacion_idtipoNotificacion = 6");

        $query->setGroupBy("t.idnotificacion");

        $query->setOrderBy("t.fechaNotificacion DESC");

        $listado = $this->getList($query);

        return $listado;
    }

    /*     * Metodo que retorna el listado de controles y chequeos en formato para slider de home Paciente
     * 
     * @param type $idpaciente
     */

    public function getListadoControlesChequeosHome($idpaciente) {
        $listado = $this->getListadoPaginadoControlesChequeosSinPaginarPaciente($idpaciente);

        $count = COUNT($listado);
        $result = [];
        $par = [];
        //recorremos el listado y lo agrupamos de a 2 notificaciones
        if ($listado) {
            for ($i = 1; $i <= $count; $i++) {

                $par[] = $listado[$i - 1];
                if ($i % 2 == 0) {
                    $result[] = $par;
                    $par = [];
                }
                //si es impar, el ultimo lo agregamos solo
                elseif ($i == $count) {
                    $result[] = $par;
                }
            }
        }
        return $result;
    }

    /**
     * Creación de la notificación desde la reserva de un turno por parte de un paciente..
     * @param type $idturno
     * @return type
     */
    public function createNotificacionFromReservaTurno($idturno) {

        $ManagerTurno = $this->getManager("ManagerTurno");
        //Busco el turno sobre el que creo la notificación
        $turno = $ManagerTurno->get($idturno);

        //obenemos la fecha del turno
        $calendar = new Calendar();
        $nombre_dia_turno = $calendar->getNameDayWeek($turno["fecha"], true);
        list($y, $m, $d) = preg_split("[-]", $turno["fecha"]);
        $nombre_corto_mes = $calendar->getMonthsShort((int) $m);
        $explode_hora_inicio = explode(":", $turno["horarioInicio"]);
        $fecha_turno = "$nombre_dia_turno $d $nombre_corto_mes " . $explode_hora_inicio[0] . ":" . $explode_hora_inicio[1] . "hs";

        //obtengo el paciente del turno
        $ManagerPaciente = $this->getManager("ManagerPaciente");
        $paciente = $ManagerPaciente->get($turno["paciente_idpaciente"]);


        //item_options con los datos del consultorios
        $consultorio = $this->getManager("ManagerConsultorio")->get($turno["consultorio_idconsultorio"]);
        $nombreConsultorio = $consultorio["nombreConsultorio"];

        if ($consultorio["is_virtual"] == 1) {
            $tipoVisita = "Vidéo Consultation";
            $direccionConsultorio = "";
            $icon = "dp-video";
        } else {
            $icon = "dp-branch";
            $tipoVisita = "Consultation Présentielle";
            $direccionConsultorio = $consultorio["direccion"] . " " . $consultorio["numero"];
        }

        $item_options = "<i class='{$icon}'></i><span>{$nombreConsultorio}<small class='address'>{$direccionConsultorio}</small> <small>{$tipoVisita}</small></span>";


        //Armamos la notificacion
        $array_insert = array(
            "medico_idmedico" => $turno["medico_idmedico"],
            "leido" => 0,
            "turno_idturno" => $idturno,
            "titulo" => "Reserva de turno",
            "subtitulo" => "",
            "descripcion" => $fecha_turno,
            "estado_turno" => $turno["estado"],
            "tipoNotificacion_idtipoNotificacion" => 3,
            "paciente_nombre" => "{$paciente["nombre"]} {$paciente["apellido"]}",
            "item_options" => $item_options,
            "paciente_idpaciente_emisor" => $paciente["idpaciente"]
        );


        // FIX 27/12/2019 VAmos a notificar al Médico cuando tenga una VC con turno
        $ManagerMedico = $this->getManager("ManagerMedico");
        $medico = $ManagerMedico->get($turno["medico_idmedico"]);

        if ($medico["numeroCelular"] != "" && $medico["celularValido"]) {
            $numero = $medico["numeroCelular"];
            if ($consultorio["is_virtual"] == 1) {
                $cuerpo = "Nouvelle demande de rendez-vous en Visio: " . URL_ROOT . "panel-medico/notificaciones/";
                /**
                 * Inserción del SMS en la lista de envio
                 */
                $ManagerLogSMS = $this->getManager("ManagerLogSMS");
                $sms = $ManagerLogSMS->insert([
                    "dirigido" => 'M',
                    //"paciente_idpaciente" => $paciente["idpaciente"],
                    "medico_idmedico" => $medico["idmedico"],
                    "contexto" => "Nueva VC Turno",
                    "texto" => $cuerpo,
                    "numero_cel" => $numero
                ]);
            } else {
                $cuerpo = "Nouvelle demande de rendez-vous au cabinet: " . URL_ROOT . "panel-medico/notificaciones/";
                /**
                 * Inserción del SMS en la lista de envio
                 */
                $ManagerLogSMS = $this->getManager("ManagerLogSMS");
                $sms = $ManagerLogSMS->insert([
                    "dirigido" => 'M',
                    //"paciente_idpaciente" => $paciente["idpaciente"],
                    "medico_idmedico" => $medico["idmedico"],
                    "contexto" => "Nuevo Turno",
                    "texto" => $cuerpo,
                    "numero_cel" => $numero
                ]);
            }
        }

        return parent::process($array_insert);
    }

    /**
     * Creación de la notificación desde la reprogramacion de un turno por parte de un paciente..
     * @param type $idturno
     * @return type
     */
    public function createNotificacionFromReprogramacionTurnoPaciente($idturno, $idturno_anterior) {

        $ManagerTurno = $this->getManager("ManagerTurno");
        //Busco el turno sobre el que creo la notificación
        $turno = $ManagerTurno->get($idturno);

        //obenemos la fecha del turno
        $calendar = new Calendar();
        $nombre_dia_turno = $calendar->getNameDayWeek($turno["fecha"], true);
        list($y, $m, $d) = preg_split("[-]", $turno["fecha"]);
        $nombre_corto_mes = $calendar->getMonthsShort((int) $m);
        $explode_hora_inicio = explode(":", $turno["horarioInicio"]);
        $fecha_turno = "$nombre_dia_turno $d $nombre_corto_mes " . $explode_hora_inicio[0] . ":" . $explode_hora_inicio[1] . "hs";

        //obtengo el paciente del turno
        $ManagerPaciente = $this->getManager("ManagerPaciente");
        $paciente = $ManagerPaciente->get($turno["paciente_idpaciente"]);


        //item_options con los datos del consultorios
        $consultorio = $this->getManager("ManagerConsultorio")->get($turno["consultorio_idconsultorio"]);
        $nombreConsultorio = $consultorio["nombreConsultorio"];

        if ($consultorio["is_virtual"] == 1) {
            $tipoVisita = "Vidéo Consultation";
            $direccionConsultorio = "";
            $icon = "dp-video";
        } else {
            $icon = "dp-branch";
            $tipoVisita = "Consultation Présentielle";
            $direccionConsultorio = $consultorio["direccion"] . " " . $consultorio["numero"];
        }

        $item_options = "<i class='{$icon}'></i><span>{$nombreConsultorio}<small class='address'>{$direccionConsultorio}</small> <small>{$tipoVisita}</small></span>";


        //Armamos la notificacion
        $array_insert = array(
            "medico_idmedico" => $turno["medico_idmedico"],
            "leido" => 0,
            "turno_idturno" => $idturno,
            "titulo" => "Reprogramacion de turno",
            "subtitulo" => "",
            "descripcion" => $fecha_turno,
            "estado_turno" => $turno["estado"],
            "tipoNotificacion_idtipoNotificacion" => 3,
            "paciente_nombre" => "{$paciente["nombre"]} {$paciente["apellido"]}",
            "item_options" => $item_options,
            "paciente_idpaciente_emisor" => $paciente["idpaciente"],
            "turno_reprogramado" => $idturno_anterior
        );


        // FIX 27/12/2019 VAmos a notificar al Médico cuando tenga una VC con turno
        $ManagerMedico = $this->getManager("ManagerMedico");
        $medico = $ManagerMedico->get($turno["medico_idmedico"]);

        if ($medico["numeroCelular"] != "" && $medico["celularValido"]) {
            $numero = $medico["numeroCelular"];
            if ($consultorio["is_virtual"] == 1) {
                $cuerpo = "Votre rendez-vous en Visio est reporté: " . URL_ROOT . "panel-medico/notificaciones/";
                /**
                 * Inserción del SMS en la lista de envio
                 */
                $ManagerLogSMS = $this->getManager("ManagerLogSMS");
                $sms = $ManagerLogSMS->insert([
                    "dirigido" => 'M',
                    //"paciente_idpaciente" => $paciente["idpaciente"],
                    "medico_idmedico" => $medico["idmedico"],
                    "contexto" => "Reprogramacion VC Turno",
                    "texto" => $cuerpo,
                    "numero_cel" => $numero
                ]);
            } else {
                $cuerpo = "Rendez-vous au cabinet reporté: " . URL_ROOT . "panel-medico/notificaciones/";
                /**
                 * Inserción del SMS en la lista de envio
                 */
                $ManagerLogSMS = $this->getManager("ManagerLogSMS");
                $sms = $ManagerLogSMS->insert([
                    "dirigido" => 'M',
                    //"paciente_idpaciente" => $paciente["idpaciente"],
                    "medico_idmedico" => $medico["idmedico"],
                    "contexto" => "Reprogramacion Turno",
                    "texto" => $cuerpo,
                    "numero_cel" => $numero
                ]);
            }
        }

        return parent::process($array_insert);
    }

    /**
     * Creación de la notificación ante el cambio de estado del turno por parte del medico..
     * @param type $record
     * @return type
     */
    public function createNotificacionFromCambioEstadoTurno($record) {


        $ManagerTurno = $this->getManager("ManagerTurno");
        //Busco el turno sobre el que creo la notificación
        $turno = $ManagerTurno->get($record["idturno"]);

        //obenemos la fecha del turno
        $calendar = new Calendar();
        $nombre_dia_turno = $calendar->getNameDayWeek($turno["fecha"], true);
        list($y, $m, $d) = preg_split("[-]", $turno["fecha"]);
        $nombre_corto_mes = $calendar->getMonthsShort((int) $m);
        $explode_hora_inicio = explode(":", $turno["horarioInicio"]);
        $fecha_turno = "$nombre_dia_turno $d $nombre_corto_mes " . $explode_hora_inicio[0] . ":" . $explode_hora_inicio[1] . "hs";

        //obtengo el medico del turno
        $ManagerMedico = $this->getManager("ManagerMedico");
        $medico = $ManagerMedico->get($turno["medico_idmedico"]);
        //obtengo las especialidades del medico
        $esp_array = $this->getManager("ManagerEspecialidadMedico")->getListadoVisualizacion($medico["idmedico"]);
        $especialidades = $esp_array["especialidad"] . $esp_array["subEspecialidades"];
        //item_options con los datos del consultorios
        $consultorio = $this->getManager("ManagerConsultorio")->get($turno["consultorio_idconsultorio"]);
        $nombreConsultorio = $consultorio["nombreConsultorio"];

        if ($consultorio["is_virtual"] == 1) {
            $tipoVisita = "Vidéo Consultation";
            $direccionConsultorio = "";
            $icon = "dp-video";
        } else {
            $icon = "dp-branch";
            $tipoVisita = "Consultation Présentielle";
            $direccionConsultorio = $consultorio["direccion"] . " " . $consultorio["numero"];
        }

        $item_options = "<i class='{$icon}'></i><span>{$nombreConsultorio}<small class='address'>{$direccionConsultorio}</small> <small>{$tipoVisita}</small></span>";


        //Armamos la notificacion
        $array_insert = array(
            "paciente_idpaciente" => $turno["paciente_idpaciente"],
            "leido" => 0,
            "turno_idturno" => $turno["idturno"],
            "titulo" => "Changement de statut du Rendez-vous",
            "descripcion" => $fecha_turno,
            "estado_turno" => $record["estado"],
            "tipoNotificacion_idtipoNotificacion" => 3,
            "medico_nombre" => "{$medico["tituloprofesional"]} {$medico["nombre"]} {$medico["apellido"]}",
            "medico_especialidad" => $especialidades,
            "item_options" => $item_options
        );

        $rdo = parent::process($array_insert);

        if ($rdo) {

            switch ($record["estado"]) {
                case 1:$text = "Rendez-vous confirmé";
                    break;
                case 2:$text = "Rendez-vous annulé";
                    break;
                case 3:$text = "Rendez-vous décliné";
                    break;
                case 5:$text = "Patient absent";
                    break;
            }
            //notify
            $client = new XSocketClient();
            $paciente = $this->getManager("ManagerPaciente")->get($turno["paciente_idpaciente"]);
            $notify["title"] = "{$paciente["nombre"]} {$paciente["apellido"]} - Notification";
            $notify["text"] = $text;
            $notify["paciente_idpaciente"] = $turno["paciente_idpaciente"];
            $notify["style"] = "notificacion";
            $notify["type"] = "cambio_estado_turno";
            $notify["id"] = $turno["idturno"];
            $client->emit('notify_php', $notify);
        }
        return $rdo;
    }

    /**
     * Método utilizado para crear la notificación que es utilizada como respuesta al mensaje compartido por el médico
     * @param type $request
     * @return type
     */
    public function createNotificacionFromRespuestaMensaje($request) {

        if ($request["respuesta"] == "") {
            $this->setMsg(["msg" => "Ingrese el texto del mensaje", "result" => false]);
            return false;
        }
        if ($request["notificacion_idnotificacion"] != "") {
            $notificacion_padre = parent::get($request["notificacion_idnotificacion"]);
            $ManagerMedico = $this->getManager("ManagerMedico");
            $medico = $ManagerMedico->get($_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"]);
            //LA RESPUESTA ES EL PRIMER MENSAJE DE LA CADENA DE RESPUESTAS  
            $notificacion_idnotificacionRespuesta = $notificacion_padre["notificacion_idnotificacionRespuesta"] != "" ? $notificacion_padre["notificacion_idnotificacionRespuesta"] : $notificacion_padre["idnotificacion"];

            $array_insert = array(
                "medico_idmedicoRespuesta" => $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"],
                "leido" => 0,
                "titulo" => "Message de {$medico["tituloprofesional"]} {$medico["nombre"]} {$medico["apellido"]}",
                "descripcion" => $request["respuesta"],
                "notificacion_idnotificacionRespuesta" => $notificacion_idnotificacionRespuesta
            );
            //verificamos si la notificacion que se responde era de un paciente o un medico
            //destinatario: paciente 
            if ($notificacion_padre["paciente_idpaciente_emisor"] != "") {
                $array_insert["paciente_idpaciente"] = $notificacion_padre["paciente_idpaciente_emisor"];
                $array_insert["tipoNotificacion_idtipoNotificacion"] = 8;
                $array_insert["medico_idmedico_emisor"] = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];
            }
            //destinatario: medico
            if ($notificacion_padre["medico_idmedicoRespuesta"] != "") {
                $array_insert["medico_idmedico"] = $notificacion_padre["medico_idmedicoRespuesta"];
                $array_insert["tipoNotificacion_idtipoNotificacion"] = 2;
            }
            $this->db->StartTrans();
            $rdo = parent::process($array_insert);
            //enviamos el mensaje por mail al destinatario
            //destinatario medico
            if ($notificacion_padre["medico_idmedicoRespuesta"] != "") {
                $record["medico_idmedico"] = $notificacion_padre["medico_idmedicoRespuesta"];
                $record["cuerpo"] = $request["respuesta"];
                $mail = $this->getManager("ManagerMedico")->enviarMensajeMedico($record);
            }
            //destinatario paciente
            if ($notificacion_padre["paciente_idpaciente_emisor"] != "") {
                $record["paciente_idpaciente"] = $notificacion_padre["paciente_idpaciente_emisor"];
                $record["cuerpo"] = $request["respuesta"];
                $mail = $this->getManager("ManagerMedico")->enviarMensajePaciente($record);
            }

            if (!$mail) {
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                $this->setMsg(["msg" => "Error. No se pudo crear la respuesta a la notificacion seleccionada", "result" => false]);
                return false;
            }
            if ($rdo) {

                $text = "{$medico["tituloprofesional"]} {$medico["nombre"]} {$medico["apellido"]} a envoyé un message";
                //notify
                $client = new XSocketClient();

                $notify["title"] = "{$medico["tituloprofesional"]} {$medico["nombre"]} {$medico["apellido"]} - Notification";
                $notify["text"] = $text;
                if ($notificacion_padre["paciente_idpaciente_emisor"] != "") {
                    $notify["paciente_idpaciente"] = $notificacion_padre["paciente_idpaciente_emisor"];
                }
                if ($notificacion_padre["medico_idmedicoRespuesta"] != "") {
                    $notify["medico_idmedico"] = $notificacion_padre["medico_idmedicoRespuesta"];
                }
                $notify["style"] = "notificacion";
                $notify["type"] = "notificacion";
                $client->emit('notify_php', $notify);

                $this->db->CompleteTrans();
                $this->setMsg(["msg" => "Mensaje enviado con éxito", "result" => true]);
                return true;
            } else {
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                $this->setMsg(["msg" => "Error. No se pudo crear la respuesta a la notificacion seleccionada", "result" => false]);
                return false;
            }
        } else {
            $this->setMsg(["msg" => "Error. No se pudo crear la respuesta a la notificacion seleccionada", "result" => false]);
            return false;
        }
    }

    /**
     * Método utilizado para crear la notificación que es utilizada como respuesta del paciente al mensaje del medico
     * @param type $request
     * @return type
     */
    public function createNotificacionFromRespuestaMensajePaciente($request) {

        if ($request["respuesta"] == "") {
            $this->setMsg(["msg" => "Ingrese el texto del mensaje", "result" => false]);
            return false;
        }
        $notificacion_padre = parent::get($request["notificacion_idnotificacion"]);
        //LA RESPUESTA ES EL PRIMER MENSAJE DE LA CADENA DE RESPUESTAS  
        $notificacion_idnotificacionRespuesta = $notificacion_padre["notificacion_idnotificacionRespuesta"] != "" ? $notificacion_padre["notificacion_idnotificacionRespuesta"] : $notificacion_padre["idnotificacion"];

        $ManagerPaciente = $this->getManager("ManagerPaciente");
        $paciente = $ManagerPaciente->getPacienteXHeader();
        if ($request["notificacion_idnotificacion"] != "") {
            $this->db->StartTrans();
            $array_insert = array(
                "paciente_idpaciente_emisor" => $paciente["idpaciente"],
                "medico_idmedico" => $notificacion_padre["medico_idmedico_emisor"],
                "leido" => 0,
                "titulo" => "Message de {$paciente["nombre"]} {$paciente["apellido"]}",
                "descripcion" => $request["respuesta"],
                "tipoNotificacion_idtipoNotificacion" => 2,
                "notificacion_idnotificacionRespuesta" => $notificacion_idnotificacionRespuesta
            );

            $rdo = parent::process($array_insert);
            //enviamos el mail al medico con la respuesta
            $mail = $this->enviarMailNotificacionFromRespuestaMensajePaciente($array_insert);
            if (!$mail) {
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                return false;
            }

            if ($rdo) {



                $text = "{$paciente["nombre"]} {$paciente["apellido"]} a envoyé un message";
                //notify
                $client = new XSocketClient();

                $notify["title"] = "{$paciente["nombre"]} {$paciente["apellido"]} - Notification";
                $notify["text"] = $text;
                $notify["medico_idmedico"] = $notificacion_padre["medico_idmedico_emisor"];
                $notify["style"] = "notificacion";
                $notify["type"] = "notificacion";
                $client->emit('notify_php', $notify);
                $this->db->CompleteTrans();
                $this->setMsg(["msg" => "Mensaje enviado con éxito", "result" => true]);
                return true;
            } else {
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                $this->setMsg(["msg" => "Error. No se pudo crear la respuesta a la notificacion seleccionada", "result" => false]);
                return false;
            }
        } else {
            $this->setMsg(["msg" => "Error. No se pudo crear la respuesta a la notificacion seleccionada", "result" => false]);
            return false;
        }
    }

    /**
     * Metodo que envia un mail al medico cuando el paciente responde un mensaje desde la seccion de notificaciones
     * @param type $request
     * @return boolean
     */
    public function enviarMailNotificacionFromRespuestaMensajePaciente($request) {
        if (!isset($request["paciente_idpaciente_emisor"]) || $request["paciente_idpaciente_emisor"] == "") {
            $this->setMsg(["msg" => "Error. No se pudo recuperar el registro de paciente", "result" => false]);
            return false;
        }

        if (!isset($request["medico_idmedico"]) || $request["medico_idmedico"] == "") {
            $this->setMsg(["msg" => "Error. No se pudo recuperar el registro de medico", "result" => false]);
            return false;
        }

        $ManagerPaciente = $this->getManager("ManagerPaciente");
        $paciente = $ManagerPaciente->get($request["paciente_idpaciente_emisor"]);
        $paciente["imagen"] = $ManagerPaciente->getImagenPaciente($paciente["idpaciente"]);

//validamos que el mensaje no este vacio
        if (!isset($request["descripcion"]) || $request["descripcion"] == "") {
            $this->setMsg(["msg" => "Error. Mensaje vacío", "result" => false]);
            return false;
        }

//envio de la invitacion por mail
//$mEmail = $this->getManager("ManagerMail");
        $mEmail = $this->getManager("ManagerMail");

        $smarty = SmartySingleton::getInstance();

        $medico = $this->getManager("ManagerMedico")->get($request["medico_idmedico"], true);

        $smarty->assign("paciente", $paciente);
        $smarty->assign("medico", $medico);
        $smarty->assign("cuerpo", $request["descripcion"]);

        $mEmail->setHTML(true);

        //ojo solo arnet local
        $mEmail->setPort("587");

        $mEmail->setSubject(sprintf("WorknCare | Nouveau message du %s %s", $paciente["nombre"], $paciente["apellido"]));

        $mEmail->setBody($smarty->Fetch("email/paciente_medico_mensaje.tpl"));
        $email = $medico["email"];
        $mEmail->addTo($email);

        if ($mEmail->send()) {
            $this->setMsg(["msg" => "Mensaje enviado con éxito", "result" => true]);
            return true;
        } else {
            $this->setMsg(["msg" => "No se ha podido enviar el mensaje. Inténtelo más tarde", "result" => false]);
            return false;
        }
    }

    /**
     * Método que retorna la notificación perteneciente a la compartida de estudios
     * @param type $idnotificacion
     * @return boolean
     */
    private function getNotificacionesMensajesAnteriores($idnotificacion) {

        $query = new AbstractSql();

        $query->setSelect("ce.*,
                        ce.nombre as nombre_medico_ce,
                        ce.apellido as apellido_medico_ce,
                        ifnull(vm.nombre,vp.nombre) as nombre,
                        ifnull(vm.apellido,vp.apellido) as apellido,
                        n.*");

        $query->setFrom("$this->table n
                            LEFT JOIN v_medicos vm ON (vm.idmedico = n.medico_idmedicoRespuesta)
                            LEFT JOIN v_pacientes vp ON (vp.idpaciente = n.paciente_idpaciente_emisor)
                           
                            LEFT JOIN v_compartirestudio ce ON (n.medicoCompartirEstudio_idmedicoCompartirEstudio = ce.idmedicoCompartirEstudio)
                    ");

        $query->setWhere("(n.notificacion_idnotificacionRespuesta = $idnotificacion or idnotificacion=$idnotificacion)");

        $query->setGroupBy("n.idnotificacion");
        $query->setOrderBy("n.fechaNotificacion ASC");
        $registros = $this->getList($query);

        if ($registros) {
            foreach ($registros as $key => $registro) {


                //Me fijo si hay ids de los archivos.
                if ($registro["ids"] != "") {

                    $ids = substr($registro["ids"], 1);
                    $list_ids = explode(",", $ids);

                    if (count($list_ids) > 0) {

                        $ManagerPerfilSaludEstudiosImagen = $this->getManager("ManagerPerfilSaludEstudiosImagen");

                        $attach = array();

                        foreach ($list_ids as $key2 => $id) {
                            if ((int) $id > 0) {

                                $imagenes = $ManagerPerfilSaludEstudiosImagen->getListImages((int) $id);

                                // $filename = path_entity_files("estudios_imagenes/$id/" . $estudio["nombre_archivo"] . ".jpg");
                            }
                        }
                        $registro["file"][] = $imagenes;
                    }
                }


                if ($registro["fechaNotificacion"] != "") {
                    $calendar = new Calendar();
                    $date_explode = explode(" ", $registro["fechaNotificacion"]);
                    if (count($date_explode) == 2) {
                        list($y, $m, $d) = preg_split("[-]", $date_explode[0]);
                        list($hs, $mn, $sg) = preg_split("[:]", $date_explode[1]);
                        $mes = $calendar->getMonthsShort((int) $m);
                        $registro["fechaNotificacion_format"] = "$d $mes $hs:$mn";
                    }
                }
                $path_dir = path_entity_files("archivos_mensaje_paciente/{$registro["medico_idmedico_emisor"]}/{$registro["paciente_idpaciente"]}/{$registro["idnotificacion"]}");
                if (file_exists($path_dir)) {
                    $archivos = scandir($path_dir);
                    foreach ($archivos as $i => $archivo) {
                        if ($archivo == "." || $archivo == "..") {
                            unset($archivos[$i]);
                        }
                    }
                    $registro["archivos"] = $archivos;
                }
                $registros[$key] = $registro;
            }
        }
        return $registros;
    }

    /**
     * Método que crea la notificación correspondiente al mensaje que envía el paciente al medico
     * @param type $request
     * @return boolean
     */
    public function createNotificacionFromMisPacientesMensajeMedico($request) {
        if ($request["idmedico"] == "") {
            $this->setMsg(["msg" => "Error. No se pudo crear el mensaje hacia el médico seleccionado médico", "result" => false]);
            return false;
        } else {

            $ManagerMedico = $this->getManager("ManagerMedico");
            $medico = $ManagerMedico->get($_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"]);

            $array_insert = array(
                "medico_idmedicoRespuesta" => $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"],
                "medico_idmedico" => $request["idmedico"],
                "leido" => 0,
                "titulo" => "Message de " . $medico["tituloprofesional"] . " " . $medico["nombre"] . " " . $medico["apellido"],
                "descripcion" => $request["mensaje"],
                "tipoNotificacion_idtipoNotificacion" => 2
            );
            $this->db->StartTrans();
            $process = parent::process($array_insert);
            $mail = $this->getManager("ManagerMedico")->enviarMensajeMedico(["medico_idmedico" => $request["idmedico"], "cuerpo" => $request["mensaje"]]);

            if ($process) {


                $text = "{$medico["tituloprofesional"]} {$medico["nombre"]} {$medico["apellido"]} vous a envoyé un message";
                //notify
                $client = new XSocketClient();

                $notify["title"] = "{$medico["tituloprofesional"]} {$medico["nombre"]} {$medico["apellido"]} - Notification";
                $notify["text"] = $text;
                $notify["medico_idmedico"] = $request["idmedico"];
                $notify["style"] = "notificacion";
                $notify["type"] = "notificacion";
                $client->emit('notify_php', $notify);


                $this->setMsg(["msg" => "Se envió correctamente el mensaje al médico", "result" => true]);
                $this->db->CompleteTrans();
                return $process;
            } else {
                $this->setMsg(["msg" => "Error. No se pudo crear el mensaje hacia el médico seleccionado médico", "result" => false]);
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                return false;
            }
        }
    }

    /**
     * Método que crea la notificación correspondiente al mensaje que envía el medico al paciente
     * @param type $request
     * @return boolean
     */
    public function createNotificacionMensajeMedicoPaciente($request) {

        if (!isset($request["paciente_idpaciente"]) || $request["paciente_idpaciente"] == "") {
            $this->setMsg(["msg" => "Error. No se pudo recuperar el registro de paciente", "result" => false]);
            return false;
        } else {
            if (CONTROLLER == "medico") {
                $idmedico = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];
            } else {
                $idmedico = $request["idmedico"];
            }
            $request["idmedico"] = $idmedico;
            $ManagerMedico = $this->getManager("ManagerMedico");
            $medico = $ManagerMedico->get($idmedico);

            $array_insert = array(
                "paciente_idpaciente" => $request["paciente_idpaciente"],
                "medico_idmedico_emisor" => $idmedico,
                "medico_idmedicoRespuesta" => $idmedico,
                "leido" => 0,
                "titulo" => "Message de " . $medico["tituloprofesional"] . " " . $medico["nombre"] . " " . $medico["apellido"],
                "descripcion" => $request["cuerpo"],
                "tipoNotificacion_idtipoNotificacion" => 8
            );
            $this->db->StartTrans();
            $idnotificacion = parent::process($array_insert);
            $request["idnotificacion"] = $idnotificacion;
            $mail = $this->getManager("ManagerMedico")->enviarMensajePaciente($request);

            if ($idnotificacion && $mail) {


                $text = "{$medico["tituloprofesional"]} {$medico["nombre"]} {$medico["apellido"]} vous a envoyé un message";
                //notify
                $client = new XSocketClient();

                $notify["title"] = "{$medico["tituloprofesional"]} {$medico["nombre"]} {$medico["apellido"]} - Notification";
                $notify["text"] = $text;
                $notify["paciente_idpaciente"] = $request["paciente_idpaciente"];
                $notify["style"] = "notificacion";
                $notify["type"] = "notificacion";
                $client->emit('notify_php', $notify);


                $this->setMsg(["msg" => "Se envió correctamente el mensaje al médico", "result" => true]);
                $this->db->CompleteTrans();
                return $idnotificacion;
            } else {
                $this->setMsg(["msg" => "Error. No se pudo crear el mensaje hacia el médico seleccionado médico", "result" => false]);
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                return false;
            }
        }
    }

    /**
     * Método que crea la notificación correspondiente al mensaje que envía el médico al paciente, cuando el médico lo agrega a sus pacientes
     * @param type $request
     * @return boolean
     */
    public function createNotificacionFromMisPacientesInvitacion($request) {
        if ($request["paciente_idpaciente"] != "") {

            $ManagerMedico = $this->getManager("ManagerMedico");

            $idmedico = (isset($request["medico_idmedico"]) && (int) $request["medico_idmedico"] > 0) ? $request["medico_idmedico"] : $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];
            $medico = $ManagerMedico->get($idmedico, true);

            //Sexo médico
            $string_mensaje = "";
            if ($medico["tituloprofesional"] != "") {
                $string_mensaje .= $medico["tituloprofesional"] . " ";
            }

            $string_mensaje .= "{$medico["nombre"]} {$medico["apellido"]}";
            if (count($medico["mis_especialidades"]) > 0) {
//                  Agrego las especialidades
                $string_mensaje .= " ";
                $especialidades_str = $medico["mis_especialidades"][0]["especialidad"];
                $string_mensaje .= "($especialidades_str) ";
            }


            if ($medico["mis_especialidades"][0]["tipo"] == 2 && $medico["mis_especialidades"][0]["tipo_identificacion"] == 2) {
                $label_paciente = "client";
            } else {
                $label_paciente = "patient";
            }

            $string_mensaje .= " souhaite vous ajouter en tant que {$label_paciente}";


            $array_insert = array(
                "paciente_idpaciente" => $request["paciente_idpaciente"],
                "leido" => 0,
                "titulo" => $string_mensaje,
                "medico_paciente_invitacion_idmedico_paciente_invitacion" => $request["idmedico_paciente_invitacion"],
                "tipoNotificacion_idtipoNotificacion" => 5
            );

            $rdo = parent::process($array_insert);
            if ($rdo) {
                //notify
                $client = new XSocketClient();
                $notify["title"] = "{$medico["tituloprofesional"]} {$medico["nombre"]} {$medico["apellido"]} - Notification";
                $notify["text"] = $string_mensaje;
                $notify["paciente_idpaciente"] = $request["paciente_idpaciente"];
                $notify["style"] = "notificacion";
                $notify["type"] = "notificacion";
                $client->emit('notify_php', $notify);
            }

            return $rdo;
        } else {
            $this->setMsg(["msg" => "Error. Se produjo un error al crear la notificación del paciente", "result" => true]);
            return false;
        }
    }

    /**
     * Método que crea la notificación correspondiente a la facturacion de una videoconsulta
     * @param type $request
     * @return boolean
     */
    public function createNotificacionFacturacionVideoConsulta($request) {

        if ($request["paciente_idpaciente"] != "") {

            $ManagerMedico = $this->getManager("ManagerMedico");

            $idmedico = (isset($request["medico_idmedico"]) && (int) $request["medico_idmedico"] > 0) ? $request["medico_idmedico"] : $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];
            $medico = $ManagerMedico->get($idmedico, true);

            $ManagerPaciente = $this->getManager("ManagerPaciente");
            $paciente = $ManagerPaciente->get($request["paciente_idpaciente"]);

            //Sexo médico
            if ($request["estado_facturacion_caja"] == 1) {
                if ($medico["facturacion_teleconsulta"] == 1) {
                    $estado_facutacion_texto = "a envoyé à votre CPAM la feuille de soin pour le remboursement de votre téléconsultation";
                } else {
                    $estado_facutacion_texto = "vous a envoyé votre feuille de soin pour le remboursement de votre téléconsultation";
                }
            }
            if ($request["estado_facturacion_caja"] == 2 || $request["estado_facturacion_caja"] == 3) {
                if ($request["idmotivo_rechazo_reintegro"] == 1) {
                    $estado_facutacion_texto = "vous informe que votre téléconsultation n’est pas prise en charge par votre CPAM. Motif: Numéro Carte Vitale invalide";
                }
                if ($request["idmotivo_rechazo_reintegro"] == 2) {
                    $estado_facutacion_texto = "vous informe que votre téléconsultation n’est pas prise en charge par votre CPAM. Motif: Je ne suis pas médecin traitant";
                }
                if ($request["idmotivo_rechazo_reintegro"] == 3) {
                    $estado_facutacion_texto = "vous informe que votre téléconsultation n’est pas prise en charge par votre CPAM. Motif: Ce patient n'est pas en ALD";
                }
                if ($request["idmotivo_rechazo_reintegro"] == 4) {
                    $estado_facutacion_texto = "vous informe que votre téléconsultation n’est pas prise en charge par votre CPAM. Motif: Pas de consultation présentielle dans les 12 derniers mois";
                }
            }

            if ($request["estado_facturacion_caja"] == 3) {
                $estado_facutacion_texto = "";
            }

            $string_mensaje = "{$medico["tituloprofesional"]} {$medico["nombre"]} {$medico["apellido"]} $estado_facutacion_texto";



            $array_insert = array(
                "paciente_idpaciente" => $request["paciente_idpaciente"],
                "leido" => 0,
                "titulo" => $string_mensaje,
                "medico_paciente_invitacion_idmedico_paciente_invitacion" => $request["idmedico_paciente_invitacion"],
                "tipoNotificacion_idtipoNotificacion" => 7
            );

            $rdo = parent::process($array_insert);
            if ($rdo) {

                //notify
                $client = new XSocketClient();
                $notify["title"] = "{$medico["tituloprofesional"]} {$medico["nombre"]} {$medico["apellido"]} - Notification";
                $notify["text"] = $string_mensaje;
                $notify["paciente_idpaciente"] = $request["paciente_idpaciente"];
                $notify["style"] = "notificacion";
                $notify["type"] = "notificacion";
                $client->emit('notify_php', $notify);

                //envio SMS

                /**
                 * Inserción del SMS en la lista de envio
                 */
                $ManagerLogSMS = $this->getManager("ManagerLogSMS");
                $sms = $ManagerLogSMS->insert([
                    "dirigido" => "P",
                    "paciente_idpaciente" => $paciente["idpaciente"],
                    "contexto" => "Facturacion Videoconsulta",
                    "texto" => "WorknCare: " . $string_mensaje,
                    "numero_cel" => $paciente["numeroCelular"]
                ]);
            }

            return $rdo;
        } else {
            $this->setMsg(["msg" => "Error. Se produjo un error al crear la notificación del paciente", "result" => true]);
            return false;
        }
    }

    /**
     * Método que crea la notificación correspondiente al mensaje de respuesta del paciente al médico con respecto 
     * @param type $request
     * @return boolean
     */
    public function createNotificacionFromMisPacientesRespuesta($request) {
        if ($request["paciente_idpaciente"] != "") {

            $ManagerPaciente = $this->getManager("ManagerPaciente");
            $paciente = $ManagerPaciente->get($request["paciente_idpaciente"]);

            $string_mensaje = "{$paciente["nombre"]} {$paciente["apellido"]}";
            $medico = $this->getManager("ManagerMedico")->get($request["medico_idmedico"], true);

            if ($medico["mis_especialidades"][0]["tipo"] == 2 && $medico["mis_especialidades"][0]["tipo_identificacion"] == 2) {
                $label_paciente = "clients";
            } else {
                $label_paciente = "patients";
            }

            if ((int) $request["estado"] == 1) {
                $string_mensaje .= " a accepté votre invitation et a été ajouté à votre liste de {$label_paciente}";
                $notify_text = "A accepté votre invitation et a été ajouté à votre liste de {$label_paciente}";
            } else {
                $string_mensaje .= " a décliné votre invitation et n’a pas été ajouté à votre liste de {$label_paciente}";
                $notify_text = " A décliné votre invitation et n’a pas été ajouté à votre liste de {$label_paciente}";
            }


            $array_insert = array(
                "medico_idmedico" => $request["medico_idmedico"],
                "leido" => 0,
                "titulo" => $string_mensaje,
                "notificacion_idnotificacionRespuesta" => $request["idnotificacion"],
                "tipoNotificacion_idtipoNotificacion" => 5
            );

            $rdo = parent::process($array_insert);
            if ($rdo) {
                //notify
                $client = new XSocketClient();

                $notify["title"] = "{$paciente["nombre"]} {$paciente["apellido"]} - Notification";
                $notify["text"] = $notify_text;
                $notify["medico_idmedico"] = $request["medico_idmedico"];
                $notify["type"] = "respuesta-invitacion-paciente";
                $notify["style"] = "notificacion";
                $notify["type"] = "notificacion";
                $client->emit('notify_php', $notify);
            }
            return $rdo;
        } else {
            $this->setMsg(["msg" => "Error. Se produjo un error al crear la notificación del paciente", "result" => true]);
            return false;
        }
    }

    /**
     * Método que crea la notificación correspondiente al mensaje cuando el profesional pasa a ser medico frecuente del paciente
     * @param type $request
     * @return boolean
     */
    public function createNotificacionRespuestaAgregarProfesionalFrecuente($request) {
        if ($request["paciente_idpaciente"] != "" && $request["medico_idmedico"] != "") {

            $medico = $ManagerMedico = $this->getManager("ManagerMedico")->get($request["medico_idmedico"]);



            $string_mensaje = "{$medico["tituloprofesional"]} {$medico["nombre"]} {$medico["apellido"]} accepté votre invitation et a été ajouté à votre liste de Professionnels Fréquents";
            $notify_text = " Votre invitation a été acceptée et le Professionnel a été ajouté à votre liste de Professionnels Fréquents";

            $array_insert = array(
                "paciente_idpaciente" => $request["paciente_idpaciente"],
                "leido" => 0,
                "titulo" => $string_mensaje,
                "notificacion_idnotificacionRespuesta" => $request["idnotificacion"],
                "tipoNotificacion_idtipoNotificacion" => 7
            );

            $rdo = parent::process($array_insert);
            if ($rdo) {
                //notify
                $client = new XSocketClient();

                $notify["title"] = $medico["tituloprofesional"] . " " . $medico["nombre"] . " " . $medico["apellido"] . " - Notification";
                $notify["text"] = $notify_text;
                $notify["paciente_idpaciente"] = $request["paciente_idpaciente"];
                $notify["style"] = "notificacion";
                $notify["type"] = "notificacion";
                $client->emit('notify_php', $notify);
            }
            return $rdo;
        } else {
            $this->setMsg(["msg" => "Error. Se produjo un error al crear la notificación del paciente", "result" => true]);
            return false;
        }
    }

    /**
     * Método que crea la notificación correspondiente  cuando el paciente agrega a un profesional frecuente
     * @param type $request
     * @return boolean
     */
    public function createNotificacionAgregarProfesionalFrecuente($request) {
        if ($request["paciente_idpaciente"] != "" && $request["medico_idmedico"] != "") {

            $paciente = $ManagerPaciente = $this->getManager("ManagerPaciente")->get($request["paciente_idpaciente"]);


            //Sexo médico

            $string_mensaje .= "{$paciente["nombre"]} {$paciente["apellido"]} vous a ajouté à ses Professionnels Fréquents";
            $notify_text = "Vous avez été ajouté à ses Professionnels Fréquents";



            $array_insert = array(
                "medico_idmedico" => $request["medico_idmedico"],
                "leido" => 0,
                "titulo" => $string_mensaje,
                "notificacion_idnotificacionRespuesta" => $request["idnotificacion"],
                "tipoNotificacion_idtipoNotificacion" => 5
            );

            $rdo = parent::process($array_insert);
            if ($rdo) {
                //notify
                $client = new XSocketClient();

                $notify["title"] = $paciente["nombre"] . " " . $paciente["apellido"] . " - Notification";
                $notify["text"] = $notify_text;
                $notify["medico_idmedico"] = $request["medico_idmedico"];
                $notify["style"] = "notificacion";
                $notify["type"] = "notificacion";
                $client->emit('notify_php', $notify);
            }
            return $rdo;
        } else {
            $this->setMsg(["msg" => "Error. Se produjo un error al crear la notificación del paciente", "result" => true]);
            return false;
        }
    }

    /**
     * Método utilizado para la creación de las notificaciones mediante los crones diarios...
     * @param type $request
     */
    public function cronCreacionNotificacionesControlesYChequeos() {
        //Obtengo el listado de pacientes que no mandaron mensaje hoy..
        $hoy = date("Y-m-d");
        //$this->db->StartTrans();

        $query = new AbstractSql();

        $query->setSelect("*");

        $query->setFrom("paciente p ");

        //Listo todos los pacientes que el cron todavía no los agarró...
        $query->setWhere("idpaciente NOT IN (SELECT paciente_idpaciente
                                                FROM campaniascronpaciente
                                                WHERE fechaControlesChequeos = '$hoy')
                          ");

        $query->addAnd("active = 1");

        $query->setLimit("0,50");

        $listado = $this->getList($query);

        if ($listado && count($listado) > 0) {

            foreach ($listado as $key => $paciente) {

                $this->insertControlesChequeosPaciente($paciente["idpaciente"], $hoy);
            }
        }
    }

    /**
     * Método que realiza la inserción de los controles y chequeos correspondientes a un paciente
     * @param type $idpaciente
     */
    public function insertControlesChequeosPaciente($idpaciente, $hoy) {
        return true;
    }

    /**
     * Método que realiza la inserción de los controles y chequeos correspondientes a un paciente
     * @param type $idpaciente
     */
    public function insertControlesChequeosPaciente_old($idpaciente, $hoy) {

        $ManagerPaciente = $this->getManager("ManagerPaciente");
        $paciente = $ManagerPaciente->get($idpaciente);


        if ($paciente) {

            //Recorro todos los pacientes y en base a la edad actualizo las notificaciones
            $ManagerVacunaVacunaEdad = $this->getManager("ManagerVacunaVacunaEdad");
            $ManagerCampaniasCronPaciente = $this->getManager("ManagerCampaniasCronPaciente");

            //Recorro todas las listado de vacunas de edad que no tiene puestas el paciente...
            $listado_vacuna_paciente = $ManagerVacunaVacunaEdad->getListVacunasNoAplicadasPaciente($paciente["idpaciente"]);

            //Paso la edad del paciente a meses -> Unidad Más chica
            $edad_paciente_en_meses = (int) $paciente["edad_anio"] * 12 + (int) $paciente["edad_mes"];


            //Tengo que recorrer cada listado vacuna edad, fijarme si está creado o no el aviso de control y chequeo...
            if ($listado_vacuna_paciente && count($listado_vacuna_paciente) > 0) {
                foreach ($listado_vacuna_paciente as $key2 => $vacuna_paciente) {

                    if ((int) $vacuna_paciente["valor_unidad"] >= 0 && (int) $vacuna_paciente["unidadTemporal_idunidadTemporal"] >= 0) {
                        //Unidad temporal lo paso a meses -> si es <> de 1 entonces es porque es año y lo debo pasar a meses
                        $unidad_temporal = $vacuna_paciente["unidadTemporal_idunidadTemporal"] == 1 ? 1 : 12;

                        $meses_aplicacion_vacuna = $vacuna_paciente["valor_unidad"] * $unidad_temporal;

                        /**
                         * Realización de comparadores de edad
                         * de 18 meses para abajo
                         * de 18 meses a 5 años (60 meses)
                         * de 5 años a 18 años (216 meses)
                         */
                        $validacion = ($edad_paciente_en_meses <= 18 && $meses_aplicacion_vacuna <= 18) ||
                                ($edad_paciente_en_meses > 18 && $edad_paciente_en_meses <= 50 && $meses_aplicacion_vacuna > 18 && $meses_aplicacion_vacuna <= 50 ) ||
                                ($edad_paciente_en_meses > 50 && $edad_paciente_en_meses <= 216 && $meses_aplicacion_vacuna > 50 && $meses_aplicacion_vacuna <= 216 );


                        if ($validacion) {

                            //Comparo con la edad del paciente en meses
                            if ($edad_paciente_en_meses >= $meses_aplicacion_vacuna) {
                                //Debo realizar el aviso si es que todavía no se hizo
                                $registro = $this->getXRelacion($paciente["idpaciente"], $vacuna_paciente["idvacuna_vacunaEdad"]);

                                if (!$registro) {

                                    //Debo crear el registro
                                    $insert = array(
                                        "titulo" => "Le vaccin " . $vacuna_paciente["vacuna"] . " doit être appliqué",
                                        "descripcion" => $vacuna_paciente["descripcion_vacuna"],
                                        "vacuna_vacunaEdad_idvacuna_vacunaEdad" => $vacuna_paciente["idvacuna_vacunaEdad"],
                                        "paciente_idpaciente" => $paciente["idpaciente"],
                                        "tipoControlChequeo_idtipoControlChequeo" => 1,
                                        "tipoNotificacion_idtipoNotificacion" => 6
                                    );

                                    $rdo = $this->insert($insert);
                                    if ($rdo) {
                                        //notify
                                        $client = new XSocketClient();
                                        $paciente = $this->getManager("ManagerPaciente")->get($idpaciente);
                                        $notify["title"] = "{$paciente["nombre"]} {$paciente["apellido"]} - Notification";
                                        $notify["text"] = "Contrôles et vérifications";
                                        $notify["paciente_idpaciente"] = $idpaciente;
                                        $notify["style"] = "notificacion";
                                        $notify["type"] = "notificacion";
                                        $client->emit('notify_php', $notify);
                                    }
                                    return $rdo;
                                }
                            }
                        }
                    }
                }
            }

            if ($paciente["sexo"] === 0) {
                //Si es mujer debo verificar la fecha de pap y mam
                $ManagerPerfilSaludGinecologico = $this->getManager("ManagerPerfilSaludGinecologico");
                $perfil_ginecologico = $ManagerPerfilSaludGinecologico->getPerfilSaludXIDPaciente($paciente["idpaciente"]);
                if ($perfil_ginecologico) {
                    //Me fijo si pasaron 6 meses de la última visita al ginecólogo
                    if ($perfil_ginecologico["fecha_ultimo_pap"] != "") {


                        $calendar = new Calendar();
                        $diferencia = $calendar->getDiferenciasFechas($hoy, $perfil_ginecologico["fecha_ultimo_pap"], "m");
                        if ($diferencia >= 6) {

                            //Me fijo si ya tiene creado
                            $notificacion_fr = $this->getNotificacionFactorRiesgo($idpaciente, 4);
                            if (!$notificacion_fr) {
                                $insert = array(
                                    "titulo" => "Vous devriez réaliser un test Papanicolau (PAP).",
                                    "descripcion" => "Un contrôle gynécologique est essentiel pour la prévention de nombreuses pathologies, notamment celles impliquant le col de l’utérus.",
                                    "paciente_idpaciente" => $idpaciente,
                                    "tipoControlChequeo_idtipoControlChequeo" => 4,
                                    "tipoNotificacion_idtipoNotificacion" => 6
                                );

                                $rdo = parent::insert($insert);
                                if ($rdo) {
                                    //notify
                                    $client = new XSocketClient();
                                    $paciente = $this->getManager("ManagerPaciente")->get($idpaciente);
                                    $notify["title"] = "{$paciente["nombre"]} {$paciente["apellido"]} - Notification";
                                    $notify["text"] = "Contrôles et vérifications";
                                    $notify["paciente_idpaciente"] = $idpaciente;
                                    $notify["style"] = "notificacion";
                                    $notify["type"] = "notificacion";
                                    $client->emit('notify_php', $notify);
                                }
                                return $rdo;
                            }
                        } else {
                            $notificacion_fr = $this->getNotificacionFactorRiesgo($idpaciente, 4);
                            if ($notificacion_fr) {
                                parent::delete($notificacion_fr[$this->id]);
                            }
                        }
                    }

                    //Me fijo si pasaron 12 meses de la última mamografía
                    if ($perfil_ginecologico["fecha_ultima_mamografia"] != "") {
                        $calendar = new Calendar();
                        $diferencia = $calendar->getDiferenciasFechas($hoy, $perfil_ginecologico["fecha_ultimo_pap"], "m");
                        if ($diferencia >= 12) {
                            //Me fijo si viene creado o no
                            $notificacion_fr = $this->getNotificacionFactorRiesgo($idpaciente, 3);
                            if (!$notificacion_fr) {
                                $insert = array(
                                    "titulo" => "Vous devriez réaliser un contrôle mammaire",
                                    "descripcion" => "Un contrôle mammaire est essentiel pour le diagnostic de lésions potentielles non identifiables par une palpation.",
                                    "paciente_idpaciente" => $idpaciente,
                                    "tipoControlChequeo_idtipoControlChequeo" => 3,
                                    "tipoNotificacion_idtipoNotificacion" => 6
                                );

                                $rdo = parent::insert($insert);
                                if ($rdo) {
                                    //notify
                                    $client = new XSocketClient();
                                    $paciente = $this->getManager("ManagerPaciente")->get($idpaciente);
                                    $notify["title"] = "{$paciente["nombre"]} {$paciente["apellido"]} - Notification";
                                    $notify["text"] = "Contrôles et vérifications";
                                    $notify["paciente_idpaciente"] = $idpaciente;
                                    $notify["style"] = "notificacion";
                                    $notify["type"] = "notificacion";
                                    $client->emit('notify_php', $notify);
                                }
                                return $rdo;
                            }
                        } else {
                            $notificacion_fr = $this->getNotificacionFactorRiesgo($idpaciente, 4);
                            if ($notificacion_fr) {
                                parent::delete($notificacion_fr[$this->id]);
                            }
                        }
                    }
                }
            }


            //Tengo que insertar el registro de que se pasó por el cron
            $ManagerCampaniasCronPaciente->insert([
                "paciente_idpaciente" => $paciente["idpaciente"],
                "fechaControlesChequeos" => $hoy
            ]);
        }
    }

    /**
     * Método que obtiene la relación de los controles y chequeos
     * @param type $idpaciente
     * @param type $idvacuna_vacunaEdad
     */
    public function getXRelacion($idpaciente, $idvacuna_vacunaEdad) {
        $query = new AbstractSql();

        $query->setSelect("*");

        $query->setFrom("$this->table");

        $query->setWhere("paciente_idpaciente = $idpaciente");

        $query->addAnd("vacuna_vacunaEdad_idvacuna_vacunaEdad = $idvacuna_vacunaEdad");

        $execute = $this->db->Execute($query->getSql());

        if ($execute) {
            return $execute->FetchRow();
        } else {
            return false;
        }
    }

    /**
     * Método que obteinee la notificacion perteneciente a un factor de riesgo de un paciente
     * @param type $idpaciente
     * @return boolean
     */
    public function getNotificacionFactorRiesgo($idpaciente, $tipo) {
        $query = new AbstractSql();

        $query->setSelect("*");

        $query->setFrom("$this->table");

        $query->setWhere("paciente_idpaciente = $idpaciente");

        $query->addAnd("tipoControlChequeo_idtipoControlChequeo = $tipo");

        $execute = $this->db->Execute($query->getSql());

        if ($execute) {
            return $execute->FetchRow();
        }
        return false;
    }

    /**
     * Método que realiza el cron Factor de Riesgo de Gripe
     */
    public function cronFactorRiesgoGripe() {
        $hoy = date("Y-m-d");

        $query = new AbstractSql();

        $query->setSelect("*");

        $query->setFrom("paciente");

        //Listo todos los pacientes que el cron todavía no los agarró...
        $query->setWhere("idpaciente NOT IN (SELECT paciente_idpaciente
                                                FROM campaniascronpaciente
                                                WHERE fechaFactorRiesgoGripe = '$hoy')
                          ");

        $query->addAnd("estado = 1");

        $query->setLimit("0,50");

        $listado = $this->getList($query);



        if ($listado && count($listado) > 0) {
            $ManagerCampaniasCronPaciente = $this->getManager("ManagerCampaniasCronPaciente");
            foreach ($listado as $key => $paciente) {
                $this->insertFactorRiesgoPaciente($paciente, $hoy);

                //Tengo que insertar el registro de que se pasó por el cron

                $ManagerCampaniasCronPaciente->insert([
                    "paciente_idpaciente" => $paciente["idpaciente"],
                    "fechaFactorRiesgoGripe" => $hoy
                ]);
            }
        }
    }

    /**
     * Método que realiza la inserción de los controles y chequeos correspondientes a un paciente
     * @param type $idpaciente
     */
    public function insertFactorRiesgoPaciente($paciente, $hoy) {
        return true;
    }

    /**
     * Método que chequea el factor de riesgo de los pacientes
     * @param type $paciente
     * @param type $hoy
     */
    private function insertFactorRiesgoPaciente_old($paciente, $hoy) {
        $idpaciente = $paciente["idpaciente"];

        $notificacion_fr = $this->getNotificacionFactorRiesgo($idpaciente, 2);

        if ($notificacion_fr) {
            $flag = true;
        }

        //Me tengo que fijar si tienen entre 6 <= Edad <= 24 Meses o mayores a 64 años
        if ($paciente["edad_anio"] >= 64 || ($paciente["edad_mes"] >= 6 && $paciente["edad_mes"] <= 24)) {
            if (!$flag) {
                return $this->insertFactorRiesgo($idpaciente, $hoy);
            } else {
                return true;
            }
        }

        //Embarazadas
        if ((int) $paciente["sexo"] == 0) {
            $ManagerPerfilSaludGinecologico = $this->getManager("ManagerPerfilSaludGinecologico");
            $perfil_ginecologico = $ManagerPerfilSaludGinecologico->getByField("paciente_idpaciente", $idpaciente);

            if ($perfil_ginecologico) {
                //Si es ginecológico, y está marcado el flag de embarazada Creo notificación
                if ((int) $perfil_ginecologico["is_embarazada"] == 1) {
                    if (!$flag) {
                        return $this->insertFactorRiesgo($idpaciente, $hoy);
                    } else {
                        return true;
                    }
                }
            }
        }


        //Presenten patologías -> respiratorias - cardíacas - Insuficiencia Renal (nefrológicas) - diabetes (endócrinas)
        $ManagerEnfermedadesActuales = $this->getManager("ManagerEnfermedadesActuales");
        //Respiratorias id= 1 - Cardíacas id= 13 - Nefrólogias id= 10 - Endócrinas id= 4
        $listado = $ManagerEnfermedadesActuales->getByEnfermedades("1,13,10,4", $idpaciente);

        if ($listado && count($listado) > 0) {
            //TODO
            if (!$flag) {
                return $this->insertFactorRiesgo($idpaciente, $hoy);
            } else {
                return true;
            }
        }


        //Personas Obesas con índice de masa corporal mayor a 40 (IMC)
        $ManagerPerfilSaludBiometrico = $this->getManager("ManagerPerfilSaludBiometrico");
        $perfil_salud_biometrico = $ManagerPerfilSaludBiometrico->getByField("paciente_idpaciente", $idpaciente);
        if ($perfil_salud_biometrico && (int) $perfil_salud_biometrico["idperfilSaludBiometricos"]) {
            $ManagerMasaCorporal = $this->getManager("ManagerMasaCorporal");
            $masa_corporal = $ManagerMasaCorporal->getLastInformation($perfil_salud_biometrico["idperfilSaludBiometricos"]);

            if ($masa_corporal && (float) $masa_corporal["imc"] > 40) {
                if (!$flag) {
                    return $this->insertFactorRiesgo($idpaciente, $hoy);
                } else {
                    return true;
                }
            }
        }


        //Si viene acá es porque no retorno y si flag está en true, debo eliminar el registro, 
        if ($flag) {
            return parent::delete($notificacion_fr[$this->id]);
        }
    }

    /**
     * Método que realiza la inserción de los controles y chequeos correspondientes a un paciente
     * @param type $idpaciente
     */
    public function insertFactorRiesgo($idpaciente, $hoy) {
        return true;
    }

    /**
     * Método utilizado para insertar el factor de riesgo cuando corresponda
     * @param type $idpaciente
     * @param type $hoy
     */
    private function insertFactorRiesgo_old($idpaciente, $hoy) {
        //Debo crear el registro
        $insert = array(
            "titulo" => "Veuillez-vous appliquer un vaccin Antigrippal",
            "descripcion" => "Un vaccin antigrippal vise à diminuer les complications, hospitalisations, décès et séquelles liées au virus de la grippe.",
            "paciente_idpaciente" => $idpaciente,
            "tipoControlChequeo_idtipoControlChequeo" => 2,
            "tipoNotificacion_idtipoNotificacion" => 6
        );

        $rdo = $this->insert($insert);
        if ($rdo) {
            //notify
            $client = new XSocketClient();
            $paciente = $this->getManager("ManagerPaciente")->get($idpaciente);
            $notify["title"] = "{$paciente["nombre"]} {$paciente["apellido"]} - Notification";
            $notify["text"] = "Contrôles et vérifications";
            $notify["paciente_idpaciente"] = $idpaciente;
            $notify["style"] = "notificacion";
            $notify["type"] = "notificacion";
            $client->emit('notify_php', $notify);
        }
        return $rdo;
    }

    /**
     * Método que retorna la cantidad
     * @param type $idpaciente
     */
    public function getCantidadControlesChequeos($idpaciente) {

        $query = new AbstractSql();

        $query->setSelect("COUNT($this->id) as cant");

        $query->setFrom("$this->table");

        $query->setWhere("paciente_idpaciente = $idpaciente");

        $query->addAnd("leido = 0");

        $query->addAnd("tipoNotificacion_idtipoNotificacion = 6");

        $execute = $this->db->Execute($query->getSql());

        if ($execute) {
            $rdo = $execute->FetchRow();
            if ((int) $rdo["cant"] > 0) {
                return (int) $rdo["cant"];
            }
        }
        return 0;
    }

    /**
     * Eliminación múltiple de las notificaciones.
     * chequeo de que no se eliminen notificaciones pertenecientes a controles y chequeos
     * @param type $ids
     * @param type $forced
     * @return boolean
     */
    public function deleteMultipleNotificaciones($ids, $forced = true) {
        $listado_ids = explode(",", $ids);

        if ($listado_ids && count($listado_ids) > 0) {

            //Recorro todos los ID´s 
            foreach ($listado_ids as $key => $id) {
                $ids_new = "";
                $registro = $this->get($id);
                //Si no es de tipo control y chequeo 
                if ((int) $registro["tipoNotificacion_idtipoNotificacion"] != 6) {
                    $ids_new .= ",$id";
                }
            }
            if ($ids_new != "") {
                $rdo = parent::deleteMultiple($ids_new, true);

                if ($rdo) {
                    $this->setMsg(["msg" => "Notificaciones eliminadas", "result" => true]);
                    return false;
                } else {
                    $this->setMsg(["msg" => "Error. No puedieron elimnar las notificaciones", "result" => false]);
                    return false;
                }
            } else {
                $this->setMsg(["msg" => "Error. No puede eliminar notificaciones de controles y chequeos", "result" => false]);
                return false;
            }
        } else {
            $this->setMsg(["msg" => "No ha seleccionado notificaciones", "result" => false]);
            return false;
        }
    }

    /**
     * Método que creará todas las notificaciones de controles y chequeos
     * @param type $idpaciente
     */
    public function createNotificacionesFromAddPaciente($idpaciente) {
        $hoy = date("Y-m-d");
        $paciente = $this->insertControlesChequeosPaciente($idpaciente, $hoy);
    }

    /**
     * Método que eliminará la notificación de la vacuna una vez que se modifique la vacuna
     * @param type $request
     */
    public function actualizarNotificacionesFromAddVacunaPaciente($idpaciente, $idvacuna_vacunaEdad) {

        $registro = $this->getXRelacion($idpaciente, $idvacuna_vacunaEdad);
        if ($registro) {
            //Tengo que eliminarlo...
            return parent::delete($registro[$this->id]);
        }
        return true;
    }

    /**
     * Método que agregará la notificación de la vacuna una vez que se modifique la vacuna
     * @param type $request
     */
    public function actualizarNotificacionesFromDeleteVacunaPaciente($request) {

        $hoy = date("Y-m-d");
        $paciente = $this->insertControlesChequeosPaciente($request["idpaciente"], $hoy);
    }

    public function marcarLeidoTodasNotificacionesControlesChequeo($request) {
        //desactivar

        $ManagerPaciente = $this->getManager("ManagerPaciente");
        //Paciente que se encuentra en el array de SESSION de header paciente
        $paciente = $ManagerPaciente->getPacienteXHeader();

        if ($paciente) {
            $idpaciente = $paciente["idpaciente"];
            $leido = isset($request["desactivar"]) && (int) $request["desactivar"] == 1 ? 1 : 0;

            $query_execute = "UPDATE $this->table 
                                SET leido=$leido
                                WHERE paciente_idpaciente = $idpaciente
                                    AND tipoNotificacion_idtipoNotificacion = 6";
            $rdo_execute = $this->db->Execute($query_execute);
            if ($rdo_execute) {
                $msg = (int) $request["desactivar"] == 1 ? "desactivaron" : "activaron";
                $this->setMsg(["msg" => "Se $msg todas las notificaciones", "result" => true]);
                return true;
            } else {
                $this->setMsg(["msg" => "Error. No se pudo realizar la operación solicitado.", "result" => false]);
                return false;
            }
        } else {
            $this->setMsg(["msg" => "Error. Inicie sesión nuevamente", "result" => false]);
            return false;
        }
    }

    /**
     * Método de creación de la notificación desde la cancelación del turno por parte del paciente
     * @param type $request
     * @return type
     */
    public function createNotificacionFromCancelacionTurnoPaciente($request) {
        $ManagerTurno = $this->getManager("ManagerTurno");
        //Busco el turno sobre el que creo la notificación
        $turno = $ManagerTurno->get($request["idturno"]);

        //obenemos la fecha del turno
        $calendar = new Calendar();
        $nombre_dia_turno = $calendar->getNameDayWeek($turno["fecha"], true);
        list($y, $m, $d) = preg_split("[-]", $turno["fecha"]);
        $nombre_corto_mes = $calendar->getMonthsShort((int) $m);
        $explode_hora_inicio = explode(":", $turno["horarioInicio"]);
        $fecha_turno = "$nombre_dia_turno $d $nombre_corto_mes " . $explode_hora_inicio[0] . ":" . $explode_hora_inicio[1] . "hs";

        //obtengo el paciente del turno
        $ManagerPaciente = $this->getManager("ManagerPaciente");
        $paciente = $ManagerPaciente->get($turno["paciente_idpaciente"]);


        //item_options con los datos del consultorios
        $consultorio = $this->getManager("ManagerConsultorio")->get($turno["consultorio_idconsultorio"]);
        $nombreConsultorio = $consultorio["nombreConsultorio"];

        if ($consultorio["is_virtual"] == 1) {
            $tipoVisita = "Vidéo Consultation";
            $direccionConsultorio = "";
            $icon = "dp-video";
        } else {
            $icon = "dp-branch";
            $tipoVisita = "Consultation Présentielle";
            $direccionConsultorio = $consultorio["direccion"] . " " . $consultorio["numero"];
        }

        $item_options = "<i class='{$icon}'></i><span>{$nombreConsultorio}<small class='address'>{$direccionConsultorio}</small> <small>{$tipoVisita}</small></span>";


        //Armamos la notificacion para el medico
        $array_insert = array(
            "medico_idmedico" => $turno["medico_idmedico"],
            "leido" => 0,
            "turno_idturno" => $request["idturno"],
            "titulo" => "Annulation du rendez-vous",
            "mensaje_cancelacion_turno" => $request["mensaje_cancelacion_turno"],
            "subtitulo" => "",
            "descripcion" => $fecha_turno,
            "estado_turno" => 2,
            "tipoNotificacion_idtipoNotificacion" => 3,
            "paciente_nombre" => "{$paciente["nombre"]} {$paciente["apellido"]}",
            "item_options" => $item_options
        );


        $rdo = $this->insert($array_insert);

        //Armamos la notificacion para el paciente
        //obtengo el medico del turno
        $ManagerMedico = $this->getManager("ManagerMedico");
        $medico = $ManagerMedico->get($turno["medico_idmedico"]);
        //obtengo las especialidades del medico
        $esp_array = $this->getManager("ManagerEspecialidadMedico")->getListadoVisualizacion($medico["idmedico"]);
        $especialidades = $esp_array["especialidad"] . $esp_array["subEspecialidades"];

        $array_insert_paciente = array(
            "paciente_idpaciente" => $turno["paciente_idpaciente"],
            "leido" => 0,
            "turno_idturno" => $request["idturno"],
            "titulo" => "Annulation du rendez-vous",
            "descripcion" => $fecha_turno,
            "estado_turno" => 2,
            "tipoNotificacion_idtipoNotificacion" => 3,
            "medico_nombre" => "{$medico["tituloprofesional"]} {$medico["nombre"]} {$medico["apellido"]}",
            "medico_especialidad" => $especialidades,
            "item_options" => $item_options
        );

        $rdo_paciente = $this->insert($array_insert_paciente);

        if ($rdo && $rdo_paciente) {
            //notify
            $client = new XSocketClient();
            $paciente = $this->getManager("ManagerPaciente")->get($turno["paciente_idpaciente"]);
            $notify["title"] = "{$paciente["nombre"]} {$paciente["apellido"]} - Notification";
            $notify["text"] = "Rendez-vous annulé";
            $notify["paciente_idpaciente"] = $turno["paciente_idpaciente"];
            $notify["style"] = "notificacion";
            $notify["type"] = "turno_cancelado_paciente";
            $client->emit('notify_php', $notify);
        }
        return $rdo;
    }

    /**
     * Método de creación de la notificación desde la cancelación del turno por parte del mmedico
     * @param type $idturno
     * @return type
     */
    public function createNotificacionFromCancelacionTurnoMedico($idturno) {

        $ManagerTurno = $this->getManager("ManagerTurno");
        //Busco el turno sobre el que creo la notificación
        $turno = $ManagerTurno->get($idturno);
        //obenemos la fecha del turno
        $calendar = new Calendar();
        $nombre_dia_turno = $calendar->getNameDayWeek($turno["fecha"], true);
        list($y, $m, $d) = preg_split("[-]", $turno["fecha"]);
        $nombre_corto_mes = $calendar->getMonthsShort((int) $m);
        $explode_hora_inicio = explode(":", $turno["horarioInicio"]);
        $fecha_turno = "$nombre_dia_turno $d $nombre_corto_mes " . $explode_hora_inicio[0] . ":" . $explode_hora_inicio[1] . "hs";

        //obtengo el medico del turno
        $ManagerMedico = $this->getManager("ManagerMedico");
        $medico = $ManagerMedico->get($turno["medico_idmedico"]);
        //obtengo las especialidades del medico
        $esp_array = $this->getManager("ManagerEspecialidadMedico")->getListadoVisualizacion($medico["idmedico"]);
        $especialidades = $esp_array["especialidad"] . $esp_array["subEspecialidades"];
        //item_options con los datos del consultorios
        $consultorio = $this->getManager("ManagerConsultorio")->get($turno["consultorio_idconsultorio"]);
        $nombreConsultorio = $consultorio["nombreConsultorio"];

        if ($consultorio["is_virtual"] == 1) {
            $tipoVisita = "Vidéo Consultation";
            $direccionConsultorio = "";
            $icon = "dp-video";
        } else {
            $icon = "dp-branch";
            $tipoVisita = "Consultation Présentielle";
            $direccionConsultorio = $consultorio["direccion"] . " " . $consultorio["numero"];
        }

        $item_options = "<i class='{$icon}'></i><span>{$nombreConsultorio}<small class='address'>{$direccionConsultorio}</small> <small>{$tipoVisita}</small></span>";


        //Armamos la notificacion
        $array_insert = array(
            "paciente_idpaciente" => $turno["paciente_idpaciente"],
            "leido" => 0,
            "turno_idturno" => $idturno,
            "titulo" => "Annulation du rendez-vous",
            "descripcion" => $fecha_turno,
            "estado_turno" => 2,
            "tipoNotificacion_idtipoNotificacion" => 3,
            "medico_nombre" => "{$medico["tituloprofesional"]} {$medico["nombre"]} {$medico["apellido"]}",
            "medico_especialidad" => $especialidades,
            "item_options" => $item_options
        );

        $rdo = $this->insert($array_insert);
        if ($rdo) {
            //notify
            $client = new XSocketClient();
            $paciente = $this->getManager("ManagerPaciente")->get($turno["paciente_idpaciente"]);
            $notify["title"] = "{$paciente["nombre"]} {$paciente["apellido"]} - Notification";
            $notify["text"] = "Rendez-vous annulé";
            $notify["paciente_idpaciente"] = $turno["paciente_idpaciente"];
            $notify["style"] = "notificacion";
            $notify["type"] = "notificacion";
            $client->emit('notify_php', $notify);
        }
        return $rdo;
    }

    /*     * Metodo que obtiene las notificaciones que no han sido alertadas mediante una notificacion emergente
     * Utilizado en el caso de las notificaciones de controles y chequeos que se generan por un cron a la noche para que el paciente
     * vea el alerta al conectarse
     */

    public function getAlertaNotificacionesEmergentes() {

        $idpaciente = $_SESSION[URL_ROOT]["paciente_p"]['logged_account']["paciente"]["idpaciente"];
        //obtenemos si hay notificaciones del titular
        $queryTitular = new AbstractSql();
        $queryTitular->setSelect("n.idnotificacion,n.paciente_idpaciente,pgf.nombre,pgf.apellido");
        $queryTitular->setFrom("notificacion n INNER JOIN pacientegrupofamiliar pgf ON (n.paciente_idpaciente=pgf.pacienteGrupo)");
        $queryTitular->setWhere("tipoNotificacion_idtipoNotificacion=6 and notify=0 and pgf.pacienteTitular=$idpaciente");
        $queryTitular->setGroupBy("n.paciente_idpaciente");

        //obtenemos si hay notificaciones de los familiares
        $queryFamiliares = new AbstractSql();
        $queryFamiliares->setSelect("n.idnotificacion,n.paciente_idpaciente,usw.nombre,usw.apellido");
        $queryFamiliares->setFrom("notificacion n
                                       inner join paciente p on (n.paciente_idpaciente=p.idpaciente)
                                        inner join usuarioweb usw on (usw.idusuarioweb=p.usuarioweb_idusuarioweb)");
        $queryFamiliares->setWhere("tipoNotificacion_idtipoNotificacion=6 and notify=0 and n.paciente_idpaciente=$idpaciente");
        $queryFamiliares->setGroupBy("n.paciente_idpaciente");

        $query = new AbstractSql();
        $query->setSelect("T.*");
        $query->setFrom("((" . $queryTitular->getSql() . ")UNION(" . $queryFamiliares->getSql() . ")) as T");

        $listado = $this->getList($query);
        if (count($listado) > 0) {
            //las marcamos como notificadas
            //las que corresponden al paciente titular
            $this->db->Execute("UPDATE notificacion SET notify=1 WHERE tipoNotificacion_idtipoNotificacion=6 and notify=0 and paciente_idpaciente=$idpaciente ");
            //las que corresponden a los familiares
            $this->db->Execute("UPDATE notificacion n INNER JOIN pacientegrupofamiliar pgf ON (n.paciente_idpaciente=pgf.pacienteGrupo) SET notify=1 WHERE tipoNotificacion_idtipoNotificacion=6 and notify=0 and pgf.pacienteTitular=1");
        }

        return $listado;
    }

    /*     * Metodo que obtiene las notificaciones emergentes que corresponden a alertas del sistema para el paciente
     * 
     */

    public function getNotificacionesEmergentesSistemaPaciente() {
        $alertas = [];
        $idpaciente = $_SESSION[URL_ROOT]["paciente_p"]['logged_account']["paciente"]["idpaciente"];
        $ManagerPaciente = $this->getManager("ManagerPaciente");
        $paciente = $ManagerPaciente->get($idpaciente);

//celular no validado
        if ($paciente["numeroCelular"] != "" && $paciente["celularValido"] == "0") {
            $notificacion["title"] = "{$paciente["nombre"]} {$paciente["apellido"]} - Info del sistema";
            $notificacion["text"] = "Vous n’avez pas encore validé votre portable.";
            $notificacion["style"] = "sistema";
            array_push($alertas, $notificacion);
        }
//cambio email no validado
        if ($paciente["cambioEmail"] != "") {
            $notificacion["title"] = "{$paciente["nombre"]} {$paciente["apellido"]} - Info del sistema";
            $notificacion["text"] = "Vous n’avez pas encore validé votre nouvel email.";
            $notificacion["style"] = "sistema";
            array_push($alertas, $notificacion);
        }
//saldo insuficiente
        $cuenta = $this->getManager("ManagerCuentaUsuario")->getByField("paciente_idpaciente", $idpaciente);
        if ((int) $cuenta["saldo"] <= 50) {
            $notificacion["title"] = "Veuillez créditer votre compte";
            $notificacion["text"] = "Solde insuffisant pour réaliser une nouvelle consultation.";
            $notificacion["style"] = "cuenta";
            // array_push($alertas, $notificacion);
        }
//perfil de salud incompleto
        $estado_titular = $ManagerPaciente->isPermitidoConsultaExpress($idpaciente);
        if ($estado_titular == 0) {
            $notificacion["title"] = "{$paciente["nombre"]} {$paciente["apellido"]} - Information";
            $notificacion["text"] = "Profil de Santé incomplet ! Vous n’êtes pas habilité pour réaliser des consultations à distance.";
            $notificacion["style"] = "sistema";
            array_push($alertas, $notificacion);
        }

        $list_familiares = $this->getManager("ManagerPacienteGrupoFamiliar")->getListFamiliares($idpaciente);
        if (count($list_familiares) > 0) {

            foreach ($list_familiares as $familiar) {
                $estado = $ManagerPaciente->isPermitidoConsultaExpress($familiar["pacienteGrupo"]);
                if ($estado == 0) {
                    $notificacion["title"] = "{$familiar["nombre"]} {$familiar["apellido"]} - Information";
                    $notificacion["text"] = "Profil de Santé incomplet ! Vous n’êtes pas habilité pour réaliser des consultations à distance.";
                    $notificacion["style"] = "sistema";
                    array_push($alertas, $notificacion);
                }
            }
        }

//controles y chequeos
        /* $controles = $this->getAlertaNotificacionesEmergentes();
          if (count($controles) > 0) {
          foreach ($controles as $paciente) {

          $notificacion["title"] = "{$paciente["nombre"]} {$paciente["apellido"]} - Notification";
          $notificacion["text"] = "Contrôles et vérifications";
          $notificacion["style"] = "notificacion";

          array_push($alertas, $notificacion);
          }
          } */


//  utf8_decode_ar($alertas);
//   print_r($alertas);
        return $alertas;
    }

    /*     * Metodo que obtiene las notificaciones emergentes que corresponden a alertas del sistema para el medico
     * 
     */

    public function getNotificacionesEmergentesSistemaMedico() {
        $alertas = [];
        $idmedico = $_SESSION[URL_ROOT]["paciente_p"]['logged_account']["paciente"]["idpaciente"];
        $medico = $this->getManager("ManagerMedico")->get($idmedico);

//celular no validado
        if ($medico["numeroCelular"] != "" && $medico["celularValido"] == "0") {
            $notificacion["title"] = "Info del sistema";
            $notificacion["text"] = "Vous n’avez pas encore validé votre portable";
            $notificacion["style"] = "sistema";
            array_push($alertas, $notificacion);
        }
//cambio email no validado
        if ($medico["cambioEmail"] != "") {
            $notificacion["title"] = "Info del sistema";
            $notificacion["text"] = "Vous n’avez pas encore validé votre nouvel email.";
            $notificacion["style"] = "sistema";
            array_push($alertas, $notificacion);
        }
        return $alertas;
    }

}

?>
