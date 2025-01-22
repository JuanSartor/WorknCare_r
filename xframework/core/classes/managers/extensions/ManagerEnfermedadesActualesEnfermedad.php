<?php

/**
 * 	Manager de las Enfermedades Actuales Tipo Enfermedad
 *
 * 	@author Xinergia
 * 	@version 1.0
 * 	@package managers\extensions
 */
class ManagerEnfermedadesActualesEnfermedad extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Constructor
        parent::__construct($db, "enfermedadesactuales_enfermedad", "idenfermedadesActuales_enfermedad");
    }

    /**
     * Procesamiento de las enfermedades actuales correspondientes al FrontEnd de enfermedades
     * @param type $request
     * @return boolean
     */
    public function processFromEnfermedadesActuales($request) {

        //otras_enfermedades[{$enfermedad.idenfermedad}]
        if (isset($request["otras_enfermedades"]) && count($request["otras_enfermedades"]) > 0) {
            //Elimino el tipo de enfermedad
            $array_insert = array(
                "enfermedadesActuales_idenfermedadesActuales" => $request["idenfermedadesActuales"]
            );

            $ManagerEnfermedadesActuales = $this->getManager("ManagerEnfermedadesActuales");
            $enfermedad_actual = $ManagerEnfermedadesActuales->get($request["idenfermedadesActuales"]);

            //Recorro todas las otras enfermedades $request["otras_enfermedades"][idEnfermedades]="otra_enfermedad"
            foreach ($request["otras_enfermedades"] as $key => $otra_enfermedad) {
                if ($otra_enfermedad != "") {
                    //Si hay algo escrito en el input
                    $array_insert["enfermedad_idenfermedad"] = $key;
                    $array_insert["otras_enfermedades"] = $otra_enfermedad;

                    //Me fijo si hay alguna enfermedad
                    $get_this = $this->getByEnfermedad($key, $enfermedad_actual["paciente_idpaciente"]);

                    if ($get_this) {
                        //Si hay actualizo
                        $rdo = parent::update($array_insert, $get_this[$this->id]);
                    } else {
                        //Si no hay inserto
                        $rdo = parent::insert($array_insert);
                    }

                    if (!$rdo) {
                        return false;
                    }
                } else {
                    $get_this = $this->getByEnfermedad($key, $enfermedad_actual["paciente_idpaciente"]);
                    if ($get_this) {
                        $delete = parent::delete($get_this[$this->id], true);
                        if (!$delete) {
                            return false;
                        }
                    }
                }
            }
        }
        return true;
    }

    public function processFromPatologias($request) {
        $ManagerPaciente = $this->getManager("ManagerPaciente");
        if (CONTROLLER == "medico") {
            //Paciente que se encuentra en el array de SESSION de header paciente
            $paciente = $ManagerPaciente->getPacienteXSelectMedico();
            $idpaciente = $paciente["idpaciente"];
        } elseif (CONTROLLER == "paciente_p") {
            $paciente = $ManagerPaciente->getPacienteXHeader();
            $idpaciente = $paciente["idpaciente"];
        } else {
            $idpaciente = $request["idpaciente"];
        }

        if ($request["otro_tipo_enfermedad"] != "" && $idpaciente != "") {

            $ManagerEnfermedadesActuales = $this->getManager("ManagerEnfermedadesActuales");
            $enfermedad_actual = $ManagerEnfermedadesActuales->getByField("paciente_idpaciente", $idpaciente);

            if (!$enfermedad_actual) {

                //La creo
                $insertEnfermedadActual = $ManagerEnfermedadesActuales->insert([
                    "paciente_idpaciente" => $paciente["idpaciente"]
                ]);
                if ($insertEnfermedadActual) {
                    $enfermedad_actual = $ManagerEnfermedadesActuales->getByField("paciente_idpaciente", $idpaciente);
                } else {

                    $this->setMsg([ "msg" => "Error. No se pudo insertar la enfermedad.", "result" => false]);
                }
            }

            if ($enfermedad_actual) {

                $insert = parent::insert([
                            "enfermedad_idenfermedad" => $request["idenfermedad"],
                            "enfermedadesActuales_idenfermedadesActuales" => $enfermedad_actual["idenfermedadesActuales"],
                            "otras_enfermedades" => $request["otro_tipo_enfermedad"]
                ]);

                if ($insert) {
                    $ManagerTipoEnfermedad = $this->getManager("ManagerTipoEnfermedad");
                    $tipo_enfermedad = $ManagerTipoEnfermedad->get($request["idtipoEnfermedad"]);
                    $this->setMsg([ "msg" => "Registro creado con éxito", "result" => true, "id" => "2-{$insert}", "tipoEnfermedad" => $tipo_enfermedad["tipoEnfermedad"]]);
                    return $insert;
                }
            }
        } else {
            
        }

        //Si se produjo un error retorno false

        return false;
    }

    /**
     * Método que obtiene la relación entre las enfermedades actuales y las enfermedades 
     * 
     * @param type $idenfermedad
     * @param type $idpaciente
     * @return boolean
     */
    public function getByEnfermedad($idenfermedad, $idpaciente) {
        $ManagerEnfermedadesActuales = $this->getManager("ManagerEnfermedadesActuales");
        $enfermedad_actual = $ManagerEnfermedadesActuales->getByField("paciente_idpaciente", $idpaciente);

        if ($enfermedad_actual) {
            $query = new AbstractSql();

            $query->setSelect("*");

            $query->setFrom("$this->table t ");

            $query->setWhere("enfermedad_idenfermedad = $idenfermedad");

            $query->addAnd("enfermedadesActuales_idenfermedadesActuales = " . $enfermedad_actual["idenfermedadesActuales"]);

            $execute = $this->db->Execute($query->getSql());

            if ($execute) {
                return $execute->FetchRow();
            } else {
                return false;
            }
        } else {
            return false;
        }
    }

    /**
     * Eliminación de la enfermedad actual
     * @param type $idenfermedadActual
     * @return type
     */
    public function deleteFromEnfermedadActual($idenfermedadActual) {
        $delete = "DELETE FROM {$this->table} WHERE enfermedadesActuales_idenfermedadesActuales = {$idenfermedadActual}";

        return $this->db->Execute($delete);
    }

    /**
     * Envío tags inputs del médico
     * @param type $idpaciente
     * @return boolean
     */
    public function getTagsInputsMenuMedico($idpaciente) {
        $ManagerEnfermedadesActuales = $this->getManager("ManagerEnfermedadesActuales");
        $enfermedad_actual = $ManagerEnfermedadesActuales->getByField("paciente_idpaciente", $idpaciente);

        if ($enfermedad_actual) {
            $query = new AbstractSql();

            $query->setSelect("t.*");

            $query->setFrom("$this->table t ");

            $query->addAnd("t.enfermedadesActuales_idenfermedadesActuales = " . $enfermedad_actual["idenfermedadesActuales"]);

            $listado = $this->getList($query);

            if ($listado && count($listado) > 0) {
                $tags_inputs = "";

                foreach ($listado as $key => $value) {
                    $tags_inputs .= $value["otras_enfermedades"] . ",";
                }

                return $tags_inputs;
            } else {
                return false;
            }
        } else {
            return false;
        }
    }

    /**
     * Listado de las enfermedades actuales pertenecientes a un paciente
     * @param type $idpaciente
     * @return type
     */
    public function getListEnfermedadesActualesEnfermedad($idpaciente) {
        $query = new AbstractSql();

        $query->setSelect("
                ee.idenfermedadesActuales_enfermedad AS id,
                ee.otras_enfermedades
            ");

        $query->setFrom("
                       enfermedadesactuales t
                           INNER JOIN enfermedadesactuales_enfermedad ee ON (t.idenfermedadesActuales = ee.enfermedadesActuales_idenfermedadesActuales)
            ");

        $query->setWhere("t.paciente_idpaciente = {$idpaciente}");

        return $this->getList($query);
    }

}

//END_class
?>