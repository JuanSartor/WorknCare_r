<?php

/**
 * 	Manager de los perfiles de salud de cirugias
 *
 * 	@author Xinergia
 * 	@version 1.0
 * 	@package managers\extensions
 */
class ManagerPerfilSaludCirugias extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Constructor
        parent::__construct($db, "perfilsaludcirugias", "idperfilSaludCirugias");
    }

    public function process($request) {

        $array_insert = array(
            "cirugia", "cuando", "como", "donde", "porque", "paciente_idpaciente"
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
            $request["posee_cirugia"] = 1;
            $this->getManager("ManagerPerfilSaludCirugiasProtesis")->process($request);


            if (isset($request[$this->id])) {
                $this->setMsg(["msg" => "Registro agregado con éxito", "result" => true, "id" => $rdo, "entitie" => $this->get($rdo)]);
            } else {
                $this->setMsg([ "msg" => "Registro actualizado con éxito", "result" => true, "id" => $rdo, "entitie" => $this->get($rdo)]);
            }
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
                
            return $rdo;
        } else {
            return false;
        }
    }

    /**
     * Mpétodo que procesan las modificaciones de los perfiles de salud de cirugías
     * @param type $request
     * @return boolean
     */
    public function processModificaciones($request) {
        //Recorro todo el array de IDs y los mando a procesar


        if (count($request["idperfilSaludCirugias"]) > 0) {
            foreach ($request["idperfilSaludCirugias"] as $key => $value) {
                //El $value es el id
                $array_modificaciones = array(
                    "$this->id" => $value,
                    "cirugia" => $request["cirugia"][$value],
                    "como" => $request["como"][$value],
                    "cuando" => $request["cuando"][$value],
                    "donde" => $request["donde"][$value],
                    "porque" => $request["porque"][$value],
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
            $this->setMsg([ "result" => false, "msg" => "Error. No había cirugías para modificar."]);
            return false;
        }
    }

    /**
     * Método que retorna un listado con las cirugias
     * @param type $idpaciente
     * @return type
     */
    public function getListCirugias($idpaciente) {
        $query = new AbstractSql();

        $query->setSelect("t.*");

        $query->setFrom("$this->table t");

        $query->setWhere("t.paciente_idpaciente = $idpaciente");

        return $this->getList($query);
    }

    public function getInfoTablero($idpaciente) {
        $query = new AbstractSql();

        $query->setSelect("t.*");

        $query->setFrom("$this->table t");

        $query->setWhere("t.paciente_idpaciente = $idpaciente");

        $query->setLimit("0,4");

        $listado_cirugias = $this->getList($query);

        if ($listado_cirugias && count($listado_cirugias) > 0) {
            $info = array();

            foreach ($listado_cirugias as $key => $cirugia) {
                $info[] = $cirugia["cirugia"];
            }

            return $info;
        } else {
            return false;
        }
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
                t.cirugia AS value
            ");

        $query->setFrom("$this->table t");

        $query->setWhere("t.paciente_idpaciente = $idpaciente");

        $tags_inputs = $this->getList($query, false);

        if ($tags_inputs > 0 && count($tags_inputs) > 0) {
            $tag = "";
            foreach ($tags_inputs as $key => $ti) {
                $tag .= "Chirurgies: {$ti["value"]},";
            }
            return $tag;
        } else {
            return false;
        }
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
            $this->setMsg([ "msg" => "Registro actualizado con éxito", "result" => true]);
            return true;
        } else {
            $this->setMsg([ "result" => false, "msg" => "Error. No había cirugías para modificar."]);
            return false;
        }
    }

}

//END_class
?>