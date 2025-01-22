<?php

/**
 * 	@autor Juan Sartor
 * 	@version 	01/10/2021
 * 	Manager de Medicos referentes de Programas de salud grupo asociacion.
 *
 */
class ManagerProgramaSaludGrupoEmpresaAsociacion extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    public function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "programas_salud_grupo_empresa_asociacion", "idprogramas_salud_grupo_empresa_asociacion");
    }

    public function getListadoProgramas($request, $idpaginate = null) {
        $query = new AbstractSql();
        $query->setSelect("t.* ,m.*");
        $query->setFrom("
                $this->table  t INNER JOIN programa_salud m ON (t.programa_salud_idprograma_salud=m.idprograma_salud)     
            ");
        $query->setWhere("t.programa_salud_grupo_empresa_idprograma_salud_grupo_empresa=" . $request["idprograma_salud_grupo_empresa"]);

        $query->setOrderBy("t.idprogramas_salud_grupo_empresa_asociacion ASC");

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
        $query->setWhere("NOT EXISTS (SELECT * FROM programas_salud_grupo_empresa_asociacion where programa_salud_idprograma_salud=m.idprograma_salud)");
        $query->setOrderBy("m.programa_salud ASC");

        return $this->getComboBox($query, false);
    }

    /**
     * Método que asigna un programa a un grupo de salud
     * @param type $request
     */
    public function insert($request) {
        $exist_programa_ya_asignado = $this->getByFieldArray(["programa_salud_grupo_empresa_idprograma_salud_grupo_empresa", "programa_salud_idprograma_salud"], [$request["programa_salud_grupo_empresa_idprograma_salud_grupo_empresa"], $request["programa_salud_idprograma_salud"]]);

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
        $ManagerProgramaSaludCategoria = $this->getManager("ManagerProgramaSaludCategoria");
        $query = new AbstractSQL();
        $query->setSelect("*");
        $query->setFrom("$this->table");
        $query->setWhere("programa_salud_grupo_empresa_idprograma_salud_grupo_empresa=$idprodrama_grupo");
        $query->setOrderBy("$this->id ASC");

        $listado = $this->getList($query);
        $ManagerProgramaSalud = $this->getManager("ManagerProgramaSalud");
        foreach ($listado as $key => $grupo) {
            $listado[$key] = $ManagerProgramaSalud->get($grupo["programa_salud_idprograma_salud"]);
            $listado_categorias = $ManagerProgramaSaludCategoria->getListadoCategorias($grupo["programa_salud_idprograma_salud"]);


            $listado[$key]["listado_categorias"] = $listado_categorias;
        }
        return $listado;
    }

    public function deleteAsociacion($id) {

        $this->db->Execute("delete from programas_salud_grupo_empresa_asociacion where programa_salud_grupo_empresa_idprograma_salud_grupo_empresa=" . $id);
    }

}

//END_class


