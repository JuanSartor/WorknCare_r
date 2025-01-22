<?php

/**
 * 	Manager de los antecedentes del control visual
 *
 * 	@author Xinergia
 * 	@version 1.0
 * 	@package managers\extensions
 */
class ManagerPerfilSaludControlVisualAntecedentes extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Constructor
        parent::__construct($db, "perfilsaludcontrolvisualantecedentes", "idperfilSaludControlVisualAntecedentes");
    }

    public function insert($request) {


        if ($request["idperfilSaludControlVisual"] == "" || ($request["idcirugia_ocular"] == "" && $request["otro_antecedente"] == "")) {
            $this->setMsg([ "msg" => "Error. Verifique los campos ingresados", "result" => false]);
            return false;
        }

        //verificamos si ya existe el antecendete a registrar
        if ($request["otro_antecedente"] != "") {
            $exist = $this->getByFieldArray(["otro_antecedente", "perfilsaludcontrolvisual_idperfilSaludControlVisual"], [ $request["otro_antecedente"], $request["idperfilSaludControlVisual"]]);
        } else {
            $exist = $this->getByFieldArray(["cirugia_ocular_idcirugia_ocular", "perfilsaludcontrolvisual_idperfilSaludControlVisual"], [ $request["idcirugia_ocular"], $request["idperfilSaludControlVisual"]]);
        }
        if ($exist) {
            $this->setMsg([ "msg" => "Ya ha agregado el antecedente indicado", "result" => false]);
            return false;
        }
        $record["cirugia_ocular_idcirugia_ocular"] = $request["idcirugia_ocular"];
        $record["otro_antecedente"] = $request["otro_antecedente"];
        $record["perfilsaludcontrolvisual_idperfilSaludControlVisual"] = $request["idperfilSaludControlVisual"];

        $id = parent::insert($record);

        if ($id) {
            $this->setMsg([ "msg" => "Antecedente registrado con éxito", "result" => true, "id" => $id]);
            
            // <-- LOG
            $log["data"] = "Update register Visual controls";
            $log["page"] = "Health Profile";
            $log["action"] = "val"; //"val" "vis" "del"
            $log["purpose"] = "See information Health Profile";                        
            //        
            $ManagerLog = $this->getManager("ManagerLog");
            $ManagerLog->track($log);
            // <--
            
            return true;
        } else {
            $this->setMsg([ "msg" => "Error. No se pudo registrar el antecedente", "result" => false]);
            return false;
        }
    }

    public function insert_patologia_actual($request) {
        if ($request["idperfilSaludControlVisual"] == "" || $request["patologia_actual"] == "") {
            $this->setMsg([ "msg" => "Error. Verifique los campos ingresados", "result" => false]);
            return false;
        }

        //verificamos si ya existe la patologia actual a registrar

        $exist = $this->getByFieldArray(["patologia_actual", "perfilsaludcontrolvisual_idperfilSaludControlVisual"], [ $request["patologia_actual"], $request["idperfilSaludControlVisual"]]);


        if ($exist) {
            $this->setMsg([ "msg" => "Ya ha agregado la patología indicada", "result" => false]);
            return false;
        }
        $record["patologia_actual"] = $request["patologia_actual"];
        $record["actual"] = 1;
        $record["perfilsaludcontrolvisual_idperfilSaludControlVisual"] = $request["idperfilSaludControlVisual"];

        $id = parent::insert($record);

        if ($id) {
            
            // <-- LOG
            $log["data"] = "Update register Visual controls";
            $log["page"] = "Health Profile";
            $log["action"] = "val"; //"val" "vis" "del"
            $log["purpose"] = "See information Health Profile";
            //
            //        
            $ManagerLog = $this->getManager("ManagerLog");
            $ManagerLog->track($log);
            // <--
            
            
            $this->setMsg([ "msg" => "Patología actual registrada con éxito", "result" => true, "id" => $id]);
            return true;
        } else {
            $this->setMsg([ "msg" => "Error. No se pudo registrar la patología indicada", "result" => false]);
            return false;
        }
    }

    /**
     * Listado de los antecedentes de control visual de un paciente
     * @param type $idperfilSaludControlVisual
     * @return type
     */
    public function getListAntecedentes($idperfilSaludControlVisual) {
        $query = new AbstractSql();

        $query->setSelect("
               p.idperfilSaludControlVisualAntecedentes as id, cirugia_ocular,otro_antecedente 
            ");

        $query->setFrom("
                       perfilsaludcontrolvisualantecedentes p
                        LEFT JOIN cirugia_ocular c on (p.cirugia_ocular_idcirugia_ocular=c.idcirugia_ocular)
            ");

        $query->setWhere("p.perfilsaludcontrolvisual_idperfilSaludControlVisual=$idperfilSaludControlVisual and actual=0");

        return $this->getList($query);
    }

    /**
     * Listado de las patologias actuales de control visual de un paciente
     * @param type $idperfilSaludControlVisual
     * @return type
     */
    public function getListPatologiasActuales($idperfilSaludControlVisual) {
        $query = new AbstractSql();

        $query->setSelect("
               p.idperfilSaludControlVisualAntecedentes as id, patologia_actual 
            ");

        $query->setFrom("
                       perfilsaludcontrolvisualantecedentes p
                       
            ");

        $query->setWhere("p.perfilsaludcontrolvisual_idperfilSaludControlVisual=$idperfilSaludControlVisual and actual=1");

        return $this->getList($query);
    }

    /**
     * metodo que elimna todas las patologias actuales de un paciente
     * @param type $idperfilSaludControlVisual
     * @return type
     */
    public function delete_all_patologias_actuales($idperfilSaludControlVisual) {

        $rdo = $this->db->Execute("delete from $this->table where perfilsaludcontrolvisual_idperfilSaludControlVisual=$idperfilSaludControlVisual and actual=1");
        if ($rdo) {

            $this->setMsg([ "msg" => "Patologías eliminadas", "result" => true]);
            return true;
        } else {
            $this->setMsg([ "msg" => "Error. No pudo eliminar las patologías", "result" => false]);
            return false;
        }
    }

}

//END_class
?>