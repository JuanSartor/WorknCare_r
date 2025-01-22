<?php

/**
 * 	@autor Juan Sartor
 * 	@version 	01/10/2021
 * 	Manager de Medicos referentes de Programas de salud grupo asociacion.
 *
 */
class ManagerProgramaSaludGrupoAsociacion extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    public function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "programas_salud_grupo_asociacion", "idprogramas_salud_grupo_asociacion");
    }

    public function getListadoProgramas($request, $idpaginate = null) {
        $query = new AbstractSql();
        $query->setSelect("t.* ,m.*");
        $query->setFrom("
                $this->table  t INNER JOIN programa_salud m ON (t.programa_salud_idprograma_salud=m.idprograma_salud)     
            ");
        $query->setWhere("t.programa_salud_grupo_idprograma_salud_grupo=" . $request["idprograma_salud_grupo"]);

        $query->setOrderBy("t.idprogramas_salud_grupo_asociacion ASC");

        $data = $this->getList($query);
        return $data;
    }

    /**
     * Método que devuelve un combo con los programas que aun no han sido asignados a un grupo
     */
    public function getComboProgramas($request, $idpaginate = null) {
        $query = new AbstractSql();
        $query->setSelect("m.idprograma_salud, m.programa_salud");
        $query->setFrom("programa_salud m");
        $query->setOrderBy("m.programa_salud ASC");

        return $this->getComboBox($query, false);
    }

    /**
     * Método que asigna un programa a un grupo de salud
     * @param type $request
     */
    public function insert($request) {
        $exist_programa_ya_asignado = $this->getByFieldArray(["programa_salud_grupo_idprograma_salud_grupo", "programa_salud_idprograma_salud"], [$request["programa_salud_grupo_idprograma_salud_grupo"], $request["programa_salud_idprograma_salud"]]);

        if ($exist_programa_ya_asignado) {
            $this->setMsg(["msg" => "El programa ya se encuentra asignado", "result" => false]);
            return false;
        }
        return parent::insert($request);
    }

    /**
     * Metodo que devuelve la informacion de los programas asociados a un grupo
     * @param type $idprodrama_grupo
     */
    public function getProgramasAsociados($idprodrama_grupo) {
        $query = new AbstractSQL();
        $query->setSelect("*");
        $query->setFrom("$this->table");
        $query->setWhere("programa_salud_grupo_idprograma_salud_grupo=$idprodrama_grupo");
        $query->setOrderBy("$this->id ASC");

        $listado = $this->getList($query);
        $ManagerProgramaSalud = $this->getManager("ManagerProgramaSalud");
        foreach ($listado as $key => $grupo) {
            $listado[$key] = $ManagerProgramaSalud->get($grupo["programa_salud_idprograma_salud"]);
        }
        return $listado;
    }

}

//END_class


