<?php

/**
 * 	Manager del perfil de salud ginecológico
 *
 * 	@author Xinergia
 * 	@version 1.0
 * 	@package managers\extensions
 */
class ManagerPerfilSaludGinecologico extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Constructor
        parent::__construct($db, "perfilsaludginecologico", "idperfilSaludGinecologico");
    }

    public function process($request) {



        if (!isset($request["paciente_idpaciente"]) || $request["paciente_idpaciente"] == "") {
            $request["paciente_idpaciente"] = $_SESSION[URL_ROOT]["paciente_p"]['logged_account']["paciente"]["idpaciente"];
        }

        $ManagerPaciente = $this->getManager("ManagerPaciente");
        $paciente = $ManagerPaciente->get($request["paciente_idpaciente"]);
        if ($paciente["sexo"] == 1) {
            $this->setMsg([ "msg" => "No se le puede crear un perfil de salud ginecológico a un paciente masculino", "result" => false]);
            return false;
        }

        if ($request["from_antecedentes"] && ($request["posee_menarca"] == "" || $request["vida_sexual_activa"] == "")) {
            $this->setMsg([ "msg" => "Complete los campos requeridos de antecedentes ginecologiocos", "result" => false]);
            return false;
        }

        if (($request["from_controles"] == 1 && !isset($request["no_pap"])) && ( $request["pap_mes"] == "" || $request["pap_anio"] == "")) {
            $this->setMsg([ "msg" => "Complete la fecha de último PAP", "result" => false]);
            return false;
        }
        if ($request["from_controles"] == 1 && !isset($request["no_mam"]) && ( $request["mam_mes"] == "" || $request["mam_anio"] == "")) {
            $this->setMsg([ "msg" => "Complete la fecha de última mamografia", "result" => false]);
            return false;
        }

        //Si nunca se realizó el pap. Seteo la fecha en null
        if (isset($request["no_pap"]) && $request["no_pap"] == 1) {
            $request["fecha_ultimo_pap"] = "";
        } else {
            if ($request["pap_mes"] != "" && $request["pap_anio"] != "") {
                $request["fecha_ultimo_pap"] = $request["pap_anio"] . "-" . $request["pap_mes"] . "-01";
                $request["no_pap"] = 0;
            }
        }

        //Si nunca se realizó la mamografía. Seteo la fecha en null
        if (isset($request["no_mam"]) && $request["no_mam"] == 1) {

            $request["fecha_ultima_mamografia"] = "";
        } else {

            if ($request["mam_mes"] != "" && $request["mam_anio"] != "") {
                $request["fecha_ultima_mamografia"] = $request["mam_anio"] . "-" . $request["mam_mes"] . "-01";
                $request["no_mam"] = 0;
            }
        }

        //Me fijo si viene fecha para FUM
        if ($request["fum_dia"] != "" && $request["fum_mes"] != "" && $request["fum_anio"] != "") {
            $request["FUM"] = $request["fum_anio"] . "-" . $request["fum_mes"] . "-" . $request["fum_dia"];
        }

       /* if ($request["is_embarazada"] == 1 && $request["FUM"] == "" && $request["from_embarazo"] == "1") {
            $this->setMsg([ "result" => false, "msg" => "Si se encuentra embarazada, debe ingresar la fecha de la última menstruación."]);
            return false;
        }*/
        if ($request["idperfilSaludGinecologico"] == "") {
            $exist = $this->getByField("paciente_idpaciente", $request["paciente_idpaciente"]);
            if ($exist) {
                $request["idperfilSaludGinecologico"] = $exist["idperfilSaludGinecologico"];
            }
        }
        $rdo = parent::process($request);

        //verifico si se completaron los datos necesarios para el perfil ginecologico del status de perfil de salud
        $this->getManager("ManagerPerfilSaludStatus")->actualizarStatus($request["paciente_idpaciente"]);

        if (!$rdo) {
            $this->setMsg([ "result" => false, "msg" => "Se produjo un error, verifique los datos"]);
            return false;
        } else {
            $this->setMsg([ "result" => true, "msg" => "Registro actualizado con éxito", "id" => $rdo]);
            return $rdo;
        }
    }

    /**
     * Procesamiento de las fedchas y demás datos de perfil salud ginecológico perteneciente a las tarjetas
     * @param type $request
     * @return boolean
     */
    public function processFromCard($request) {

        $insert_value = array();
        if ($request["pap_mes"] != "" && $request["pap_anio"] != "") {
            $insert_value["fecha_ultimo_pap"] = $request["pap_anio"] . "-" . $request["pap_mes"] . "-01";
        }

        if ($request["mam_mes"] != "" && $request["mam_anio"] != "") {
            $insert_value["fecha_ultima_mamografia"] = $request["mam_anio"] . "-" . $request["mam_mes"] . "-01";
        }

        if ($request["fum_dia"] != "" && $request["fum_mes"] != "" && $request["fum_anio"] != "") {
            $insert_value["FUM"] = $request["fum_anio"] . "-" . $request["fum_mes"] . "-" . $request["fum_dia"];
        } else {
            $insert_value["FUM"] = "";
        }

        if ($request[$this->id] != "") {
            $insert_value[$this->id] = $request[$this->id];
        }

        $insert_value["is_embarazada"] = ($request["is_embarazada"] != "" && $request["is_embarazada"] == "on") ? 1 : 0;

        /*if ($insert_value["is_embarazada"] == 1 && $insert_value["FUM"] == "") {
            $this->setMsg([ "result" => false, "msg" => "Si se encuentra embarazada, debe ingresar la fecha de la última menstruación."]);
            return false;
        }*/

        $rdo = parent::process($insert_value);

        if ($rdo) {
            $this->setMsg([ "result" => true, "msg" => "Registro actualizado con éxito", "id" => $rdo]);
            return $rdo;
        } else {
            $this->setMsg([ "result" => false, "msg" => "Se produjo un error, verifique los datos"]);
            return false;
        }
    }

    /**
     * Obtiene el perfil de salud de los pacientes
     * @param type $idpaciente
     * @return type
     */
    public function getPerfilSaludXIDPaciente($idpaciente) {

        $perfil_salud = $this->getByField("paciente_idpaciente", $idpaciente);

        if ($perfil_salud) {
            //Si es que hay fecha de último pap o fecha de última mamografía, se setean los valores para los combos
            $calendar = new Calendar();
            if ($perfil_salud["fecha_ultimo_pap"] != "") {
                $array_pap = $calendar->splitFecha($perfil_salud["fecha_ultimo_pap"]);
                $perfil_salud["pap_dp"] = $calendar->getFechasDP($perfil_salud["fecha_ultimo_pap"]);
                //eliminamos el dia ya que se solicita el mes
                $perfil_salud["pap_dp"] = substr($perfil_salud["pap_dp"], 3);
                $perfil_salud["split_pap"] = $array_pap;
            }

            if ($perfil_salud["fecha_ultima_mamografia"] != "") {
                $array_mam = $calendar->splitFecha($perfil_salud["fecha_ultima_mamografia"]);
                $perfil_salud["mam_dp"] = $calendar->getFechasDP($perfil_salud["fecha_ultima_mamografia"]);
                $perfil_salud["mam_dp"] = substr($perfil_salud["mam_dp"], 3);
                $perfil_salud["split_mam"] = $array_mam;
            }

            if ($perfil_salud["FUM"] != "") {
                $array_mam = $calendar->splitFecha($perfil_salud["FUM"]);
                $perfil_salud["FUM_dp"] = $calendar->getFechasDP($perfil_salud["FUM"]);
                $perfil_salud["split_fum"] = $array_mam;

                //Cálculo semana de embarazos
                if ((int) $perfil_salud["is_embarazada"] == 1) {
                    $hoy = date("Y-m-d");
                    $diferencia_dias = $calendar->getDiferenciasFechas($hoy, $perfil_salud["FUM"]);
                    if ($diferencia_dias > 0) {
                        $perfil_salud["semanas_embarazo"] = ceil($diferencia_dias / 7);
                    }
                }
            }


            return $perfil_salud;
        } else {
            return false;
        }
    }

}

//END_class
?>