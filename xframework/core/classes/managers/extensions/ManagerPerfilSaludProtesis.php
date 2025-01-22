<?php

/**
 * 	Manager de los perfiles de salud de prótesis
 *
 * 	@author Xinergia
 * 	@version 1.0
 * 	@package managers\extensions
 */
class ManagerPerfilSaludProtesis extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Constructor
        parent::__construct($db, "perfilsaludprotesis", "idperfilSaludProtesis");
    }

    public function process($request) {

        $array_insert = array(
            "tipo_aparato", "desde_cuando", "paciente_idpaciente"
        );

        //recorro todas las enfermedades y si no están seteadas las pongo vacías
        foreach ($array_insert as $key => $row) {
            if (!isset($request[$row]) || $request[$row] == "") {
                $this->setMsg([ "result" => false, "msg" => "Error. Verifique los campos obligatorios."]);
                return false;
            }
        }

        $rdo = parent::process($request);

        if ($rdo) {
            $request["posee_protesis"] = 1;
            $this->getManager("ManagerPerfilSaludCirugiasProtesis")->process($request);


            if (isset($request[$this->id])) {
                // <-- LOG
                $log["data"] = "Update register Chirurgical operations, prothese";
                $log["page"] = "Health Profile";
                $log["action"] = "val"; //"val" "vis" "del"
                $log["purpose"] = "See information Health Profile";
                //
                //        
                $ManagerLog = $this->getManager("ManagerLog");
                $ManagerLog->track($log);
                // <--
            
                $this->setMsg([ "msg" => "Registro actualizado con éxito", "result" => true, "id" => $rdo, "entitie" => $this->get($rdo)]);
            } else {
                $this->setMsg([ "msg" => "Registro agregado con éxito", "result" => true, "id" => $rdo, "entitie" => $this->get($rdo)]);
            }


            return $rdo;
        } else {
            return false;
        }
    }

    /**
     * Mpétodo que procesan las modificaciones de los perfiles de salud de prótesis
     * @param type $request
     * @return boolean
     */
    public function processModificaciones($request) {
        //Recorro todo el array de IDs y los mando a procesar


        if (count($request["idperfilSaludProtesis"]) > 0) {

            foreach ($request["idperfilSaludProtesis"] as $key => $value) {
                //El $value es el id
                $array_modificaciones = array(
                    "$this->id" => $value,
                    "tipo_aparato" => $request["tipo_aparato"][$value],
                    "desde_cuando" => $request["desde_cuando"][$value],
                    "paciente_idpaciente" => $request["paciente_idpaciente"]
                );


                $rdo = $this->process($array_modificaciones);

                if (!$rdo) {
                    return false;
                }
            }

            $this->setMsg([ "msg" => "Registro actualizado con éxito", "result" => true]);
            return true;
        } else {
            $this->setMsg([ "result" => false, "msg" => "Error. No había prótesis para modificar."]);
            return false;
        }
    }

    /**
     * Métoodo que retorna los tags para las prótesis.
     * @param type $idpaciente
     * @return string|boolean
     */
    public function getTagsInputsMenuMedico($idpaciente) {
        $query = new AbstractSql();

        $query->setSelect("
                t.$this->id AS id ,
                t.tipo_aparato AS value
            ");

        $query->setFrom("$this->table t");

        $query->setWhere("t.paciente_idpaciente = $idpaciente");

        $tags_inputs = $this->getList($query, false);

        if ($tags_inputs > 0 && count($tags_inputs) > 0) {
            $tag = "";
            foreach ($tags_inputs as $key => $ti) {
                $tag .= "Prothèse: {$ti["value"]},";
            }
            return $tag;
        } else {
            return false;
        }
    }

    /**
     * Método que retorna un listado con las cirugias
     * @param type $idpaciente
     * @return type
     */
    public function getListProtesis($idpaciente) {
        $query = new AbstractSql();

        $query->setSelect("t.*");

        $query->setFrom("$this->table t");

        $query->setWhere("t.paciente_idpaciente = $idpaciente");

        return $this->getList($query);
    }

    /**
     * Elimina todas las cirugias pertenecientes a un paciente
     * Esto ocurre cuando en el perfil de cirugias pone que no posee cirugias..
     * @param type $request
     * @return boolean
     */
    public function deleteAll($request) {
        $idpaciente = $request["id"];

        $delete = "DELETE FROM $this->table WHERE paciente_idpaciente = $idpaciente";
        
        $execute = $this->db->Execute($delete);

        if ($execute) {
            
            // <-- LOG
            $log["data"] = "Update register Chirurgical operations, prothese";
            $log["page"] = "Health Profile";
            $log["action"] = "val"; //"val" "vis" "del"
            $log["purpose"] = "See information Health Profile";
            //
            //        
            $ManagerLog = $this->getManager("ManagerLog");
            $ManagerLog->track($log);
            // <--
                
            $this->setMsg([ "msg" => "Registro actualizado con éxito", "result" => true]);
            return true;
        } else {
            $this->setMsg([ "result" => false, "msg" => "Error. No había prótesis para modificar."]);
            return false;
        }
    }

}

//END_class
?>