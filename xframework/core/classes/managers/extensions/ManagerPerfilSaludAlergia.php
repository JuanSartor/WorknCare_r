<?php

/**
 * 	Manager del perfil de salud alergia
 *
 * 	@author Xinergia
 * 	@version 1.0
 * 	@package managers\extensions
 */
class ManagerPerfilSaludAlergia extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Constructor
        parent::__construct($db, "perfilsaludalergia", "idperfilSaludAlergia");
    }

    public function process($request) {


        $request["intolerancia_alimentos"] = isset($request["check_intolerancia_alimentos"]) && $request["check_intolerancia_alimentos"] != "" ? $request["intolerancia_alimentos"] : "";
        $request["intolerancia_medicamentos"] = isset($request["check_intolerancia_medicamentos"]) && $request["check_intolerancia_medicamentos"] != "" ? $request["intolerancia_medicamentos"] : "";
        $request["intolerancia_insecto"] = isset($request["check_intolerancia_insecto"]) && $request["check_intolerancia_insecto"] != "" ? $request["intolerancia_insecto"] : "";
        $request["intolerancia_otros"] = isset($request["check_intolerancia_otros"]) && $request["check_intolerancia_otros"] != "" ? $request["intolerancia_otros"] : "";

        $request["posee_causa_intolerancia"] = isset($request["posee_causa_intolerancia"]) ? $request["posee_causa_intolerancia"] : "";
        $request["posee_intolerancia"] = isset($request["posee_intolerancia"]) ? $request["posee_intolerancia"] : "";
        $request["posee_anafilaxia"] = isset($request["posee_anafilaxia"]) && (int) $request["posee_anafilaxia"] == 1 ? 1 : 0;


        if ($request["posee_causa_intolerancia"] == "" && $request["posee_intolerancia"] == "") {
            $this->setMsg([ "result" => false, "msg" => "Error. Debe seleccionar al menos una de las opciones"]);
            return false;
        }

//verificamos que si posee alergias seleccione al menos una

        if ($request["posee_causa_intolerancia"] == 1 && count($request["check_sta"]) == 0 && $request["posee_anafilaxia"] == 0) {
            $this->setMsg([ "result" => false, "msg" => "Seleccione al menos una alergia o intolerancia"]);
            return false;
        }

        //verificamos que si se conoce la causa, se seleccione una
        if ($request["posee_causa_intolerancia"] == 1 && !(isset($request["check_intolerancia_alimentos"]) || isset($request["check_intolerancia_medicamentos"]) ||
                isset($request["check_intolerancia_insecto"]) || isset($request["check_intolerancia_otros"]) )) {
            $this->setMsg([ "result" => false, "msg" => "Ingrese al menos un agente produce su alergia o intolerancia"]);
            return false;
        }

        //verificamos que si se selecciono una intolerancia poseea el texto descriptivo
        if ((($request["check_intolerancia_alimentos"] == 1 && $request["intolerancia_alimentos"] == "") || ($request["check_intolerancia_medicamentos"] == 1 && $request["intolerancia_medicamentos"] == "") ||
                ($request["check_intolerancia_insecto"] == 1 && $request["intolerancia_insecto"] == "" ) || ($request["check_intolerancia_otros"] == 1 && $request["intolerancia_otros"] == ""))) {
            $this->setMsg([ "result" => false, "msg" => "Ingrese una descripción del agente que produce su alergia o intolerancia"]);
            return false;
        }


        $this->db->StartTrans();
        //verifico si ya existe una entrada creada
        $perfilAlergia = $this->getByField("paciente_idpaciente", $request["paciente_idpaciente"]);
        if ($perfilAlergia["idperfilSaludAlergia"] != "") {
            $request["idperfilSaludAlergia"] = $perfilAlergia["idperfilSaludAlergia"];
        }
        $rdo = parent::process($request);

        //actualizamos el estado del perfil de salud al modificar un campo
        $this->getManager("ManagerPerfilSaludStatus")->actualizarStatus($request["paciente_idpaciente"]);



        if (!$rdo) {
            $this->db->FailTrans();
            $this->db->CompleteTrans();
            $this->setMsg([ "result" => false, "msg" => "Se produjo un error, verifique los datos"]);
            return false;
        } else {
            //verificamos que si se selecciona OTROS, se ingrese el texto

            foreach ($request["check_sta_otros"] as $key => $otro) {
                if ($otro == "" && $request["check_sta"][$key] == 1) {

                    $this->db->FailTrans();
                    $this->db->CompleteTrans();
                    $this->setMsg(["result" => false, "msg" => "Ingrese una descripción en el tipo de alergia Otros"]);

                    return false;
                }
            }


            //Si se procesó correctamente, tengo que procesar los tipos de alergias y subtipos de alergias
            $request[$this->id] = $rdo;
            $ManagerPerfilSaludAlergiaSubTipoAlergia = $this->getManager("ManagerPerfilSaludAlergiaSubTipoAlergia");
            $rdo = $ManagerPerfilSaludAlergiaSubTipoAlergia->processFromSaludAlergia($request);

            if (!$rdo) {
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                $this->setMsg([ "result" => false, "msg" => "Error. No se pudieron registrar los datos"]);
                return false;
            }

            // <-- LOG
            $log["data"] = "Update register Alergie and intolerances";
            $log["page"] = "Health Profile";
            $log["action"] = "val"; //"val" "vis" "del"
            $log["purpose"] = "See information Health Profile";
            //
            //        
            $ManagerLog = $this->getManager("ManagerLog");
            $ManagerLog->track($log);
            // <--
            $this->setMsg([ "result" => true, "msg" => "Registro actualizado con éxito", "id" => $rdo]);

            $this->db->CompleteTrans();
            return $rdo;
        }
    }

    /**
     * Obtiene la información utilizada para visualizar en el tablero
     * @param type $idpaciente
     * @return boolean
     */
    public function getInfoTablero($idpaciente) {
        $alergia = $this->getByField("paciente_idpaciente", $idpaciente);


        if ($alergia) {

            $info = array();

            $ManagerSubTipoAlergia = $this->getManager("ManagerSubTipoAlergia");
            $array_sub_tipos_alergias = $ManagerSubTipoAlergia->getArraySubTipoAlergiaPaciente($idpaciente);

            if ($array_sub_tipos_alergias && count($array_sub_tipos_alergias) > 0) {
                foreach ($array_sub_tipos_alergias as $key => $sta) {
                    if ($sta["subTipoAlergia"] == "Otros") {
                        $info[] = $sta["texto"];
                    } else {
                        $info[] = $sta["subTipoAlergia"];
                    }
                }
            }
            if ($alergia["intolerancia_alimentos"] != "") {
                $info[] = $alergia["intolerancia_alimentos"];
            }
            if ($alergia["intolerancia_medicamentos"] != "") {
                $info[] = $alergia["intolerancia_medicamentos"];
            }
            if ($alergia["intolerancia_insecto"] != "") {
                $info[] = $alergia["intolerancia_insecto"];
            }
            if ($alergia["intolerancia_otros"] != "") {
                $info[] = $alergia["intolerancia_otros"];
            }
            if ($alergia["posee_anafilaxia"]) {
                $info[] = "Anafilaxia";
            }

            return $info;
        } else {
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
                t.{$this->id} AS id ,
                IFNULL(psa.texto, sta.subTipoAlergia) AS value
            ");

        $query->setFrom("$this->table t 
                                INNER JOIN perfilsaludalergia_subtipoalergia psa ON (t.idperfilSaludAlergia = psa.perfilSaludAlergia_idperfilSaludAlergia)
                                INNER JOIN subtipoalergia sta ON (sta.idsubTipoAlergia = psa.subTipoAlergia_idsubTipoAlergia)");

        $query->setWhere("t.paciente_idpaciente = $idpaciente");

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

}

//END_class
?>