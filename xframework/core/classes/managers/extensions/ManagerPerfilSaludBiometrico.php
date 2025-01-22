<?php

/**
 * 	Manager del perfil de salud alergia
 *
 * 	@author Xinergia
 * 	@version 1.0
 * 	@package managers\extensions
 */
class ManagerPerfilSaludBiometrico extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Constructor
        parent::__construct($db, "perfilsaludbiometricos", "idperfilSaludBiometricos");
    }

    public function process($request) {
        if ($request["grupofactorsanguineo_idgrupoFactorSanguineo"] == "") {
            $this->setMsg(["result" => false, "msg" => "Debe seleccionar el grupo y factor sanguineo"]);
            return false;
        }


        $rdo = parent::process($request);
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
        //verifico si se completaron los datos necesarios para datos biometricos del status de perfil de salud

      
        $this->getManager("ManagerPerfilSaludStatus")->actualizarStatus($request["paciente_idpaciente"]);
      
        return $rdo;
    }

    /**
     * Manager Perfil Salud Biométrico... 
     * Obtención de los datos con las tablas relacionadas
     * @param type $idpaciente
     * @return boolean
     */
    public function getWithData($idpaciente) {
        $query = new AbstractSql();

        $query->setSelect("t.*,
                            co.colorOjos,
                            cpe.colorPelo,
                            cpi.colorPiel,
                            gfs.nombre
                    ");

        $query->setFrom("
                        $this->table t
                            LEFT JOIN colorojos co ON (t.colorOjos_idcolorOjos = co.idcolorOjos)
                            LEFT JOIN colorpelo cpe ON (t.colorPelo_idcolorPelo = cpe.idcolorPelo)
                            LEFT JOIN colorpiel cpi ON (t.colorPiel_idcolorPiel = cpi.idcolorPiel)
                            LEFT JOIN grupofactorsanguineo gfs ON (t.grupofactorsanguineo_idgrupoFactorSanguineo = gfs.idgrupoFactorSanguineo)
                     ");

        $query->setWhere("t.paciente_idpaciente = $idpaciente");

        $execute = $this->db->Execute($query->getSql());

        if ($execute) {
            return $execute->FetchRow();
        } else {
            return false;
        }
    }

}

//END_class
?>