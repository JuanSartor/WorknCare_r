<?php

  /**
   * 	@autor Xinergia
   * 	@version 1.0	29/05/2014
   * 	Manager de Las Obras Sociales - Prepagas
   *
   */
  class ManagerTipoAlergia extends Manager {

      /** constructor
       * 	@param $db instancia de adodb
       */
      function __construct($db) {

          // Llamamos al constructor del a superclase
          parent::__construct($db, "tipoalergia", "idtipoAlergia");
          
          
          $this->default_paginate = "tipo_alergia_list";
      }

      /*
       * 	@author Xinergia <info@e-xinergia.com>
       *   @version 1.0
       */

      public function insert($request) {

          $id = parent::insert($request);

          //si se crea correctamente asocio las funcionaldades y si aplica o no
          if ($id) {
              $this->setMsg(["msg"=>"La Alergia ha sido creado con éxito","result"=>true]);
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
          if ($request["tipoAlergia"] != "") {

              $nombre = cleanQuery($request["tipoAlergia"]);

              $query->addAnd("tipoAlergia LIKE '%$nombre%'");
          }


          $query->setOrderBy("tipoAlergia ASC");

          $data = $this->getJSONList($query, array("tipoAlergia"), $request, $idpaginate);

          return $data;
      }

      public function getCombo() {

          $query = new AbstractSql();
          $query->setSelect("$this->id, tipoAlergia");
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

          $query->setSelect(" e.$this->id AS data, e.tipoAlergia AS value");

          $query->setFrom(" $this->table e");

          if (!is_null($request)) {
              $queryStr = cleanQuery($request["query"]);
              $query->setWhere("e.tipoAlergia LIKE '%$queryStr%'");
          }
          
          $query->setOrderBy("e.tipoAlergia ASC");

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

          $query->setSelect(" e.$this->id AS data, e.tipoAlergia AS value");

          $query->setFrom(" $this->table e");

          if (!is_null($request)) {
              $queryStr = cleanQuery($request["query"]);
              $query->setWhere("e.tipoAlergia LIKE '%$queryStr%'");
          }
          
          $query->setOrderBy("e.tipoAlergia ASC");


          return json_encode($this->getList($query, FALSE));
      }
  }

//END_class
?>