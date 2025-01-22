<?php

/**
 * 	Manager de las patologías actuales
 *
 * 	@author Xinergia
 * 	@version 1.0
 * 	@package managers\extensions
 */
class ManagerPatologiasActuales extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Constructor
        parent::__construct($db, "patologiasactuales", "idpatologiasActuales");
    }

    public function process($request) {

        $array_patologias = array(
            "hepatitisA", "hepatitisB", "hepatitisC", "VPH", "HIV"
        );
        //recorro todas las enfermedades y si no están seteadas las pongo vacías
        foreach ($array_patologias as $key => $patologia) {
            $request[$patologia] = isset($request[$patologia]) && $request[$patologia] != "" ? $request[$patologia] : "";
        }


        $rdo = parent::process($request);
        //verifico si se completaron los datos necesarios para datos biometricos del status de perfil de salud
        $ManagerPerfilSaludStatus = $this->getManager("ManagerPerfilSaludStatus");
        $ManagerPerfilSaludStatus->actualizarStatus($request["paciente_idpaciente"]);
       
        return $rdo;
    }

    public function getInfoTablero($idpaciente) {
        $patologia_actual = $this->getByField("paciente_idpaciente", $idpaciente);

        if ($patologia_actual) {
            $info = array();

            if ((int) $patologia_actual["hepatitisA"] == 1)
                $info[] = "Hépatite A";
            if ((int) $patologia_actual["hepatitisB"] == 1)
                $info[] = "Hépatite B";
            if ((int) $patologia_actual["hepatitisC"] == 1)
                $info[] = "Hépatite C";
            if ((int) $patologia_actual["VPH"] == 1)
                $info[] = "VPH";
            if ((int) $patologia_actual["HIV"] == 1)
                $info[] = "HIV";

            if (count($info) > 0) {
                return $info;
            } else {
                return false;
            }
        } else {
            return false;
        }
    }

    /**
     * Retorna los valores de patologías actuales para el menú del médico
     * @param type $idpaciente
     */
    public function getTagsInputsMenuMedico($idpaciente) {
        $info_tablero = $this->getInfoTablero($idpaciente);

        $tags_inputs = "";

        if ($info_tablero) {
            foreach ($info_tablero as $key => $value) {
                $tags_inputs .= "{$value},";
            }
        }

        return $tags_inputs;
    }

}

//END_class
?>