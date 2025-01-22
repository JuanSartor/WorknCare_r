<?php

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * ManagerProfesionalBloqueo administra el bloqueo de un medico por parte del paciente para que no se le asigne las consulas express 
 * dirigida profesionales en la red
 *
 * @author lucas
 */
class ManagerProfesionalBloqueo extends AbstractManager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Constructor
        parent::__construct($db, "profesionalbloqueo", "idprofesionalBloqueo");
    }

    /**
     * bloqueo multiple de profesionales
     * 
     * @param type $ids
     * @param type $forced
     * @return boolean
     */
    public function bloquear($ids) {
        $listado_ids = explode(",", $ids);

        $paciente = $this->getManager("ManagerPaciente")->getPacienteXHeader();
        $idpaciente = $paciente["idpaciente"];
        $result = true;
        if ($listado_ids && count($listado_ids) > 0) {

            foreach ($listado_ids as $idmedico) {

                if (!$this->isBloqueado($idmedico, $idpaciente)) {
                    $rdo = parent::insert(["medico_idmedico" => $idmedico, "paciente_idpaciente" => $idpaciente]);
                    if (!$rdo) {
                        $result = false;
                    }
                }
            }
            if ($result) {
                $this->setMsg([ "msg" => "Profesionales bloqueados con exito", "result" => true]);
                return true;
            } else {
                $this->setMsg([ "msg" => "No ha podido bloquear el profesional", "result" => false]);
                return false;
            }
        } else {
            $this->setMsg([ "msg" => "No ha seleccionado profesionales", "result" => false]);
            return false;
        }
    }

    /*     * Metodo que permite desbloquear un profesional  bloqueado por el paciente anteriormente 
     * 
     * @param type $idmedico
     * @return boolean
     */

    public function desbloquear($idmedico) {
        $paciente = $this->getManager("ManagerPaciente")->getPacienteXHeader();
        $idpaciente = $paciente["idpaciente"];
        if ($idmedico == "") {
            $this->setMsg([ "msg" => "No ha seleccionado un profesional", "result" => false]);
            return false;
        } else {
            $rdo = $this->db->Execute("delete from profesionalbloqueo where medico_idmedico=$idmedico and paciente_idpaciente=$idpaciente");
            if ($rdo) {
                $this->setMsg([ "msg" => "El profesional ha sido desbloqueado con éxito", "result" => true]);
                return true;
            } else {
                $this->setMsg([ "msg" => "Error. No ha podido desbloquear el profesional", "result" => false]);
                return false;
            }
        }
    }

    /*     * Metodo que retorna el listado de idmedicos bloqueados por un paciente concatenados en formato de string
     * 
     * @param type $idpaciente
     */

    public function getBloqueados($idpaciente) {
        $list = $this->getListadoBloqueados($idpaciente);
        $result = "";
        foreach ($list as $medico) {
            $result = $result . "," . $medico["medico_idmedico"];
        }
        return substr($result, 1);
    }

    /* Metodo que devuelve un array de idmedico bloqueados por un paciente
     * 
     */

    public function getListadoBloqueados($idpaciente) {
        $query = new AbstractSql();
        $query->setSelect("medico_idmedico");
        $query->setFrom("$this->table");
        $query->setWhere("paciente_idpaciente=$idpaciente");

        return $this->getList($query);
    }

    /* Metodo que devuelve un array de idmedico bloqueados por un paciente
     * 
     */

    public function isBloqueado($idmedico, $idpaciente) {

        $query = new AbstractSql();
        $query->setSelect("count(*) as qty");
        $query->setFrom("$this->table");
        $query->setWhere("medico_idmedico=$idmedico and paciente_idpaciente=$idpaciente");
        $rdo = $this->db->getRow($query->getSql());
        return (int) $rdo["qty"] > 0;
    }

}
