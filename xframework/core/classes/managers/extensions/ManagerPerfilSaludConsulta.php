<?php

/**
 * 	Manager del perfil de salud de consulta.
 *
 * 	@author Xinergia
 * 	@version 1.0
 * 	@package managers\extensions
 */
class ManagerPerfilSaludConsulta extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Constructor
        parent::__construct($db, "perfilsaludconsulta", "idperfilSaludConsulta");
    }

    //metodo que inserta un nuevo regisro de consulta medica al ingresar a la seccion  borra los pendientes que quedaron de ingresos previos
    public function insert($record) {

        if ($record["paciente_idpaciente"] != "") {
            $record["medico_idmedico"] = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"];
            //borramos las consultas sucias que quedaron de ingresos previos
            $this->db->Execute("delete from $this->table where is_cerrado=0 and consultaExpress_idconsultaExpress is null and videoconsulta_idvideoconsulta is null and paciente_idpaciente=" . $record["paciente_idpaciente"]);

            return parent::insert($record);
        } else {
            return false;
        }
    }

    /*     * Procesa la el cierre de la consulta medica creada al paciente, 
     * puede provenir de un turno medico mediante el perfil de salud o desde el cierre de una videoconsulta o consultaexpress
     * @param type $request
     * @return boolean
     */

    public function processFromMedico($request) {

        $request["medico_idmedico"] = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"];
        if ($request["paciente_idpaciente"] == "" || !isset($request["paciente_idpaciente"])) {
            $this->setMsg(["result" => false, "msg" => "Error. No hay paciente seleccionado"]);
            return false;
        }
//validacion de campos obligatorios

        if ($request["diagnostico"] == "") {
            $this->setMsg(["result" => false, "msg" => "Ingrese el diagnostico de la consulta"]);
            return false;
        }
        if ($request["tratamiento"] == "") {
            $this->setMsg(["result" => false, "msg" => "Ingrese el tratamiento para el paciente"]);
            return false;
        }

        if ($request["fecha"] != "") {
            $request["fecha"] = $this->sqlDate($request["fecha"]);
        } else {
            $request["fecha"] = date("Y-m-d");
        }

        /**
         * Corroboro que la enfermedad sea de cie10 o no
         */
        if ($request["diagnostico"] != $request["diagnostico_hidden"]) {
            //Si son distintos, unset del id de importacion cie10
            unset($request["importacion_cie10_idimportacion_cie10"]);
        }


        $this->db->StartTrans();
        $request["is_cerrado"] = 1;
        $request["receta_disponible_consultorio"] = $request["receta_disponible_consultorio"] == 1 ? 1 : 0;

        $rdo = parent::process($request);

        //añadimos el paciente de la consulta a Mis Pacientes
        $miPaciente = $this->getManager("ManagerMedicoMisPacientes")->insert($request);

        //añadimos al medico a la lista de Profesionales Frecuentes
        $medicoFrecuente = $this->getManager("ManagerProfesionalesFrecuentesPacientes")->insert($request);


        $consulta = $this->get($rdo);
        //finalizamos la consulta express si corresponde

        if ($rdo && $consulta["consultaExpress_idconsultaExpress"] != "") {

            $ManagerConsultaExpress = $this->getManager("ManagerConsultaExpress");
            $CE = $ManagerConsultaExpress->get($consulta["consultaExpress_idconsultaExpress"]);
            //verificamos que este abierta la consulta
            if ($CE["estadoConsultaExpress_idestadoConsultaExpress"] != "8") {

                $this->setMsg(["result" => false, "msg" => "Error. La consulta express no se encuentra abierta"]);
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                return false;
            }

            $rdo1 = $ManagerConsultaExpress->cambiarEstado(["estadoConsultaExpress_idestadoConsultaExpress" => 4, "idconsultaExpress" => $consulta["consultaExpress_idconsultaExpress"]]);

            $rdo2 = $ManagerConsultaExpress->finalizarConsultaExpress(["idconsultaExpress" => $consulta["consultaExpress_idconsultaExpress"]]);




            if (!$rdo1 || !$rdo2) {
                $this->setMsg(["result" => false, "msg" => "Error. Se produjo un error al procesar la consulta"]);
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                return false;
            }
        }


        //finalizamos la videoconsulta si corresponde
        if ($rdo && $consulta["videoconsulta_idvideoconsulta"] != "") {
            $ManagerVideoConsulta = $this->getManager("ManagerVideoConsulta");
            $VC = $ManagerVideoConsulta->get($consulta["videoconsulta_idvideoconsulta"]);
            //verificamos que este abierta la consulta
            if ($VC["estadoVideoConsulta_idestadoVideoConsulta"] != "8") {

                $this->setMsg(["result" => false, "msg" => "Error. La videoconsulta no se encuentra pendiente de finalizacion"]);
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                return false;
            }


            $rdo1 = $ManagerVideoConsulta->cambiarEstado(["estadoVideoConsulta_idestadoVideoConsulta" => 4, "idvideoconsulta" => $consulta["videoconsulta_idvideoconsulta"]]);
            $rdo2 = $ManagerVideoConsulta->finalizarVideoConsulta(["idvideoconsulta" => $consulta["videoconsulta_idvideoconsulta"]]);

            if (!$rdo1 || !$rdo2) {

                $this->setMsg(["result" => false, "msg" => "Error. Se produjo un error al procesar la consulta"]);
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                return false;
            }
        }


        if ($rdo) {

            if ($request["idturno"] != "") {
                $ManagerTurno = $this->getManager("ManagerTurno");
                $idturno = $ManagerTurno->update(["perfilSaludConsulta_idperfilSaludConsulta" => $request[$this->id]], $request["idturno"]);
            }



            $this->setMsg(["msg" => "La consulta fue procesada con éxito", "result" => true, "id" => $rdo]);

            //retornamos los datos necesarios cuando se finaliza una consulta proveniente de VC o CE
            if ($CE["idconsultaExpress"] != "") {

                // <-- LOG
                $log["data"] = "Confirmation, data created, picture attached";
                $log["page"] = "Conseil";
                $log["action"] = "val"; //"val" "vis" "del"
                $log["purpose"] = "Finalize Conseil CONCLUSION";

                $ManagerLog = $this->getManager("ManagerLog");
                $ManagerLog->track($log);
                // 

                $this->setMsg(["msg" => "La consulta fue procesada con éxito", "result" => true, "id" => $rdo, "precio_tarifa" => $CE["precio_tarifa"], "idconsultaexpress" => $CE["idconsultaExpress"]]);
            }
            if ($VC["idvideoconsulta"] != "") {

                // <-- LOG
                $log["data"] = "Confirmation, data conclusion created, picture, prescription attached";
                $log["page"] = "Video Consultation";
                $log["action"] = "val"; //"val" "vis" "del"
                $log["purpose"] = "Finalize Video Consultation CONCLUSION";

                $ManagerLog = $this->getManager("ManagerLog");
                $ManagerLog->track($log);
                // 
                $this->setMsg(["msg" => "La consulta fue procesada con éxito", "result" => true, "id" => $rdo, "precio_tarifa" => $VC["precio_tarifa"], "idvideoconsulta" => $VC["idvideoconsulta"]]);
            }




            $this->db->CompleteTrans();

            if ($rdo && $consulta["consultaExpress_idconsultaExpress"] == "" && $consulta["videoconsulta_idvideoconsulta"] == "") {
                // <-- LOG
                $log["data"] = "consultation data";
                $log["page"] = "New consultation";
                $log["action"] = "val"; //"val" "vis" "del"
                $log["purpose"] = "Add data consultation";

                $ManagerLog = $this->getManager("ManagerLog");
                $ManagerLog->track($log);
                // 
            }
            //enviamos los mail de consulta
            if ($rdo && $consulta["consultaExpress_idconsultaExpress"] != "") {
                $ManagerConsultaExpress = $this->getManager("ManagerConsultaExpress");
                //$ManagerConsultaExpress->enviarMailFinalizacionCE($consulta["consultaExpress_idconsultaExpress"]);
                $ManagerConsultaExpress->enviarSMSFinalizacionCE($consulta["consultaExpress_idconsultaExpress"]);
                $client = new XSocketClient();
                $client->emit("cambio_estado_consultaexpress_php", $consulta);

                //notify
                $paciente = $this->getManager("ManagerPaciente")->get($consulta["paciente_idpaciente"]);
                $notify["title"] = "{$paciente["nombre"]} {$paciente["apellido"]} - Conseil";
                $notify["text"] = "Conseil finalisé";
                $notify["type"] = "ce_finalizada";
                $notify["id"] = $consulta["idperfilSaludConsulta"];
                $notify["paciente_idpaciente"] = $consulta["paciente_idpaciente"];
                $notify["style"] = "consulta-express";
                $client->emit('notify_php', $notify);
            }
            if ($rdo && $consulta["videoconsulta_idvideoconsulta"] != "") {
                $ManagerVideoConsulta = $this->getManager("ManagerVideoConsulta");
                //$ManagerVideoConsulta->enviarMailFinalizacionVC($consulta["videoconsulta_idvideoconsulta"]);
                $ManagerVideoConsulta->enviarSMSFinalizacionVC($consulta["videoconsulta_idvideoconsulta"]);
                $client = new XSocketClient();
                $client->emit("cambio_estado_videoconsulta_php", $consulta);

                //notify
                $paciente = $this->getManager("ManagerPaciente")->get($consulta["paciente_idpaciente"]);
                $notify["title"] = "{$paciente["nombre"]} {$paciente["apellido"]} - Vidéo Consultation";
                $notify["text"] = "Vidéo Consultation finalisée";
                $notify["type"] = "vc_finalizada";
                $notify["id"] = $consulta["idperfilSaludConsulta"];
                $notify["paciente_idpaciente"] = $consulta["paciente_idpaciente"];
                $notify["style"] = "video-consulta";
                $client->emit('notify_php', $notify);
            }
            //enviamos el email de resumen de la consulta medica
            $this->enviarMailResumenConsulta($rdo);

            return $rdo;
        } else {

            $this->setMsg(["result" => false, "msg" => "Error. Se produjo un error al procesar la consulta"]);
            $this->db->FailTrans();
            $this->db->CompleteTrans();
            return false;
        }
    }

    /**
     * Método que retorna un listado de los pacientes pertenecientes a un médico
     * @param array $request
     * @param type $idpaginate
     * @return type
     */
    public function getListadoPaginado($request, $idpaginate = null) {

        //$this->resetPaginate($idpaginate);
        if (isset($request["do_reset"]) && $request["do_reset"] == 1) {
            $this->resetPaginate($idpaginate);
        }

        if (!is_null($idpaginate)) {
            $this->paginate($idpaginate, 10);
        }

        //Seteo el current page
        $request["current_page"] = $request["current_page"] != "" ? $request["current_page"] : 1;
        SmartyPaginate::setCurrentPage($request["current_page"], $idpaginate);

//          $this->print_r($_SESSION['SmartyPaginate'][$idpaginate]);


        $idmedico = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"];

        $query = new AbstractSql();

        $query->setSelect("t.$this->id,
                                DATE_FORMAT(t.fecha, '%d/%m/%Y') as fecha_format,
                                t.*                    
                            ");

        $query->setFrom("$this->table t");

        $query->setWhere("t.medico_idmedico = $idmedico");

        $query->addAnd("t.is_cerrado = 1");

        $query->addAnd("t.paciente_idpaciente = " . $request["idpaciente"]);

        $query->setOrderBy("t.fecha DESC, t.$this->id DESC");

        $listado = $this->getListPaginado($query, $idpaginate);

        if ($listado && count($listado) > 0) {
            //Recorro todo el listado para buscar los datos del perfil de salud consulta
            $ManagerPerfilSaludMedicamento = $this->getManager("ManagerPerfilSaludMedicamento");
            $ManagerPerfilSaludEstudios = $this->getManager("ManagerPerfilSaludEstudios");

            foreach ($listado["rows"] as $key => $consulta) {

                //Agrego la medicación
                $medicacion = $ManagerPerfilSaludMedicamento->getListMedicacionMedicoConsulta($consulta);
                if ($medicacion && count($medicacion) > 0) {
                    $listado["rows"][$key]["medicacion_list"] = $medicacion;
                } else {
                    $listado["rows"][$key]["medicacion_list"] = false;
                }

                //Agrego los estudios
                $estudios = $ManagerPerfilSaludEstudios->getListEstudiosConsulta($consulta);
                if ($estudios && count($estudios) > 0) {
                    $listado["rows"][$key]["estudios_list"] = $estudios;
                } else {
                    $listado["rows"][$key]["estudios_list"] = false;
                }
            }


            return $listado;
        } else {
            return false;
        }
    }

    /**
     * Método que retorna un listado de los pacientes pertenecientes a un médico
     * @param array $request
     * @param type $idpaginate
     * @return type
     */
    public function getListadoOtrosProfesionalesPaginado($request, $idpaginate = null) {

        //$this->resetPaginate($idpaginate);
        if (isset($request["do_reset"]) && $request["do_reset"] == 1) {
            $this->resetPaginate($idpaginate);
        }

        if (!is_null($idpaginate)) {
            $this->paginate($idpaginate, 20);
        }

        //Seteo el current page
        $request["current_page"] = $request["current_page"] != "" ? $request["current_page"] : 1;
        SmartyPaginate::setCurrentPage($request["current_page"], $idpaginate);

//          $this->print_r($_SESSION['SmartyPaginate'][$idpaginate]);




        $query = new AbstractSql();

        $query->setSelect("t.$this->id,
                                DATE_FORMAT(t.fecha, '%d/%m/%Y') as fecha_format,
                                t.*                    
                            ");

        $query->setFrom("$this->table t
                  INNER JOIN especialidadmedico em ON (t.medico_idmedico=em.medico_idmedico)
                   ");



        $query->setWhere("t.paciente_idpaciente = " . $request["idpaciente"]);

        $query->addAnd("t.is_cerrado = 1");
        if ($request["idespecialidad"] != "") {
            $query->addAnd("em.especialidad_idespecialidad=" . $request["idespecialidad"]);
        }

        //si se ingresa desde medico filtraamos los resultados de otros profesionales
        if (CONTROLLER == "medico") {
            $idmedico = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"];
            $query->addAnd("t.medico_idmedico <> " . $idmedico);
        }

        $query->setOrderBy("t.fecha DESC, t.$this->id DESC");
        $query->setGroupBy("t.$this->id");

        $listado = $this->getListPaginado($query, $idpaginate);

        if ($listado && count($listado) > 0) {
            //Recorro todo el listado para buscar los datos del perfil de salud consulta
            $ManagerPerfilSaludMedicamento = $this->getManager("ManagerPerfilSaludMedicamento");
            $ManagerPerfilSaludEstudios = $this->getManager("ManagerPerfilSaludEstudios");

            foreach ($listado["rows"] as $key => $consulta) {
                //Agrego la medicación
                $medicacion = $ManagerPerfilSaludMedicamento->getListMedicacionMedicoConsulta($consulta);
                if ($medicacion && count($medicacion) > 0) {
                    $listado["rows"][$key]["medicacion_list"] = $medicacion;
                } else {
                    $listado["rows"][$key]["medicacion_list"] = false;
                }
                //Agrego los estudios
                $estudios = $ManagerPerfilSaludEstudios->getListEstudiosConsulta($consulta);
                if ($estudios && count($estudios) > 0) {
                    $listado["rows"][$key]["estudios_list"] = $estudios;
                } else {
                    $listado["rows"][$key]["estudios_list"] = false;
                }
                $listado["rows"][$key]["medico"] = $this->getManager("ManagerMedico")->get($consulta["medico_idmedico"], true);
            }

            return $listado;
        } else {
            return false;
        }
    }

    /**
     * Método que retorna los otros profesionales que atendieron a un determinado paciente
     * @param type $request
     * @return type
     */
    public function getListadoOtrosProfesionales($request) {



        $query = new AbstractSql();

        $query->setSelect("MAX(idperfilSaludConsulta) as idperfilSaludConsulta,
                            em.especialidad_idespecialidad");

        $query->setFrom("perfilsaludconsulta t
                           INNER JOIN especialidadmedico em ON (t.medico_idmedico=em.medico_idmedico)");
        $query->setWhere("t.is_cerrado = 1");


        $query->addAnd("t.paciente_idpaciente = " . $request["idpaciente"]);

        //si se ingresa desde medico filtraamos los resultados de otros profesionales
        if (CONTROLLER == "medico") {
            $idmedico = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"];
            $query->addAnd("t.medico_idmedico <> " . $idmedico);
        }

        $query->setGroupBy("em.especialidad_idespecialidad");


        //agrupamos los resultados por especialidad
        $query2 = new AbstractSql();
        $query2->setSelect("pf.*,DATE_FORMAT(pf.fecha, '%d/%m/%Y') as fecha_format,uw.nombre,uw.apellido, es.idespecialidad,es.especialidad");
        $query2->setFrom("(" . $query->getSql() . ") as T
                    INNER JOIN perfilsaludconsulta pf on (pf.idperfilSaludConsulta=T.idperfilSaludConsulta)
                    INNER JOIN especialidad es on (es.idespecialidad=T.especialidad_idespecialidad)
                    INNER JOIN medico m ON (m.idmedico=pf.medico_idmedico)
                    INNER JOIN usuarioweb uw ON (uw.idusuarioweb=m.usuarioweb_idusuarioweb)");


        return $this->getList($query2);
    }

    /**
     * Listado paginado perteneciente a las consultas realizadas por un determinado médico
     * Sección ver más de las consultas
     * @param array $request
     * @param type $idpaginate
     * @return type
     */
    public function getListPaginadoMedico($request, $idpaginate = null) {

        if (isset($request["do_reset"]) && $request["do_reset"] == 1) {
            $this->resetPaginate($idpaginate);
        }

        if (!is_null($idpaginate)) {
            $this->paginate($idpaginate, 2);
        }

        //Seteo el current page
        $request["current_page"] = $request["current_page"] != "" ? $request["current_page"] : 1;
        SmartyPaginate::setCurrentPage($request["current_page"], $idpaginate);


        $idmedico = $request["idmedico"];

        $query = new AbstractSql();

        $query->setSelect("t.$this->id,
                                DATE_FORMAT(t.fecha, '%d/%m/%Y') as fecha_format,
                                t.evolucion_clinica,
                                t.laboratorio,
                                t.otros_estudios,
                                t.diagnostico,
                                t.tratamiento,
                                uw.nombre,
                                uw.apellido,
                                t.paciente_idpaciente,
                                tp.titulo_profesional
                            ");

        $query->setFrom("$this->table t 
                                INNER JOIN medico m ON (t.medico_idmedico = m.idmedico)
                                LEFT JOIN titulo_profesional tp ON (m.titulo_profesional_idtitulo_profesional = tp.idtitulo_profesional)
                                INNER JOIN usuarioweb uw ON (m.usuarioweb_idusuarioweb = uw.idusuarioweb)
                            ");

        $query->setWhere("t.medico_idmedico = $idmedico");

        $query->addAnd("t.paciente_idpaciente = " . $request["idpaciente"]);

        $query->setOrderBy("t.fecha DESC,t.$this->id DESC");

        $query->setGroupBy("t.medico_idmedico");

        $listado = $this->getListPaginado($query, $idpaginate);

        if ($listado && count($listado) > 0) {
            //Recorro todo el listado para buscar los datos del perfil de salud consulta
            $ManagerPerfilSaludMedicamento = $this->getManager("ManagerPerfilSaludMedicamento");
            $ManagerPerfilSaludEstudios = $this->getManager("ManagerPerfilSaludEstudios");

            foreach ($listado["rows"] as $key => $consulta) {
                //Agrego la medicación
                $medicacion = $ManagerPerfilSaludMedicamento->getListMedicacionMedicoConsulta($consulta);
                if ($medicacion && count($medicacion) > 0) {
                    $listado["rows"][$key]["medicacion_list"] = $medicacion;
                } else {
                    $listado["rows"][$key]["medicacion_list"] = false;
                }
                //Agrego los estudios
                $estudios = $ManagerPerfilSaludEstudios->getListImagesConsulta($consulta);
                if ($estudios && count($estudios) > 0) {
                    $listado["rows"][$key]["estudios_list"] = $estudios;
                } else {
                    $listado["rows"][$key]["estudios_list"] = false;
                }
            }

            return $listado;
        } else {
            return false;
        }
    }

    /**
     * Método que retorna un listado con la información de perfil de salud de consultas
     * @param type $idpaciente
     * @return type
     */
    public function getInfoTablero($idpaciente) {

        $query = new AbstractSql();

        $query->setSelect("t.$this->id,
                                DATE_FORMAT(t.fecha, '%d/%m/%Y') as fecha_format,
                                t.evolucion_clinica,
                                t.laboratorio,
                                t.otros_estudios,
                                t.diagnostico,
                                t.tratamiento,
                                m.idmedico,
                                uw.nombre,
                                uw.apellido,
                                tp.titulo_profesional,
                                consultaExpress_idconsultaExpress,
                                videoconsulta_idvideoconsulta
                               
                            ");

        $query->setFrom("$this->table t 
                                INNER JOIN medico m ON (t.medico_idmedico = m.idmedico)
                                LEFT JOIN titulo_profesional tp ON (m.titulo_profesional_idtitulo_profesional = tp.idtitulo_profesional)
                                INNER JOIN usuarioweb uw ON (m.usuarioweb_idusuarioweb = uw.idusuarioweb)
                                 
                            ");

        $query->addAnd("t.paciente_idpaciente = $idpaciente");
        $query->addAnd("t.is_cerrado=1");

        $query->setLimit("0, 8");

        $query->setOrderBy("t.fecha DESC");

        $rdo = $this->getList($query);

        foreach ($rdo as $key => $consulta) {
            $esp = $this->getManager("ManagerEspecialidadMedico")->getEspecialidadesMedico($consulta["idmedico"]);

            $rdo[$key]["especialidad"] = $esp[0]["especialidad"];
        }
        return $rdo;
    }

    /**
     * Método que obtiene la última consulta médica
     * @param type $idpaciente
     * @return boolean
     */
    public function getLastConsultaMedica($idpaciente) {

        $query = new AbstractSql();

        $query->setSelect("t.$this->id,
                                DATE_FORMAT(t.fecha, '%d/%m/%Y') as fecha_format,
                                t.evolucion_clinica,
                                t.laboratorio,
                                t.otros_estudios,
                                t.diagnostico,
                                t.tratamiento,
                                uw.nombre,
                                uw.apellido,
                                tp.titulo_profesional,
                                em.especialidad_idespecialidad as idespecialidad,
                                t.consultaExpress_idconsultaExpress,
                                t.videoconsulta_idvideoconsulta
                            ");

        $query->setFrom("$this->table t 
                                INNER JOIN medico m ON (t.medico_idmedico = m.idmedico)
                                LEFT JOIN titulo_profesional tp ON (m.titulo_profesional_idtitulo_profesional = tp.idtitulo_profesional)
                                INNER JOIN usuarioweb uw ON (m.usuarioweb_idusuarioweb = uw.idusuarioweb)
                                INNER JOIN especialidadmedico em on (em.medico_idmedico=m.idmedico)
                            ");

        $query->addAnd("t.paciente_idpaciente = $idpaciente");
        $query->addAnd("t.is_cerrado=1");
        $query->setOrderBy("t.fecha DESC,t.$this->id DESC");

        $query->setLimit("0, 1");

        $execute = $this->db->Execute($query->getSql());

        if ($execute) {
            return $execute->FetchRow();
        } else {
            return false;
        }
    }

    /*     * Metodo que obtiene el listado de consultas medicas realizas en un periodo
     * 
     * @param type $request
     */

    public function getListadoConsultasRango($request) {

        $query = new AbstractSql();
        $query->setSelect("idperfilSaludConsulta");
        $query->setFrom("{$this->table}");
        $query->setWhere("paciente_idpaciente={$request["idpaciente"]}");
        if ($request["fecha_desde"] != "") {
            list($d, $m, $y) = explode("/", $request["fecha_desde"]);

            $query->addAnd("fecha >= '$y-$m-$d'");
        }
        if ($request["fecha_hasta"] != "") {
            list($d, $m, $y) = explode("/", $request["fecha_hasta"]);

            $query->addAnd("fecha <= '$y-$m-$d'");
        }
        return $this->getList($query);
    }

    /**
     * Método que retorna los tags pertenecientes a un paciente, visualizados en el perfil del médico
     * @param type $idpaciente
     * @return type
     */
    public function getInfoTags($idpaciente) {

        //Obtengo ManagerPerfil Salud Biometrico
        $ManagerPerfilSaludBiometrico = $this->getManager("ManagerPerfilSaludBiometrico");
        $perfil_salud_biometrico = $ManagerPerfilSaludBiometrico->getByField("paciente_idpaciente", $idpaciente);
        $paciente = $this->getManager("ManagerPaciente")->get($idpaciente);



        $tags = "";
        //ALD
        if ($paciente["beneficia_ald"] == 1) {
            $afeccion = $this->getManager("ManagerAfeccionPaciente")->getAfeccionPaciente($idpaciente);
            $tags .= "ALD: {$afeccion["afeccion"]},";
        }

        //Peso
        if ($perfil_salud_biometrico) {
            $ManagerMasaCorporal = $this->getManager("ManagerMasaCorporal");
            $masa_corporal = $ManagerMasaCorporal->getLastInformation($perfil_salud_biometrico["idperfilSaludBiometricos"]);
            if ($masa_corporal) {
                if ($masa_corporal["peso"] != "") {
                    $tags .= x_translate("Peso") . ": " . $masa_corporal["peso"] . " Kg,";
                }
                if ($masa_corporal["altura"] != "") {
                    $tags .= x_translate("Altura") . ": " . $masa_corporal["altura"] . " Cm,";
                }
            }
        }

        $perfil_salud_biometrico_data = $ManagerPerfilSaludBiometrico->getWithData($idpaciente);
        if ($perfil_salud_biometrico_data["colorOjos"] != "") {
            $tags .= x_translate("Color de Ojos") . ": " . $perfil_salud_biometrico_data["colorOjos"] . ",";
        }
        if ($perfil_salud_biometrico_data["colorPelo"] != "") {
            $tags .= x_translate("Color de Pelo") . ": " . $perfil_salud_biometrico_data["colorPelo"] . ",";
        }
        if ($perfil_salud_biometrico_data["colorPiel"] != "") {
            $tags .= x_translate("Color de Piel") . ": " . $perfil_salud_biometrico_data["colorPiel"] . ",";
        }


        if ($perfil_salud_biometrico) {
            $ManagerGlucemia = $this->getManager("ManagerGlucemia");

            $glucemia = $ManagerGlucemia->getLastInformation($perfil_salud_biometrico["idperfilSaludBiometricos"]);
            if ($glucemia && $glucemia["test"] != "") {
                $tags .= x_translate("Glucemia") . ": " . $glucemia["test"] . " mg/dl,";
            }


            $ManagerColesterol = $this->getManager("ManagerColesterol");
            $colesterol = $ManagerColesterol->getLastInformation($perfil_salud_biometrico["idperfilSaludBiometricos"]);
            if ($colesterol) {
                if ($colesterol["colesterol_total"] != "") {
                    $tags .= x_translate("Colesterol") . ": " . $colesterol["colesterol_total"] . " mg/dl,";
                }
            }

            $ManagerPresionArterial = $this->getManager("ManagerPresionArterial");
            $presion_arterial = $ManagerPresionArterial->getLastInformation($perfil_salud_biometrico["idperfilSaludBiometricos"]);
            if ($presion_arterial && $presion_arterial["presion_arterial"] != "") {
                $tags .= x_translate("Presión Arterial") . ": " . $presion_arterial["presion_arterial"] . ",";
            }
        }
        //medicamentos actuales
        $ManagerPerfilSaludMedicamento = $this->getManager("ManagerPerfilSaludMedicamento");
        $tags_medicamentos = $ManagerPerfilSaludMedicamento->getInfoTags($idpaciente);

        if ($tags_medicamentos) {
            $tags .= $tags_medicamentos;
        }
        //antecedentes
        $ManagerAntecedentesPatologiaFamiliar = $this->getManager("ManagerAntecedentesPatologiaFamiliar");
        $tags_antecedentes = $ManagerAntecedentesPatologiaFamiliar->getTagsInputsMenuMedico($idpaciente);

        if ($tags_antecedentes) {
            $tags .= $tags_antecedentes;
        }

        $ManagerAntecedentesPersonales = $this->getManager("ManagerAntecedentesPersonales");
        $tags_antecedentes_personales = $ManagerAntecedentesPersonales->getTagsInputsMenuMedico($idpaciente);
        if ($tags_antecedentes_personales) {
            $tags .= $tags_antecedentes_personales;
        }
//enfermedades y patologias
        $ManagerEnfermedadesActuales = $this->getManager("ManagerEnfermedadesActuales");
        $tags_enfermedades_actuales = $ManagerEnfermedadesActuales->getTagsInputsMenuMedico($idpaciente);
        if ($tags_enfermedades_actuales) {
            $tags .= $tags_enfermedades_actuales;
        }


        $ManagerEnfermedadesActualesTipoEnfermedad = $this->getManager("ManagerEnfermedadesActualesTipoEnfermedad");
        $tags_tipo_enfermedades_actuales = $ManagerEnfermedadesActualesTipoEnfermedad->getTagsInputsMenuMedico($idpaciente);
        if ($tags_tipo_enfermedades_actuales) {
            $tags .= $tags_tipo_enfermedades_actuales;
        }

        $ManagerEnfermedadesActualesEnfermedad = $this->getManager("ManagerEnfermedadesActualesEnfermedad");
        $tags_enfermedades_actuales_enf = $ManagerEnfermedadesActualesEnfermedad->getTagsInputsMenuMedico($idpaciente);
        if ($tags_enfermedades_actuales_enf) {
            $tags .= $tags_enfermedades_actuales_enf;
        }
        $ManagerPatologiasActuales = $this->getManager("ManagerPatologiasActuales");

        $tags_patologias = $ManagerPatologiasActuales->getTagsInputsMenuMedico($idpaciente);
        if ($tags_patologias) {
            $tags .= $tags_patologias;
        }
//estilo de vida
        $ManagerPerfilSaludEstiloVida = $this->getManager("ManagerPerfilSaludEstiloVida");
        $tags_estilo = $ManagerPerfilSaludEstiloVida->getTagsInputsMenuMedico($idpaciente);
        if ($tags_estilo) {
            $tags .= $tags_estilo;
        }

        //control visual
        $ManagerPerfilSaludControlVisual = $this->getManager("ManagerPerfilSaludControlVisual");
        $tags_control_visual = $ManagerPerfilSaludControlVisual->getTagsInputsMenuMedico($idpaciente);
        if ($tags_estilo) {
            $tags .= $tags_control_visual;
        }
//otros

        $ManagerPerfilSaludCirugias = $this->getManager("ManagerPerfilSaludCirugias");
        $tags_cirugias = $ManagerPerfilSaludCirugias->getTagsInputsMenuMedico($idpaciente);
        if ($tags_cirugias) {
            $tags .= $tags_cirugias;
        }

        $ManagerPerfilSaludProtesis = $this->getManager("ManagerPerfilSaludProtesis");
        $tags_protesis = $ManagerPerfilSaludProtesis->getTagsInputsMenuMedico($idpaciente);
        if ($tags_protesis) {
            $tags .= $tags_protesis;
        }

        $ManagerPerfilSaludAlergia = $this->getManager("ManagerPerfilSaludAlergia");
        $tags_perfil_salud_alergia = $ManagerPerfilSaludAlergia->getTagsInputsMenuMedico($idpaciente);
        if ($tags_perfil_salud_alergia) {
            $tags .= $tags_perfil_salud_alergia;
        }

        return $tags;
    }

    /*     * Metodo que retorna una consulta medica completa con estudios y medicamentos
     * para ser impresa
     * @param type $idconsulta
     * @return boolean
     */

    public function getConsultaCompleta($idconsulta) {

        $query = new AbstractSql();

        $query->setSelect("t.{$this->id},
                                DATE_FORMAT(t.fecha, '%d/%m/%Y') as fecha_format,
                                t.evolucion_clinica,
                                t.laboratorio,
                                t.otros_estudios,
                                t.anotacion,
                                t.diagnostico,
                                t.tratamiento,
                                t.receta_disponible_consultorio,
                                uw.nombre,
                                uw.apellido,
                                t.paciente_idpaciente as idpaciente,
                                m.idmedico,
                                tp.titulo_profesional,
                                consultaExpress_idconsultaExpress,
                                videoconsulta_idvideoconsulta,
                                t.recomendacion,
                                m.matriculaProvincial,
                                m.matriculaNacional,
                                ce.*,
                                mc.*,
                                vc.*,
                                mv.*
                            ");

        $query->setFrom("{$this->table} t 
                                INNER JOIN medico m ON (t.medico_idmedico = m.idmedico)
                                INNER JOIN usuarioweb uw ON (m.usuarioweb_idusuarioweb = uw.idusuarioweb)
                                LEFT JOIN titulo_profesional tp ON (m.titulo_profesional_idtitulo_profesional = tp.idtitulo_profesional)
                                LEFT JOIN consultaexpress ce ON (t.consultaExpress_idconsultaExpress = ce.idconsultaExpress)
                                LEFT JOIN motivoconsultaexpress mc ON (mc.idmotivoConsultaExpress=ce.motivoConsultaExpress_idmotivoConsultaExpress)
                                LEFT JOIN videoconsulta vc ON (t.videoconsulta_idvideoconsulta = vc.idvideoconsulta)
                                LEFT JOIN motivovideoconsulta mv ON (mv.idmotivoVideoConsulta=vc.motivoVideoConsulta_idmotivoVideoConsulta)
                                
                               
                            ");

        /* if (CONTROLLER == "medico") {

          $query->setWhere("t.medico_idmedico = $idmedico");
          }
         */

        $query->addAnd("t.idperfilSaludConsulta = {$idconsulta}");

        $query->addAnd("t.is_cerrado=1");

        $consulta = $this->db->GetRow($query->getSql());

        if ($consulta && count($consulta) > 0) {


            //fix para idmedico y  idpaciente, ya que se borra con los left join de ConsultaExpress
            $consulta["medico_idmedico"] = $consulta["idmedico"];
            $consulta["paciente_idpaciente"] = $consulta["idpaciente"];


            $consulta["fechaConsulta_format"] = fechaToString($consulta["fecha_format"]);

            //Recorro todo el listado para buscar los datos del perfil de salud consulta
            $ManagerPerfilSaludMedicamento = $this->getManager("ManagerPerfilSaludMedicamento");
            $ManagerPerfilSaludEstudios = $this->getManager("ManagerPerfilSaludEstudios");
            $ManagerPerfilSaludReceta = $this->getManager("ManagerPerfilSaludReceta");
            $ManagerPerfilSaludAdjunto = $this->getManager("ManagerPerfilSaludAdjunto");

            $ManagerMedico = $this->getManager("ManagerMedico");
            $ManagerPaciente = $this->getManager("ManagerPaciente");

            $ManagerEspecialidadMedico = $this->getManager("ManagerEspecialidadMedico");
            $consulta["especialidades"] = $ManagerEspecialidadMedico->getListadoVisualizacion($consulta["medico_idmedico"]);
            $consulta["medico_imagen"] = $ManagerMedico->getImagenMedico($consulta["medico_idmedico"]);
            //Agrego la medicación

            $medicacion = $ManagerPerfilSaludMedicamento->getListMedicacionMedicoConsulta($consulta);

            if ($medicacion && count($medicacion) > 0) {
                $consulta["medicacion_list"] = $medicacion;
            } else {
                $consulta["medicacion_list"] = false;
            }
            //Agrego los estudios

            $estudios = $ManagerPerfilSaludEstudios->getListEstudiosConsulta($consulta);

            if ($estudios && count($estudios) > 0) {
                $consulta["estudios_list"] = $estudios;
            } else {
                $consulta["estudios_list"] = false;
            }

            //Agrego los estudios

            $recetas = $ManagerPerfilSaludReceta->getListRecetaConsulta($consulta);

            if ($recetas && count($recetas) > 0) {
                $consulta["recetas_list"] = $recetas;
            } else {
                $consulta["recetas_list"] = false;
            }

            //Agrego los archivos adjuntos

            $adjuntos = $ManagerPerfilSaludAdjunto->getListAdjuntoConsulta($consulta);

            if ($adjuntos && count($adjuntos) > 0) {
                $consulta["adjuntos_list"] = $adjuntos;
            } else {
                $consulta["adjuntos_list"] = false;
            }
            //Agrego el paciente

            $consulta["paciente"] = $ManagerPaciente->get($consulta["paciente_idpaciente"]);
            $consulta["paciente"]["imagen"] = $ManagerPaciente->getImagenPaciente($consulta["paciente_idpaciente"]);


            /**
             * Si es consulta express o videoconsulta, obtengo los datos históricos 
             * los medicos solo pueden ver los mensajes de las VC y CE que realizaron ellos
             * */
            $idmedico = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"];
            if ((CONTROLLER == "medico" && $consulta["medico_idmedico"] == $idmedico) || (CONTROLLER == "paciente_p")) {
                if ((int) $consulta["videoconsulta_idvideoconsulta"] > 0) {
                    $ManagerMensajeVideoConsulta = $this->getManager("ManagerMensajeVideoConsulta");
                    $consulta["videoconsulta"] = array();

                    if ($consulta["fecha_inicio"] != "") {
                        $consulta["videoconsulta"]["fecha_inicio_format"] = fechaToString($consulta["fecha_inicio"], 1);
                    }

                    if ($consulta["fecha_fin"] != "") {
                        $consulta["videoconsulta"]["fecha_fin_format"] = fechaToString($consulta["fecha_fin"], 1);
                    }

                    $consulta["videoconsulta"]["paciente"] = $ManagerPaciente->get($consulta["paciente_idpaciente"]);

                    //obtenemos el titular de la cuenta si es un familiar
                    $relaciongrupo = $this->getManager("ManagerPacienteGrupoFamiliar")->getByField("pacienteGrupo", $consulta["paciente_idpaciente"]);
                    if ($relaciongrupo["pacienteTitular"] != "") {
                        //Traigo la informacion del paciente titular
                        $consulta["videoconsulta"]["paciente_titular"] = $ManagerPaciente->get($relaciongrupo["pacienteTitular"]);
                        $relacion_grupo = $this->getManager("ManagerRelacionGrupo")->get($relaciongrupo["relacionGrupo_idrelacionGrupo"]);
                        $consulta["videoconsulta"]["paciente_titular"]["relacion"] = $relacion_grupo["relacionGrupo"];
                    }

                    //traigo los mensajes de la consulta

                    if ($consulta["turno_idturno"] != "") {

                        $consulta["videoconsulta"]["mensajes"][] = $this->getManager("ManagerMensajeTurno")->getListadoMensajes($consulta["turno_idturno"], $consulta["paciente_idpaciente"]);
                        //sumamos los mensajes durante la VC
                        $consulta["videoconsulta"]["mensajes"] = array_merge($consulta["videoconsulta"]["mensajes"], $ManagerMensajeVideoConsulta->getListadoMensajes($consulta["videoconsulta_idvideoconsulta"]));
                    } else {
                        //traigo los mensajes de la videoconsulta
                        $consulta["videoconsulta"]["mensajes"] = $ManagerMensajeVideoConsulta->getListadoMensajes($consulta["videoconsulta_idvideoconsulta"]);
                    }
                }

                if ((int) $consulta["consultaExpress_idconsultaExpress"] > 0) {
                    $ManagerMensajeConsultaExpress = $this->getManager("ManagerMensajeConsultaExpress");
                    $consulta["consulta_express"] = array();

                    if ($consulta["fecha_inicio"] != "") {
                        $consulta["consulta_express"]["fecha_inicio_format"] = fechaToString($consulta["fecha_inicio"], 1);
                    }

                    if ($consulta["fecha_fin"] != "") {
                        $consulta["consulta_express"]["fecha_fin_format"] = fechaToString($consulta["fecha_fin"], 1);
                    }

                    $consulta["consulta_express"]["paciente"] = $ManagerPaciente->get($consulta["paciente_idpaciente"]);

                    //obtenemos el titular de la cuenta si es un familiar
                    $relaciongrupo = $this->getManager("ManagerPacienteGrupoFamiliar")->getByField("pacienteGrupo", $consulta["paciente_idpaciente"]);
                    if ($relaciongrupo["pacienteTitular"] != "") {
                        //Traigo la informacion del paciente titular
                        $consulta["consulta_express"]["paciente_titular"] = $ManagerPaciente->get($relaciongrupo["pacienteTitular"]);
                        $relacion_grupo = $this->getManager("ManagerRelacionGrupo")->get($relaciongrupo["relacionGrupo_idrelacionGrupo"]);
                        $consulta["consulta_express"]["paciente_titular"]["relacion"] = $relacion_grupo["relacionGrupo"];
                    }

                    //traigo los mensajes de la consulta
                    $consulta["consulta_express"]["mensajes"] = $ManagerMensajeConsultaExpress->getListadoMensajes($consulta["consultaExpress_idconsultaExpress"]);
                }
            }

            return $consulta;
        } else {
            return false;
        }
    }

    /**
     * Método que envía el email de finalizacion de la consulta express..
     * Cuando finaliza la misma
     * @param type $idperfilSaludConsulta
     * @return boolean
     */
    public function enviarMailResumenConsulta($idperfilSaludConsulta) {

        $consulta = $this->getConsultaCompleta($idperfilSaludConsulta);

        $medico = $this->getManager("ManagerMedico")->get($consulta["medico_idmedico"]);
        $paciente_titular = $this->getManager("ManagerPaciente")->getPacienteTitular($consulta["paciente_idpaciente"]);


        //ojo solo arnet local
        $mEmail = $this->getManager("ManagerMail");
        $mEmail->setHTML(true);

        //ojo solo arnet local
        $mEmail->setPort("587");

        $mEmail->setSubject("WorknCare | Compte-rendu ");

        $smarty = SmartySingleton::getInstance();

        $smarty->assign("consulta", $consulta);
        $smarty->assign("medico", $medico);
        $smarty->assign("paciente_titular", $paciente_titular);


        $smarty->assign("sistema", NOMBRE_SISTEMA);

        $mEmail->setBody($smarty->Fetch("email/mensaje_resumen_consulta_medica.tpl"));



        if ($paciente_titular["email"] != "") {
            $mEmail->addTo($paciente_titular["email"]);
            //header a todos los comentarios!
            if ($mEmail->send()) {
                return true;
            }
        }
        $this->setMsg(array("result" => false, "msg" => "No se pudo enviar el mensaje"));
        return false;
    }

}

//END_class
?>