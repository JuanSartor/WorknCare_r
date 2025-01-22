<?php

/**
 * 	Manager del perfil de salud alergia
 *
 * 	@author Xinergia
 * 	@version 1.0
 * 	@package managers\extensions
 */
class ManagerPresionArterial extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Constructor
        parent::__construct($db, "presionarterial", "idpresionArterial");
    }

    public function process($request) {

        return parent::process($request);
    }

    /**
     * Sobreescritura del insert
     * @param type $record
     * @return boolean
     */
    public function insert($record) {

        if (!isset($record["perfilSaludBiometricos_idperfilSaludBiometricos"]) || $record["perfilSaludBiometricos_idperfilSaludBiometricos"] == "") {
            $ManagerPerfilSaludBiometrico = $this->getManager("ManagerPerfilSaludBiometrico");
            $record["perfilSaludBiometricos_idperfilSaludBiometricos"] = $ManagerPerfilSaludBiometrico->insert($record);
            if (!$record["perfilSaludBiometricos_idperfilSaludBiometricos"]) {
                $this->setMsg([ "msg" => "Error. Ingrese al menos un campo", "result" => false]);
                return false;
            }
        }

        //Obtengo el último que será modificado en caso de que se inserte correctamente el registro en la base de datos
        $ultimo = $this->getLastInformation($record["perfilSaludBiometricos_idperfilSaludBiometricos"]);

        //Guardo la fecha de inserción
        $record["fecha"] = date("Y-m-d H:i:s");

        $array_insert = ["sistole", "diastole", "frecuencia_cardiaca", "presion_campo1", "presion_campo2"];
        $flag = 0;
        foreach ($array_insert as $key => $value) {
            if (!isset($record[$value]) || $record[$value] == "") {
                $flag++;
            }
        }
        if ($flag == count($array_insert)) {
            $this->setMsg([ "msg" => "Error. Ingrese al menos un campo", "result" => false]);
            return false;
        }

        $record["presion_arterial"] = $record["presion_campo1"] . "/" . $record["presion_campo2"];

        $record["ultimo"] = 1;

        $rdo = parent::insert($record);

        if ($rdo) {
            
            // <-- LOG
            $log["data"] = "Update register biometric data";
            $log["page"] = "Health Profile";
            $log["action"] = "val"; //"val" "vis" "del"
            $log["purpose"] = "See information Health Profile";
            //
            //        
            $ManagerLog = $this->getManager("ManagerLog");
            $ManagerLog->track($log);
            // <--
            // 
            //Seteo el último, del último anterior
            if ($ultimo != "") {
                $update = parent::update(array("ultimo" => 0), $ultimo[$this->id]);

                if ($update) {
                    $this->setMsg([ "msg" => "Se actualizó la información sobre la presión arterial", "result" => true, "id" => $rdo]);
                    return $rdo;
                } else {
                    $this->setMsg([ "msg" => "Error. No se pudo registrar la información de presión arterial", "result" => false]);
                    return false;
                }
            }
        } else {
            $this->setMsg([ "msg" => "Error. No se pudo registrar la información de presión arterial", "result" => false]);
            return false;
        }
    }

    /**
     * Método que obtiene de la presión arterial el último valor para poder ser modificado en el FrontEnd
     * @param type $idperfilSaludBiometricos
     * @return boolean
     */
    public function getLastInformation($idperfilSaludBiometricos) {

        $query = new AbstractSql();

        $query->setSelect("*, DATE_FORMAT(fecha,'%Y-%m-%d') as fecha_format");

        $query->setFrom("$this->table");

        $query->setWhere("perfilSaludBiometricos_idperfilSaludBiometricos = $idperfilSaludBiometricos");

        $query->addAnd("ultimo = 1");

        $execute = $this->db->Execute($query->getSql());

        if ($execute) {

            $presion_arterial = $execute->FetchRow();

            if ($presion_arterial) {
                $calendario = new Calendar();
                $presion_arterial["fecha_dp"] = $calendario->getFechasDP($presion_arterial["fecha_format"]);

                return $presion_arterial;
            } else {
                return false;
            }
        } else {
            return false;
        }
    }

}

//END_class
?>