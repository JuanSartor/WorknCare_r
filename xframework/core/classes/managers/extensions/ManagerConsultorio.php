<?php

/**
 * 	Manager de Consultorios pertenecientes a los médicos
 *
 * 	@author Xinergia Web
 * 	@version 1.0
 * 	@package managers\extensions
 */
class ManagerConsultorio extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Constructor
        parent::__construct($db, "consultorio", "idconsultorio", "flag");
    }

    public function get($id) {


        $consultorio = parent::get($id);

        if ($consultorio && $consultorio["direccion_iddireccion"] != "") {

            $direccion = $this->getManager("ManagerDireccion")->get($consultorio["direccion_iddireccion"]);

            $consultorio = array_merge($consultorio, $direccion);
        }

        return $consultorio;
    }

    /**
     * Procesamiento del consultorio virtual, es igual al consultorio común con la diferencia de que no tiene dirección
     * @param type $request
     * @return boolean
     */
    public function processVirtual($request = []) {

        $idmedico = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];

        $request["medico_idmedico"] = $idmedico;
        $request["is_virtual"] = 1;
        $request["nombreConsultorio"] = "Cabinet Virtuel";


        $consultorio_virutal = $this->getByFieldArray(["medico_idmedico", "is_virtual"], [$request["medico_idmedico"], 1]);

        if ($consultorio_virutal) {

            $rdo = parent::update(["flag" => 1], $consultorio_virutal["idconsultorio"]);
        } else {
            $rdo = parent::insert($request);
        }

        if ($rdo) {

            //Verificamos si completó los datos minimos requeridos 
            $ManagerMedico = $this->getManager("ManagerMedico");
            $info_medico = $ManagerMedico->getInfoMenuMedico();
            $showModal = false;

          // Hacemos la consulta: Si tiene tarifas y seteo la direccion, luego de agregar consultorio está completo
            if ($info_medico["medico"]["preferencia"]["valorPinesVideoConsultaTurno"] != "" &&
                    $info_medico["medico"]["direccion_iddireccion"] != "") { //tiene direccion seteada
                // En este caso forzamos a mostrar el modal.
                $showModal = true;
            }
            // -->
            $this->setMsg(["msg" => "Se dió de alta el consultorio virtual", "result" => true, "id" => $rdo, "showModal" => $showModal
            ]);
            return $rdo;
        } else {
            $this->setMsg(["msg" => "Error. No se pudo crear el consultorio virtual, verifique los datos ingresados", "result" => false
            ]);
            return false;
        }
    }

    /**
     * Procesamiento de los consultorioFísicos pertenecientes a un médico
     * @param type $request
     * @return boolean
     */
    public function process($request) {

        //Obtengo el id del médico que se encuentra actualmente logueado.
        $idmedico = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];
        $request["medico_idmedico"] = $idmedico;

        //Controlo que el médico no tengo más de dos consultorios a la hora de dar dee alta un consultorio
        $cantidad_consultorios = $this->getCantidadConsultorios($idmedico, true);
        if ($cantidad_consultorios > 0) {
            $this->setMsg(array("result" => false, "msg" => "No se pueden crear más de dos consultorios físicos"));
            return false;
        }

        //Obtengo la dirección del médico
        $medico = $this->getManager("ManagerMedico")->get($idmedico);
        if ($medico["direccion_iddireccion"] > 0) {
            $direccion = $ManagerDireccion = $this->getManager("ManagerDireccion")->get($medico["direccion_iddireccion"]);
            $request["direccion_iddireccion"] = $medico["direccion_iddireccion"];
        } else {
            $this->setMsg(["result" => false, "msg" => "Agregue la dirección de su consultorio u hospital"]);
            return false;
        }

        $preferencia = $this->getManager("ManagerPreferencia")->getPreferenciaMedico($idmedico);
        $request["duracionTurnos"] = $preferencia["duracionTurnos"];

        //limpiamos el telefono del formato del plugin
        $request["telefono"] = str_replace(" ", "", $direccion["telefono"]);
        $request["telefono"] = str_replace("-", "", $request["telefono"]);
        $request["principal"] = 1;
        $request["nombreConsultorio"] = "Cabinet présentiel";
        $id_consultorio = parent::process($request);
        if ($id_consultorio > 0) {
            $this->setConsultorioPorDefecto($id_consultorio);

            //si se cambio la direccion del consultorio alertamos a los pacientes que tenian turnos
            //  if ($request["cambio_direccion"] == "1") {
            //$this->notificarCambioDireccionConsultorio($id_consultorio);
            // }

            if (isset($request["idconsultorio"]) && (int) $request["idconsultorio"] > 0) {

                $this->setMsg(["result" => true, "msg" => "El consultorio ha sido actualizado con éxito", "id" => $id_consultorio]);
            } else {

                $this->setMsg(["result" => true, "msg" => "El consultorio ha sido creado con éxito", "id" => $id_consultorio]);
            }
            // <-- LOG
            $log["data"] = "Add/delete medical practice information";
            $log["page"] = "Professional information";
            $log["action"] = "val"; //"val" "vis" "del"
            $log["purpose"] = "Update Medical practice";

            $ManagerLog = $this->getManager("ManagerLog");
            $ManagerLog->track($log);
            return true;
        } else {
            $this->setMsg(["result" => false, "msg" => "Se ha producido un error al crear el consultorio"]);
            return false;
        }
    }

    /**
     * Retorno de un listado de consultorios médicos, pertenecientes al médico que se encuentra sesión
     * @return type
     */
    public function getListconsultorioMedico($idmedico = NULL, $fisicos = false) {

        if (CONTROLLER == "medico") {

            if (is_null($idmedico)) {
                $idmedico = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];
            }
        } elseif (is_null($idmedico)) {
            return false;
        }


        $query = new AbstractSql();

        $query->setSelect("c.*, d.*, l.localidad, p.pais");

        $query->setFrom("$this->table c "
                . "LEFT JOIN direccion d ON (c.direccion_iddireccion = d.iddireccion) "
                . "LEFT JOIN pais p ON (d.pais_idpais = p.idpais) "
                . "LEFT JOIN localidad l ON (d.localidad_idlocalidad = l.idlocalidad)");

        $query->setWhere("c.medico_idmedico = $idmedico");
        $query->addAnd("c.$this->flag = 1");

        if ($fisicos) {
            $query->addAnd("c.is_virtual = 0");
        }

        $query->setOrderBy("c.is_virtual DESC, c.nombreConsultorio ASC");
        $listado = $this->getList($query);

        return $listado;
    }

    /**
     * Combo de consultorios de un medico
     *
     *
     * */
    public function getComboMisConsultorios() {

        $idmedico = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];

        $query = new AbstractSql();

        $query->setSelect("c.idconsultorio, CONCAT(c.direccion,' ',c.numero,', ',c.localidad,', ', c.pais)");

        $query->setFrom("v_consultorio c");

        $query->setWhere("c.medico_idmedico = $idmedico");
        $query->addAnd("c.$this->flag = 1");

        $query->setOrderBy("c.nombreConsultorio");

        return $this->getComboBox($query, false);
    }

    /*     * Metodo que retorna las coordenadas e informacion de los consultorios y los medico para listar los puntero de google maps
     * 
     * @param type $ids_consultorios
     * @return type
     */

    public function getListConsultorioToGoogleMap($ids_consultorios) {

        $query = new AbstractSql();

        $query->setSelect("c.idconsultorio,c.nombreConsultorio,c.direccion,c.numero,c.localidad,c.pais,m.idmedico, c.lat, c.telefonos,c.lng,uw.nombre, uw.apellido, CONCAT(tp.titulo_profesional,' ',uw.nombre, ' ', uw.apellido ) as name");

        $query->setFrom("v_consultorio c "
                . "INNER JOIN medico m ON (c.medico_idmedico = m.idmedico)"
                . "INNER JOIN usuarioweb uw ON (uw.idusuarioweb = m.usuarioweb_idusuarioweb) "
                . "LEFT JOIN titulo_profesional tp ON (tp.idtitulo_profesional=m.titulo_profesional_idtitulo_profesional)");

        $query->setWhere("c.idconsultorio IN ($ids_consultorios)");
        $query->addAnd("c.$this->flag = 1");
        $query->addAnd("c.is_virtual=0");

        $idlocalidad = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']['busqueda_profesionales']['idlocalidad'];
        if ($idlocalidad != "") {
            $query->addAnd("c.localidad_idlocalidad=$idlocalidad");
        }

        $rdo = $this->getList($query);


        $ManagerEspecialidadMedico = $this->getManager("ManagerEspecialidadMedico");
        $ManagerMedico = $this->getManager("ManagerMedico");
        $ManagerPreferencia = $this->getManager("ManagerPreferencia");
        $ManagerMedicoMisPacientes = $this->getManager("ManagerMedicoMisPacientes");
        //Paciente que se encuentra en el array de SESSION de header paciente
        if (CONTROLLER == "paciente_p") {
            $ManagerPaciente = $this->getManager("ManagerPaciente");
            $paciente = $ManagerPaciente->getPacienteXHeader();
        }
        foreach ($rdo as $key => $medico) {
            $rdo[$key]["especialidad"] = $ManagerEspecialidadMedico->getEspecialidadesMedico($medico["idmedico"])[0]["especialidad"];
            $rdo[$key]["imagen"] = $ManagerMedico->getImagenMedico($medico["idmedico"]);

            $preferencia = $ManagerPreferencia->getPreferenciaMedico($medico["idmedico"]);
            //verificamos si el paciente es sin cargo
            if (CONTROLLER == "paciente_p") {
                //verificamos si el paciente es sin cargo
                if ($ManagerMedicoMisPacientes->is_paciente_sin_cargo($paciente["idpaciente"], $medico["idmedico"])) {
                    $rdo[$key]["valorPinesConsultaExpress"] = 0;
                } else {
                    $rdo[$key]["valorPinesConsultaExpress"] = $preferencia["valorPinesConsultaExpress"];
                }
            } else {
                $rdo[$key]["valorPinesConsultaExpress"] = $preferencia["valorPinesConsultaExpress"];
            }
            $rdo[$key]["valorPinesVideoConsulta"] = $preferencia["valorPinesVideoConsulta"];

            $str_name = $rdo[$key]["idmedico"] . "-" . $rdo[$key]["nombre"] . "-" . $rdo[$key]["apellido"];
            $rdo[$key]["seo"] = str2seo($str_name);
        }
        return $rdo;
    }

    /**
     *  Obtiene el consultorio por defecto
     *  Sin o existe un consultorio por defecto, trae el primero que encuentre o falso si no hay consultorio
     *
     * */
    public function getConsultorioPorDefecto($idmedico) {


        $consultorio = $this
                        ->db
                        ->Execute("
                                SELECT v.*
                                FROM  v_consultorio v
                                WHERE v.medico_idmedico = $idmedico
                                    AND v.$this->flag = 1
                                        
                                ORDER BY v.is_virtual DESC,v.principal DESC
                                LIMIT 0,1
                            ")->FetchRow();

        return $consultorio;
    }

    /**
     *  El consultorio ya esta marcado como por defecto, quita la marca de los demas
     *  
     *
     * */
    private function setConsultorioPorDefecto($idconsultorio) {

        $consultorio = $this->get($idconsultorio);

        $idmedico = $consultorio["medico_idmedico"];

        $this
                ->db
                ->Execute("
                    UPDATE consultorio c
                    SET c.principal = 0
                    WHERE c.medico_idmedico = $idmedico AND c.$this->flag = 1 AND c.idconsultorio <> $idconsultorio  
                ");
    }

    private function getNewColorConsultorio($idmedico) {
        $array_color = array(1, 2, 3, 4, 5);

        $query = new AbstractSql();

        $query->setSelect("color");

        $query->setFrom("consultorio");

        $query->setWhere("medico_idmedico = $idmedico");

        $query->addAnd("flag = 1");

        $query->addAnd("color IN (1,2,3,4,5)");

        $listado = $this->getList($query);

        if ($listado && count($listado) > 0) {
            foreach ($array_color as $key => $value) {
                //Si el value no está en el array_color
                $bandera = 0;
                foreach ($listado as $key1 => $color) {
                    if ((int) $color == (int) $value) {
                        $bandera++;
                    }
                }

                if ($bandera == 0) {
                    return $value;
                }
            }
        }

        return 1;
    }

    /**
     * Método que retorna la cantidad de consultorios pertenecientes a un médico
     * @param type $idmedico
     * @param type $fisicos : Si los consultorios que se solicitan son físicos o no
     * @return int
     */
    public function getCantidadConsultorios($idmedico = null, $fisicos = false) {
        if (is_null($idmedico)) {
            $idmedico = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];
        }

        $query = new AbstractSql();
        $query->setSelect("COUNT($this->id) as cantidad_consultorios");
        $query->setFrom("$this->table");
        $query->setWhere("medico_idmedico = $idmedico");

        if ($fisicos) {
            $query->addAnd("is_virtual = 0");
        }

        $query->addAnd("$this->flag = 1");

        $execute = $this->db->Execute($query->getSql());
        if ($execute) {
            $rdo = $execute->FetchRow();
            if ($rdo) {
                return (int) $rdo["cantidad_consultorios"];
            } else {
                return 0;
            }
        } else {
            return 0;
        }
    }

    /**
     * Método que obtiene el consultorio virtual perteneciente a un médico determinado
     * @param type $idmedico
     * @return boolean
     */
    public function getConsultorioVirtual($idmedico = null) {

        if (is_null($idmedico)) {
            $idmedico = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];
        }

        $query = new AbstractSql();

        $query->setSelect("*");

        $query->setFrom("$this->table");

        $query->setWhere("medico_idmedico = $idmedico");

        $query->addAnd("is_virtual = 1");

        $query->addAnd("$this->flag = 1");

        $execute = $this->db->Execute($query->getSql());
        if ($execute) {
            return $execute->FetchRow();
        } else {
            return false;
        }
    }

    /**
     * Método que retorna la información de los turnos agrupados por consultorios para una fecha o periodo de tiempo dado
     * @param type $fecha a partir de cuando se calcula el rango de turnos
     * @param type $tipo 1:diaria, 2:semanal, 3:mensual
     * @return type
     */
    public function getDatosTurnosXConsultorio($fecha, $tipo = 1) {

        $idmedico = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];

        if (is_null($fecha)) {
            $fecha = $this->sqlDate(date("d/m/Y"));
        }

        $query = new AbstractSql();
        $query->setSelect("c.idconsultorio,c.nombreConsultorio,c.is_virtual,t.paciente_idpaciente, t.estado");
        $query->setFrom("$this->table c INNER JOIN turno t ON (c.idconsultorio = t.consultorio_idconsultorio)");

        $query->setWhere("c.medico_idmedico = $idmedico");

        $query->addAnd("c.$this->flag = 1");
        //filtramos el rango de fechas segun se quiere obtener la canidad diaria, semanal, mensual
        //diaria
        if ($tipo == 1) {

            $fecha = $this->sqlDate($fecha);
            $query->addAnd("t.fecha = '$fecha'");
        } elseif ($tipo == 2) {
            //semanal
            list($d, $m, $y) = preg_split("[/]", $fecha);
            $fecha_inicio_semana = date('Y-m-d', strtotime('previous Monday', mktime(0, 0, 0, $m, $d, $y)));
            $fecha_fin_semana = date('Y-m-d', strtotime('Sunday', mktime(0, 0, 0, $m, $d, $y)));
            $query->addAnd("(t.fecha BETWEEN '$fecha_inicio_semana' AND '$fecha_fin_semana')");
        } else {
            //mensual
            list($d, $m, $y) = preg_split("[/]", $fecha);
            $fecha_test = date("Y-m-d", mktime(0, 0, 0, $m, 1, $y));
            $fecha_test_fin = date("Y-m-d", strtotime("- 1 day", mktime(0, 0, 0, $m + 1, 1, $y)));

            $query->addAnd("t.fecha BETWEEN '$fecha_test' AND '$fecha_test_fin'");
        }

        $query->setGroupBy("t.fecha,t.horarioInicio");
        $query2 = new AbstractSql();
        $query2->setSelect("T.idconsultorio,
                                T.nombreConsultorio,
                                SUM(IF(T.paciente_idpaciente IS NOT NULL AND T.estado = 1, 1, 0)) as turnos_confirmados,
                                SUM(IF(T.paciente_idpaciente IS NOT NULL AND T.estado = 2, 1, 0)) as turnos_cancelados,
                                SUM(IF(T.paciente_idpaciente IS NOT NULL AND T.estado = 0, 1, 0)) as turnos_pendientes,
                                SUM(IF(T.paciente_idpaciente IS NOT NULL AND T.estado = 5, 1, 0)) as turnos_ausentes,
                                SUM(IF(T.paciente_idpaciente IS NOT NULL AND T.estado = 3, 1, 0)) as turnos_declinados,
                                SUM(IF(T.paciente_idpaciente IS NULL, 1, 0)) as turnos_disponibles");
        $query2->setFrom("(" . $query->getSql() . ") as T");
        $query2->setGroupBy("T.$this->id");
        $listado = $this->getList($query2);

        return $listado;
    }

    /**
     * Eliminación de los consultorios, debe eliminar las configuraciones de las agendas
     * @param type $request
     */
    public function deleteConsultorioFromMedico($request) {

        //Para borrar el consultorio debo borrar toda la configuración de agenda, 
        //Tmb debo mandar notificación a cada uno de los pacientes
        $this->db->StartTrans();

        $idconsultorio = $request["id"];
        $consultorio = parent::get($idconsultorio);

        //si el consultorio a eliminar es virtual, quitamos tambien las tarifas de VC
        if ($consultorio["is_virtual"] == 1) {
            $medico = $this->getManager("ManagerMedico")->get($consultorio["medico_idmedico"]);
            $ManagerPreferencia = $this->getManager("ManagerPreferencia");
            $preferencia = $ManagerPreferencia->get($medico["preferencia_idPreferencia"]);
            $upd_preferencia = $ManagerPreferencia->update(["valorPinesVideoConsultaTurno" => "", "valorPinesVideoConsulta" => ""], $preferencia["idpreferencia"]);
            if (!$upd_preferencia) {
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                $this->setMsg(["msg" => "Error. No se ha podido eliminar el consultorio", "result" => false]);
                return false;
            }
        }


        //alertamos a los pacientes con turnos en ese consultorio la cancelacion del turno
        $ManagerConfiguracionAgenda = $this->getManager("ManagerConfiguracionAgenda");
        $delete_configuracion_agenda = $ManagerConfiguracionAgenda->deleteHorariosConfiguracionAgenda(["idconsultorio" => $idconsultorio]);


        //Elimino el consultorio logicamente.
        $delete = parent::delete($idconsultorio);

        if ($delete && $delete_configuracion_agenda) {
            $this->db->CompleteTrans();
            $this->setMsg(["msg" => "El consultorio fue eliminado con éxito", "result" => true]);
            return true;
        } else {
            $this->db->FailTrans();
            $this->db->CompleteTrans();
            $this->setMsg(["msg" => "Error. No se ha podido eliminar el consultorio", "result" => false]);
            return false;
        }
    }

    /**
     * Método que retorna el listado de consultorios de un médico que no sea el consultorio pasado como parámetro
     * Utilizado para la búsque de profesionales por parte del paciente
     * @param type $idmedico
     * @param type $idconsultorio
     * @return type
     */
    public function getOtherConsultoriosMedico($idmedico, $idconsultorio) {

        $query = new AbstractSql();

        $query->setSelect("*");

        $query->setFrom("v_consultorio");

        $query->setWhere("medico_idmedico = {$idmedico} ");

        $query->addAnd("flag = 1");

        $query->addAnd("idconsultorio <> {$idconsultorio}");

        $rdo = $this->getList($query);

        //verificamos si el medico solo ofrece videoconsultas a sus pacientes y es frecuente
        //Seteamos en el nombre de consultorio como disponible solo para sus pacientes
        $preferencia = $this->getManager("ManagerPreferencia")->getPreferenciaMedico($idmedico);
        if ($preferencia["pacientesVideoConsulta"] == "2") {
            $paciente = $this->getManager("ManagerPaciente")->getPacienteXHeader();
            $frecuente = $this->getManager("ManagerProfesionalesFrecuentesPacientes")->isFrecuente($idmedico, $paciente["idpaciente"]);

            if (!$frecuente) {
                foreach ($rdo as $key => $consultorio) {
                    if ($consultorio["is_virtual"] == "1") {
                        $text = "Consultorio Virtual - Disponible solo para sus pacientes frecuentes";
                        $rdo[$key]["nombreConsultorio"] = $text;
                    }
                }
            }
        }


        return $rdo;
    }

    /*     * Metodo que envia un sms y mail a los pacientes que tienen un turno futuro para un consultorio que es eliminado
     * alertando la situacion
     * 
     */

    public function notificarElimancionConsultorio($idconsultorio) {
        $fecha_actual = date("Y-m-d");
        $hora_actual = date("H:i:s");
        $idmedico = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];
        $query = new AbstractSql();
        $query->setSelect("t.idturno,t.fecha,t.horarioInicio,
                t.paciente_idpaciente as idpaciente,
                t.consultorio_idconsultorio as idconsultorio,
                c.medico_idmedico as idmedico");
        $query->setFrom("turno t inner join consultorio c on (t.consultorio_idconsultorio=c.idconsultorio)");
        $query->setWhere("c.medico_idmedico=$idmedico and c.idconsultorio=$idconsultorio");
        $query->addAnd("t.paciente_idpaciente IS NOT NULL");
        $query->addAnd("t.estado=0 OR t.estado=1"); //tunros pendientes de confirmacion o confirmados
        $query->addAnd("(t.fecha>'$fecha_actual') OR (t.fecha='$fecha_actual' AND t.horarioInicio>='$hora_actual')");

        $turnos = $this->getList($query);
        if (COUNT($turnos) > 0) {
            foreach ($turnos as $turno) {
                $this->enviarMailEliminacionConsultorio($turno);
                $this->enviarSMSEliminacionConsultorio($turno);
            }
        }
    }

    /*     * Metodo que envia un mensaje via email a paciente cuando se elimina un consultorio y tenia un turno futuro en este
     * 
     * @param type $turno
     */

    public function enviarMailEliminacionConsultorio($turno) {

        $consultorio = $this->getManager("ManagerConsultorio")->get($turno["idconsultorio"]);
        $ManagerPaciente = $this->getManager("ManagerPaciente");
        $paciente = $ManagerPaciente->get($turno["idpaciente"]);
        $ManagerMedico = $this->getManager("ManagerMedico");
        $medico = $ManagerMedico->get($turno["idmedico"], true);
        $medico["imagen"] = $ManagerMedico->getImagenMedico($medico["idmedico"]);
        //Si el email es vació puede ser que sea un miembro del grupo familiar
        if ($paciente["email"] == "") {
            $paciente_titular = $ManagerPaciente->getPacienteTitular($turno["idpaciente"]);
        }

        if ($paciente["email"] == "" && $paciente_titular["email"] == "") {
            $this->setMsg(["msg" => "Error al recuperar email del paciente ", "result" => false]);
            return false;
        }


        //envio de la mensaje por mail

        $smarty = SmartySingleton::getInstance();

        $smarty->assign("paciente", $paciente);
        $smarty->assign("medico", $medico);
        $smarty->assign("consultorio", $consultorio);
        $turno["fecha_str"] = fechaToString($turno["fecha"] . " " . $turno["horarioInicio"], 1);
        $smarty->assign("turno", $turno);



        $mEmail = $this->getManager("ManagerMail");

        if ($medico["sexo"] == "1") {
            $sexo = "Mr";
        } else {
            $sexo = "Mme";
        }
        $subject = "WorknCare | Lé {$medico["tituloprofesional"]} {$medico["nombre"]} {$medico["apellido"]} a éliminé son cabinets '{$consultorio["nombreConsultorio"]}' ";
        $mEmail->setSubject($subject);
        $mEmail->setBody($smarty->Fetch("email/mensaje_eliminacion_consultorio_paciente.tpl"));
        $email = $paciente["email"] == "" ? $paciente_titular["email"] : $paciente["email"];
        $mEmail->addTo($email);



        if ($mEmail->send()) {
            $this->setMsg(["msg" => "Mensaje enviado con éxito", "result" => true]);
            return true;
        } else {
            $this->setMsg(["msg" => "No se ha podido enviar el mensaje. Inténtelo más tarde", "result" => false]);
            return false;
        }
    }

    /** Metodo que envia un mensaje via sms a paciente cuando se elimina un consultorio y tenia un turno futuro en este
     * @return boolean
     */
    public function enviarSMSEliminacionConsultorio($turno) {

        $consultorio = $this->getManager("ManagerConsultorio")->get($turno["idconsultorio"]);
        $ManagerPaciente = $this->getManager("ManagerPaciente");
        $paciente = $ManagerPaciente->get($turno["idpaciente"]);
        $ManagerMedico = $this->getManager("ManagerMedico");
        $medico = $ManagerMedico->get($turno["idmedico"], true);
        //Quiere decir que no es paciente titular
        if ($paciente["usuarioweb_idusuarioweb"] == "") {
            //Obtengo el paciente titular para el envío del email
            $paciente_titular = $ManagerPaciente->getPacienteTitular($turno["idpaciente"]);


            if ($paciente_titular["celularValido"] == 0) {
                return false;
            } else {
                $numero = $paciente_titular["numeroCelular"];
            }
        } else {
            //Es el paciente titular el seleccionado para enviar la invitación, entonces ya tiene celular
            if ($paciente["celularValido"] == 0) {
                return false;
            } else {
                $numero = $paciente["numeroCelular"];
            }
        }


        $fecha_str = fechaToString($turno["fecha"] . " " . $turno["horarioInicio"], 1);
        $cuerpo = "{$medico["titulo_profesional"]["titulo_profesional"]} {$medico["nombre"]} {$medico["apellido"]} a éliminé le cabinet '{$consultorio["nombreConsultorio"]}' " .
                "y su turno del dia {$fecha_str}hs queda cancelado";


        /**
         * Inserción del SMS en la lista de envio
         */
        $ManagerLogSMS = $this->getManager("ManagerLogSMS");
        $sms = $ManagerLogSMS->insert([
            "dirigido" => 'P',
            "paciente_idpaciente" => $turno["idpaciente"],
            "medico_idmedico" => $turno["idmedico"],
            "contexto" => "Alerta eliminacion consultorio",
            "texto" => $cuerpo,
            "numero_cel" => $numero
        ]);


        if ($sms) {
            $this->setMsg(["msg" => "Se ha enviado un SMS a su celular.", "result" => true]);
            return true;
        } else {
            $this->setMsg($ManagerLogSMS->getMsg());

            return false;
        }
    }

    /*     * Metodo que envia un sms y mail a los pacientes que tienen un turno futuro para un consultorio al que se le cambia la direccion
     * 
     */

    public function notificarCambioDireccionConsultorio($idconsultorio) {

        $fecha_actual = date("Y-m-d");
        $hora_actual = date("H:i:s");
        $idmedico = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];
        $query = new AbstractSql();
        $query->setSelect("t.idturno,t.fecha,t.horarioInicio,
                t.paciente_idpaciente as idpaciente,
                t.consultorio_idconsultorio as idconsultorio,
                c.medico_idmedico as idmedico");
        $query->setFrom("turno t inner join consultorio c on (t.consultorio_idconsultorio=c.idconsultorio)");
        $query->setWhere("c.medico_idmedico=$idmedico and c.idconsultorio=$idconsultorio");
        $query->addAnd("t.paciente_idpaciente IS NOT NULL");
        $query->addAnd("t.estado=0 OR t.estado=1"); //tunros pendientes de confirmacion o confirmados
        $query->addAnd("(t.fecha>'$fecha_actual') OR (t.fecha='$fecha_actual' AND t.horarioInicio>='$hora_actual')");

        $turnos = $this->getList($query);
        if (COUNT($turnos) > 0) {
            foreach ($turnos as $turno) {
                $this->enviarMailCambioDireccionConsultorio($turno);
                $this->enviarSMSCambioDireccionConsultorio($turno);
            }
        }
    }

    /*     * Metodo que envia un mensaje via email a paciente cuando  se le cambia la direccion a un consultorio y tenia un turno futuro en este
     * 
     * @param type $turno
     */

    public function enviarMailCambioDireccionConsultorio($turno) {

        $consultorio = $this->getManager("ManagerConsultorio")->get($turno["idconsultorio"]);
        $ManagerPaciente = $this->getManager("ManagerPaciente");
        $paciente = $ManagerPaciente->get($turno["idpaciente"]);
        $ManagerMedico = $this->getManager("ManagerMedico");
        $medico = $ManagerMedico->get($turno["idmedico"], true);
        $medico["imagen"] = $ManagerMedico->getImagenMedico($medico["idmedico"]);
        //Si el email es vació puede ser que sea un miembro del grupo familiar
        if ($paciente["email"] == "") {
            $paciente_titular = $ManagerPaciente->getPacienteTitular($turno["idpaciente"]);
        }

        if ($paciente["email"] == "" && $paciente_titular["email"] == "") {
            $this->setMsg(["msg" => "Error al recuperar email del paciente ", "result" => false]);
            return false;
        }


        //envio de la mensaje por mail

        $smarty = SmartySingleton::getInstance();

        $smarty->assign("paciente", $paciente);
        $smarty->assign("medico", $medico);
        $smarty->assign("consultorio", $consultorio);
        $turno["fecha_str"] = fechaToString($turno["fecha"] . " " . $turno["horarioInicio"], 1);
        $smarty->assign("turno", $turno);



        $mEmail = $this->getManager("ManagerMail");

        if ($medico["sexo"] == "1") {
            $sexo = "Mr";
        } else {
            $sexo = "Mme";
        }
        $subject = "WorknCare | Le {$medico["tituloprofesional"]} {$medico["nombre"]} {$medico["apellido"]} a changé l'adresse de son cabinet '{$consultorio["nombreConsultorio"]}' ";
        $mEmail->setSubject($subject);
        $mEmail->setBody($smarty->Fetch("email/mensaje_cambio_direccion_consultorio_paciente.tpl"));
        $email = $paciente["email"] == "" ? $paciente_titular["email"] : $paciente["email"];
        $mEmail->addTo($email);



        if ($mEmail->send(true)) {
            $this->setMsg(["msg" => "Mensaje enviado con éxito", "result" => true]);
            return true;
        } else {
            $this->setMsg(["msg" => "No se ha podido enviar el mensaje. Inténtelo más tarde", "result" => false]);
            return false;
        }
    }

    /** Metodo que envia un mensaje via sms a paciente cuando se le cambia la direccion a un consultorio y tenia un turno futuro en este
     * @return boolean
     */
    public function enviarSMSCambioDireccionConsultorio($turno) {

        $consultorio = $this->getManager("ManagerConsultorio")->get($turno["idconsultorio"]);
        $ManagerPaciente = $this->getManager("ManagerPaciente");
        $paciente = $ManagerPaciente->get($turno["idpaciente"]);
        $ManagerMedico = $this->getManager("ManagerMedico");
        $medico = $ManagerMedico->get($turno["idmedico"], true);
        //Quiere decir que no es paciente titular
        if ($paciente["usuarioweb_idusuarioweb"] == "") {
            //Obtengo el paciente titular para el envío del email
            $paciente_titular = $ManagerPaciente->getPacienteTitular($turno["idpaciente"]);


            if ($paciente_titular["celularValido"] == 0) {
                return false;
            } else {
                $numero = $paciente_titular["numeroCelular"];
            }
        } else {
            //Es el paciente titular el seleccionado para enviar la invitación, entonces ya tiene celular
            if ($paciente["celularValido"] == 0) {
                return false;
            } else {
                $numero = $paciente["numeroCelular"];
            }
        }

        if ($medico["sexo"] == "1") {
            $sexo = "Mr";
        } else {
            $sexo = "Mme";
        }

        $fecha_str = fechaToString($turno["fecha"] . " " . $turno["horarioInicio"], 1);
        $cuerpo = "{$medico["titulo_profesional"]["titulo_profesional"]} {$medico["nombre"]} {$medico["apellido"]} a changé l\'adresse du cabinet {$consultorio["nombreConsultorio"]} " .
                "de votre rendez-vous du jour {$fecha_str}hs a: {$consultorio["direccion"]} {$consultorio["numero"]},{$consultorio["localidad"]},{$consultorio["pais"]}";


        /**
         * Inserción del SMS en la lista de envio
         */
        $ManagerLogSMS = $this->getManager("ManagerLogSMS");
        $sms = $ManagerLogSMS->insert([
            "dirigido" => 'P',
            "paciente_idpaciente" => $turno["idpaciente"],
            "medico_idmedico" => $turno["idmedico"],
            "contexto" => "Alerta cambio direccion consultorio",
            "texto" => $cuerpo,
            "numero_cel" => $numero
        ]);


        if ($sms) {
            $this->setMsg(["msg" => "Se ha enviado un SMS a su celular.", "result" => true]);
            return true;
        } else {
            $this->setMsg($ManagerLogSMS->getMsg());

            return false;
        }
    }

}

//END_class 
?>