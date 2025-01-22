<?php

/**
 * 	@autor Xinergia
 * 	@version 1.0	04/12/2014
 * 	Manager de configuracion de agenda de un médico
 *
 */
class ManagerConfiguracionAgenda extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "configuracionagenda", "idconfiguracionAgenda");
    }

    /* Metodo que crea la configuracion de agenda de turnos, creando dicha entidad y los turnos en el rango de horarios seleccionado
     * se verifica que no exista otra configuracion donde se superongan los turnos en algun consultorio al mismmo tiempo
     * 
     * 	@author Xinergia <info@e-xinergia.com>
     *   @version 1.0
     */

    public function process($request) {

        $request["medico_idmedico"] = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];
        if ($_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["tipousuario"] == "medico") {
            //iteramos sobre todos los dias que se han marcado
            if (count($request["dias"]) == 0) {
                $this->setMsg(["result" => false, "msg" => "Seleccione al menos un día"]);
                return false;
            }

            $ManagerPreferencia = $this->getManager("ManagerPreferencia");
            $ManagerConsultorio = $this->getManager("ManagerConsultorio");
            $ManagerTurno = $this->getManager("ManagerTurno");

            $consultorio = $ManagerConsultorio->get($request["consultorio_idconsultorio"]);

            if ($consultorio["is_virtual"] == "1") {
                //Servicio de video llamada
                $request["servicio_medico_idservicio_medico"] = 2;
            } else {
                //fuerzo consulta presencial
                $request["servicio_medico_idservicio_medico"] = 3;
            }

            $preferencia = $ManagerPreferencia->getPreferenciaMedico($request["medico_idmedico"]);
            $request["duracionTurnos"] = $preferencia["duracionTurnos"];



            foreach ($request["dias"] as $dia) {

                $request["dia_iddia"] = $dia;


                $request["desde"] = $request["hora_desde"];
                $request["hasta"] = $request["hora_hasta"];

                list($hd, $md) = preg_split("[:]", $request["desde"]);

                list($hh, $mh) = preg_split("[:]", $request["hasta"]);

                // Obtenemos el día de la semana de la fecha dada 
                $timed = date("H:i", mktime($hd, $md, 0, 0, 0, 0));
                $timeh = date("H:i", mktime($hh, $mh, 0, 0, 0, 0));

                if (strtotime($timed) >= strtotime($timeh)) {
                    $this->setMsg(["result" => false, "msg" => "Error. El horario de comienzo es mayor al horario de finalización"]);
                    return false;
                }

                $is_exist_configuracion = $this->existConfiguracion($timed . ":00", $timeh . ":00", $request["dia_iddia"]);
                if ($is_exist_configuracion) {

                    //obtengo en que consultorio se encontro la configuracion
                    $consultorio_superposicion = $ManagerConsultorio->get($is_exist_configuracion["consultorio_idconsultorio"]);
                    $dia_str = getNombreDia($dia - 1);
                    $this->setMsg(["result" => false, "msg" => "Está superponiendo horarios de atención del día [[{$dia_str}]] en otro consultorio."]);
                    return false;
                }



                $this->db->StartTrans();

                $id = parent::process($request);

                if (!$id) {

                    $this->setMsg(["result" => false, "msg" => "Ha ocurrido un error, al guardar el horario, intente nuevamente"]);

                    $this->db->FailTrans();
                    $this->db->CompleteTrans();
                    return false;
                }

                //Genero los turnos del médico en base al horario configurado...

                $configuracion = $this->get($id);

                $result = $ManagerTurno->generateTurnosMedico($configuracion);

                if (!$result) {
                    $msg_turno = $ManagerTurno->getMsg();
                    $this->setMsg(["result" => false, "msg" => $msg_turno["msg"]]
                    );


                    $this->db->FailTrans();
                    $this->db->CompleteTrans();
                    return false;
                }


                $this->db->CompleteTrans();
            }

            // <-- LOG
            $log["data"] = "Add/delete medical practice information";
            $log["page"] = "Professional information";
            $log["action"] = "val"; //"val" "vis" "del"
            $log["purpose"] = "Update Medical practice";

            $ManagerLog = $this->getManager("ManagerLog");
            $ManagerLog->track($log);
            // 

            $this->setMsg(["result" => true, "msg" => "Horario creado con éxito"]
            );
            return true;
        } else {

            $this->setMsg(["result" => false, "msg" => "Error, acceso denegado"]);
            return false;
        }
    }

    /**
     * Retorna TRUE si existe una configuración de agenda ya cargada para ese consultorio y ese horario
     * @param type $timed
     * @param type $timeh
     * @param type $dia_iddia
     * @param type $consultorio_idconsultorio
     * @return boolean
     */
    public function existConfiguracion($timed, $timeh, $dia_iddia) {

        //Configuro los time para que entren  en el BETWEEN de la consulta y sea no inclusivo (Le sumo 1 min)
        list($hd, $md, $sd) = preg_split("[:]", $timed);
        $timed = date("H:i:s", mktime($hd, $md + 1, $sd, 0, 0, 0));
        list($hh, $mh, $sh) = preg_split("[:]", $timeh);
        $timeh = date("H:i:s", mktime($hh, $mh - 1, $sh, 0, 0, 0));

        $idmedico = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];


        $query = new AbstractSql();
        $query->setSelect("*");
        $query->setFrom("$this->table ca INNER JOIN consultorio c on (c.idconsultorio=ca.consultorio_idconsultorio) ");
        $query->setWhere("c.flag=1");
        $query->addAnd("dia_iddia = $dia_iddia");
        $query->addAnd("('$timed' BETWEEN desde AND hasta) OR ('$timeh' BETWEEN desde AND hasta) OR"
                . "( desde BETWEEN '$timed' AND '$timeh') OR (hasta BETWEEN '$timed' AND '$timeh' )");
        $query->addAnd("c.medico_idmedico = $idmedico");
        $query->addAnd("ca.medico_idmedico = $idmedico");
        $rdo = $this->db->Execute($query->getSql())->FetchRow();


        if ($rdo) {
            return $rdo;
        } else {
            return false;
        }
    }

    /*
     * 	@author Xinergia <info@e-xinergia.com>
     *   @version 1.0
     */

    public function update($request, $id) {

        $prev = $this->get($id);

        if ($prev["medico_idmedico"] == $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"]) {

            //validar solapamiento de horario
            $result = parent::update($request, $id);

            if ($result) {
                // <-- LOG
                $log["data"] = "Add/delete medical practice information";
                $log["page"] = "Professional information";
                $log["action"] = "val"; //"val" "vis" "del"
                $log["purpose"] = "Update Medical practice";

                $ManagerLog = $this->getManager("ManagerLog");
                $ManagerLog->track($log);
                // 

                $this->setMsg(["result" => $result, "msg" => "Horario actualizado con éxito"]);
                return true;
            } else {

                $this->setMsg(["result" => false, "msg" => "Error, acceso denegado"]);
                return false;
            }
        } else {

            $this->setMsg(["msg" => "Error, acceso denegado"]);
            return false;
        }
    }

    /**
     *  Delete
     * 
     * */
    public function delete($id) {

        $this->db->StartTrans();
        /**
         * Elimino las configuraciones de los turnos cuando se borran
         */
        $ManagerTurno = $this->getManager("ManagerTurno");
        $this->notificarElimancionConfiguracionAgenda($id);
        $result = $ManagerTurno->deleteTurnoXConfiguracionAgenda($id);

        $conf_agenda = $this->get($id);

        if ($conf_agenda["medico_idmedico"] == $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"] && $result) {


            $result2 = parent::delete($id);


            if ($result2) {
                $this->setMsg(["result" => $result2, "msg" => "Horario eliminado con éxito"]);

                // <-- LOG
                $log["data"] = "Add/delete medical practice information";
                $log["page"] = "Professional information";
                $log["action"] = "val"; //"val" "vis" "del"
                $log["purpose"] = "Update Medical practice";

                $ManagerLog = $this->getManager("ManagerLog");
                $ManagerLog->track($log);
                // 


                $this->db->CompleteTrans();
                return true;
            } else {

                $this->setMsg(["result" => false, "msg" => "Error, no se pudo eliminar el horario"]);

                $this->db->FailTrans();
                $this->db->CompleteTrans();
                return false;
            }
        } else {

            $this->setMsg(["result" => false, "msg" => "Error, acceso denegado"]);
            $this->db->FailTrans();
            $this->db->CompleteTrans();
            return false;
        }
    }

    /*     * Metodo que envia un sms, mail y notificacion a los pacientes que tienen un turno futuro que es eliminado
     * alertando la situacion
     * 
     */

    public function notificarElimancionConfiguracionAgenda($idconfiguracionagenda) {
        $fecha_actual = date("Y-m-d");
        $hora_actual = date("H:i:s");
        $idmedico = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];
        $query = new AbstractSql();
        $query->setSelect("t.idturno");
        $query->setFrom("turno t inner join configuracionagenda c on (t.configuracion_agenda_idconfiguracion_agenda=c.idconfiguracionAgenda)");
        $query->setWhere("t.configuracion_agenda_idconfiguracion_agenda=$idconfiguracionagenda AND c.medico_idmedico=$idmedico");

        $query->addAnd("t.paciente_idpaciente IS NOT NULL");
        $query->addAnd("t.estado=0 OR t.estado=1"); //tunros pendientes de confirmacion o confirmados
        $query->addAnd("(t.fecha>'$fecha_actual') OR (t.fecha='$fecha_actual' AND t.horarioInicio>='$hora_actual')");

        $turnos = $this->getList($query);
        if (COUNT($turnos) > 0) {
            $ManagerTurno = $this->getManager("ManagerTurno");
            $ManagerNotificacion = $this->getManager("ManagerNotificacion");
            foreach ($turnos as $record) {
                $record["estado"] = 2;
                $ManagerTurno->sendTurnoPacienteEmail($record);
                $ManagerTurno->sendTurnoPacienteSMS($record);
                $ManagerNotificacion->createNotificacionFromCambioEstadoTurno($record);
            }
        }
    }

    /**
     *  combo con horas para establecer los turnos de trabajo en la agenda
     *
     * */
    public function getComboHoras() {


        $horas = array();

        for ($i = 1; $i < 24; $i++) {

            if ($i < 10) {
                $hora = "0" . $i;
            } else {
                $hora = $i;
            }

            $horas[$hora] = $hora;
        }

        return $horas;
    }

    /**
     *  combo con minutos para establecer los turnos de trabajo en la agenda
     *  
     *  El incremento de los minutos depende de la duracion de turnos configurada
     *  para el medico                
     *
     * */
    public function getComboMinutos($idMedico) {


        $preferencia = $this->getManager("ManagerPreferencia")->getPreferenciaMedico($idMedico);

        if ($preferencia) {
            $inc = $preferencia["duracionTurnos"];
        } else {
            $inc = 30;
        }



        $minutos = array();

        for ($i = 0; $i < 60; $i += $inc) {

            if ($i < 10) {
                $min = "0" . $i;
            } else {
                $min = $i;
            }

            $minutos[$min] = $min;
        }

        return $minutos;
    }

    /**
     *  Obiene todos los horarios de un medico agrupado por dia
     *
     * */
    public function getTodosLosHorarios($medico_idmedico, $consultorio_idconsultorio = NULL) {


        $fecha_hoy = date("Y-m-d");
        $query = new AbstractSql();

        $query->setSelect("distinct conf.*,CONCAT(co.nombreConsultorio,'(',co.direccion,' ',co.numero,', ',co.localidad,', ', co.pais,')') AS consultorio, co.color");

        $query->setFrom("configuracionagenda conf 
              JOIN v_consultorio co ON (conf.consultorio_idconsultorio = co.idconsultorio), turno t

        ");

        $query->setWhere("conf.medico_idMedico = $medico_idmedico");
        if (!is_null($consultorio_idconsultorio)) {
            $query->addAnd("conf.consultorio_idconsultorio = $consultorio_idconsultorio");
            $query->addAnd("conf.consultorio_idconsultorio = t.consultorio_idconsultorio");
            $query->addAnd("conf.medico_idMedico = t.medico_idmedico");
            $query->addAnd("t.configuracion_agenda_idconfiguracion_agenda= conf.idconfiguracionAgenda");
            $query->addAnd(" ((fecha > '$fecha_hoy')
                            OR 
                            (fecha = '$fecha_hoy'))");
        }

        $query->setOrderBy("conf.dia_iddia ASC, conf.desde ASC");

        $horarios_temp = $this->getList($query, false);

        $horarios = array();

        foreach ($horarios_temp as $key => $horario) {
            $horarios[$horario["dia_iddia"]][] = $horario;
        }

        return $horarios;
    }

    /**
     *  Obiene todos los horarios de un medico agrupado por dia
     *
     * */
    public function getHorariosDia($dia_iddia, $idconsultorio) {

        $medico_idmedico = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];

        $query = new AbstractSql();

        $query->setSelect("conf.*,CONCAT(co.nombreConsultorio,'(',co.direccion,' ',co.numero,', ',co.localidad,', ', co.provincia,')') AS consultorio, co.color");

        $query->setFrom("configuracionagenda conf 
              JOIN v_consultorio co ON (conf.consultorio_idconsultorio = co.idconsultorio) 
            ");

        $query->setWhere("conf.medico_idMedico = $medico_idmedico AND conf.dia_iddia = $dia_iddia AND conf.consultorio_idconsultorio = $idconsultorio");

        $query->setOrderBy("conf.dia_iddia ASC, conf.desde ASC");

        return $this->getList($query, false);
    }

    /**
     *  Obiene todos los horarios de un medico agrupado por dia
     *
     * */
    public function getConfiguracionMedico($dia_iddia, $idmedico) {

        $medico_idmedico = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];

        if ($medico_idmedico != $idmedico) {
            return false;
        }

        $query = new AbstractSql();

        $query->setSelect("conf.*");

        $query->setFrom("configuracionagenda conf ");

        $query->setWhere("conf.medico_idmedico = $medico_idmedico AND conf.dia_iddia = $dia_iddia");

        $query->setOrderBy("conf.dia_iddia ASC, conf.desde ASC");

        return $this->getList($query, false);
    }

    /**
     * Método que retorna un listado con todas las configuraciones de agenda pertenecientes al médico
     * @param type $idmedico
     * @return type
     */
    public function getListAllConfiguracionAgenda($idmedico) {
        $query = new AbstractSql();

        $query->setSelect("conf.*");

        $query->setFrom("configuracionagenda conf ");

        $query->setWhere("conf.medico_idmedico = $idmedico");

        return $this->getList($query, false);
    }

    /**
     * Método que retorna un listado con todas las configuraciones de agenda pertenecientes al médico y a un determinado consultorio
     * @param type $idconsultorio
     * @return type
     */
    public function getListConfiguracionAgendaConsultorio($idconsultorio) {
        $query = new AbstractSql();

        $query->setSelect("conf.*");

        $query->setFrom("configuracionagenda conf ");

        $idmedico = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];

        $query->setWhere("conf.medico_idmedico = $idmedico");

        $query->addAnd("conf.consultorio_idconsultorio = $idconsultorio");

        return $this->getList($query, false);
    }

    /*     * Metodo que retorna un array con los intervalos de tiempo para los turnos
     * configurados con un salto de tiempo segun la duracion de turnos establecida
     * por el medico
     * 
     * @param type $idconsultorio
     * @return string
     */

    public function getComboHorarioMinutos($idmedico) {
        $horas = array();

        $preferencia = $this->getManager("ManagerPreferencia")->getPreferenciaMedico($idmedico);

        if ($preferencia) {
            $inc = $preferencia["duracionTurnos"];
        } else {
            $inc = 30;
        }



        $minutos = array();

        for ($i = 0; $i < 60; $i += $inc) {

            if ($i < 10) {
                $min = "0" . $i;
            } else {
                $min = $i;
            }

            $minutos[$min] = $min;
        }



        for ($i = 1; $i < 24; $i++) {

            foreach ($minutos as $key => $minuto) {
                if ($i < 10) {
                    $hora = "0" . $i . ":" . $minuto;
                } else {
                    $hora = $i . ":" . $minuto;
                }

                $horas[$hora] = $hora;
            }
        }


        return $horas;
    }

    /*     * Metodo que actualiza la preferencia del medico para el intervalo de creacion de turnos, y borra la configuracion anterior
     * 
     * 
     */

    public function modificar_intervalos_turno($request) {

        $idmedico = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];
        $listado = $this->getManager("ManagerConsultorio")->getListconsultorioMedico($idmedico);
        $preferencia = $this->getManager("ManagerPreferencia")->getPreferenciaMedico($idmedico);
        $this->db->StartTrans();
        $rdo = $this->getManager("ManagerPreferencia")->update(["duracionTurnos" => $request["duracionTurnos"]], $preferencia["idpreferencia"]);
        if (!$rdo) {
            $this->setMsg(["result" => false, "msg" => "Error, no se pudo actualizar la preferencia de horarios"]);
            $this->db->FailTrans();
            $this->db->CompleteTrans();

            return false;
        }
        $exito = true;

        if (COUNT($listado) > 0) {
            foreach ($listado as $consultorio) {
                $exito = $this->deleteHorariosConfiguracionAgenda(["idconsultorio" => $consultorio["idconsultorio"]]);
                if (!$exito) {
                    $exito = false;
                }
            }
        }

        if (!$exito) {
            $this->setMsg(["result" => false, "msg" => "Error, no se pudo actualizar la configuración de horarios de turno en el consultorio"]);
            $this->db->FailTrans();
            $this->db->CompleteTrans();

            return false;
        } else {
            $this->setMsg(["result" => true, "msg" => "Se ha actualizado con éxito su configuración de horarios de turnos de consultorios"]);

            // <-- LOG
            $log["data"] = "Add/delete medical practice information";
            $log["page"] = "Professional information";
            $log["action"] = "val"; //"val" "vis" "del"
            $log["purpose"] = "Update Medical practice";

            $ManagerLog = $this->getManager("ManagerLog");
            $ManagerLog->track($log);
            // 

            $this->db->CompleteTrans();



            return true;
        }
    }

    /**
     * Eliminación de los horarios de la configuración de agenda
     * @param type $request
     */
    public function deleteHorariosConfiguracionAgenda($request) {
        $idconsultorio = $request["idconsultorio"];



        //Si el listado del consultorio agenda existe y hay 
        //Abro una transacción global
        $this->db->StartTrans();

        //Si sale del foreach, tengo que actualizar los valores en la tabla consultorio
        $ManagerConsultorio = $this->getManager("ManagerConsultorio");
        $consultorio = $ManagerConsultorio->get($request["idconsultorio"]);
        if ($consultorio && (int) $request["duracionTurnos"] != (int) $consultorio["durarionTurnos"]) {
            //Realizo la modificación
            $update = $ManagerConsultorio->update(["duracionTurnos" => (int) $request["duracionTurnos"]], $idconsultorio);
            if (!$update) {
                $this->setMsg(["result" => false, "msg" => "Error, no se pudo actualizar la configuración de horarios de turno en el consultorio"]);

                $this->db->FailTrans();
                $this->db->CompleteTrans();
                return false;
            }
        }

        //Busco las configuraciones de agenda de u
        $listado_consultorio_agenda = $this->getListConfiguracionAgendaConsultorio($idconsultorio);

        if ($listado_consultorio_agenda && count($listado_consultorio_agenda) > 0) {
            foreach ($listado_consultorio_agenda as $key => $configuracion_agenda) {
                $delete = $this->delete($configuracion_agenda[$this->id]);
                if (!$delete) {
                    $this->setMsg(["result" => false, "msg" => "Error, No se pudo eliminar una configuración de agenda. No se cambió el horario de la configuración de agenda"]);

                    $this->db->FailTrans();
                    $this->db->CompleteTrans();
                    return false;
                }
            }
        }

        //REtorno true si la configuración de horarios pudo actualizarse
        $this->setMsg(["result" => true, "msg" => "Los horarios de la configuración de agenda ha sido actualizados"]);

        $this->db->CompleteTrans();
        return $idconsultorio;
    }

    /**
     * Método utilizado para generar automaticamente los turnos y las configuraciones de agenda a los médicos que se cargan de manera manual
     * SOLAMENTE PARA CARGA MANUAL
     */
    public function generateTurnosConfiguracionAgenda() {

        //Obtengo los médicos y sus consultorios, de manera que se puedan crear las configuraciones de agenda y los horarios
        $query = new AbstractSql();

        $query->setSelect("*");

        $query->setFrom("medico m INNER JOIN consultorio c ON (m.idmedico = c.medico_idmedico)");

        $query->setWhere("m.estado = 1");

        $query->addAnd("c.flag = 1");

        $query->addAnd("c.is_virtual = 0");

        $query->addAnd("m.idmedico NOT IN (SELECT medico_idmedico FROM configuracionagenda)");

        $listado = $this->getList($query);

        $array_generacion_horarios = array(
            1 => array(["desde" => "08:00", "hasta" => "10:00"], ["desde" => "16:00", "hasta" => "20:00"]),
            2 => array(["desde" => "09:00", "hasta" => "12:30"], ["desde" => "16:00", "hasta" => "19:00"]),
            3 => array(["desde" => "06:30", "hasta" => "14:00"], ["desde" => "15:00", "hasta" => "17:30"]),
            4 => array(["desde" => "08:00", "hasta" => "10:00"], ["desde" => "16:00", "hasta" => "20:00"]),
            5 => array(["desde" => "08:00", "hasta" => "10:00"], ["desde" => "16:00", "hasta" => "20:00"]),
            6 => array(["desde" => "08:00", "hasta" => "10:00"], ["desde" => "16:00", "hasta" => "20:00"]),
        );

        if ($listado && count($listado) > 0) {
            $ManagerTurno = $this->getManager("ManagerTurno");
            foreach ($listado as $key => $value) {

                for ($i = 1; $i <= 6; $i++) {
                    foreach ($array_generacion_horarios[$i] as $key1 => $horario) {


                        $request["desde"] = $horario["desde"];
                        $request["hasta"] = $horario["hasta"];
                        $request["consultorio_idconsultorio"] = $value["idconsultorio"];
                        $request["dia_iddia"] = $i;
                        $request["medico_idmedico"] = $value["idmedico"];
                        $request["duracionTurnos"] = $value["duracionTurnos"];
//                          $this->print_r($request);

                        list($hd, $md) = preg_split("[:]", $horario["desde"]);

                        list($hh, $mh) = preg_split("[:]", $horario["hasta"]);

                        // Obtenemos el día de la semana de la fecha dada 
                        $timed = date("H:i", mktime($hd, $md, 0, 0, 0, 0));
                        $timeh = date("H:i", mktime($hh, $mh, 0, 0, 0, 0));


                        $is_exist_configuracion = $this->existConfiguracion($timed . ":00", $timeh . ":00", $request["dia_iddia"], $request["consultorio_idconsultorio"]);
                        if (!$is_exist_configuracion) {

                            //fuerzo consulta presencial
                            $request["servicio_medico_idservicio_medico"] = 3;

                            $this->db->StartTrans();

                            $id = parent::insert($request);

                            if (!$id) {

                                $this->db->FailTrans();
                                $this->db->CompleteTrans();
                            } else {
                                //Genero los turnos del médico en base al horario configurado...

                                $configuracion = $this->get($id);

                                $result = $ManagerTurno->generateTurnosMedico($configuracion, $request["medico_idmedico"]);

                                if (!$result) {
                                    $this->db->FailTrans();
                                    $this->db->CompleteTrans();
                                } else {

                                    //Finalizó correctamente la configuración de la agenda
                                    $this->db->CompleteTrans();
                                }
                            }
                        }
                    }
                }
            }
        }
    }

}

//END_class
?>