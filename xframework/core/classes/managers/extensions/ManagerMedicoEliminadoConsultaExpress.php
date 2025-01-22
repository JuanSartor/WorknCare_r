<?php

/**
 * ManagerMedicoEliminadoConsultaExpress administra los medico que se eliminan de los resultados de busqueda de profesionales para que no se le asigne las consulas express 
 * dirigida profesionales en la red
 *
 * @author lucas
 */
class ManagerMedicoEliminadoConsultaExpress extends AbstractManager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Constructor
        parent::__construct($db, "medicoeliminadoconsultaexpress", "idmedicoEliminadoConsultaExpress");
    }

    /**
     * eliminacion multiple de profesionales de la bolsa de medicos de la consulta express
     * 
     * @param type $request
     * @return boolean
     */
    public function eliminarMedicosConsultaExpress($request) {

        $listado_ids = explode(",", $request["ids"]);


        $result = true;
        if ($listado_ids && count($listado_ids) > 0) {

            foreach ($listado_ids as $idmedico) {

                if (!$this->isEliminadoConsultaExpress($idmedico, $request["idconsultaExpress"])) {
                    $rdo = parent::insert(["medico_idmedico" => $idmedico, "consultaExpress_idconsultaExpress" => $request["idconsultaExpress"]]);
                    if (!$rdo) {
                        $result = false;
                    }
                }
            }
            if ($result) {
                $this->setMsg([ "msg" => "Profesionales eliminados con éxito", "result" => true]);
                return true;
            } else {
                $this->setMsg([ "msg" => "No se ha podido eliminar el profesional", "result" => false]);
                return false;
            }
        } else {
            $this->setMsg([ "msg" => "No ha seleccionado profesionales", "result" => false]);
            return false;
        }
    }

    /*     * Metodo que retorna el listado de idmedicos bloqueados por un paciente concatenados en formato de string
     * 
     * @param type $idconsultaExpress
     */

    public function getElimiadosConsultaExpress($idconsultaExpress) {
        $list = $this->getListadoEliminadosConsultaExpress($idconsultaExpress);
        $result = "";
        foreach ($list as $medico) {
            $result = $result . "," . $medico["medico_idmedico"];
        }

        $rdo = substr($result, 1);

        return $rdo;
    }

    /* Metodo que devuelve un array de idmedico eliminados de una consultaExpress
     * 
     */

    public function getListadoEliminadosConsultaExpress($idconsultaExpress) {
        $query = new AbstractSql();
        $query->setSelect("medico_idmedico");
        $query->setFrom("$this->table");
        $query->setWhere("consultaExpress_idconsultaExpress=$idconsultaExpress");

        $rdo = $this->getList($query);

        return $rdo;
    }

    /* Metodo que devuelve un array de idmedico eliminado de la consulta express
     * 
     */

    public function isEliminadoConsultaExpress($idmedico, $idconsultaexpress) {

        $query = new AbstractSql();
        $query->setSelect("count(*) as qty");
        $query->setFrom("$this->table");
        $query->setWhere("medico_idmedico=$idmedico and consultaExpress_idconsultaExpress=$idconsultaexpress");
        $rdo = $this->db->getRow($query->getSql());
        return (int) $rdo["qty"] > 0;
    }

}
