<?php

/**
 * 	Manager de las patologías actuales
 *
 * 	@author Xinergia
 * 	@version 1.0
 * 	@package managers\extensions
 */
class ManagerPerfilSaludEstiloVida extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Constructor
        parent::__construct($db, "perfilsaludestilovida", "idperfilSaludEstiloVida");

        /*
         * Valores de los campos
         * actividad_fisica: 
         * 0 -> De 2 a 7 veces por semana
         * 1 -> 1 fois par semaine
         * 2 -> Occasionnellement
         * 3 -> No hace actividad física
         * consumo_tabaco:
         * 0 -> No fuma
         * 1 -> Occasionnellement
         * 2 -> De 1 à 7 cigarettes par jour
         * 3 -> Más de 7 cigarrillos diarios
         * consumo_azucares_grasas:
         * 0 -> Regularmente en grandes cantidades
         * 1 -> Regularmente en pocas cantidades
         * 2 -> Occasionnellement en pocas cantidades
         * 3 -> Occasionnellement en grandes cantidades
         * consumo_sal:
         * 0 -> Menos de 0,5 g. diarios
         * 1 -> Entre 0,5 y 5 g. diarios
         * 2 -> Entre 5 a 12 g. diarios
         * 3 -> Más de 12 g. diarios
         * consumo_alcohol:
         * 0 -> No toma alcohol
         * 1 -> Una copa de vez en cuando
         * 2 -> Una copa por día
         * 3 -> Dos copas diarias
         * 4 -> Más de dos copas diarias
         */
    }

    /**
     * Obtiene el nombre del estilo de vida, según el campo y el valor
     * @param type $numero
     * @param type $campo
     * @return string
     */
    public function getNombre($numero, $campo) {
        switch ($campo) {
            case "actividad_fisica":
                switch ($numero) {
                    case 0:
                        return "2 à 7 fois par semaine";
                        break;
                    case 1:
                        return "1 fois par semaine";
                        break;
                    case 2:
                        return "Occasionnellement";
                        break;
                    case 3:
                        return "Pas d'activité physique";
                        break;
                    default:
                        return "";
                        break;
                }
                break;
            case "consumo_tabaco":
                switch ($numero) {
                    case 0:
                        return "Ne pas fumer";
                        break;
                    case 1:
                        return "Occasionnellement";
                        break;
                    case 2:
                        return "De 1 à 7 cigarettes par jour";
                        break;
                    case 3:
                        return "Plus de 7 cigarettes par jour";
                        break;
                    default:
                        return "";
                        break;
                }
                break;
            case "consumo_azucares_grasas":
                switch ($numero) {
                    case 0:
                        return "Régulièrement en grandes quantités";
                        break;
                    case 1:
                        return "Régulièrement en petites quantités";
                        break;
                    case 2:
                        return "Occasionnellement en grandes quantités";
                        break;
                    case 3:
                        return "Occasionnellement en petites quantités";
                        break;
                    default:
                        return "";
                        break;
                }
                break;
            case "consumo_sal":
                switch ($numero) {
                    case 0:
                        return "Moins de 0.5 g les journaux";
                        break;
                    case 1:
                        return "Entre 0.5 et 5 g. les journaux";
                        break;
                    case 2:
                        return "Entre 5 et 12 g. les journaux";
                        break;
                    case 3:
                        return "Plus de 12 g. les journaux";
                        break;
                    default:
                        return "";
                        break;
                }
                break;
            case "consumo_alcohol":
                switch ($numero) {
                    case 0:
                        return "Pas d'alcool";
                        break;
                    case 1:
                        return "Occasionnellement";
                        break;
                    case 2:
                        return "Un verre / jour";
                        break;
                    case 3:
                        return "Deux verres / jour";
                        break;
                    case 4:
                        return "Plus de deux verres / jour";
                        break;
                    default:
                        return "";
                        break;
                }
                break;
            default:
                break;
        }
    }

    /**
     * Métoodo que retorna los tags para las prótesis.
     * @param type $idpaciente
     * @return string|boolean
     */
    public function getTagsInputsMenuMedico($idpaciente) {

        $registro = $this->getByField("paciente_idpaciente", $idpaciente);
        if ($registro) {
            $tags_input = "";
            $nombre = $this->getNombre($registro["actividad_fisica"], "actividad_fisica");
            if ($nombre) {
                $tags_input .= "Activité physique: $nombre ,";
            }
            $nombre = $this->getNombre($registro["consumo_tabaco"], "consumo_tabaco");
            if ($nombre) {
                $tags_input .= "Tabagisme: $nombre ,";
            }
            $nombre = $this->getNombre($registro["consumo_azucares_grasas"], "consumo_azucares_grasas");
            if ($nombre) {
                $tags_input .= "Consommation d'aliments sucrés et gras: $nombre,";
            }
            $nombre = $this->getNombre($registro["consumo_sal"], "consumo_sal");
            if ($nombre) {
                $tags_input .= "Consommation de sel: $nombre,";
            }
            $nombre = $this->getNombre($registro["consumo_alcohol"], "consumo_alcohol");
            if ($nombre) {
                $tags_input .= "Consommation d'alcool: $nombre,";
            }

            return $tags_input;
        } else {
            return false;
        }
    }

    public function process($request) {

        $ManagerPaciente = $this->getManager("ManagerPaciente");
        if (CONTROLLER == "paciente_p") {
            $paciente = $ManagerPaciente->getPacienteXHeader();
            if ($paciente["idpaciente"] != $request["paciente_idpaciente"]) {
                $this->setMsg([ "result" => false, "msg" => "Error. Verifique el paciente seleccionado para la modificación del paciente"]);
                return false;
            }
        } elseif (CONTROLLER == "medico") {
            $idpaciente = $_SESSION[URL_ROOT]["medico"]['logged_account']["paciente_session"]["idpaciente"];
            $paciente = $ManagerPaciente->get($idpaciente);
            if ($paciente["idpaciente"] != $request["paciente_idpaciente"]) {
                $this->setMsg([ "result" => false, "msg" => "Error. Verifique el paciente seleccionado para la modificación del paciente"]);
                return false;
            }
        }

        // <-- LOG
        $log["data"] = "Update register Lifestyle";
        $log["page"] = "Health Profile";
        $log["action"] = "val"; //"val" "vis" "del"
        $log["purpose"] = "See information Health Profile";
        //
        //        
        $ManagerLog = $this->getManager("ManagerLog");
        $ManagerLog->track($log);
        // <--
        
        
        $rdo = parent::process($request);
        
        
        
        
        //verifico si se completaron los datos necesarios para datos biometricos del status de perfil de salud
        $this->getManager("ManagerPerfilSaludStatus")->actualizarStatus($request["paciente_idpaciente"]);
        return $rdo;
    }

    /**
     * Tarjeta con los datos del porcentaje para los estilos de salud
     * @param type $idpaciente
     */
    public function getDatosCard($idpaciente) {
        $record = $this->getByField("paciente_idpaciente", $idpaciente);

        if ($record) {
            //Armo los porcentajes 
            $array = array();

            //Actividad Física Como son 4, es el 25 %
            $array["porc_actividad_fisica"] = $porc_actividad_fisica = 25;

            //Consumo tabaco_ Como son 4, es el 25 %
            $array["porc_consumo_tabaco"] = $porc_consumo_tabaco = 25;

            //Consumo azúcares y grasas_ Como son 4, es el 25 %
            $array["porc_azucares_grasas"] = $porc_azucares_grasas = 25;

            //Consul sal_ Como son 4, es el 25 %
            $array["porc_consumo_sal"] = $porc_consumo_sal = 25;

            //Consumo alcohol_ Como son 5, es el 20 %
            $array["porc_consumo_alcohol"] = $porc_consumo_alcohol = 20;

            //Si tiene porcentaje amarillo seguro tiene verde
            //Si tiene porcentaje rojo seguro tiene amarillo y rojo 
            //Actividad Física
            switch ($record["actividad_fisica"]) {
                case "":
                    $array["porc_actividad_fisica"] = 0;
                    break;
                case 0:
                    $array["porc_actividad_fisica_verde"] = 1 * $porc_actividad_fisica;
                    $array["porc_actividad_fisica_amarillo"] = 0;
                    $array["porc_actividad_fisica_rojo"] = 0;
                    break;
                case 1:
                    $array["porc_actividad_fisica_verde"] = 2 * $porc_actividad_fisica;
                    $array["porc_actividad_fisica_amarillo"] = 0;
                    $array["porc_actividad_fisica_rojo"] = 0;
                    break;
                case 2:
                    $array["porc_actividad_fisica_verde"] = 2 * $porc_actividad_fisica;
                    $array["porc_actividad_fisica_amarillo"] = 1 * $porc_actividad_fisica;
                    $array["porc_actividad_fisica_rojo"] = 0;
                    break;
                case 3:
                    $array["porc_actividad_fisica_verde"] = 2 * $porc_actividad_fisica;
                    $array["porc_actividad_fisica_amarillo"] = 1 * $porc_actividad_fisica;
                    $array["porc_actividad_fisica_rojo"] = 1 * $porc_actividad_fisica;
                    break;
            }

            //Consumo tabaco
            switch ($record["consumo_tabaco"]) {
                case "":
                    $array["porc_consumo_tabaco"] = 0;
                    break;
                case 0:
                    $array["porc_consumo_tabaco_verde"] = 1 * $porc_consumo_tabaco;
                    $array["porc_consumo_tabaco_amarillo"] = 0;
                    $array["porc_consumo_tabaco_rojo"] = 0;
                    break;
                case 1:
                    $array["porc_consumo_tabaco_verde"] = 1 * $porc_consumo_tabaco;
                    $array["porc_consumo_tabaco_amarillo"] = 1 * $porc_consumo_tabaco;
                    $array["porc_consumo_tabaco_rojo"] = 0;
                    break;
                case 2:
                    $array["porc_consumo_tabaco_verde"] = 1 * $porc_consumo_tabaco;
                    $array["porc_consumo_tabaco_amarillo"] = 2 * $porc_consumo_tabaco;
                    $array["porc_consumo_tabaco_rojo"] = 0;
                    break;
                case 3:
                    $array["porc_consumo_tabaco_verde"] = 1 * $porc_consumo_tabaco;
                    $array["porc_consumo_tabaco_amarillo"] = 2 * $porc_consumo_tabaco;
                    $array["porc_consumo_tabaco_rojo"] = 1 * $porc_consumo_tabaco;
                    break;
            }
            //Consumo azúcares y grasas
            switch ($record["consumo_azucares_grasas"]) {
                case "":
                    $array["porc_azucares_grasas"] = 0;
                    break;
                case 0:
                    $array["porc_azucares_grasas_verde"] = 1 * $porc_azucares_grasas;
                    $array["porc_azucares_grasas_amarillo"] = 0;
                    $array["porc_azucares_grasas_rojo"] = 0;
                    break;
                case 1:
                    $array["porc_azucares_grasas_verde"] = 1 * $porc_azucares_grasas;
                    $array["porc_azucares_grasas_amarillo"] = 1 * $porc_azucares_grasas;
                    $array["porc_azucares_grasas_rojo"] = 0;
                    break;
                case 2:
                    $array["porc_azucares_grasas_verde"] = 1 * $porc_azucares_grasas;
                    $array["porc_azucares_grasas_amarillo"] = 1 * $porc_azucares_grasas;
                    $array["porc_azucares_grasas_rojo"] = 1 * $porc_azucares_grasas;
                    break;
                case 3:
                    $array["porc_azucares_grasas_verde"] = 1 * $porc_azucares_grasas;
                    $array["porc_azucares_grasas_amarillo"] = 1 * $porc_azucares_grasas;
                    $array["porc_azucares_grasas_rojo"] = 2 * $porc_azucares_grasas;
                    break;
            }
            //Consumo sal
            switch ($record["consumo_sal"]) {
                case "":
                    $array["porc_consumo_sal"] = 0;
                    break;
                case 0:
                    $array["porc_consumo_sal_verde"] = 1 * $porc_consumo_sal;
                    $array["porc_consumo_sal_amarillo"] = 0;
                    $array["porc_consumo_sal_rojo"] = 0;
                    break;
                case 1:
                    $array["porc_consumo_sal_verde"] = 2 * $porc_consumo_sal;
                    $array["porc_consumo_sal_amarillo"] = 0;
                    $array["porc_consumo_sal_rojo"] = 0;
                    break;
                case 2:
                    $array["porc_consumo_sal_verde"] = 2 * $porc_consumo_sal;
                    $array["porc_consumo_sal_amarillo"] = 1 * $porc_consumo_sal;
                    $array["porc_consumo_sal_rojo"] = 0;
                    break;
                case 3:
                    $array["porc_consumo_sal_verde"] = 2 * $porc_consumo_sal;
                    $array["porc_consumo_sal_amarillo"] = 1 * $porc_consumo_sal;
                    $array["porc_consumo_sal_rojo"] = 1 * $porc_consumo_sal;
                    break;
            }
            //Consumo de alcohol
            switch ($record["consumo_alcohol"]) {
                case "":
                    $array["porc_consumo_alcohol"] = 0;
                    break;
                case 0:
                    $array["porc_consumo_alcohol_verde"] = 1 * $porc_consumo_alcohol;
                    $array["porc_consumo_alcohol_amarillo"] = 0;
                    $array["porc_consumo_alcohol_rojo"] = 0;
                    break;
                case 1:
                    $array["porc_consumo_alcohol_verde"] = 2 * $porc_consumo_alcohol;
                    $array["porc_consumo_alcohol_amarillo"] = 0;
                    $array["porc_consumo_alcohol_rojo"] = 0;
                    break;
                case 2:
                    $array["porc_consumo_alcohol_verde"] = 2 * $porc_consumo_alcohol;
                    $array["porc_consumo_alcohol_amarillo"] = 1 * $porc_consumo_alcohol;
                    $array["porc_consumo_alcohol_rojo"] = 0;
                    break;
                case 3:
                    $array["porc_consumo_alcohol_verde"] = 2 * $porc_consumo_alcohol;
                    $array["porc_consumo_alcohol_amarillo"] = 1 * $porc_consumo_alcohol;
                    $array["porc_consumo_alcohol_rojo"] = 1 * $porc_consumo_alcohol;
                    break;
                case 4:
                    $array["porc_consumo_alcohol_verde"] = 2 * $porc_consumo_alcohol;
                    $array["porc_consumo_alcohol_amarillo"] = 1 * $porc_consumo_alcohol;
                    $array["porc_consumo_alcohol_rojo"] = 2 * $porc_consumo_alcohol;
                    break;
            }
            return $array;
        } else {
            return array(
                "porc_actividad_fisica" => 0,
                "porc_consumo_tabaco" => 0,
                "porc_azucares_grasas" => 0,
                "porc_consumo_sal" => 0,
                "porc_consumo_alcohol" => 0
            );
        }
    }

}

//END_class
?>