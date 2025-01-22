<?php

/**
 * 	@autor Xinergia
 * 	@version 1.0	20/11/2020
 * 	Manager de Medicos complementarios de Programas de salud.
 *
 */
class ManagerProgramaSaludMedicoComplementario extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "programa_medico_complementario", "idprograma_medico_complementario");
    }

    public function getListadoMedicos($request, $idpaginate = NULL) {

        $query = new AbstractSql();
        $query->setSelect("t.* ,m.*");
        $query->setFrom("
                $this->table  t INNER JOIN v_medicos m ON (t.medico_idmedico=m.idmedico)     
            ");
        $query->setWhere("programa_categoria_idprograma_categoria=" . $request["idprograma_categoria"]);

        $query->setOrderBy("nombre ASC,apellido ASC");

        $data = $this->getList($query);
        return $data;
    }

    /**
     * Método que devuelve un combo con los médicos que aun no han sido asignados como medico complementario a una categoria
     */
    public function getComboMedicos($request, $idpaginate = null) {
        $query = new AbstractSql();
        $query->setSelect("m.idmedico, CONCAT(m.nombre,' ',m.apellido,' (',m.especialidad,')')");
        $query->setFrom("v_medicos m");
        $query->setWhere("m.idmedico NOT IN (SELECT medico_idmedico FROM programa_medico_complementario where programa_categoria_idprograma_categoria={$request['idprograma_categoria']})");
        $query->addAnd("m.idmedico NOT IN (SELECT medico_idmedico FROM programa_medico_referente where programa_categoria_idprograma_categoria={$request['idprograma_categoria']})");

        $query->setOrderBy("nombre ASC,apellido ASC");

        return $this->getComboBox($query, false);
    }

    /**
     * Método que asigna un medico a una categoria del programa de salud
     * @param type $request
     */
    public function insert($request) {
        $exist_referente = $this->getByFieldArray(["programa_categoria_idprograma_categoria", "medico_idmedico"], [$request["programa_categoria_idprograma_categoria"], $request["medico_idmedico"]]);
        $exist_complementario = $this->getManager("ManagerProgramaSaludMedicoReferente")->getByFieldArray(["programa_categoria_idprograma_categoria", "medico_idmedico"], [$request["programa_categoria_idprograma_categoria"], $request["medico_idmedico"]]);
        if ($exist_referente || $exist_complementario) {
            $this->setMsg(["msg" => "El médico ya se encuentra en esta categoría del programa de salud", "result" => false]);
            return false;
        }
        return parent::insert($request);
    }

}

//END_class
