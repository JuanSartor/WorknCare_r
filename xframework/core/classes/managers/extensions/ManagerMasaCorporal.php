<?php

/**
 * 	Manager de la masa corporal
 *
 * 	@author Xinergia
 * 	@version 1.0
 * 	@package managers\extensions
 */
class ManagerMasaCorporal extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Constructor
        parent::__construct($db, "masacorporal", "idmasaCorporal");
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
     
        if ($record["peso"] == "" && $record["altura"] == "") {
            $this->setMsg([ "msg" => "Ingrese al menos un valor", "result" => false]);
            return false;
        }

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

        if ($record["from_altura"] == 1) {

            //Si viene del tablero pediatrico, solamente guardo la altura, entonces tengo que poner los datos anteriores de peso
            $array_insert = ["altura"];
            $record["diferencia_peso"] = $ultimo["diferencia_peso"];
            $record["fecha_peso"] = $ultimo["fecha_peso"];
            $record["peso"] = $ultimo["peso"];
        } elseif ($record["from_peso"] == 1) {
            $array_insert = ["peso"];
            $record["diferencia_altura"] = $ultimo["diferencia_altura"];
            $record["fecha_altura"] = $ultimo["fecha_altura"];
            $record["altura"] = $ultimo["altura"];
        } else {
            $array_insert = ["peso", "altura"];
        }
        $flag = 0;
        foreach ($array_insert as $key => $value) {
            if (!isset($record[$value]) || $record[$value] == "") {
                $flag++;
            } else {
                $record["fecha_$value"] = date("Y-m-d H:i:s");

                //Si hay último, y el valor viene distinto a vacío, tengo que sacar la diferencia con el último para insertarlo en la BD
                if ($ultimo && $ultimo[$value] != "") {
                    $record["diferencia_$value"] = ((float) $record[$value] - (float) $ultimo[$value] != 0) ? (float) $record[$value] - (float) $ultimo[$value] : $ultimo["diferencia_$value"];
                }
            }
        }

        if ((float) $record["peso"] > 0 && (float) $record["altura"]) {
            $record["imc"] = (float) $record["peso"] / pow((float) $record["altura"] / 100, 2);
        }

        if ($flag == count($array_insert)) {
            $this->setMsg([ "msg" => "Error. Ingrese al menos un campo", "result" => false]);
            return false;
        }

        $record["ultimo"] = 1;

        $record["ver_status_imc"] = isset($record["ver_status_imc"]) && (int) $record["ver_status_imc"] == 1 ? 1 : 0;

        //obtenemos el registro anterior para obtener el % avance  al completar el perfil de salud




        $rdo = parent::insert($record);

        if ($rdo) {
            //verifico si se completaron los datos necesarios para datos biometricos del status de perfil de salud
            $ManagerPerfilSaludStatus=$this->getManager("ManagerPerfilSaludStatus");
            $ManagerPerfilSaludStatus->actualizarStatus($record["paciente_idpaciente"]);
            
            
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
                    $this->setMsg([ "msg" => "Error. No se pudo registrar la información referida la masa corporal", "result" => false]);
                    return false;
                }
            }

            $this->setMsg([ "msg" => "Registro actualizado con éxito", "result" => true, "id" => $rdo]);
            return $rdo;
        } else {
            $this->setMsg([ "msg" => "Error. No se pudo registrar la información de la masa corporal", "result" => false]);
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

        $query->setSelect("*,
        
                    DATE_FORMAT(fecha_peso,'%Y-%m-%d') as fecha_peso_format, 
                    DATE_FORMAT(fecha_altura,'%Y-%m-%d') as fecha_altura_format");

        $query->setFrom("$this->table");

        $query->setWhere("perfilSaludBiometricos_idperfilSaludBiometricos = $idperfilSaludBiometricos");

        $query->addAnd("ultimo = 1");

        $execute = $this->db->Execute($query->getSql());

        if ($execute) {

            $registro = $execute->FetchRow();

            if ($registro) {
                $calendario = new Calendar();
                $registro["fecha_peso_dp"] = $calendario->getFechasDP($registro["fecha_peso_format"]);
                $registro["fecha_altura_dp"] = $calendario->getFechasDP($registro["fecha_altura_format"]);

                //seteamos una fecha general, la ultima de las 2 para mostrar en el tablero
                if (strtotime($registro["fecha_peso"]) > strtotime($registro["fecha_altura"])) {
                    $registro["fecha_dp"] = $registro["fecha_peso_dp"];
                } else {
                    $registro["fecha_dp"] = $registro["fecha_altura_dp"];
                }

                if ((float) $registro["diferencia_peso"] > 0) {
                    $registro["diferencia_peso"] = "+" . $registro["diferencia_peso"];
                }
                if ((float) $registro["diferencia_altura"] > 0) {
                    $registro["diferencia_altura"] = "+" . $registro["diferencia_altura"];
                }
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