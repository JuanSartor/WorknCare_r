<?php

  /**
   * 	@autor Xinergia
   * 	Manager de los diferentes tipos de tomas de medicamentos que hay
   *
   */
  class ManagerTipoTomaMedicamentos extends Manager {

      /** constructor
       * 	@param $db instancia de adodb
       */
      function __construct($db) {

          // Llamamos al constructor del a superclase
          parent::__construct($db, "tipotomamedicamentos", "idtipoTomaMedicamentos");

          
      }

      public function getCombo() {

          $query = new AbstractSql();
          $query->setSelect("$this->id,tipoTomaMedicamentos");
          $query->setFrom("$this->table");
              $query->setOrderBy("tipoTomaMedicamentos desc");

          return $this->getComboBox($query, false);
      }

  }

//END_class
?>