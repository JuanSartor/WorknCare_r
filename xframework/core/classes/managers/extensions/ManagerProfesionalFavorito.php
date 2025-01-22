<?php

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * ManagerProfesionalFavorito administra la seleccion de un medico como favorito de un paciente
 *
 * @author lucas
 */
class ManagerProfesionalFavorito extends AbstractManager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Constructor
        parent::__construct($db, "profesionalfavorito", "idprofesionalFavorito");
    }

    /**
     * establece un profesional como favorito
     * 
     * @param type $ids
     * @param type $forced
     * @return boolean
     */
    public function marcarFavorito($idmedico) {
        $paciente = $this->getManager("ManagerPaciente")->getPacienteXHeader();
        $idpaciente = $paciente["idpaciente"];

        if ($idmedico == "") {
            $this->setMsg([ "msg" => "No ha seleccionado profesionales", "result" => false]);
            return false;
        } else {


            if (!$this->isFavorito($idmedico, $idpaciente)) {
                $result = parent::insert(["medico_idmedico" => $idmedico, "paciente_idpaciente" => $idpaciente]);
                if ($result) {
                    $this->setMsg([ "msg" => "El profesional ha sido seleccionado como favorito", "result" => true]);
                    
                    // <-- LOG
                    $log["data"] = "Added to list of Health Professionals";
                    $log["page"] = "Home page (connected)";
                    $log["action"] = "val"; //"val" "vis" "del"
                    $log["purpose"] = "Add Favorite Profesional";    

                    $ManagerLog = $this->getManager("ManagerLog");
                    $ManagerLog->track($log);
                    // 
                    return true;
                } else {
                    $this->setMsg([ "msg" => "No se ha podido seleccionar el profesional como favorito", "result" => false]);
                    return false;
                }
            } else {
                $result = $this->desmarcarFavorito($idmedico);
                if ($result) {
                    $this->setMsg([ "msg" => "El profesional ha sido eliminado de su favoritos con éxito", "result" => true]);

                    return true;
                } else {
                    $this->setMsg([ "msg" => "Error. No ha podido eliminarse el profesional de sus favoritos", "result" => false]);
                    return false;
                }
            }
        }
    }

    /*     * Metodo que permite desmarcar un medico como favorito por el paciente anteriormente 
     * 
     * @param type $idmedico
     * @return boolean
     */

    public function desmarcarFavorito($idmedico) {
        $paciente = $this->getManager("ManagerPaciente")->getPacienteXHeader();
        $idpaciente = $paciente["idpaciente"];
        if ($idmedico == "") {
            $this->setMsg([ "msg" => "No ha seleccionado un profesional", "result" => false]);
            return false;
        } else {
            $rdo = $this->db->Execute("delete from profesionalfavorito where medico_idmedico=$idmedico and paciente_idpaciente=$idpaciente");
            if ($rdo) {
                $this->setMsg([ "msg" => "El profesional ha sido eliminado de su favoritos con éxito", "result" => true]);
                
                // <-- LOG
                $log["data"] = "Added to list of Health Professionals";
                $log["page"] = "Home page (connected)";
                $log["action"] = "val"; //"val" "vis" "del"
                $log["purpose"] = "Remove Favorite Profesionals";    

                $ManagerLog = $this->getManager("ManagerLog");
                $ManagerLog->track($log);
                // 

                return true;
            } else {
                $this->setMsg([ "msg" => "Error. No ha podido eliminarse el profesional de sus favoritos", "result" => false]);
                return false;
            }
        }
    }

    /*     * Metodo que retorna el listado de idmedicos favoritos por un paciente concatenados en formato de string
     * 
     * @param type $idpaciente
     */

    public function getFavoritos($idpaciente) {
        $list = $this->getListadoFavoritos($idpaciente);
        $result = "";
        foreach ($list as $medico) {
            $result .= "," . $medico["medico_idmedico"];
        }
        return substr($result, 1);
    }

    /* Metodo que devuelve un array de idmedico favoritos de un paciente
     * 
     */

    public function getListadoFavoritos($idpaciente) {
        $query = new AbstractSql();
        $query->setSelect("medico_idmedico");
        $query->setFrom("$this->table");
        $query->setWhere("paciente_idpaciente=$idpaciente");

        return $this->getList($query);
    }

    /* Metodo que devuelve si un medico es favorito de un paciente
     * 
     */

    public function isFavorito($idmedico, $idpaciente) {

        $query = new AbstractSql();
        $query->setSelect("count(*) as qty");
        $query->setFrom("$this->table");
        $query->setWhere("medico_idmedico=$idmedico and paciente_idpaciente=$idpaciente");
        $rdo = $this->db->getRow($query->getSql());
        return (int) $rdo["qty"] > 0;
    }

}
