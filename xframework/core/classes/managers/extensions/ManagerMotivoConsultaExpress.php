<?php

/**
 * ManagerMotivoConsultaExpress administra los motivos asociados a una consulta express cuando se crea
 *
 * @author lucas
 */
class ManagerMotivoConsultaExpress extends AbstractManager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Constructor
        parent::__construct($db, "motivoconsultaexpress", "idmotivoConsultaExpress");
    }

    /**
     *  Combo de los motivos de consulta
     *
     * */
    public function getComboByEspecialidad($idespecialidad) {

        $query = new AbstractSql();
        $query->setSelect("$this->id, motivoConsultaExpress");
        $query->setFrom("motivoconsultaexpress_especialidad t inner JOIN motivoconsultaexpress m ON(t.motivoConsultaExpress_idmotivoConsultaExpress=m.idmotivoConsultaExpress)");
        $query->setWhere("t.especialidad_idespecialidad=$idespecialidad");
        $query->setOrderBy("motivoConsultaExpress ASC");
        $list = $this->getComboBox($query, false);

        if (count($list) == 0) {
            //buscamos los default
            $query = new AbstractSql();
            $query->setSelect("$this->id, motivoConsultaExpress");
            $query->setFrom("motivoconsultaexpress t");
            $query->setWhere("t.idmotivoConsultaExpress not in (select m.motivoConsultaExpress_idmotivoConsultaExpress from motivoconsultaexpress_especialidad m  )");
            $query->setOrderBy("motivoConsultaExpress ASC");
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
        $query->setSelect("$this->id, motivoConsultaExpress");
        $query->setFrom("motivoconsultaexpress_programa_categoria t inner JOIN motivoconsultaexpress m ON(t.motivoConsultaExpress_idmotivoConsultaExpress=m.idmotivoConsultaExpress)");
        $query->setWhere("t.idprograma_categoria=$idprograma_categoria");
        $query->setOrderBy("motivoConsultaExpress ASC");
        $list = $this->getComboBox($query, false);

        if (count($list) == 0) {
            //buscamos los default
            $query = new AbstractSql();
            $query->setSelect("$this->id, motivoConsultaExpress");
            $query->setFrom("motivoconsultaexpress t");
            $query->setWhere("t.idmotivoConsultaExpress not in (select m.motivoConsultaExpress_idmotivoConsultaExpress from motivoconsultaexpress_programa_categoria m  )");
            $query->setOrderBy("motivoConsultaExpress ASC");
            $list = $this->getComboBox($query, false);
        }
        return $list;
    }

    /**
     *  Combo de los motivos de rechazo de una CE
     *
     * */
    public function getCombo($psicologo = 0) {

        $query = new AbstractSql();
        $query->setSelect("$this->id, motivoConsultaExpress");
        $query->setFrom("$this->table");
        $query->setWhere("ps=$psicologo");
        $query->setOrderBy("motivoConsultaExpress ASC");

        return $this->getComboBox($query, false);
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
        if ($request["motivoConsultaExpress"] != "") {

            $nombre = cleanQuery($request["motivoConsultaExpress"]);

            $query->addAnd("motivoConsultaExpress LIKE '%$nombre%'");
        }


        $query->setOrderBy("motivoConsultaExpress ASC");

        $data = $this->getJSONList($query, array("motivoConsultaExpress"), $request, $idpaginate);

        return $data;
    }

}
