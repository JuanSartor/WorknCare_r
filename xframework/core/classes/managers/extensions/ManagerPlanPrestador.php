<?php

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Description of ManagerPrestador
 *
 * @author lucas
 */
class ManagerPlanPrestador extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "plan_prestador", "idplan_prestador");
    }

    /*     * Metodo que obtiene el liostado en formato JSON de los planes asignados a un prestador
     * 
     * @param type $idpaginate
     * @param type $request
     * @return type
     */

    public function getListadoJSON($request, $idpaginate = NULL) {


        if ($_SESSION[URL_ROOT][CONTROLLER]['logged_account']['user']['idusuario_prestador'] != "") {
            $request["idprestador"] = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']['user']['prestador_idprestador'];
        }
        if ($request["idprestador"] == "") {
            return false;
        }
        if (!is_null($idpaginate)) {
            $this->paginate($idpaginate, 50);
        }

        $query = new AbstractSql();
        $query->setSelect("*");
        $query->setFrom("$this->table");
        $query->setWhere("prestador_idprestador={$request["idprestador"]}");
        $query->setOrderBy("nombre ASC");

        $data = $this->getJSONList($query, array("nombre", "cantidad_ce", "cantidad_vc"), $request, $idpaginate);
        return $data;
    }

    /*     * Metodo que crea la relacion entre un paciente y el prestador
     * 
     * @param type $request
     * @return boolean
     */

    public function process($request) {
        if ($_SESSION[URL_ROOT][CONTROLLER]['logged_account']['user']['idusuario_prestador'] != "") {
            $request["prestador_idprestador"] = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']['user']['prestador_idprestador'];
        }
        if ($request["prestador_idprestador"] == "") {
            $this->setMsg(["msg" => "Error. No se pudo recuperar el prestador", "result" => false]);
            return false;
        }
        return parent::process($request);
    }

    /*     * Metodo que devuelve un combo de planes de un prestador
     * 
     * @param type $idprestado
     */

    public function getComboPlanes($idprestador) {
        
          $query = new AbstractSql();
          $query->setSelect("$this->id,nombre");
          $query->setFrom("$this->table");
          $query->setWhere("prestador_idprestador=$idprestador");

          return $this->getComboBox($query, false);
    }

}
