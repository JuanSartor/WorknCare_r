<?php

  /**
   * 	@autor Xinergia
   * 	@version 1.0	29/05/2014
   * 	Manager de Las condiciones de Color de Pelos
   *
   */
  class ManagerColorPelo extends Manager {

      /** constructor
       * 	@param $db instancia de adodb
       */
      function __construct($db) {

          // Llamamos al constructor del a superclase
          parent::__construct($db, "colorpelo", "idcolorPelo");
          $this->setFlag("active");
      }

      public function getCombo() {

          $query = new AbstractSql();
          $query->setSelect("$this->id,colorPelo");
          $query->setFrom("$this->table");

          return $this->getComboBox($query, false);
      }

  }

//END_class
?>