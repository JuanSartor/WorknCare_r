<?php

  /**
   * 	@autor Xinergia
   * 	@version 1.0	29/05/2014
   * 	Manager de RESETS
   *    Resets de contraseña para los usuarios web -> Médicos y pacientes
   * 
   */
  class ManagerResetsWeb extends Manager {

      /** constructor
       * 	@param $db instancia de adodb
       */
      function __construct($db) {

          // Llamamos al constructor del a superclase
          parent::__construct($db, "resetsweb", "idresetsweb");
      }

      /*
       * 	@author Xinergia <info@e-xinergia.com>
       *   @version 1.0
       */

      public function insert($request) {

          //Para el insert ingreso la validez de dos horas dsp´s 
          $request["validez"] = date("Y-m-d H:i:s", time() + 2 * 60 * 60);



          $id = parent::insert($request);

          //si se crea correctamente asocio las funcionaldades y si aplica o no
          if (!$id) {

              return false;
          }

          return $id;
      }

      /**
       * Método que retorna true si el reset está validado o no
       * @param type $request
       * @return boolean
       */
      public function validateResets($request) {
          $hash = addslashes($request['hash']);

          $query = new AbstractSql();
          //Compara la validez y el hash
          $query->setSelect("r.$this->id, r.usuarioweb_idusuarioweb,(r.validez > NOW()) as valido,r.hash");
          $query->setFrom(" $this->table r");
          $query->setWhere(" r.hash = '$hash' ");

          $rdo = $this->db->Execute($query->getSql())->FetchRow();

          if (!$rdo || (int) $rdo['valido'] == 0) {
              if ($rdo) {
                  $this->delete($rdo[$this->id]);
              }
              return false;
          } else {
              return true;
          }
      }

      /**
       * Método que obtiene el registro correspondiente a la tabla "hash".
       * @param type $hash
       * @return boolean
       */
      public function getResetByHash($hash) {
          $hash = addslashes($hash);

          $query = new AbstractSql();
          //Compara la validez y el hash
          $query->setSelect("r.$this->id, r.usuarioweb_idusuarioweb,(r.validez > NOW()) as valido,r.hash");
          
          $query->setFrom("$this->table r");
          
          $query->setWhere("r.hash = '$hash'");

          $execute = $this->db->Execute($query->getSql());

          if ($execute) {
              return $execute->FetchRow();
          } else {
              return false;
          }
      }

  }

//END_class
?>