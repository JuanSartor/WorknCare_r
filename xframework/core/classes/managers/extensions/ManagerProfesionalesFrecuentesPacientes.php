<?php

/**
 * 	@autor Xinergia
 * 	@version 1.0	29/05/2014
 * 	Manager que contiene la asociación de los médicos y pacientes
 * Un profesional es frecuente cuando el medico crea la consulta medica luego de un turno, VC o CE
 *
 */
class ManagerProfesionalesFrecuentesPacientes extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "profesionalesfrecuentes_pacientes", "idprofesionalesFrecuentes_pacientes");
    }

    public function process($request) {

        $request["medico_idmedico"] = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"];

        if ($request["medico_idmedico"] == "" || $request["paciente_idpaciente"] == "") {
            $this->setMsg(["msg" => "Error. No se pudo crear la relación entre profesional frecuente y paciente", "result" => false]);

            return false;
        }

        return parent::process($request);
    }

    /**
     * Método que busco los profesiones frecuentes de un determinado paciente..
     * 
     * @param type $idpaciente
     * @param type $idmedico : Si viene el id del médico, el médico no tiene que estar incluído en el listado
     * @return boolean
     */
    public function getListadoProfesionalesFrecuentesPaciente($idpaciente, $idmedico = null) {

        $query = new AbstractSql();

        $query->setSelect("t.*");

        $query->setFrom("$this->table t
                            INNER JOIN medico m ON (t.medico_idmedico = m.idmedico)
                            
                        ");

        $query->setWhere("t.paciente_idpaciente = $idpaciente");

        $query->setOrderBy("t.ultima_interaccion DESC");
        $query->setGroupBy("t.medico_idmedico");


        //Si viene ID del médico, el mismo no tendrá que ser incluído.. Es para el listado de Mis pacientes


        if (!is_null($idmedico) && (int) $idmedico > 0) {
            $query->addAnd("t.medico_idmedico <> $idmedico");
        }

        $listado = $this->getList($query);

        if ($listado && count($listado) > 0) {

            //Tengo que buscar toda la información del médico
            $ManagerMedico = $this->getManager("ManagerMedico");
            foreach ($listado as $key => $value) {
                $listado[$key] = $ManagerMedico->get($value["medico_idmedico"], true);

                //Agrego un listado con las especialidades
                if ($listado[$key]["mis_especialidades"] && count($listado[$key]["mis_especialidades"]) > 0) {
                    $especialidades = "";
                    foreach ($listado[$key]["mis_especialidades"] as $key1 => $especialidad) {
                        $especialidades .= ", " . $especialidad["subEspecialidad"];
                    }
                    $listado[$key]["subEspecialidades"] = $especialidades != "" ? substr($especialidades, 1) : "";
                }

                $listado[$key]["imagenes"] = $ManagerMedico->getImagenMedico($value["medico_idmedico"]);
            }

            return $listado;
        } else {

            return false;
        }
    }

    /*     * metodo que inserta un registro de un medico al que se realizo una consulta en listado de Profesionales frecuentes
     * Un profesional es frecuente cuando el medico crea la consulta medica luego de un turno, VC o CE
     * @param array $record
     * @return boolean
     */

    public function insert($record) {

        $record["ultima_interaccion"] = date("Y-m-d");
        //verificamos que no exista 
        $res = $this->db->getRow("select idprofesionalesFrecuentes_pacientes from $this->table t where medico_idmedico=" . $record["medico_idmedico"]
                . " and paciente_idpaciente=" . $record["paciente_idpaciente"]);

        if ($res["idprofesionalesFrecuentes_pacientes"] != "") {
            //Si hay resultado, quiere decir que ya se encuentra la relación entre el médico y el paciente
            return parent::update(["ultima_interaccion" => $record["ultima_interaccion"]], $res["idprofesionalesFrecuentes_pacientes"]);
        } else {
            return parent::insert($record);
        }
    }

    /**
     * Método que elimina la asociación de un paciente con medicofrecuente cuando se elimina de mis pacientes
     * @param type $request
     * @return boolean
     */
    public function deleteAsociacion($request) {

        $relacion_to_delete = $this->db->GetRow("select * from $this->table where paciente_idpaciente=" . $request["paciente_idpaciente"] . " and medico_idmedico=" . $request["medico_idmedico"]);

        if ($relacion_to_delete) {
            $delete = parent::delete($relacion_to_delete[$this->id], true);

            if ($delete) {
                $this->setMsg(["msg" => "El médico seleccionado fue eliminado de 'Profesionales Frecuentes'", "result" => true]);
                return true;
            } else {
                $this->setMsg(["msg" => "Error. No se pudo eliminar el médico seleccionado de 'Profesionales Frecuentes'", "result" => false]);
                return false;
            }
        } else {
            $this->setMsg(["msg" => "Error. No se encontró la relación paciente/médico en el sistema. Recargue la página", "result" => false]);
            return false;
        }
    }

    /**
     * Eliminación múltiple de laos medicos frecuentes de un paciente
     * chequeo de que no se eliminen notificaciones pertenecientes a controles y chequeos
     * @param type $ids
     * @param type $forced
     * @return boolean
     */
    public function deleteMultiple($ids) {
        $listado_ids = explode(",", $ids);

        if ($listado_ids && count($listado_ids) > 0) {
            $paciente = $this->getManager("ManagerPaciente")->getPacienteXHeader();
            $idpaciente = $paciente["idpaciente"];
            $result = true;
            foreach ($listado_ids as $idmedico) {
                $rdo = $this->db->Execute("delete from $this->table where medico_idmedico=$idmedico and paciente_idpaciente=$idpaciente");
                if (!$rdo) {
                    $result = false;
                }
            }
            if ($result) {
                $this->setMsg(["msg" => "Se han eliminado los profesionales frecuentes", "result" => true]);

                // <-- LOG
                $log["data"] = "Delete Professional from list of Frequent Professionals";
                $log["page"] = "Frequent Professionals";
                $log["action"] = "val"; //"val" "vis" "del"
                $log["purpose"] = "Update Frequent Profesionals";

                $ManagerLog = $this->getManager("ManagerLog");
                $ManagerLog->track($log);
                // 


                return true;
            } else {
                $this->setMsg(["msg" => "Error. No se han podido eliminar los profesionales frecuentes", "result" => false]);
                return false;
            }
        } else {
            $this->setMsg(["msg" => "No ha seleccionado profesionales", "result" => false]);
            return false;
        }
    }

    /**
     * Eliminación del flag de medico de cabecera de un medico frecuente
     * @param type $idmedico
     * @param type $forced
     * @return boolean
     */
    public function eliminar_medico_cabecera($idmedico) {

        $paciente = $this->getManager("ManagerPaciente")->getPacienteXHeader();


        $relacion = $this->getByFieldArray(["medico_idmedico", "paciente_idpaciente"], [$idmedico, $paciente["idpaciente"]]);
        if (!$relacion) {
            $this->setMsg(["msg" => "Error. No se pudo eliminar el médico de cabecera", "result" => false]);
            return false;
        }
        $result = parent::update(["medico_cabecera" => 0], $relacion[$this->id]);
        $upd2 = $this->getManager("ManagerPaciente")->basic_update(["medico_cabeza" => 0], $paciente["idpaciente"]);

        if ($result && $upd2) {
            $this->setMsg(["msg" => "Se ha eliminado el médico de cabecera", "result" => true]);

            // <-- LOG
            $log["data"] = "Delete Professional as Medecin Traitant";
            $log["page"] = "Frequent Professionals";
            $log["action"] = "val"; //"val" "vis" "del"
            $log["purpose"] = "Update Frequent Profesionals";

            $ManagerLog = $this->getManager("ManagerLog");
            $ManagerLog->track($log);
            // 
            return true;
        } else {
            $this->setMsg(["msg" => "Error. No se pudo eliminar el médico de cabecera", "result" => false]);
            return false;
        }
    }

    /**
     * Agregar el flag de medico de cabecera de un medico frecuente
     * @param type $idmedico
     * @param type $forced
     * @return boolean
     */
    public function agregar_medico_cabecera($idmedico) {

        $paciente = $this->getManager("ManagerPaciente")->getPacienteXHeader();

        //verificamos si ya tiene un médico de cacebera
        $res = $this->db->getRow("select idprofesionalesFrecuentes_pacientes from $this->table t where medico_cabecera=1 and medico_idmedico=" . $idmedico
                . " and paciente_idpaciente=" . $paciente["idpaciente"]);

        if ($res["idprofesionalesFrecuentes_pacientes"] != "") {
            $this->setMsg(["msg" => "Error. Ya posee un médico de cabecera", "result" => false]);
            return false;
        }
        //creamos o actualizamos la relacion paciente-medico
        $idrelacion = $this->insert(["medico_idmedico" => $idmedico, "paciente_idpaciente" => $paciente["idpaciente"]]);
        if (!$idrelacion) {
            $this->setMsg(["msg" => "Error. No se pudo agregar el médico de cabecera", "result" => false]);
            return false;
        }
        //seteamos el flago de medico cabecera
        $result = parent::update(["medico_cabecera" => 1], $idrelacion);
        $upd2 = $this->getManager("ManagerPaciente")->basic_update(["medico_cabeza" => 1], $paciente["idpaciente"]);

        if ($result && $upd2) {
            $this->setMsg(["msg" => "Se ha agregado el médico de cabecera", "result" => true]);

            // <-- LOG
            $log["data"] = "Add Professional as Medecin Traitant";
            $log["page"] = "Personal information";
            $log["action"] = "val"; //"val" "vis" "del"
            $log["purpose"] = "Add Medecin Traitant";

            $ManagerLog = $this->getManager("ManagerLog");
            $ManagerLog->track($log);
            // 
            return true;
        } else {
            $this->setMsg(["msg" => "Error. No se pudo agregar el médico de cabecera", "result" => false]);
            return false;
        }
    }

    /* Metodo que devuelve si un medico es frecuente de un paciente
     * 
     */

    public function isFrecuente($idmedico, $idpaciente) {

        $query = new AbstractSql();
        $query->setSelect("count(*) as qty");
        $query->setFrom("$this->table");
        $query->setWhere("medico_idmedico=$idmedico and paciente_idpaciente=$idpaciente");
        $rdo = $this->db->getRow($query->getSql());
        return (int) $rdo["qty"] > 0;
    }

    /*     * Metodo que retorna la cantidad de profesionles favoritos y frecuentes que tiene un paciente
     * 
     * @return type
     */

    public function getCantidadFrecuentesFavoritos($idpaciente = null) {

        if (is_null($idpaciente)) {
            $paciente = $this->getManager("ManagerPaciente")->getPacienteXHeader();
            $idpaciente = $paciente["idpaciente"];
        }
        $freq = $this->db->getOne("select count(*) from profesionalesfrecuentes_pacientes where paciente_idpaciente=$idpaciente");
        $fav = $this->db->getOne("select count(*) from profesionalfavorito where paciente_idpaciente=$idpaciente");

        return (int) $fav + (int) $freq;
    }

    /*     * Metodo que retorna el listado de idmedicos frecuentes por un paciente concatenados en formato de string
     * 
     * @param type $idpaciente
     */

    public function getFrecuentes($idpaciente) {
        $query = new AbstractSql();
        $query->setSelect("medico_idmedico");
        $query->setFrom("$this->table");
        $query->setWhere("paciente_idpaciente=$idpaciente");

        $list = $this->getList($query);

        $result = "";
        foreach ($list as $medico) {
            $result .= "," . $medico["medico_idmedico"];
        }

        return substr($result, 1);
    }

}

//END_class
?>