<?php

/**
 * 	@autor Xinergia
 * 	@version 1.0	2022-05-04
 * 	Manager de empresas
 *
 */

/**
 * @autor Juan
 * 
 * Class ManagerProgramaSaludPlanEmpresa
 * 	
 * 
 */
class ManagerHistorialProgramaSaludPlanEmpresa extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

// Llamamos al constructor del a superclase
        parent::__construct($db, "historial_programasalud_plan_empresa", "idhistorial_programasalud_plan_empresa");
        $this->default_paginate = "historial_programasalud_plan_empresa";
    }

    public function getListByIdEmpresa($idempresa) {
        $query = new AbstractSql();

        $query->setSelect("*");

        $query->setFrom("$this->table t");

        $query->setWhere("t.empresa_idempresa= $idempresa");

        return $this->getList($query);
    }

}

//END_class 
?>