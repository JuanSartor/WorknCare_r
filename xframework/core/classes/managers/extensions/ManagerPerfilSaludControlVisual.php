<?php

/**
 * 	Manager del perfil de salud control visual
 *
 * 	@author Xinergia
 * 	@version 1.0
 * 	@package managers\extensions
 */
class ManagerPerfilSaludControlVisual extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Constructor
        parent::__construct($db, "perfilsaludcontrolvisual", "idperfilSaludControlVisual");
    }

    public function insert($request) {

        // <-- LOG
        $log["data"] = "Update register Visual controls";
        $log["page"] = "Health Profile";
        $log["action"] = "val"; //"val" "vis" "del"
        $log["purpose"] = "See information Health Profile";
        //
        // Fix para cuando se ve un miembro de grupo familiar. Ingreso con un ID pero estoy visualizando otro usuario
        $ManagerLog = $this->getManager("ManagerLog");
        $ManagerLog->track($log);
        // <--
        return parent::insert($request);
    }

    /*     * Meotodo para actualizar la informacion de control oftalmologico
     * 
     * @param type $request
     * @return boolean
     */

    public function update_control_oftalmologico($request) {


        if (CONTROLLER == "paciente_p") {
            $ManagerPaciente = $this->getManager("ManagerPaciente");
            $paciente = $ManagerPaciente->getPacienteXHeader();
            $idpaciente = $paciente["idpaciente"];
            if ($idpaciente == "") {
                $this->setMsg(["result" => false, "msg" => "Error. No se pudo recuperar el paciente seleccionado"]);
                return false;
            }
        } else {
            $idpaciente = $request["paciente_idpaciente"];
        }


        $perfil = $this->getByField("paciente_idpaciente", $idpaciente);


        $id = $perfil["$this->id"];


        $record["control_oftalmologico"] = $request["control_oftalmologico"] == "on" ? 1 : 0;
        $record["recien_nacido"] = $request["recien_nacido"] == "" ? 0 : 1;
        $record["12_meses"] = $request["12_meses"] == "" ? 0 : 1;
        $record["3_anios"] = $request["3_anios"] == "" ? 0 : 1;
        $record["5_anios"] = $request["5_anios"] == "" ? 0 : 1;
        $record["6_anios"] = $request["6_anios"] == "" ? 0 : 1;
        $record["12_anios"] = $request["12_anios"] == "" ? 0 : 1;

        $rdo = parent::update($record, $id);
        if ($rdo) {
            // <-- LOG
            $log["data"] = "Update register Visual controls";
            $log["page"] = "Health Profile";
            $log["action"] = "val"; //"val" "vis" "del"
            $log["purpose"] = "See information Health Profile";
            //
            // Fix para cuando se ve un miembro de grupo familiar. Ingreso con un ID pero estoy visualizando otro usuario
            $ManagerLog = $this->getManager("ManagerLog");
            $ManagerLog->track($log);
            // <--
        
            $this->setMsg(["result" => true, "msg" => "Se ha actualizado con éxito el registro de control visual"]);
            return true;
        } else {
            $this->setMsg(["result" => false, "msg" => "Error. No se pudo actualizar el registro de control visual"]);
            return false;
        }
    }

    /*     * Meotodo para actualizar la informacion de uso de anteojos
     * 
     * @param type $request
     * @return boolean
     */

    public function update_control_anteojos($request) {


        if (CONTROLLER == "paciente_p") {
            $ManagerPaciente = $this->getManager("ManagerPaciente");
            $paciente = $ManagerPaciente->getPacienteXHeader();
            $idpaciente = $paciente["idpaciente"];
            if ($idpaciente == "") {
                $this->setMsg(["result" => false, "msg" => "Error. No se pudo recuperar el paciente seleccionado"]);
                return false;
            }
        } else {
            $idpaciente = $request["paciente_idpaciente"];
        }


        $perfil = $this->getByField("paciente_idpaciente", $idpaciente);


        $id = $perfil["$this->id"];


        $record["usa_anteojos"] = $request["usa_anteojos"] == "on" ? 1 : 0;
        $record["lejos"] = $request["lejos"] == "" ? 0 : 1;
        $record["cerca"] = $request["cerca"] == "" ? 0 : 1;

        $record["lejos_OD"] = $request["lejos_OD"];
        $record["lejos_OI"] = $request["lejos_OI"];
        $record["cerca_OD"] = $request["cerca_OD"];
        $record["cerca_OI"] = $request["cerca_OI"];

        $rdo = parent::update($record, $id);
        if ($rdo) {
            $this->setMsg(["result" => true, "msg" => "Se ha actualizado con éxito el registro de control visual"]);
            return true;
        } else {
            $this->setMsg(["result" => false, "msg" => "Error. No se pudo actualizar el registro de control visual"]);
            return false;
        }
    }

    /**
     * Obtiene la información utilizada para visualizar en el tablero
     * @param type $idpaciente
     * @return boolean
     */
    public function getInfoTablero($idpaciente) {
        
        $control_visual = $this->getByField("paciente_idpaciente", $idpaciente);


        if ($control_visual) {

            $info = array();
            //anteojos
            $info["anteojos"] = "";
            if ($control_visual["usa_anteojos"] == 0) {
                $info["anteojos"] = "No";
            } else {
                if ($control_visual["lejos"]== 1) {
                    $info["anteojos"].="Lejos. ";
                }
                if ($control_visual["cerca"] ==1) {
                    $info["anteojos"].="Cerca. ";
                }
                if ($control_visual["bifocal"] == 1) {
                    $info["anteojos"].="Bifocal. ";
                }
                if ($control_visual["bifocal"] == 0) {
                    $info["anteojos"].="Multifocal. ";
                }
            
            }
            //antecedentes
            $ManagerPerfilSaludControlVisualAntecedentes = $this->getManager("ManagerPerfilSaludControlVisualAntecedentes");

            $list_antecedentes = $ManagerPerfilSaludControlVisualAntecedentes->getListAntecedentes($control_visual["idperfilSaludControlVisual"]);
            if (count($list_antecedentes) > 0) {
                $info["antecedentes"] = "";
                foreach ($list_antecedentes as $antecedente) {
                    if ($antecedente["cirugia_ocular"] != "") {
                        $info["antecedentes"].= $antecedente["cirugia_ocular"] . ", ";
                    } else {
                        $info["antecedentes"].= $antecedente["otro_antecedente"] . ", ";
                    }
                }
                    $info["antecedentes"]=substr($info["antecedentes"], 0, -2);
            } else {
                $info["antecedentes"] = "No posee";
            }


            //patologia actual


            $list_actuales = $ManagerPerfilSaludControlVisualAntecedentes->getListPatologiasActuales($control_visual["idperfilSaludControlVisual"]);
            if (count($list_actuales) > 0) {
                $info["patologia_actual"] = "";
                foreach ($list_actuales as $patologia_actual) {

                    $info["patologia_actual"].= $patologia_actual["patologia_actual"] . ", ";
                }
                    $info["patologia_actual"]=substr($info["patologia_actual"], 0, -2);

            } else {
                $info["patologia_actual"] = "No posee";
            }

            return $info;
        } else {
            return false;
        }
    }

    /**
     * Métoodo que retorna los tags para las prótesis.
     * @param type $idpaciente
     * @return string|boolean
     */
    public function getTagsInputsMenuMedico($idpaciente) {
        
 $control_visual = $this->getByField("paciente_idpaciente", $idpaciente);


        if ($control_visual) {
            $tags="";
            
               if ($control_visual["usa_anteojos"] == 1) {
           $anteojos="Lunettes: ";
                if ($control_visual["lejos"]== 1) {
                    $anteojos.="Vision de loin. ";
                }
                if ($control_visual["cerca"] ==1) {
                   $anteojos.="Vision de près. ";
                }
                if ($control_visual["bifocal"] == 1) {
                    $anteojos.="Bifocal. ";
                }
                if ($control_visual["bifocal"] == 0) {
                    $anteojos.="Multifocal. ";
                }
             $tags.=$anteojos;
            }
                        $ManagerPerfilSaludControlVisualAntecedentes = $this->getManager("ManagerPerfilSaludControlVisualAntecedentes");

            $list_antecedentes = $ManagerPerfilSaludControlVisualAntecedentes->getListAntecedentes($control_visual["idperfilSaludControlVisual"]);
            if (count($list_antecedentes) > 0) {
                $tags.=",";
                foreach ($list_antecedentes as $antecedente) {
                    if ($antecedente["cirugia_ocular"] != "") {
                       $tags.= $antecedente["cirugia_ocular"] . ",";
                    } else {
                        $tags.= $antecedente["otro_antecedente"] . ",";
                    }
                }
                 
            }
            
            
            $list_actuales = $ManagerPerfilSaludControlVisualAntecedentes->getListPatologiasActuales($control_visual["idperfilSaludControlVisual"]);
            if (count($list_actuales) > 0) {
               $tags.=",";
                foreach ($list_actuales as $patologia_actual) {

                   $tags.= $patologia_actual["patologia_actual"] . ", ";
                }
                   

            }
             $tags=substr($tags, 0, -1);
             return $tags;
        }else{
  
            return false;
        }
    }

}

//END_class
?>