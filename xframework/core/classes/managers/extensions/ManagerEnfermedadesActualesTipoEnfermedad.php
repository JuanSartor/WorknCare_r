<?php

/**
 * 	Manager de las Enfermedades Actuales Tipo Enfermedad
 *
 * 	@author Xinergia
 * 	@version 1.0
 * 	@package managers\extensions
 */
class ManagerEnfermedadesActualesTipoEnfermedad extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Constructor
        parent::__construct($db, "enfermedadesactuales_tipoenfermedad", "idenfermedadesActuales_tipoEnfermedad");
    }

    /**
     * Procesamiento de las enfermedades actuales correspondientes al FrontEnd de enfermedades
     * @param type $request
     * @return boolean
     */
    public function processFromEnfermedadesActuales($request) {

        //Voy a recibir un array con los valores de los tipos de enfermedades seteadas por el usuario..
        //Tmb va a haber otro array con el otro referida a esa enfermedad..
        if (isset($request["tipo_enfermedades"]) && count($request["tipo_enfermedades"]) > 0) {
            $array_insert = array(
                "enfermedadesActuales_idenfermedadesActuales" => $request["idenfermedadesActuales"]
            );

            //Busco la enfermedad Actual relacionada a su id
            $ManagerEnfermedadesActuales = $this->getManager("ManagerEnfermedadesActuales");
            $enfermedad_actual = $ManagerEnfermedadesActuales->get($request["idenfermedadesActuales"]);

            //Recorro los tipo_enfermedades : son los combos
            foreach ($request["tipo_enfermedades"] as $key => $tipo_enfermedad) {
                //Voy insertando los tipos de enfermedades
                if ((int) $tipo_enfermedad > 0) {
                    $array_insert["tipoEnfermedad_idtipoEnfermedad"] = $tipo_enfermedad;

                    //Me fijo si hay alguna enfermedad
                    $get_this = $this->getXRelacion($tipo_enfermedad, $request["idenfermedadesActuales"]);

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
                }
            }

            //Recorro todos los tipos de enfermedad que no estén
            $listado_not_in = $this->getListadoNotIn($request["tipo_enfermedades"], $request["idenfermedadesActuales"], false);
            if ($listado_not_in && count($listado_not_in) > 0) {
                foreach ($listado_not_in as $key => $value) {
                    $delete = parent::delete($value[$this->id]);
                    if (!$delete) {
                        return false;
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

        if ((int) $request["idtipoEnfermedad"] > 0 && $idpaciente) {
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
                //Verifico que no haya una relación existente
                $relacion = $this->getXRelacion($request["idtipoEnfermedad"], $enfermedad_actual["idenfermedadesActuales"]);

                if (!$relacion) {
                    $insert = parent::insert([
                                "tipoEnfermedad_idtipoEnfermedad" => $request["idtipoEnfermedad"],
                                "enfermedadesActuales_idenfermedadesActuales" => $enfermedad_actual["idenfermedadesActuales"]
                    ]);

                    if ($insert) {
                        $ManagerTipoEnfermedad = $this->getManager("ManagerTipoEnfermedad");
                        $tipo_enfermedad = $ManagerTipoEnfermedad->get($request["idtipoEnfermedad"]);
                        $this->setMsg([ "msg" => "Registro creado con éxito", "result" => true, "id" => "1-{$insert}", "tipoEnfermedad" => $tipo_enfermedad["tipoEnfermedad"]]);
                        return $insert;
                    }
                } else {

                    $this->setMsg([ "msg" => "Error. Se encuentra cargada la enferdad seleccionada", "result" => false]);
                }
            }
        } else {

            $this->setMsg([ "msg" => "Error. Verifique los datos.", "result" => false]);
        }

        //Si se produjo un error retorno false

        return false;
    }

    /**
     * Relación 
     * @param type $idtipo_enfermedad
     * @param type $idenfermedadesActuales
     * @return type
     */
    public function getXRelacion($idtipo_enfermedad, $idenfermedadesActuales) {
        $query = new AbstractSql();
        $query->setSelect("*");
        $query->setFrom("$this->table");
        $query->setWhere("tipoEnfermedad_idtipoEnfermedad = $idtipo_enfermedad");
        $query->addAnd("enfermedadesActuales_idenfermedadesActuales = $idenfermedadesActuales");

        return $this->db->GetRow($query->getSql());
    }

    /**
     * Método que recibe un listado, donde los keys del listado son los $this->id...
     * retorna un listado de NOT IN en esos id´s
     * 
     * @param type $listado
     * @return boolean
     */
    public function getListadoNotIn($listado, $idenfermedadesActuales) {
        if (count($listado) > 0) {
            $not_in = "";
            foreach ($listado as $key => $valor) {
                //Si es enfermedad, va la clave que es el Id de la misma.. Sino el valor que es el id del tipo de enfermedad

                if ((int) $valor > 0) {
                    $not_in .= ", $valor";
                }
            }

            if ($not_in != "") {

                $not_in = substr($not_in, 1);

                $query = new AbstractSql();
                $query->setSelect("
                            *
                         ");
                $query->setFrom("
                            $this->table t 
                        ");

                $query->setWhere("enfermedadesActuales_idenfermedadesActuales = $idenfermedadesActuales");


                $query->addAnd("tipoEnfermedad_idtipoEnfermedad NOT IN ($not_in)");


                return $this->getList($query);
            }
        } else {
            return false;
        }
    }

    /**
     * Método que obtiene la relación entre las enfermedades actuales y las enfermedades 
     * 
     * @param type $idenfermedad
     * @param type $idpaciente
     * @return boolean
     */
    public function getByTipoEnfermedad($idenfermedad, $idpaciente) {
        $ManagerEnfermedadesActuales = $this->getManager("ManagerEnfermedadesActuales");
        $enfermedad_actual = $ManagerEnfermedadesActuales->getByField("paciente_idpaciente", $idpaciente);

        if ($enfermedad_actual) {
            $query = new AbstractSql();

            $query->setSelect("t.*");

            $query->setFrom("$this->table t 
                                    INNER JOIN tipoenfermedad te ON (t.tipoEnfermedad_idtipoEnfermedad = te.idtipoEnfermedad) ");

            $query->setWhere("te.enfermedad_idenfermedad = $idenfermedad");

            $query->addAnd("t.enfermedadesActuales_idenfermedadesActuales = " . $enfermedad_actual["idenfermedadesActuales"]);

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
     * Envío tags inputs del médico
     * @param type $idpaciente
     * @return boolean
     */
    public function getTagsInputsMenuMedico($idpaciente) {
        $ManagerEnfermedadesActuales = $this->getManager("ManagerEnfermedadesActuales");
        $enfermedad_actual = $ManagerEnfermedadesActuales->getByField("paciente_idpaciente", $idpaciente);

        if ($enfermedad_actual) {
            $query = new AbstractSql();

            $query->setSelect("t.*, te.*");

            $query->setFrom("$this->table t 
                                    INNER JOIN tipoenfermedad te ON (t.tipoEnfermedad_idtipoEnfermedad = te.idtipoEnfermedad) ");

            $query->addAnd("t.enfermedadesActuales_idenfermedadesActuales = " . $enfermedad_actual["idenfermedadesActuales"]);

            $listado = $this->getList($query);
            if ($listado && count($listado) > 0) {
                $tags_inputs = "";

                foreach ($listado as $key => $value) {
                    $tags_inputs .= $value["tipoEnfermedad"] . ",";
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
     * Eliminación de la enfermedad actual
     * @param type $idenfermedadActual
     * @return type
     */
    public function deleteFromEnfermedadActual($idenfermedadActual) {
        $delete = "DELETE FROM {$this->table} WHERE enfermedadesActuales_idenfermedadesActuales = {$idenfermedadActual}";

        return $this->db->Execute($delete);
    }

}

//END_class
?>