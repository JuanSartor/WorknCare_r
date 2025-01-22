<?php

/**
 * ManagerMotivoVideoConsulta administra los motivos asociados a una videoconsulta cuando se crea
 *
 * @author lucas
 */
class ManagerMotivoVideoConsulta extends AbstractManager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Constructor
        parent::__construct($db, "motivovideoconsulta", "idmotivoVideoConsulta");
    }

    /**
     *  Combo de los motivos de rechazo de una VC
     *
     * */
    public function getCombo($psicologo = 0) {

        $query = new AbstractSql();
        $query->setSelect("$this->id, motivoVideoConsulta");
        $query->setFrom("$this->table");
        $query->setWhere("ps=$psicologo");
        $query->setOrderBy("motivoVideoConsulta ASC");

        return $this->getComboBox($query, false);
    }

    /**
     *  Combo de los motivos de consulta
     *
     * */
    public function getComboByEspecialidad($idespecialidad) {

        $query = new AbstractSql();
        $query->setSelect("$this->id, motivoVideoConsulta");
        $query->setFrom("motivovideoconsulta_especialidad t inner JOIN motivovideoconsulta m ON(t.motivoVideoConsulta_idmotivoVideoConsulta=m.idmotivoVideoConsulta)");
        $query->setWhere("t.especialidad_idespecialidad=$idespecialidad");
        $query->setOrderBy("motivoVideoConsulta ASC");
        $list = $this->getComboBox($query, false);

        if (count($list) == 0) {
            //buscamos los default
            $query = new AbstractSql();
            $query->setSelect("$this->id, motivoVideoConsulta");
            $query->setFrom("motivovideoconsulta t");
            $query->setWhere("t.idmotivoVideoConsulta not in (select m.motivoVideoConsulta_idmotivoVideoConsulta from motivovideoconsulta_especialidad m  )");
            $query->setOrderBy("motivoVideoConsulta ASC");
            $list = $this->getComboBox($query, false);
        }

        return $list;
    }
    
       /**
     *  Combo de los motivos de consulta por programa de salud
     *
     * */
    public function getComboByProgramaCategoria($idprograma_categoria) {

        $query = new AbstractSql();
        $query->setSelect("$this->id, motivoVideoConsulta");
        $query->setFrom("motivovideoconsulta_programa_categoria t inner JOIN motivovideoconsulta m ON(t.motivoVideoConsulta_idmotivoVideoConsulta=m.idmotivoVideoConsulta)");
        $query->setWhere("t.idprograma_categoria=$idprograma_categoria");
        $query->setOrderBy("motivoVideoConsulta ASC");
        $list = $this->getComboBox($query, false);

        if (count($list) == 0) {
            //buscamos los default
            $query = new AbstractSql();
            $query->setSelect("$this->id, motivoVideoConsulta");
            $query->setFrom("motivovideoconsulta t");
            $query->setWhere("t.idmotivoVideoConsulta not in (select m.motivoVideoConsulta_idmotivoVideoConsulta from motivovideoconsulta_programa_categoria m  )");
            $query->setOrderBy("motivoVideoConsulta ASC");
            $list = $this->getComboBox($query, false);
        }

        return $list;
    }

    public function getListadoJSON($request, $idpaginate = NULL) {

        if (!is_null($idpaginate)) {
            $this->paginate($idpaginate, 50);
        }

        $query = new AbstractSql();
        $query->setSelect("*");

        $query->setFrom("
                $this->table
            ");

        // Filtro
        if ($request["motivoVideoConsulta"] != "") {

            $nombre = cleanQuery($request["motivoVideoConsulta"]);

            $query->addAnd("motivoVideoConsulta LIKE '%$nombre%'");
        }


        $query->setOrderBy("motivoVideoConsulta ASC");

        $data = $this->getJSONList($query, array("motivoVideoConsulta"), $request, $idpaginate);

        return $data;
    }

}
