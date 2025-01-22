<?php

/**
 * 	Manager de las enfermedades actuales
 *
 * 	@author Xinergia
 * 	@version 1.0
 * 	@package managers\extensions
 */
class ManagerEnfermedadesActuales extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Constructor
        parent::__construct($db, "enfermedadesactuales", "idenfermedadesActuales");
    }

    public function process($request) {

        $array_enfermedades = array(
            "otitis", "infecciones_urinarias", "psicologicas", "dbt"
        );

        //recorro todas las enfermedades y si no están seteadas las pongo vacías
        foreach ($array_enfermedades as $key => $enfermedad) {
            $request[$enfermedad] = isset($request[$enfermedad]) && $request[$enfermedad] != "" ? $request[$enfermedad] : "";
        }


        $this->db->StartTrans();

        $id = parent::process($request);
        if ($id) {

            $request["idenfermedadesActuales"] = $id;


            //Pregunto si viene seteado el valor de ninguno
            if (isset($request["ninguna_patologia"]) && (int) $request["ninguna_patologia"] == 1) {
                //Tengo que borrar todas las patologías cargadas
                $ManagerEnfermedadesActualesTipoEnfermedad = $this->getManager("ManagerEnfermedadesActualesTipoEnfermedad");
                $delete_enfermedad = $ManagerEnfermedadesActualesTipoEnfermedad->deleteFromEnfermedadActual($id);
                if (!$delete_enfermedad) {
                    $this->setMsg([ "msg" => "Se produjo un error al procesar las enfermedades actuales. Verifique los datos ingresados", "result" => false]);
                    $this->db->FailTrans();
                    $this->db->CompleteTrans();
                    return false;
                }

                $ManagerEnfermedadesActualesEnfermedad = $this->getManager("ManagerEnfermedadesActualesEnfermedad");
                $delete_enfermedad = $ManagerEnfermedadesActualesEnfermedad->deleteFromEnfermedadActual($id);

                if (!$delete_enfermedad) {
                    $this->setMsg([ "msg" => "Se produjo un error al procesar las enfermedades actuales. Verifique los datos ingresados", "result" => false]);
                    $this->db->FailTrans();
                    $this->db->CompleteTrans();
                    return false;
                }
            }


            $this->db->CompleteTrans();
            return $id;
        } else {
            $this->setMsg([ "msg" => "Se produjo un error al procesar las enfermedades actuales. Verifique los datos ingresados", "result" => false]);
            $this->db->FailTrans();
            $this->db->CompleteTrans();
            return false;
        }
    }

    public function getInfoTablero($idpaciente) {
        $enfermedad_actual = $this->getByField("paciente_idpaciente", $idpaciente);
       
        if ($enfermedad_actual) {
            $info = array();

            if ( $enfermedad_actual["otitis"] != "") {
              
                $info[] = "Otites";
            }
            if ( $enfermedad_actual["infecciones_urinarias"] == 1) {
                $info[] = "Infections urinaires";
            }
            if ( $enfermedad_actual["psicologicas"] == 1) {
                $info[] = "Soutien psychologique";
            }
            if ( $enfermedad_actual["dbt"] == 1) {
                $info[] = "Diabète";
            }
            if ($enfermedad_actual["virales_otro_tipo"] != "") {
                $info[] = $enfermedad_actual["virales_otro_tipo"];
            }
            //Agrego las enfermedades actuales
            $listado = $this->getListEnfermedadesActuales($idpaciente);
            if ($listado && count($listado) > 0) {
                foreach ($listado as $key => $value) {
                    $info[] = $value["tipoEnfermedad"];
                }
            }

            //Agrego las otras enfermedades
            $ManagerEnfermedadesActualesEnfermedad = $this->getManager("ManagerEnfermedadesActualesEnfermedad");
            $listado_enfermedades = $ManagerEnfermedadesActualesEnfermedad->getListEnfermedadesActualesEnfermedad($idpaciente);
            if ($listado_enfermedades && count($listado_enfermedades) > 0) {
                foreach ($listado_enfermedades as $key => $value) {
                    $info[] = $value["otras_enfermedades"];
                }
            }

            if (count($info) > 0) {
                return $info;
            } else {
                return false;
            }
        } else {
            return false;
        }
    }

    /**
     * Método que retorna los tags inputs de las enfermedades
     * @param type $idpaciente
     * @return type
     */
    public function getTagsInputs($idpaciente) {

        $query = new AbstractSql();

        $query->setSelect("
                ea.idenfermedadesActuales_tipoEnfermedad AS id,
                te.tipoEnfermedad AS value
            ");

        $query->setFrom("
                       $this->table t
                           INNER JOIN enfermedadesactuales_tipoenfermedad ea ON (t.idenfermedadesActuales = ea.enfermedadesActuales_idenfermedadesActuales)
                           INNER JOIN tipoenfermedad te ON (ea.tipoEnfermedad_idtipoEnfermedad = te.idtipoEnfermedad)
            ");

        $query->setWhere("t.paciente_idpaciente = {$idpaciente}");

        $tags_inputs = $this->getList($query, false);

        $query2 = new AbstractSql();

        $query2->setSelect("
                ee.idenfermedadesActuales_enfermedad AS id,
                ee.otras_enfermedades AS value
            ");

        $query2->setFrom("
                       $this->table t
                           INNER JOIN enfermedadesactuales_enfermedad ee ON (t.idenfermedadesActuales = ee.enfermedadesActuales_idenfermedadesActuales)
            ");

        $query2->setWhere("t.paciente_idpaciente = {$idpaciente}");

        $tags_inputs2 = $this->getList($query2, false);

        $array_return = array();
        $i = 0;
        if (count($tags_inputs) > 0) {
            foreach ($tags_inputs as $key => $ti) {
                $array_return[$i]["value"] = $ti["value"];
                $array_return[$i]["id"] = "'1-{$ti["id"]}'";
                $i++;
            }
        }

        if (count($tags_inputs2) > 0) {
            foreach ($tags_inputs2 as $key2 => $ti2) {
                $array_return[$i]["value"] = ($ti2["value"]);
                $array_return[$i]["id"] = "'2-{$ti2["id"]}'";
                $i++;
            }
        }

        return $array_return;
    }

    /**
     * Método utilizado para eliminar la patología familiar
     * @param type $request
     * @return boolean
     */
    public function deletePatologiaFamiliar($request) {

        $explode = explode("-", $request["id"]);

        if ($explode[0] == "1") {
            //Si es uno debo eliminar EnfermedadesActuales_TipoEnfermedad
            $ManagerEnfermedadesActualesTipoEnfermedad = $this->getManager("ManagerEnfermedadesActualesTipoEnfermedad");
            $delete = $ManagerEnfermedadesActualesTipoEnfermedad->delete($explode[1]);
            if ($delete) {
                $this->setMsg([ "msg" => "Registro eliminado con éxito", "result" => true]);
                return true;
            }
        } elseif ($explode[0] == "2") {
            //Si es uno debo eliminar EnfermedadesActuales_Enfermedad
            $ManagerEnfermedadesActualesEnfermedad = $this->getManager("ManagerEnfermedadesActualesEnfermedad");
            $delete = $ManagerEnfermedadesActualesEnfermedad->delete($explode[1]);
            if ($delete) {
                $this->setMsg([ "msg" => "Registro eliminado con éxito", "result" => true]);
                return true;
            }
        }
        $this->setMsg([ "msg" => "Error. ", "result" => false]);
        return false;
    }

    /**
     * Retorna los valores de Enfermedades actuales
     * @param type $idpaciente
     */
    public function getTagsInputsMenuMedico($idpaciente) {
        $info_tablero = $this->getInfoTablero($idpaciente);
    
        $tags_inputs = "";

        if ($info_tablero) {
            foreach ($info_tablero as $key => $value) {
                $tags_inputs .= "{$value},";
            }
        }

        return $tags_inputs;
    }

    /**
     * Método que obtiene la relación entre el paciente y las enfermedades pasadas como ID
     * 
     * @param type $idenfermedades : ids de enfermedades separados por comas
     * @param type $idpaciente
     * @return boolean
     */
    public function getByEnfermedades($idenfermedades, $idpaciente) {

        $query = new AbstractSql();

        $query->setSelect("t.*");

        $query->setFrom("$this->table t 
                                    INNER JOIN enfermedadesactuales_tipoenfermedad ea ON (ea.enfermedadesActuales_idenfermedadesActuales = t.$this->id)
                                    INNER JOIN tipoenfermedad te ON (te.idtipoEnfermedad = ea.tipoEnfermedad_idtipoEnfermedad) ");

        $query->setWhere("te.enfermedad_idenfermedad IN ($idenfermedades)");

        $query->addAnd("t.paciente_idpaciente = $idpaciente");

        return $this->getList($query);
    }

    /**
     * Listado de las enfermedades actuales pertenecientes a un paciente
     * @param type $idpaciente
     * @return type
     */
    public function getListEnfermedadesActuales($idpaciente) {
        $query = new AbstractSql();

        $query->setSelect("
                ea.idenfermedadesActuales_tipoEnfermedad AS id,
                te.tipoEnfermedad
            ");

        $query->setFrom("
                       $this->table t
                           INNER JOIN enfermedadesactuales_tipoenfermedad ea ON (t.idenfermedadesActuales = ea.enfermedadesActuales_idenfermedadesActuales)
                           INNER JOIN tipoenfermedad te ON (ea.tipoEnfermedad_idtipoEnfermedad = te.idtipoEnfermedad)
            ");

        $query->setWhere("t.paciente_idpaciente = {$idpaciente}");

        return $this->getList($query);
    }

}

//END_class
?>