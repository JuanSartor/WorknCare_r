<?php

/**
 * 	Manager del perfil de salud alergia
 *
 * 	@author Xinergia
 * 	@version 1.0
 * 	@package managers\extensions
 */
class ManagerPerfilSaludAntecedentes extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Constructor
        parent::__construct($db, "perfilsaludantecedentes", "idperfilSaludAntecedentes");
    }

    public function process($request) {

        //verificamos los campos obligatorios  
        if ((isset($request["grupofactorsanguineo_idgrupoFactorSanguineo_madre"]) && $request["grupofactorsanguineo_idgrupoFactorSanguineo_madre"] == "") ||
                (isset($request["grupofactorsanguineo_idgrupoFactorSanguineo_padre"]) && $request["grupofactorsanguineo_idgrupoFactorSanguineo_padre"] == "")) {
            $this->setMsg([ "msg" => "Ingrese grupo sanguineo de su madre y padre", "result" => false,]);
            return false;
        }

        if ($request["from_perinatales"] == 1) {
            if ((!isset($request["is_parto"]) && !isset($request["is_cesarea"]))) {
                $this->setMsg([ "msg" => "Seleccione parto o cesárea", "result" => false,]);
                return false;
            }

            if (isset($request["is_parto"]) && (int) $request["is_parto"] == 1) {
                $request["is_parto"] = 1;
                $request["is_cesarea"] = 0;
            }

            if (isset($request["is_cesarea"]) && (int) $request["is_cesarea"] == 1) {
                $request["is_cesarea"] = 1;
                $request["is_parto"] = 0;
            }

            //si es paciente pediatrico se debe completar peso, talla, per. cef.
            $paciente = $this->getManager("ManagerPaciente")->get($request["paciente_idpaciente"]);
            if ((int) $paciente["edad_anio"] < 18 && ((isset($request["peso"]) && (int) $request["peso"] == "") || (isset($request["peso"]) && (int) $request["talla"] == "") || (isset($request["peso"]) && (int) $request["per_cef"] == ""))) {
                $this->setMsg([ "msg" => "Ingrese los campos obligatorios: Peso, Talla, Per. Cef.", "result" => false,]);
                return false;
            }
        }
        //si no se seteo el id en el formulario lo obtenemos mediante el idpaciente si se ha seteado
        if ($request["idperfilSaludAntecedentes"] == "") {
            $antecedentes = $this->getByField("paciente_idpaciente", $request["paciente_idpaciente"]);
            $request["idperfilSaludAntecedentes"] = $antecedentes["idperfilSaludAntecedentes"];
        }

        $rdo = parent::process($request);

        //actualizamos el status si se completaron los perfiles pediatricos 

        $this->getManager("ManagerPerfilSaludStatus")->actualizarStatus($request["paciente_idpaciente"]);

        return $rdo;
    }

    /*     * Metodo que mediante el checkbox de anecedentes familiares selecciona que no poseen ninguna patologia y borra las existentes
     * 
     * @param type $request
     */

    public function ningunAntecedenteFamiliar($request) {
        //si no se seteo el id en el formulario lo obtenemos mediante el idpaciente si se ha seteado
        if ($request["idperfilSaludAntecedentes"] == "") {
            $antecedentes = $this->getByField("paciente_idpaciente", $request["paciente_idpaciente"]);
            $request["idperfilSaludAntecedentes"] = $antecedentes["idperfilSaludAntecedentes"];
        }

        $this->db->StartTrans();
        $request["posee_antecedentesfamiliares"] = 0;
        $rdo = parent::process($request);
        $borrar = true;
        if ($request["idperfilSaludAntecedentes"] != "") {
            $borrar = $this->db->Execute("delete from antecedentes_patologiafamiliar where perfilSaludAntecedentes_idperfilSaludAntecedentes=" . $request["idperfilSaludAntecedentes"]);
        }
        $this->getManager("ManagerPerfilSaludStatus")->actualizarStatus($request["paciente_idpaciente"]);
        if ($rdo && $borrar) {

            $this->setMsg([ "msg" => "Registro actualizado con éxito", "result" => true,]);
            $this->db->CompleteTrans();
            return true;
        } else {
            $this->setMsg([ "msg" => "No se pudo guardar la opción", "result" => false,]);
            $this->db->CompleteTrans();
            return false;
        }
    }

}

//END_class
?>