<?php

  /**
   * 	@autor Xinergia
   * 	@version 1.0	29/05/2014
   * 	Manager de los motivos de las visitas
   *
   */
  class ManagerMedicamento extends Manager {

      /** constructor
       * 	@param $db instancia de adodb
       */
      function __construct($db) {

          // Llamamos al constructor del a superclase
          parent::__construct($db, "medicamento", "idmedicamento");
      }

      /*
       * 	@author Xinergia <info@e-xinergia.com>
       *   @version 1.0
       */

      public function insert($request) {

          $id = parent::insert($request);

          //si se crea correctamente asocio las funcionaldades y si aplica o no
          if ($id) {

              $this->setMsg(["msg"=>"El medicamento ha sido creado con éxito","result"=>true]);
          }

          return $id;
      }

      public function getListadoJSON($request, $idpaginate = NULL) {

          if (!is_null($idpaginate)) {
              $this->paginate($idpaginate, 50);
          }

          $query = new AbstractSql();
          $query->setSelect("l.*, m.*");

          $query->setFrom("
                $this->table m
                    INNER JOIN laboratorio l ON (l.idlaboratorio = m.laboratorio_idlaboratorio)
            ");

          // Filtro
          if ($request["nombre_comercial"] != "") {

              $nombre = cleanQuery($request["nombre_comercial"]);

              $query->addAnd("nombre_comercial LIKE '%$nombre%'");
          }

          // Filtro
          if ($request["laboratorio_idlaboratorio"] != "") {

              $id = $request["laboratorio_idlaboratorio"];

              $query->addAnd("m.laboratorio_idlaboratorio = $id");
          }


          $data = $this->getJSONList($query, array("nombre_comercial", "forma_farmaceutica", "presentacion", "generico", "laboratorio"), $request, $idpaginate);

          return $data;
      }

      public function getCombo() {

          $query = new AbstractSql();
          $query->setSelect("$this->id,motivoVisita");
          $query->setFrom("$this->table");

          return $this->getComboBox($query, false);
      }

      /**
       * Metodo que retorna un Array encodado en formato JSON para el autossugest de los medicamentos
       * @param type $request
       * @return type
       */
      public function getAutosuggest($request) {


          $queryStr = cleanQuery($request["query"]);



          $query = new AbstractSql();

          $query->setSelect("m.$this->id  AS data ,
                                    CONCAT(m.nombre_comercial, ' - ', m.presentacion) AS value");
          $query->setFrom("$this->table m ");

          // Filtro


          $query->setWhere("m.nombre_comercial LIKE '%$queryStr%'");


          $data = array(
                "query" => $request["query"],
                "suggestions" => $this->getList($query, false)
          );

          return json_encode($data);
      }

      /**
       * Método que retorna el listado paginado de los medicamentos
       * @param array $request
       * @param type $idpaginate
       * @return type
       */
      public function getListMedicamentosPaginado($request, $idpaginate = null) {
          if (isset($request["do_reset"]) && $request["do_reset"] == 1) {
              $this->resetPaginate($idpaginate);
          }

          if (!is_null($idpaginate)) {
              $this->paginate($idpaginate, 5);
          }

          //Seteo el current page
          $request["current_page"] = $request["current_page"] != "" ? $request["current_page"] : 1;
          SmartyPaginate::setCurrentPage($request["current_page"], $idpaginate);

          $query = new AbstractSql();

          $query->setSelect("t.*,
                                l.laboratorio
                            ");

          $query->setFrom("$this->table t 
                                INNER JOIN laboratorio l ON (t.laboratorio_idlaboratorio = l.idlaboratorio)");

          if ($request["str"] != "") {
              $str = cleanQuery($request["str"]);
              $query->setWhere("(t.nombre_comercial LIKE '%$str%' OR t.generico LIKE '%$str%' OR l.laboratorio LIKE '%$str%')");
          } else {
              $query->setWhere("t.$this->id = 0");
          }

          $query->setOrderBy("t.generico ASC");

          return $this->getListPaginado($query, $idpaginate);
      }

  }

//END_class
?>