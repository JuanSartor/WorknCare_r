<?php

/**
 * 	@autor Xinergia
 * 	@version 1.0	29/05/2014
 * 	Manager de los motivos de las visitas
 *
 */
class ManagerMotivoVisita extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "motivovisita", "idmotivoVisita");
    }

    /*
     * 	@author Xinergia <info@e-xinergia.com>
     *   @version 1.0
     */

    public function insert($request) {

        $id = parent::insert($request);

        //si se crea correctamente asocio las funcionaldades y si aplica o no
        if ($id) {

            $msg = $this->getMsg();



            $this->setMsg(["msg" => "El Motivo de Visita ha sido creado con éxito", "result" => true]);
        }

        return $id;
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
        if ($request["motivoVisita"] != "") {

            $nombre = cleanQuery($request["motivoVisita"]);

            $query->addAnd("motivoVisita LIKE '%$nombre%'");
        }


        $query->setOrderBy("motivoVisita ASC");

        $data = $this->getJSONList($query, array("motivoVisita"), $request, $idpaginate);

        return $data;
    }

    public function getCombo($psicologo = 0) {

        $query = new AbstractSql();
        $query->setSelect("$this->id,motivoVisita");
        $query->setWhere("ps=$psicologo");
        $query->setOrderBy("motivoVisita ASC");
        return $this->getComboBox($query, false);
    }

    /**
     *  Combo de los motivos de consulta
     *
     * */
    public function getComboByEspecialidad($idespecialidad) {

        $query = new AbstractSql();
        $query->setSelect("$this->id, motivoVisita");
        $query->setFrom("motivovisita_especialidad t inner JOIN motivovisita m ON(t.motivoVisita_idmotivoVisita=m.idmotivoVisita)");
        $query->setWhere("t.especialidad_idespecialidad=$idespecialidad");
        $query->setOrderBy("motivoVisita ASC");

        $list = $this->getComboBox($query, false);

        if (count($list) == 0) {
            //buscamos los default
            $query = new AbstractSql();
            $query->setSelect("$this->id, motivoVisita");
            $query->setFrom("motivovisita t");
            $query->setWhere("t.idmotivoVisita not in (select m.motivoVisita_idmotivoVisita from motivovisita_especialidad m  )");
            $query->setOrderBy("motivoVisita ASC");
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
        $query->setSelect("$this->id, motivoVisita");
        $query->setFrom("motivovisita_programa_categoria t inner JOIN motivovisita m ON(t.motivoVisita_idmotivoVisita=m.idmotivoVisita)");
        $query->setWhere("t.idprograma_categoria=$idprograma_categoria");
        $query->setOrderBy("motivoVisita ASC");
        $list = $this->getComboBox($query, false);

        if (count($list) == 0) {
            //buscamos los default
            $query = new AbstractSql();
            $query->setSelect("$this->id, motivoVisita");
            $query->setFrom("motivovisita t");
            $query->setWhere("t.idmotivoVisita not in (select m.motivoVisita_idmotivoVisita from motivovisita_programa_categoria m  )");
            $query->setOrderBy("motivoVisita ASC");
            $list = $this->getComboBox($query, false);
        }

        return $list;
    }

    /*     * Metodo que retorna el ultimo motivo cargado
     * 
     * @return type
     */

    public function getLastMotivo() {
        $query = new AbstractSql();
        $query->setSelect("$this->id,motivoVisita");
        $query->setFrom("$this->table");
        $query->setOrderBy("$this->id DESC");

        return $this->db->getRow($query->getSql());
    }

}

//END_class
?>