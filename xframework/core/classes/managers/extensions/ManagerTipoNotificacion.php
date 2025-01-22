<?php

  /**
   * 	@autor Xinergia
   * 	Manager de los tipos de familiar
   *
   */
  class ManagerTipoNotificacion extends Manager {

      /** constructor
       * 	@param $db instancia de adodb
       */
      function __construct($db) {

          // Llamamos al constructor del a superclase
          parent::__construct($db, "tiponotificacion", "idtipoNotificacion");

          $this->default_paginate = "tipo_notificacion_list";
      }

      /*
       * 	@author Xinergia <info@e-xinergia.com>
       *   @version 1.0
       */

      public function insert($request) {

          $id = parent::insert($request);

          //si se crea correctamente asocio las funcionaldades y si aplica o no
          if ($id) {
              $this->setMsg(["msg"=>"El tipo Notificacion ha sido creado con éxito","result"=>true]);
          }

          return $id;
      }

      public function getCombo() {

          $query = new AbstractSql();
          $query->setSelect("$this->id,tipoNotificacion");
          $query->setFrom("$this->table");

          return $this->getComboBox($query, false);
      }

  }

//END_class
?>