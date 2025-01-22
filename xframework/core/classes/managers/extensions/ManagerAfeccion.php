<?php

/**
 * 	@autor Xinergia
 * 	@version 1.0	29/05/2014
 * 	Manager de Las afecciones
 *
 */
class ManagerAfeccion extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "afeccion", "idafeccion");
        $this->default_paginate = "afeccion_list";
    }

    /*
     * 	@author Xinergia <info@e-xinergia.com>
     *   @version 1.0
     */

    public function insert($request) {

        $id = parent::insert($request);
        //si se crea correctamente asocio las funcionaldades y si aplica o no
        if ($id) {

            $this->setMsg(["msg" => "La Afeccion ha sido creado con éxito", "result" => true]);
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
        if ($request["afeccion"] != "") {
            $nombre = cleanQuery($request["afeccion"]);
            $query->addAnd("afeccion LIKE '%$nombre%'");
        }

        $query->setOrderBy("afeccion ASC");
        $data = $this->getJSONList($query, array("afeccion"), $request, $idpaginate);

        return $data;
    }

    public function getCombo() {
        $query = new AbstractSql();
        $query->setSelect("$this->id, afeccion");
        $query->setFrom("$this->table");
        $query->setOrderBy("afeccion ASC");

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

        $query->setSelect(" e.$this->id AS data, e.afeccion AS value");

        $query->setFrom(" $this->table e");

        if (!is_null($request)) {
            $queryStr = cleanQuery($request["query"]);
            $query->setWhere("e.afeccion LIKE '%$queryStr%'");
        }

        $query->setOrderBy("e.afeccion ASC");

        $data = array(
            "query" => $request["query"],
            "suggestions" => $this->getList($query, false)
        );

        return json_encode($data);
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
    public function getAutosuggestComplete($request = null) {

        $query = new AbstractSql();

        $query->setSelect(" e.$this->id AS data, e.afeccion AS value");

        $query->setFrom(" $this->table e");

        if (!is_null($request)) {
            $queryStr = cleanQuery($request["query"]);
            $query->setWhere("e.afeccion LIKE '%$queryStr%'");
        }

        $query->setOrderBy("e.afeccion ASC");


        return json_encode($this->getList($query, FALSE));
    }

  

}

//END_class
?>