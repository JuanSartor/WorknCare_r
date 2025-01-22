<?php

  /**
   * 	Manager del perfil de salud alergia
   *
   * 	@author Xinergia
   * 	@version 1.0
   * 	@package managers\extensions
   */
  class ManagerPerfilSaludAlergiaSubTipoAlergia extends Manager {

      /** constructor
       * 	@param $db instancia de adodb
       */
      function __construct($db) {

          // Constructor
          parent::__construct($db, "perfilsaludalergia_subtipoalergia", "idperfilSaludAlergia_subTipoAlergia");
      }

      /**
       * Método que procesa los subtipos de alergia, provenientes del procesamiento del FrontEnd, en el perfil de la alergia
       * Se deberán eliminar Los registros que se deschequean...
       * Se deberán agregar los registros que se agregan..
       * Corroborar los otros, que poseen campos de texto para agregar
       * @param type $request
       * @return boolean
       */
      public function processFromSaludAlergia($request) {
       
          //Listado 
          $listado_subtipos = $request["check_sta"];
          $listado_subtipos_otros = $request["check_sta_otros"];


          
          if (count($listado_subtipos) >= 0) {

              $ManagerSubTipoAlergia = $this->getManager("ManagerSubTipoAlergia");


              foreach ($listado_subtipos as $key => $subtipo) {
                  $sub_tipo_alergia = $ManagerSubTipoAlergia->get($key);

                  $registro = $this->getByRelacion($key, $request["idperfilSaludAlergia"]);

        
                  //Si hay subtipo de alergia y no hay registro asociado previamente cargado lo inserto o lo actualizo si ya existe mediante el id
                  if ($sub_tipo_alergia ) {
                      //Si existe sub tipo de alergia, se inserta
                      $array_insert = array(
                          "idperfilSaludAlergia_subTipoAlergia"=>$registro["idperfilSaludAlergia_subTipoAlergia"],
                            "subTipoAlergia_idsubTipoAlergia" => $key,
                            "perfilSaludAlergia_idperfilSaludAlergia" => $request["idperfilSaludAlergia"]
                      );
                        
                      //Si es otros, me fijo que venga texto
                      if ($sub_tipo_alergia["subTipoAlergia"] == "Otros" && isset($listado_subtipos_otros[$key]) && $listado_subtipos_otros[$key] != "") {
                          $array_insert["texto"] = $listado_subtipos_otros[$key];
                      }
                 
                      $rdo = parent::process($array_insert);
                      if (!$rdo) {
                          return false;
                      }
                  }
              }

              $list_not_in = $ManagerSubTipoAlergia->getListadoNotIn($listado_subtipos, $request["idperfilSaludAlergia"]);
              if ($list_not_in && count($list_not_in) >= 0) {
                  //Debo eliminar los registros que tengan este ID, porque si no vienen es porque se deschequedaron
                  foreach ($list_not_in as $key => $not_in) {
                      $delete = parent::delete($not_in["idperfilSaludAlergia_subTipoAlergia"]);
                      if (!$delete) {
                          return false;
                      }
                  }
              }
          }

          return true;
      }

      /**
       * Método que busca la relación en base al id del sub tipo de alergia y el id del perfil de la salud de la alergia
       * @param type $idsubTipoAlergia
       * @param type $idperfilSaludAlergia
       * @return boolean
       */
      public function getByRelacion($idsubTipoAlergia, $idperfilSaludAlergia) {
          $query = new AbstractSql();

          $query->setSelect("*");

          $query->setFrom("$this->table");

          $query->setWhere("subTipoAlergia_idsubTipoAlergia = $idsubTipoAlergia");
          
          $query->addAnd("perfilSaludAlergia_idperfilSaludAlergia = $idperfilSaludAlergia");

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