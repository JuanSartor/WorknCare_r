<?php

/**
 * 	@autor Xinergia
 * 	@version 1.0	29/05/2014
 * 	Manager de Las Obras Sociales - Prepagas
 *
 */
require_once(path_libs_php("PHPExcel/Classes/PHPExcel.php"));

class ManagerObrasSociales extends ManagerMedia {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "obrasocial", "idobraSocial");
        $this->default_paginate = "obras_sociales_list";
    }

    /*
     * 	@author Xinergia <info@e-xinergia.com>
     *   @version 1.0
     */

    public function insert($request) {

        $id = parent::insert($request);

        //si se crea correctamente asocio las funcionaldades y si aplica o no
        if ($id) {

            if ((int) $request["tipo"] == 1) {
                $this->setMsg(["msg" => "La Obra Social ha sido creado con éxito", "result" => true]);
            } else {
                $this->setMsg(["msg" => "La Prepaga ha sido creada con éxito", "result" => true]);
            }
        }

        return $id;
    }

    public function getListadoJSON($idpaginate = NULL, $request) {

        if (!is_null($idpaginate)) {
            $this->paginate($idpaginate, 50);
        }

        $query = new AbstractSql();
        $query->setSelect("
                idobraSocial,
                nombre,
                tipo
            ");
        $query->setFrom("
                $this->table
            ");

        // Filtro
        if ($request["nombre"] != "") {

            $nombre = cleanQuery($request["nombre"]);

            $query->addAnd("nombre LIKE '%$nombre%'");
        }

       

        $query->setOrderBy("nombre ASC");

        $data = $this->getJSONList($query, array("nombre", "tipo"), $request, $idpaginate);

        return $data;
    }

    /**
     *  combo de las obras sociales unicamente. 
     * Diferenciadas por el campo tipo de la BD
     *
     * */
    public function getComboObra() {

        $query = new AbstractSql();
        $query->setSelect(" c.idobraSocial , c.nombre");
        $query->setFrom(" $this->table c");
      
        $query->setOrderBy("c.nombre ASC");

        return $this->getComboBox($query, false);
    }

    /**
     *  combo de las prepagas unicamente. 
     *
     * */
    public function getComboPrepaga($idprepaga = null) {

        $query = new AbstractSql();
        $query->setSelect(" c.idobraSocial , c.nombre");
        $query->setFrom(" $this->table c");
    
        $query->setOrderBy("c.nombre ASC");

        return $this->getComboBox($query, false);
    }

    public function getCombo() {
        $query = new AbstractSql();
        $query->setSelect(" c.idobraSocial , c.nombre");
        $query->setFrom(" $this->table c");
        $query->setOrderBy("c.nombre ASC");

        return $this->getComboBox($query, false);
    }

    /**
     * Método que retorna true si es obra social o false si es medicina prepaga
     */
    public function isObraSocial($idobraSocial) {
        $obra = $this->get($idobraSocial);
        if ((int) $obra["tipo"] == 1) {
            return true;
        } else {
            return false;
        }
    }

    /**
     *   Listado de Las Obras sociales con filtro de busqueda para autosugeridor
     * 		
     * 	@author Xinergia
     * 	@version 1.0
     *
     * 	@param int $request con parametros para la busqueda
     * 	@return array Listado de registros
     */
    public function getAutosuggest($request) {

        $queryStr = cleanQuery($request["query"]);

        $query = new AbstractSql();

        $query->setSelect(" c.idobraSocial AS data, c.nombre AS value");

        $query->setFrom(" $this->table c");

        $query->setWhere("c.nombre LIKE '%{$queryStr}%'");

        $query->setOrderBy("c.nombre ASC");


        $data = array(
            "query" => $request["query"],
            "suggestions" => $this->getList($query, false)
        );


        return json_encode($data);
    }

   
}

//END_class
?>