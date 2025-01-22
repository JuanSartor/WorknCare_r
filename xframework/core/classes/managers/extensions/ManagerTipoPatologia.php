<?php

  /**
   * 	@autor Xinergia
   * 	Manager de los tipos de patologías
   *
   */
  class ManagerTipoPatologia extends Manager {

      /** constructor
       * 	@param $db instancia de adodb
       */
      function __construct($db) {

          // Llamamos al constructor del a superclase
          parent::__construct($db, "tipopatologia", "idtipoPatologia");

          $this->default_paginate = "tipo_patologia_list";
      }

      /*
       * 	@author Xinergia <info@e-xinergia.com>
       *   @version 1.0
       */

      public function insert($request) {

          $id = parent::insert($request);

          //si se crea correctamente asocio las funcionaldades y si aplica o no
          if ($id) {
              $this->setMsg(["msg"=>"La patología ha sido creado con éxito","result"=>true]);
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
          if ($request["tipoPatologia"] != "") {

              $nombre = cleanQuery($request["tipoPatologia"]);

              $query->addAnd("tipoPatologia LIKE '%$nombre%'");
          }


          $query->setOrderBy("tipoPatologia ASC");

          $data = $this->getJSONList($query, array("tipoPatologia"), $request, $idpaginate);

          return $data;
      }

      /**
       * Listado de todos los tipos de patologías actuales
       * @param AbstractSql $query
       * @param type $useFlag
       * @param type $idpaginate
       * @return type
       */
      public function getList($query = NULL, $useFlag = false, $idpaginate = NULL) {
          $query = new AbstractSql();
          $query->setSelect("*");

          $query->setFrom("
                $this->table
            ");

          return parent::getList($query, $useFlag, $idpaginate);
      }

      public function getCombo() {

          $query = new AbstractSql();
          $query->setSelect("$this->id,tipoPatologia");
          $query->setFrom("$this->table");

          return $this->getComboBox($query, false);
      }

  }

//END_class
?>