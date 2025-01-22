<?php

/**
 * 	Manager de los perfiles de salud de cirugias
 *
 * 	@author Xinergia
 * 	@version 1.0
 * 	@package managers\extensions
 */
class ManagerPerfilSaludCirugiasProtesis extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Constructor
        parent::__construct($db, "perfilsaludcirugiasprotesis", "idperfilSaludCirugiasProtesis");
    }

    public function process($request) {

        if ($request["posee_cirugia"] == "" && $request["posee_protesis"] == "") {
            $this->setMsg(["result" => false, "msg" => "Debe seleccionar al menos una de las opciones"]);
            return false;
        }

        //si se da alta de una cirugia o protesis obtenemos el id mediante el paciente
        if ($request["idperfilSaludCirugiasProtesis"] == "") {

            $perfil = $this->getByField("paciente_idpaciente", $request["paciente_idpaciente"]);

            if ($perfil && count($perfil) > 0) {
                $request["idperfilSaludCirugiasProtesis"] = $perfil["idperfilSaludCirugiasProtesis"];
            } else {
                //NO está insertado, entonces hago un insert
                $rdo = parent::insert($request);
                
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
             
                //verifico si se completaron los datos de cirugias y protesis requeridos en el perfil de salud
                $this->getManager("ManagerPerfilSaludStatus")->actualizarStatus($request["paciente_idpaciente"]);
                return $rdo;
            }
        }


        $rdo = parent::process($request);
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

        //verifico si se completaron los datos de cirugias y protesis requeridos en el perfil de salud
        $this->getManager("ManagerPerfilSaludStatus")->actualizarStatus($request["paciente_idpaciente"]);
        return $rdo;
    }

}
