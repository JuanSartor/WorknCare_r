<?php

/**
 * 	@autor Lucas
 * 	@version 1.0	14/11/2017
 * 	Manager de Las cirugias oculares
 *
 */
class ManagerCirugiaOcular extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "cirugia_ocular", "idcirugia_ocular");


        $this->default_paginate = "cirugia_ocular_list";
    }

    /*
     * 	@author Xinergia <info@e-xinergia.com>
     *   @version 1.0
     */

    public function insert($request) {

        $id = parent::insert($request);

        //si se crea correctamente asocio las funcionaldades y si aplica o no
        if ($id) {

            $this->setMsg(["msg" => "La Cirugía Ocular ha sido creado con éxito", "result" => true]);
        }

        return $id;
    }

    /*
     * 	@author Xinergia <info@e-xinergia.com>
     *   @version 1.0
     */

    public function update($request, $id) {

        $rdo = parent::update($request, $id);


        if ($rdo) {
            $this->setMsg(["msg" => "La Cirugía Ocular ha sido actualizada con éxito", "result" => true]);
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
        if ($request["cirugia_ocular"] != "") {

            $nombre = cleanQuery($request["cirugia_ocular"]);

            $query->addAnd("cirugia_ocular LIKE '%$nombre%'");
        }


        $query->setOrderBy("cirugia_ocular ASC");

        $data = $this->getJSONList($query, array("cirugia_ocular"), $request, $idpaginate);

        return $data;
    }

    public function getCombo() {

        $query = new AbstractSql();
        $query->setSelect("$this->id, cirugia_ocular");
        $query->setFrom("$this->table");

        return $this->getComboBox($query, false);
    }

    /**
     *   Listado de las especialidades con filtro de busqueda para autosugeridor
     * 		
     * 	@author Xinergia
     * 	@version 1.0
     *
     * 	@param int $request con parametros para la busqueda
     * 	@return array Listado de registros
     */
    public function getAutosuggest($request = null) {

        $query = new AbstractSql();

        $query->setSelect(" e.$this->id AS data, e.cirugia_ocular AS value");

        $query->setFrom(" $this->table e");

        if (!is_null($request)) {
            $queryStr = cleanQuery($request["query"]);
            $query->setWhere("e.cirugia_ocular LIKE '%$queryStr%'");
        }

        $query->setOrderBy("e.cirugia_ocular ASC");

        $data = array(
            "query" => $request["query"],
            "suggestions" => $this->getList($query, false)
        );

        return json_encode($data);
    }

    /**
     *   Listado de las cirugias oculares con filtro de busqueda para autosugeridor
     * 		
     * 	@author Xinergia
     * 	@version 1.0
     *
     * 	@param int $request con parametros para la busqueda
     * 	@return array Listado de registros
     */
    public function getAutosuggestComplete($request = null) {

        $query = new AbstractSql();

        $query->setSelect(" e.$this->id AS data, e.cirugia_ocular AS value");

        $query->setFrom(" $this->table e");

        if (!is_null($request)) {
            $queryStr = cleanQuery($request["query"]);
            $query->setWhere("e.cirugia_ocular LIKE '%$queryStr%'");
        }

        $query->setOrderBy("e.cirugia_ocular ASC");


        return json_encode($this->getList($query, FALSE));
    }

}

//END_class
?>