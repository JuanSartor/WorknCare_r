<?php

/**
 * 	Manager del perfil de salud alergia
 *
 * 	@author Xinergia
 * 	@version 1.0
 * 	@package managers\extensions
 */
class ManagerAntecedentesPersonales extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Constructor
        parent::__construct($db, "antecedentespersonales", "idantecedentesPersonales");
    }

    public function process($request) {

        $array_enfermedades = array(
            "varicela", "rubiola", "sarampion", "escarlatina", "eritema", "exatema", "papera"
        );

        //recorro todas las enfermedades y si no están seteadas las pongo vacías
        foreach ($array_enfermedades as $key => $enfermedad) {
            $request[$enfermedad] = isset($request[$enfermedad]) && $request[$enfermedad] != "" ? $request[$enfermedad] : "";

            $campo_edad = "edad_$enfermedad";
            $request[$campo_edad] = isset($request[$enfermedad]) && (int) $request[$enfermedad] != 1 ? "" : $request[$campo_edad];
        }

        $rdo = parent::process($request);
        //verifico si se completaron los datos necesarios para datos biometricos del status de perfil de salud
        $ManagerPerfilSaludStatus = $this->getManager("ManagerPerfilSaludStatus");
        $ManagerPerfilSaludStatus->actualizarStatus($request["paciente_idpaciente"]);
       
        return $rdo;
    }

    public function getInfoTablero($idpaciente) {
        $antecedentes_personales = $this->getByField("paciente_idpaciente", $idpaciente);

        if ($antecedentes_personales) {
            $info = array();

            if ((int) $antecedentes_personales["varicela"] == 1)
                $info[] = "Varicelle";
            if ((int) $antecedentes_personales["rubiola"] == 1)
                $info[] = "Rubéole";
            if ((int) $antecedentes_personales["sarampion"] == 1)
                $info[] = "Rougeole";
            if ((int) $antecedentes_personales["escarlatina"] == 1)
                $info[] = "Scarlatine";
            if ((int) $antecedentes_personales["eritema"] == 1)
                $info[] = "Érythème infectieux";
            if ((int) $antecedentes_personales["exatema"] == 1)
                $info[] = "Roséole infantile";
            if ((int) $antecedentes_personales["papera"] == 1)
                $info[] = "Oreillons";

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
     * Retorna los valores de Enfermedades actuales
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