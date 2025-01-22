<?php

/**
 * 	@autor Xinergia
 * 	Manager de los tipos de familiar
 *
 */
class ManagerAntecedentesPatologiaFamiliar extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {
        // Llamamos al constructor del a superclase
        parent::__construct($db, "antecedentes_patologiafamiliar", "idantecedentes_patologiaFamiliar");
    }

    /**
     * Método que asocia un familiar a una patología
     * Corrobora que ya no exista esa patología para ese paciente
     * @param type $request
     * @return boolean
     */
    public function addAntecedentePatologiaFamiliar($request) {

        $ManagerPerfilSaludAntecedentes = $this->getManager("ManagerPerfilSaludAntecedentes");
        if (!isset($request["perfilSaludAntecedentes_idperfilSaludAntecedentes"]) || $request["perfilSaludAntecedentes_idperfilSaludAntecedentes"] == "") {



            //Tengo que ingresar el ID si es que no viene
            $rdo = $ManagerPerfilSaludAntecedentes->process($request);
            if (!$rdo) {
                $this->setMsg([ "msg" => "Se produjo un error al ingresar los datos", "result" => false]);
                return false;
            } else {
                $request["perfilSaludAntecedentes_idperfilSaludAntecedentes"] = $rdo;
            }
        }

        $rdo = $this->getPatologia($request["paciente_idpaciente"], $request["tipoFamiliar_idtipoFamiliar"], $request["tipoPatologia_idtipoPatologia"]);

        if (!$rdo) {
            $insert = parent::insert($request);

            if ($insert) {

                 // <-- LOG
                $log["data"] = "Update register Family issues";
                $log["page"] = "Health Profile";
                $log["action"] = "val"; //"val" "vis" "del"
                $log["purpose"] = "See information Health Profile";
                //
                //        
                $ManagerLog = $this->getManager("ManagerLog");
                $ManagerLog->track($log);
                // <--

                //actualizamos el status del perfil cuando se registra un cambio
                $ManagerPerfilSaludAntecedentes->update(["posee_antecedentesfamiliares" => 1], $request["perfilSaludAntecedentes_idperfilSaludAntecedentes"]);

                $this->getManager("ManagerPerfilSaludStatus")->actualizarStatus($request["paciente_idpaciente"]);

                $this->setMsg([ "msg" => "Registro actualizado con éxito", "result" => true, "id" => $insert
                ]);
                return $insert;
            } else {
                $this->setMsg([ "msg" => "Error. No se pudo ingresar la patología", "result" => false,]);
                return false;
            }
        } else {
            $this->setMsg([ "msg" => "Error. El antecedente ya está registrado para el paciente", "result" => false,]);
            return false;
        }
    }

    /**
     * Método que retorna la patología perteneciente al tipo de familiar y tipo de patologia
     * @param type $idpaciente
     * @param type $idtipoFamiliar
     * @param type $idtipoPatologia
     * @return boolean
     */
    private function getPatologia($idpaciente, $idtipoFamiliar, $idtipoPatologia) {

        $query = new AbstractSql();

        $query->setSelect("*");

        $query->setFrom("antecedentes_patologiafamiliar t
                                INNER JOIN tipofamiliar tf ON (t.tipoFamiliar_idtipoFamiliar = tf.idtipoFamiliar)
                                INNER JOIN tipopatologia tp ON (t.tipoPatologia_idtipoPatologia = tp.idtipoPatologia)
                                INNER JOIN perfilsaludantecedentes psa ON (t.perfilSaludAntecedentes_idperfilSaludAntecedentes = psa.idperfilSaludAntecedentes)
                    ");

        $query->setWhere("t.tipoFamiliar_idtipoFamiliar = $idtipoFamiliar");

        $query->addAnd("t.tipoPatologia_idtipoPatologia = $idtipoPatologia");

        $query->addAnd("psa.paciente_idpaciente = $idpaciente");

        $execute = $this->db->Execute($query->getSql());

        if ($execute) {
            return $execute->FetchRow();
        } else {
            return false;
        }
    }

    /**
     *  Todas las obras sociales que trabaja un medico
     *
     * */
    public function getTagsInputs($idpaciente) {

        $query = new AbstractSql();

        $query->setSelect("
                t.$this->id AS id ,
                CONCAT(tf.tipoFamiliar, ' - ', tp.tipoPatologia) AS value
            ");

        $query->setFrom("
                       $this->table t
                                INNER JOIN tipofamiliar tf ON (t.tipoFamiliar_idtipoFamiliar = tf.idtipoFamiliar)
                                INNER JOIN tipopatologia tp ON (t.tipoPatologia_idtipoPatologia = tp.idtipoPatologia)
                                INNER JOIN perfilsaludantecedentes psa ON (t.perfilSaludAntecedentes_idperfilSaludAntecedentes = psa.idperfilSaludAntecedentes)
            ");

        $query->setWhere("psa.paciente_idpaciente = $idpaciente");

        $tags_inputs = $this->getList($query, false);

        foreach ($tags_inputs as $key => $ti) {
            $tags_inputs[$key]["value"] = ($ti["value"]); // FIX 20160406 (seba) Quite el utf8 decode. ver si no afecta luego a otras cosas
        }

        return $tags_inputs;
    }

    /**
     * Métoodo que retorna el tipo de familiar y el tipo de patología para el paciente...
     * @param type $idpaciente
     * @return string|boolean
     */
    public function getTagsInputsMenuMedico($idpaciente) {
        $query = new AbstractSql();

        $query->setSelect("
                t.$this->id AS id ,
                CONCAT(tf.tipoFamiliar, ' - ', tp.tipoPatologia) AS value
            ");

        $query->setFrom("
                       $this->table t
                                INNER JOIN tipofamiliar tf ON (t.tipoFamiliar_idtipoFamiliar = tf.idtipoFamiliar)
                                INNER JOIN tipopatologia tp ON (t.tipoPatologia_idtipoPatologia = tp.idtipoPatologia)
                                INNER JOIN perfilsaludantecedentes psa ON (t.perfilSaludAntecedentes_idperfilSaludAntecedentes = psa.idperfilSaludAntecedentes)
            ");

        $query->setWhere("psa.paciente_idpaciente = $idpaciente");

        $tags_inputs = $this->getList($query, false);

        if ($tags_inputs > 0 && count($tags_inputs) > 0) {
            $tag = "";
            foreach ($tags_inputs as $key => $ti) {
                $tag .= $ti["value"] . ",";
            }
            return $tag;
        } else {
            return false;
        }
    }

    /*     * Metodo que elimina un registro de antecedentes familiar
     * 
     * @param type $id
     * @param type $force
     */

    public function delete($id, $force = false) {
        $patologia = $this->get($id);
        $perfilSaludAntecedentes = $this->getManager("ManagerPerfilSaludAntecedentes")->get($patologia["perfilSaludAntecedentes_idperfilSaludAntecedentes"]);
        
        parent::delete($id, $force);
        
        // <-- LOG
        $log["data"] = "Update register Family issues";
        $log["page"] = "Health Profile";
        $log["action"] = "val"; //"val" "vis" "del"
        $log["purpose"] = "See information Health Profile";
        //
        //        
        $ManagerLog = $this->getManager("ManagerLog");
        $ManagerLog->track($log);
        // <--
        $this->getManager("ManagerPerfilSaludStatus")->actualizarStatus($perfilSaludAntecedentes["paciente_idpaciente"]);
    }

}

//END_class
?>