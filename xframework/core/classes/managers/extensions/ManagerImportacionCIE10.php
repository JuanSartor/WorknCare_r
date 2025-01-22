<?php

  /**
   * 	@autor Xinergia
   * 	@version 1.0	29/05/2014
   * 	Manager de Las condiciones de Color de OJOs
   *
   */
  class ManagerImportacionCIE10 extends Manager {

      /** constructor
       * 	@param $db instancia de adodb
       */
      function __construct($db) {

          // Llamamos al constructor del a superclase
          parent::__construct($db, "importacion_cie10", "id");
      }

      public function insert($record) {
          $linea = $record["linea"];

          //Elimino todos los caracteres "
          $linea = str_replace("\"", " ", $linea);

          $array = explode(",", $linea);

          $string = "";
          for ($i = 1; $i < (count($array) - 1); $i++) {
              $string .= ($i == 1 ? "" : ", ") . $array[$i];
          }

          $insert = array(
                "codigo" => $array[0],
                "enfermedad" => $string,
                "tercer" => $array[count($array) - 1]
          );


          return parent::insert($insert);
      }

      /**
       * Método que retorna el listado paginado de las enfermedades CIE10
       * @param array $request
       * @param type $idpaginate
       * @return type
       */
      public function getListEnfermedadesCIE10Paginado($request, $idpaginate = null) {
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

          $query->setSelect("t.*");

          $query->setFrom("$this->table t ");

          if ($request["str"] != "") {
              $str = cleanQuery($request["str"]);
              $query->setWhere("(t.enfermedad LIKE '%$str%' OR t.codigo LIKE '%$str%')");
          } else {
              $query->setWhere("t.$this->id = 0");
          }

          $query->setOrderBy("t.enfermedad ASC");

          return $this->getListPaginado($query, $idpaginate);
      }

  }

//END_class
?>