<?php

/**
 * 	Manager de pa�s
 *
 * 	@author <XINERGIA>
 * 	@version 1.0
 * 	@package managers\extensions
 */
class ManagerPacienteTablero extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Constructor
        parent::__construct($db, "paciente_tablero", "idpaciente_tablero");
    }

    /**
     * Método que retorna el listado de tablero y paciente
     * @param type $idtablero
     * @param type $idpaciente
     * @return boolean
     */
    public function getListTableroPaciente($idtablero, $idpaciente) {
        $query = new AbstractSql();

        $query->setSelect("*");

        $query->setFrom("$this->table");

        $query->setWhere("paciente_idpaciente = $idpaciente");

        $query->addAnd("tablero_idtablero = $idtablero");

        $execute = $this->db->Execute($query->getSql());
        if ($execute) {
            return $execute->FetchRow();
        } else {
            return false;
        }
    }

    /**
     * Método que retorna un listado con los registros pertenecientes a un determinado paciente
     * @param type $idpaciente
     * @return type
     */
    public function getListPacienteTablero($idpaciente) {
        $query = new AbstractSql();

        $query->setSelect("t.*");

        $query->setFrom("$this->table pt INNER JOIN tablero t ON (pt.tablero_idtablero = t.idtablero)");

        $query->setWhere("pt.paciente_idpaciente = $idpaciente");

        return $this->getList($query);
    }

    /**
     * Método que realiza el procesamiento proveniente del Front End
     * Se recibirá un array que salen de los checkboxs que configurará el paciente
     * @param type $request
     * @return boolean
     */
    public function processFromFrontEnd($request) {

        if (count($request["tablero"]) > 0) {
            //Debo insertar los que vengan si es que no están
            foreach ($request["tablero"] as $key => $idtablero) {
                $rdo = $this->getListTableroPaciente($idtablero, $request["paciente_idpaciente"]);
                if (!$rdo) {
                    //Si no hay ninguna configuración previamente guaradada, la inserto...
                    $insert = parent::insert([
                                "tablero_idtablero" => $idtablero,
                                "paciente_idpaciente" => $request["paciente_idpaciente"]
                    ]);
                    //Si se produjo un error
                    if (!$insert) {
                        $this->setMsg([ "msg" => "Se produjo un error al procesar la configuración del tablero", "result" => false]);
                        return false;
                    }
                }
            }

            $implode = implode(",", $request["tablero"]);
            //Eliminar los que no están 
            $execute_str = "DELETE FROM $this->table
                            WHERE tablero_idtablero NOT IN($implode) AND paciente_idpaciente = " . $request["paciente_idpaciente"];
            $rdo_delete = $this->db->Execute($execute_str);
            if ($rdo_delete) {
                $this->setMsg([ "msg" => "Se ha guardado la configuración del tablero.", "result" => true]);
                return true;
            } else {
                $this->setMsg([ "msg" => "Se produjo un error al procesar la configuración del tablero.", "result" => false]);
                return false;
            }
        } else {
            //Debo borrar todos los registros que se encuentren, ya que no vino ningún seleccionado
            $execute_str = "DELETE FROM $this->table
                            WHERE paciente_idpaciente = " . $request["paciente_idpaciente"];
            $rdo_delete = $this->db->Execute($execute_str);
            if ($rdo_delete) {
                $this->setMsg([ "msg" => "Se ha guardado la configuración del tablero.", "result" => true]);
                return true;
            } else {
                $this->setMsg([ "msg" => "Se produjo un error al procesar la configuración del tablero.", "result" => false]);
                return false;
            }
        }
    }

}

?>