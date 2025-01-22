<?php

/**
 * 	Manager del perfil de salud de los medicamentos
 *
 * 	@author Xinergia
 * 	@version 1.0
 * 	@package managers\extensions
 */
class ManagerPerfilSaludMedicamento extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Constructor
        parent::__construct($db, "perfilsaludmedicamento", "idperfilSaludMedicamento");
    }

    /**
     * Método que inserta en la tabla perfil salud medicamento, los datos que vienen desde el panel de administración
     * del médico..
     * @param type $request
     * @return boolean
     */
    public function processFromMedico($request) {

        if (!isset($request["paciente_idpaciente"]) || $request["paciente_idpaciente"] == "") {
            $this->setMsg(["msg" => "Error. No hay un paciente seleccionado para asignarle el medicamento", "result" => false]);
            return false;
        } else {
            //Corroboro que el médico tenga relación con el paciente que viene por el $REQUEST
            $ManagerMedico = $this->getManager("ManagerMedico");
            $paciente = $ManagerMedico->getPacienteMedico($request["paciente_idpaciente"]);
            if (!$paciente) {
                $this->setMsg(["msg" => "Error. Usted no tiene relación con el paciente seleccionado", "result" => false]);
                return false;
            }
        }



        if ($request["fecha_fin"] != "") {
            $request["fecha_fin"] = $this->sqlDate($request["fecha_fin"]);
        }
        $request["fecha_inicio"] = $this->sqlDate($request["fecha_inicio"]);
        if ($request["fecha_inicio"] == "") {
            $this->setMsg(["msg" => "Error. La fecha es obligatoria", "result" => false]);
            return false;
        }

        //verificamos las fechas
        $fechaActual = date("Y-m-d H:i:s");
        $calendar = new Calendar();
        if ($request["fecha_inicio"] != "") {
            $rdo1 = $calendar->isMayor($fechaActual, $request["fecha_inicio"]);
            if ($rdo1 == 1) {
                $this->setMsg(["msg" => "Error. No puede ingresar fechas anteriores al día actual", "result" => false]);
                return false;
            }
        }
        if ($request["fecha_fin"] != "") {
            $rdo2 = $calendar->isMayor($fechaActual, $request["fecha_fin"]);
            if ($rdo2 == 1) {
                $this->setMsg(["msg" => "Error. No puede ingresar fechas anteriores al día actual", "result" => false]);
                return false;
            }
        }
        if ($request["fecha_inicio"] != "" && $request["fecha_fin"] != "") {
            $rdo = $calendar->isMayor($request["fecha_inicio"], $request["fecha_fin"]);
            if ($rdo == 1) {
                $this->setMsg(["msg" => "Error. La fecha de inicio no puede ser mayor a la fecha de fin", "result" => false]);
                return false;
            }
        }


        if ($request["nombre_medicamento"] == "" || $request["posologia"] == "") {
            $this->setMsg(["msg" => "Ingrese un medicamento y su posología", "result" => false]);
            return false;
        }

        $request["medico_idmedico"] = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"];

        $ManagerEspecialidadMedico = $this->getManager("ManagerEspecialidadMedico");
        $list_especialidad_medico = $ManagerEspecialidadMedico->getEspecialidadesMedico($request["medico_idmedico"]);
        if ($list_especialidad_medico) {
            $request["especialidadmedico_idespecialidadMedico"] = $list_especialidad_medico[0]["idespecialidadMedico"] != "" ? $list_especialidad_medico[0]["idespecialidadMedico"] : "";
        }

        /**
         * Ceckeo el tema de los medicamentos
         */
        if ($request["nombre_medicamento_hidden"] != $request["nombre_medicamento"]) {
            unset($request["medicamento_idmedicamento"]);
        }
        $request["alta_paciente"] = 0;

        $rdo = parent::process($request);

        if (!$rdo) {
            $this->setMsg(["result" => false, "msg" => "Se produjo un error al agregar la medicación, verifique los datos"]);
            return false;
        } else {
            $this->setMsg(["result" => true, "msg" => "Medicación agregada con éxito", "id" => $rdo]);
            return $rdo;
        }
    }

    /**
     * Método que inserta en la tabla perfil salud medicamento, los datos que vienen desde el panel de administración
     * del médico..
     * @param type $request
     * @return boolean
     */
    public function processFromPaciente($request) {

        if (!isset($request["paciente_idpaciente"]) || $request["paciente_idpaciente"] == "") {
            $this->setMsg(["msg" => "Error. No hay un paciente seleccionado para asignarle el medicamento", "result" => false]);
            return false;
        }

        if ($request["from_wizard"] == 1) {
            if ($request["nombre_medicamento"] == "") {
                $this->setMsg(["msg" => "Ingrese un medicamento", "result" => false]);
                return false;
            }

            $request["fecha_inicio"] = date("Y-m-d");
            $request["tipoTomaMedicamentos_idtipoTomaMedicamentos"] = 2; //tratamiento prolongado
        } else {


            if ((int) $request["tipoTomaMedicamentos_idtipoTomaMedicamentos"] != 4) {
                //Si la toma de medicamentos no es temporal, elimino la fecha de fin
                unset($request["fecha_fin"]);
            } else {
                if ($request["fecha_fin"] != "") {
                    $request["fecha_fin"] = $this->sqlDate($request["fecha_fin"]);
                } else {
                    $this->setMsg(["msg" => "Error. La fecha es obligatoria", "result" => false]);
                    return false;
                }
            }

            if ($request["fecha_inicio"] != "") {
                $request["fecha_inicio"] = $this->sqlDate($request["fecha_inicio"]);
            } else {
                $this->setMsg(["msg" => "Error. La fecha es obligatoria", "result" => false]);
                return false;
            }

            if ($request["fecha_inicio"] != "" && $request["fecha_fin"] != "") {
                $calendar = new Calendar();
                $rdo = $calendar->isMayor($request["fecha_inicio"], $request["fecha_fin"]);
                if ($rdo == 1) {
                    $this->setMsg(["msg" => "Error. La fecha de inicio no puede ser mayor a la fecha de fin", "result" => false]);
                    return false;
                }
            }



            if ($request["nombre_medicamento"] == "" || $request["posologia"] == "") {
                $this->setMsg(["msg" => "Ingrese un medicamento y su posología", "result" => false]);
                return false;
            }
            /*
              if ($request["especialidad_idespecialidad"] == "" && $request["medico_idmedico"] == "") {
              $this->setMsg([          "msg" => "Seleccione quien recetó el medicamento",          "result" => false          ]);
              return false;
              }

              if ($request["receto_medicofrecuente"] == "1" && $request["medico_idmedico"] == "") {
              $this->setMsg([          "msg" => "Seleccione el médico frecuente que recetó el medicamento",          "result" => false          ]);
              return false;
              }

             */

            $request["receto_medicofrecuente"] = 0;
            $request["receto_especialidad"] = 1;

            if ($request["especialidad_idespecialidad"] == "") {
                $this->setMsg(["msg" => "Seleccione el especialista que recetó el medicamento", "result" => false]);
                return false;
            }
        }
        $request["alta_paciente"] = 1;
        $rdo = parent::process($request);

        if (!$rdo) {
            $this->setMsg(["result" => false, "msg" => "Se produjo un error, verifique los datos"]);
            return false;
        } else {
            $this->setMsg(["result" => true, "msg" => "Registro actualizado con éxito", "id" => $rdo]);

            // LOG
            if ($request["from_wizard"] == 1) {
                // <-- LOG
                $log["data"] = "Go to health profile";
                $log["page"] = "Home page (connected)";
                $log["action"] = "val"; //"val" "vis" "del"
                $log["purpose"] = "Complete Health Profile";

                $ManagerLog = $this->getManager("ManagerLog");
                $ManagerLog->track($log);
                // 
            }
            return $rdo;
        }
    }

    /**
     * Método que retorna el listado de las medicaciones actuales
     * @param type $request
     * @return type
     */
    public function getListMedicacionActual($request, $idpaginate = null, $paginado = false) {

        if ($paginado) {
            if (isset($request["do_reset"]) && $request["do_reset"] == 1) {
                $this->resetPaginate($idpaginate);
            }

            if (!is_null($idpaginate)) {
                $this->paginate($idpaginate, 2);
            }

            //Seteo el current page
            $request["current_page"] = $request["current_page"] != "" ? $request["current_page"] : 1;
            SmartyPaginate::setCurrentPage($request["current_page"], $idpaginate);
        }

        $idpaciente = $request["paciente_idpaciente"];

        $query = new AbstractSql();

        $query->setSelect("
                            psm.$this->id,
                                psm.*,
                                m.nombre_comercial,
                                
                                DATE_FORMAT(psm.fecha_inicio,'%d/%m/%Y') as fecha_inicio_f,
                                DATE_FORMAT(psm.fecha_fin,'%d/%m/%Y') as fecha_fin_f,
                                e.especialidad,
                                tp.titulo_profesional,
                                uw.apellido,
                                uw.nombre,
                                srm.*
                    ");

        $query->setFrom("$this->table psm 
                            INNER JOIN tipotomamedicamentos ttm ON (psm.tipoTomaMedicamentos_idtipoTomaMedicamentos = ttm.idtipoTomaMedicamentos)
                            LEFT JOIN medicamento m ON (m.idmedicamento = psm.medicamento_idmedicamento)
                            LEFT JOIN medico med ON (med.idmedico = psm.medico_idmedico)
                            LEFT JOIN titulo_profesional tp ON (med.titulo_profesional_idtitulo_profesional=tp.idtitulo_profesional)
                            LEFT JOIN usuarioweb uw ON(uw.idusuarioweb=med.usuarioweb_idusuarioweb)
                            LEFT JOIN especialidadmedico em ON (med.idmedico = em.medico_idmedico)
                            LEFT JOIN especialidad e ON(em.especialidad_idespecialidad = e.idespecialidad)
                            LEFT JOIN solicitudrenovacionperfilsaludmedicamento srm ON (srm.perfilSaludMedicamento_idperfilSaludMedicamento = psm.$this->id)
                            LEFT JOIN perfilsaludconsulta psc on (psm.perfilSaludConsulta_idperfilSaludConsulta=psc.idperfilSaludConsulta )

                    ");

        $query->setWhere("psm.paciente_idpaciente = $idpaciente");

        $query->addAnd("(psm.tipoTomaMedicamentos_idtipoTomaMedicamentos = 4 AND CURRENT_DATE() <= psm.fecha_fin) "
                . "OR (psm.tipoTomaMedicamentos_idtipoTomaMedicamentos = 3) "
                . "OR (psm.tipoTomaMedicamentos_idtipoTomaMedicamentos =1 AND psm.fecha_inicio = CURRENT_DATE()  )"
                . "OR (psm.tipoTomaMedicamentos_idtipoTomaMedicamentos =2 AND CURRENT_DATE() BETWEEN psm.fecha_inicio AND DATE_ADD(psm.fecha_inicio,INTERVAL 120 DAY)  )");

        $query->addAnd("(psm.perfilSaludConsulta_idperfilSaludConsulta is null) or (psc.is_cerrado=1)");

        if (CONTROLLER == "medico") {
            $query->addAnd("psm.alta_paciente=0");
        }

        $query->setGroupBy("psm.$this->id");
        if ($paginado) {
            $listado = $this->getListPaginado($query, $idpaginate);
        } else {
            $listado = $this->getList($query);
        }


        if ($listado && count($listado) > 0) {
            $ManagerMedico = $this->getManager("ManagerMedico");
            $ManagerPreferencia = $this->getManager("ManagerPreferencia");
            foreach ($listado as $key => $valor) {
                $listado[$key]["imagen"] = $ManagerMedico->getImagenMedico($valor["medico_idmedico"]);
                if ($valor["medico_idmedico"] != "") {
                    $EspecialidadMedico = $this->getManager("ManagerEspecialidadMedico")->getByField("medico_idmedico", $valor["medico_idmedico"]);
                    $especialidad = $this->getManager("ManagerEspecialidades")->get($EspecialidadMedico["especialidad_idespecialidad"]);
                    $listado[$key]["especialidad"] = $especialidad["especialidad"];
                    $listado[$key]["valorPinesConsultaExpress"] = $ManagerPreferencia->getPreferenciaMedico($valor["medico_idmedico"])["valorPinesConsultaExpress"];
                }
            }

            return $listado;
        } else {
            return false;
        }
    }

    /**
     * Método que retorna el listado de las medicaciones actuales
     * @param type $request
     * @return type
     */
    public function getListMedicacionHistorica($request, $idpaginate = null, $paginado = false) {

        if ($paginado) {
            if (isset($request["do_reset"]) && $request["do_reset"] == 1) {
                $this->resetPaginate($idpaginate);
            }

            if (!is_null($idpaginate)) {
                $this->paginate($idpaginate, 2);
            }

            //Seteo el current page
            $request["current_page"] = $request["current_page"] != "" ? $request["current_page"] : 1;
            SmartyPaginate::setCurrentPage($request["current_page"], $idpaginate);
        }

        $idpaciente = $request["paciente_idpaciente"];

        $query = new AbstractSql();

        $query->setSelect("
                            psm.$this->id,
                                psm.*,
                                m.nombre_comercial,
                                med.matriculaNacional,
                                med.matriculaProvincial,
                                DATE_FORMAT(psm.fecha_inicio,'%d/%m/%Y') as fecha_inicio_f,
                                DATE_FORMAT(psm.fecha_fin,'%d/%m/%Y') as fecha_fin_f,
                                uw.apellido,
                                uw.nombre,
                                e.especialidad                                
                    ");

        $query->setFrom("$this->table psm 
                            INNER JOIN tipotomamedicamentos ttm ON (psm.tipoTomaMedicamentos_idtipoTomaMedicamentos = ttm.idtipoTomaMedicamentos)
                            LEFT JOIN medicamento m ON (m.idmedicamento = psm.medicamento_idmedicamento)
                            LEFT JOIN medico med ON (med.idmedico = psm.medico_idmedico)
                               LEFT JOIN usuarioweb uw ON(uw.idusuarioweb=med.usuarioweb_idusuarioweb)
                            LEFT JOIN especialidad e ON(psm.especialidad_idespecialidad = e.idespecialidad)   
                                                         LEFT JOIN perfilsaludconsulta psc on (psm.perfilSaludConsulta_idperfilSaludConsulta=psc.idperfilSaludConsulta)

                        ");

        $query->setWhere("psm.paciente_idpaciente = $idpaciente");

        $query->addAnd("(psm.tipoTomaMedicamentos_idtipoTomaMedicamentos = 4 AND CURRENT_DATE() > psm.fecha_fin) "
                . "OR (psm.tipoTomaMedicamentos_idtipoTomaMedicamentos= 1 AND CURRENT_DATE() > psm.fecha_inicio)"
                . "OR (psm.tipoTomaMedicamentos_idtipoTomaMedicamentos =2 AND CURRENT_DATE()> DATE_ADD(psm.fecha_inicio,INTERVAL 120 DAY)  )");

        $query->addAnd("(psm.perfilSaludConsulta_idperfilSaludConsulta is null) or (psc.is_cerrado=1)");
        if ($paginado) {
            $listado = $this->getListPaginado($query, $idpaginate);
        } else {
            $listado = $this->getList($query);

            if ($listado && count($listado) > 0) {
                $ManagerMedico = $this->getManager("ManagerMedico");
                $ManagerPreferencia = $this->getManager("ManagerPreferencia");
                foreach ($listado as $key => $valor) {
                    $listado[$key]["imagen"] = $ManagerMedico->getImagenMedico($valor["medico_idmedico"]);
                    if ($valor["medico_idmedico"] != "") {
                        $EspecialidadMedico = $this->getManager("ManagerEspecialidadMedico")->getByField("medico_idmedico", $valor["medico_idmedico"]);
                        $especialidad = $this->getManager("ManagerEspecialidades")->get($EspecialidadMedico["especialidad_idespecialidad"]);
                        $listado[$key]["especialidad"] = $especialidad["especialidad"];
                        $listado[$key]["valorPinesConsultaExpress"] = $ManagerPreferencia->getPreferenciaMedico($valor["medico_idmedico"])["valorPinesConsultaExpress"];
                    }
                }

                return $listado;
            } else {
                return false;
            }
        }
    }

    /**
     * Método que retorna el listado de medicamentos correspondiente a una consulta
     * @param type $request
     * @return type
     */
    public function getListMedicacionMedicoConsulta($request) {

        $idpaciente = $request["paciente_idpaciente"];
        $idperfilSaludConsulta = $request["idperfilSaludConsulta"];

        $query = new AbstractSql();

        $query->setSelect("
                            psm.$this->id,
                                IFNULL(m.nombre_comercial, psm.nombre_medicamento) as nombre_comercial,
                                psm.medico_idmedico,
                                psm.posologia,
                                DATE_FORMAT(psm.fecha_inicio,'%d/%m/%Y') as fecha_inicio_f,
                                DATE_FORMAT(psm.fecha_fin,'%d/%m/%Y') as fecha_fin_f,
                                psm.tipoTomaMedicamentos_idtipoTomaMedicamentos
                    ");

        $query->setFrom("$this->table psm 
                            LEFT JOIN medicamento m ON (m.idmedicamento = psm.medicamento_idmedicamento)
                    ");

        $query->setWhere("psm.paciente_idpaciente = $idpaciente");

        $query->addAnd("psm.perfilSaludConsulta_idperfilSaludConsulta = $idperfilSaludConsulta");
        if (CONTROLLER == "medico") {
            $query->addAnd("psm.medico_idmedico = " . $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"]);
        }

        $rdo = $this->getList($query);

        return $rdo;
    }

    /**
     * Método que retorna el listado de las prescripciones realizadas por el médico que se encuentra Logueado
     * @param type $request
     * @return type
     */
    public function getListMedicacionMedico($request) {

        $idpaciente = $request["paciente_idpaciente"];

        $query = new AbstractSql();

        $query->setSelect("
                            psm.$this->id,
                               psm.*,
                                e.especialidad,
                                tp.titulo_profesional,
                                uw.apellido,
                                uw.nombre,
                                psm.medico_idmedico,
                                psm.posologia,
                                DATE_FORMAT(psm.fecha_inicio,'%d/%m/%Y') as fecha_inicio_f,
                                DATE_FORMAT(psm.fecha_fin,'%d/%m/%Y') as fecha_fin_f,
                                psm.tipoTomaMedicamentos_idtipoTomaMedicamentos
                    ");

        $query->setFrom("$this->table psm 
                            LEFT JOIN medico med ON (med.idmedico = psm.medico_idmedico)
                            LEFT JOIN titulo_profesional tp ON (med.titulo_profesional_idtitulo_profesional=tp.idtitulo_profesional)
                            LEFT JOIN usuarioweb uw ON(uw.idusuarioweb=med.usuarioweb_idusuarioweb)
                            LEFT JOIN medicamento m ON (m.idmedicamento = psm.medicamento_idmedicamento)
                            LEFT JOIN perfilsaludconsulta psc on (psm.perfilSaludConsulta_idperfilSaludConsulta=psc.idperfilSaludConsulta)
                            LEFT JOIN especialidadmedico em ON (med.idmedico = em.medico_idmedico)
                            LEFT JOIN especialidad e ON(em.especialidad_idespecialidad = e.idespecialidad)
                          
                    ");

        $query->setWhere("psm.paciente_idpaciente = $idpaciente");

        $query->addAnd("psm.alta_paciente<>1");
        $query->addAnd("(psm.perfilSaludConsulta_idperfilSaludConsulta is null) or (psc.is_cerrado=1)");
        $query->setGroupBy("psm.$this->id");
        return $this->getList($query);
    }

    /**
     * Método que retorna el listado de medicamentos del paciente para el tablero
     * @param type $idpaciente
     */
    public function getInfoTablero($idpaciente) {
        $query = new AbstractSql();

        $query->setSelect("
                            psm.$this->id,
                                psm.*,
                                psm.medico_idmedico,
                                psm.posologia,
                                DATE_FORMAT(psm.fecha_inicio,'%d/%m/%Y') as fecha_inicio_f,
                                DATE_FORMAT(psm.fecha_fin,'%d/%m/%Y') as fecha_fin_f,
                                psm.tipoTomaMedicamentos_idtipoTomaMedicamentos
                    ");

        $query->setFrom("$this->table psm 
                            LEFT JOIN medicamento m ON (m.idmedicamento = psm.medicamento_idmedicamento)
                    ");

        $query->setWhere("psm.paciente_idpaciente = $idpaciente");

        //$query->addAnd("fecha_inicio > CURDATE()");

        $query->setLimit("0,8");

        return $this->getList($query);
    }

    /**
     * Método que realiza el procesamiento de la solicitud de renovación
     * El paciente solicita que se le renueve la receta
     * @param type $request
     * @return boolean
     */
    public function processSolicitudRenovacion($request) {

        $ps_medicamento = $this->get($request["perfilSaludMedicamento_idperfilSaludMedicamento"]);

        if ($ps_medicamento) {
            //Si viene por acá se va a procesar la solicitud de renovación de receta
            $ManagerSolicitudRenovacionPerfilSaludMedicamento = $this->getManager("ManagerSolicitudRenovacionPerfilSaludMedicamento");
            //BUsco si ya hay una solicitud de renovación para el médico actual
            $renovacion_perfil_salud = $ManagerSolicitudRenovacionPerfilSaludMedicamento->getByField("perfilSaludMedicamento_idperfilSaludMedicamento", $request["perfilSaludMedicamento_idperfilSaludMedicamento"]);

            if ($renovacion_perfil_salud) {
                $this->setMsg(["msg" => "Ya fue realizada la solicitud de renovación para esa receta.", "result" => false]);
                return false;
            }

            $this->db->StartTrans();

            $rdo_insert = $ManagerSolicitudRenovacionPerfilSaludMedicamento->insert($request);
            if ((int) $rdo_insert > 0) {

                $this->db->CompleteTrans();

                $this->setMsg(["msg" => "La solicitud fue realizada con éxito", "result" => true]);
                return true;
            } else {
                $this->db->FailTrans();
                $this->db->CompleteTrans();

                $this->setMsg(["msg" => "Error. Se produjo un error al realizar la solicitud de renovación. Intente nuevamente", "result" => false]);
                return false;
            }
        } else {
            $this->db->FailTrans();
            $this->db->CompleteTrans();

            $this->setMsg(["msg" => "Error. Se produjo un error al realizar la solicitud de renovación. Intente nuevamente", "result" => false]);
            return false;
        }
    }

    /*     * Metodo que devuelve el texto para tagsinput de medicamentos
     * 
     * @param type $idpaciente
     * @return type
     */

    public function getInfoTags($idpaciente) {


        $request["paciente_idpaciente"] = $idpaciente;
        $listado = $this->getListMedicacionActual($request, null, false);

        $tags = "";
        if (count($listado) > 0) {
            foreach ($listado as $medicamento) {
                if (strlen($medicamento["nombre_medicamento"]) > 50) {
                    $tags .= substr($medicamento["nombre_medicamento"], 0, 47) . "...,";
                } else {
                    $tags .= $medicamento["nombre_medicamento"] . ",";
                }
            }
        }
        return $tags;
    }

}

//END_class
?>