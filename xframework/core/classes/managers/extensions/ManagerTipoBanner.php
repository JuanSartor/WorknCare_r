<?php

  /**
   * 	@autor Xinergia
   * 	@version 1.0	29/05/2014
   * 	Manager de los Tipos de banners de médico
   *
   */
  class ManagerTipoBanner extends Manager {

      /** constructor
       * 	@param $db instancia de adodb
       */
      function __construct($db) {

          // Llamamos al constructor del a superclase
          parent::__construct($db, "tipobanner", "idtipoBanner");
      }

      /*
       * 	@author Xinergia <info@e-xinergia.com>
       *   @version 1.0
       */

      public function insert($request) {

          $id = parent::insert($request);

          //si se crea correctamente asocio las funcionaldades y si aplica o no
          if ($id) {
              $this->setMsg(["msg"=>"El tipo de banner fue creado con éxito","result"=>true]);
          }

          return $id;
      }

      public function getListadoJSON($request, $idpaginate = NULL) {

          if (!is_null($idpaginate)) {
              $this->paginate($idpaginate, 50);
          }

          $query = new AbstractSql();

          $query->setSelect("p.*");

          $query->setFrom("
                $this->table p
            ");

          $data = $this->getJSONList($query, array("tipoBanner", "descripcion"), $request, $idpaginate);

          return $data;
      }
      
      public function getCombo() {

          $query = new AbstractSql();

          $query->setSelect("$this->id,tipoBanner");

          $query->setFrom("$this->table");

          return $this->getComboBox($query, false);
      }

  }
?>