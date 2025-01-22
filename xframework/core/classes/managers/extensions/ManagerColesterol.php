<?php

/**
 * 	Manager del colesterol
 *
 * 	@author Xinergia
 * 	@version 1.0
 * 	@package managers\extensions
 */
class ManagerColesterol extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Constructor
        parent::__construct($db, "colesterol", "idcolesterol");
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

        $array_insert = ["colesterol_total", "HDL", "LDL", "trigriseliridos"];
        $flag = 0;
        foreach ($array_insert as $key => $value) {
            if (!isset($record[$value]) || $record[$value] == "") {
                $flag++;
            }
        }
        if ($flag == count($array_insert)) {
            $this->setMsg(["msg" => "Error. Ingrese al menos un campo", "result" => false]);
            return false;
        }

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
            if ($ultimo) {
                $update = parent::update(array("ultimo" => 0), $ultimo[$this->id]);

                if (!$update) {
                    $this->setMsg([ "msg" => "Error. No se pudo registrar la información referida al colesterol", "result" => false]);
                    return false;
                }
            }

            $this->setMsg([ "msg" => "Registro actualizado con éxito", "result" => true, "id" => $rdo]);
            return $rdo;
        } else {
            $this->setMsg(["msg" => "Error. No se pudo registrar la información de colesterol", "result" => false]);
            return false;
        }
    }

    /**
     * Método que obtiene del colesterol el último valor para poder ser modificado en el FrontEnd
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

            $registro = $execute->FetchRow();

            if ($registro) {
                $calendario = new Calendar();

                $registro["fecha_dp"] = $calendario->getFechasDP($registro["fecha_format"]);

                return $registro;
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