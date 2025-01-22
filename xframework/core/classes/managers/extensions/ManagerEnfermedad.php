<?php

/**
 * 	@autor Xinergia
 * 	@version 1.0	29/05/2014
 * 	Manager de Las enfermedades
 *
 */
class ManagerEnfermedad extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "enfermedad", "idenfermedad");


        $this->default_paginate = "enfermedad_list";
    }

    /*
     * 	@author Xinergia <info@e-xinergia.com>
     *   @version 1.0
     */

    public function insert($request) {

        $id = parent::insert($request);

        //si se crea correctamente asocio las funcionaldades y si aplica o no
        if ($id) {



            $this->setMsg(["msg" => "La Enfermedad ha sido creado con éxito", "result" => true]);
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
        if ($request["enfermedad"] != "") {

            $nombre = cleanQuery($request["enfermedad"]);

            $query->addAnd("enfermedad LIKE '%$nombre%'");
        }


        $query->setOrderBy("enfermedad ASC");

        $data = $this->getJSONList($query, array("enfermedad"), $request, $idpaginate);

        return $data;
    }

    public function getCombo() {

        $query = new AbstractSql();
        $query->setSelect("$this->id, enfermedad");
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

        $query->setSelect(" e.$this->id AS data, e.enfermedad AS value");

        $query->setFrom(" $this->table e");

        if (!is_null($request)) {
            $queryStr = cleanQuery($request["query"]);
            $query->setWhere("e.enfermedad LIKE '%$queryStr%'");
        }

        $query->setOrderBy("e.enfermedad ASC");

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

        $query->setSelect(" e.$this->id AS data, e.enfermedad AS value");

        $query->setFrom(" $this->table e");

        if (!is_null($request)) {
            $queryStr = cleanQuery($request["query"]);
            $query->setWhere("e.enfermedad LIKE '%$queryStr%'");
        }

        $query->setOrderBy("e.enfermedad ASC");


        return json_encode($this->getList($query, FALSE));
    }

    /**
     * Método que retorna el listado para el front edn
     * Esto está tenido en cuenta para enfermedades dinámicas
     * @param type $idpaciente
     * @return boolean
     */
    public function getListadoFrontEnd($idpaciente) {
        $query = new AbstractSql();

        $query->setSelect(" e.*");

        $query->setFrom(" $this->table e");

        $listado = $this->getList($query);

        if ($listado && count($listado) > 0) {
            $ManagerTipoEnfermedad = $this->getManager("ManagerTipoEnfermedad");
            $ManagerEnfermedadesActualesEnfermedad = $this->getManager("ManagerEnfermedadesActualesEnfermedad");
            $ManagerEnfermedadesActualesTipoEnfermedad = $this->getManager("ManagerEnfermedadesActualesTipoEnfermedad");

            foreach ($listado as $key => $enfermedad) {
                $listado[$key]["combo_tipo_enfermedad"] = $ManagerTipoEnfermedad->getCombo($enfermedad[$this->id]);
                $listado[$key]["otra_enfermedad"] = $ManagerEnfermedadesActualesEnfermedad->getByEnfermedad($enfermedad[$this->id], $idpaciente);
                $listado[$key]["tipo_enfermedad"] = $ManagerEnfermedadesActualesTipoEnfermedad->getByTipoEnfermedad($enfermedad[$this->id], $idpaciente);
            }

            return $listado;
        } else {
            return false;
        }
    }

}

//END_class
?>