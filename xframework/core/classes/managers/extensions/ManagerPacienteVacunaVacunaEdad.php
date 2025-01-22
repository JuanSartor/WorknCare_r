<?php

/**
 * 	@autor Xinergia
 * 	@version 1.0	29/05/2014
 * 	Manager de las vacunas edad
 *
 */
class ManagerPacienteVacunaVacunaEdad extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "paciente_vacuna_vacunaedad", "idpaciente_vacuna_vacunaEdad");
    }

    public function processFromPerfilPaciente($request) {

        //Si marca que se la aplica, 
        if (isset($request["is_aplicada"]) && $request["is_aplicada"] == "1") {
            if ($request["dia"] != "" && $request["mes"] != "" && $request["anio"] != "") {
                $request["fecha"] = $request["anio"] . "-" . $request["mes"] . "-" . $request["dia"];
            }

            //tengo que hacer el insert
            if (CONTROLLER == "paciente_p" && $request["paciente_idpaciente"] != "") {
                $ManagerPaciente = $this->getManager("ManagerPaciente");
                $paciente = $ManagerPaciente->getPacienteXHeader();
                if ($paciente["idpaciente"] == $request["paciente_idpaciente"]) {

                    $rdo = parent::process($request);

                    if (!$rdo) {
                        $this->setMsg([ "msg" => "Error. No se pudieron insertar los datos", "result" => false]);
                        return false;
                    } else {
                        $ManagerNotificacion = $this->getManager("ManagerNotificacion");
                        $controles_chequeos = $ManagerNotificacion->actualizarNotificacionesFromAddVacunaPaciente($request["paciente_idpaciente"], $request["vacuna_vacunaEdad_idvacuna_vacunaEdad"]);

                        $this->setMsg([ "msg" => "Se procesaron los datos con éxito", "result" => true, "id" => $rdo]);
                        return $rdo;
                    }
                }
            } else {
                $this->setMsg([ "msg" => "Error. No hay paciente seleccionado para realizar la operación", "result" => false]);
                return false;
            }
        } elseif ($request[$this->id] != "") {

            if ($this->getXRelacion($request["paciente_idpaciente"], $request["vacuna_vacunaEdad_idvacuna_vacunaEdad"])) {


                $delete = parent::delete($request[$this->id]);
                if ($delete) {
                    $this->setMsg([ "msg" => "Se procesaron los datos con éxito", "result" => true]);

                    $ManagerNotificacion = $this->getManager("ManagerNotificacion");
                    $controles_chequeos = $ManagerNotificacion->actualizarNotificacionesFromDeleteVacunaPaciente($request["paciente_idpaciente"]);

                    return true;
                } else {
                    $this->setMsg([ "msg" => "Error. No se pudo procesar la información", "result" => false]);
                    return false;
                }
            } else {
                $this->setMsg([ "msg" => "Error. No se encontró registro de la aplicación de la vacuna para el paciente seleccionado", "result" => false]);
                return false;
            }
        } else {
            $this->setMsg([ "msg" => "No seleccionó que la vacuna fue aplicada.", "result" => false]);
            return false;
        }
    }

    public function processFromPerfilMedico($request) {
        //Si marca que se la aplica, 
        if (isset($request["is_aplicada"]) && $request["is_aplicada"] == "1") {
            if ($request["dia"] != "" && $request["mes"] != "" && $request["anio"] != "") {
                $request["fecha"] = $request["anio"] . "-" . $request["mes"] . "-" . $request["dia"];
            }

            //tengo que hacer el insert
            if (CONTROLLER == "medico" && $request["paciente_idpaciente"] != "") {
                $ManagerPaciente = $this->getManager("ManagerPaciente");
                $idpaciente = $_SESSION[URL_ROOT]["medico"]['logged_account']["paciente_session"]["idpaciente"];
                $paciente = $ManagerPaciente->get($idpaciente);
                if ($paciente["idpaciente"] == $request["paciente_idpaciente"]) {

                    $rdo = parent::process($request);

                    if (!$rdo) {
                        $this->setMsg([ "msg" => "Error. No se pudieron insertar los datos", "result" => false]);
                        return false;
                    } else {
                        $this->setMsg([ "msg" => "Se procesaron los datos con éxito", "result" => true, "id" => $rdo]);
                        return $rdo;
                    }
                }
            } else {
                $this->setMsg([ "msg" => "Error. No hay paciente seleccionado para realizar la operación", "result" => false]);
                return false;
            }
        } elseif ($request[$this->id] != "") {

            if ($this->getXRelacion($request["paciente_idpaciente"], $request["vacuna_vacunaEdad_idvacuna_vacunaEdad"])) {


                $delete = parent::delete($request[$this->id]);
                if ($delete) {
                    $this->setMsg([ "msg" => "Se procesaron los datos con éxito", "result" => true]);
                    return true;
                } else {
                    $this->setMsg([ "msg" => "Error. No se pudo procesar la información", "result" => false]);
                    return false;
                }
            } else {
                $this->setMsg([ "msg" => "Error. No se encontró registro de la aplicación de la vacuna para el paciente seleccionado", "result" => false]);
                return false;
            }
        } else {
            $this->setMsg([ "msg" => "No seleccionó que la vacuna fue aplicada.", "result" => false]);
            return false;
        }
    }

    /**
     * Método que obtiene el registro de vacuna_vacunaedad que contenga los dos id´s pasados como parámetros
     * @param type $idpaciente
     * @param type $idvacuna_vacunaEdad
     * @return boolean
     */
    public function getXRelacion($idpaciente, $idvacuna_vacunaEdad) {
        $query = new AbstractSql();

        $query->setSelect("*");

        $query->setFrom("$this->table");

        $query->setWhere("paciente_idpaciente = $idpaciente");

        $query->addAnd("vacuna_vacunaEdad_idvacuna_vacunaEdad = $idvacuna_vacunaEdad");

        $execute = $this->db->Execute($query->getSql());
        if ($execute) {
            $rdo = $execute->FetchRow();
            if ($rdo) {
                if ($rdo["fecha"] != "") {
                    list($y, $m, $d) = preg_split("[-]", $rdo["fecha"]);
                    $rdo["dia"] = $d;
                    $rdo["mes"] = $m;
                    $rdo["anio"] = $y;
                }
                return $rdo;
            } else {
                return false;
            }
        } else {
            return false;
        }
    }

    /**
     * Método que obtiene un listado de vacunas para el paciente
     * @param type $idpaciente
     * @return type
     */
    public function getListVacunasPaciente($idpaciente) {
        $query = new AbstractSql();

        $query->setSelect("*");

        $query->setFrom("$this->table");

        $query->setWhere("paciente_idpaciente = $idpaciente");

        return $this->getList($query);
    }

}

//END_class
?>