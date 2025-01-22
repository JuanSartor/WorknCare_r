<?php

  /**
   * 	Manager de pa�s
   *
   * 	@author <XINERGIA>
   * 	@version 1.0
   * 	@package managers\extensions
   */
  class ManagerTablero extends Manager {

      /** constructor
       * 	@param $db instancia de adodb
       */
      function __construct($db) {

          // Constructor
          parent::__construct($db, "tablero", "idtablero");
      }

      /**
       * Método que retorna un listado con la información perteneciente a los tableros..
       * Indica además si está seleccinado por ese paciente o no
       * @param type $idpaciente
       * @return boolean
       */
      public function getListTableroFront($idpaciente) {
          $query = new AbstractSql();

          $query->setSelect("t.*");

          $query->setFrom("$this->table t");

          $query->setWhere("t.tablero_idtablero IS NULL");
          
          $query->setOrderBy("t.nombreConfiguracion");

          $listado = $this->getList($query);
          
          if ($listado && count($listado) > 0) {
              $ManagerPacienteTablero = $this->getManager("ManagerPacienteTablero");

              foreach ($listado as $key => $value) {
                  $rdo = $ManagerPacienteTablero->getListTableroPaciente($value[$this->id], $idpaciente);
                  
                  $listado[$key]["isSelect"] = $rdo ? true : false;
                  
                  $listado[$key]["sub_tablero"] = $this->getListSubTablero($value[$this->id], $idpaciente);
              }
              return $listado;
          } else {
              return false;
          }
      }

      /**
       * Método que retorna el sub tablero...
       * @param type $idtablero
       * @return boolean
       */
      public function getListSubTablero($idtablero, $idpaciente) {
          $query = new AbstractSql();

          $query->setSelect("t.*");

          $query->setFrom("$this->table t");

          $query->setWhere("t.tablero_idtablero = $idtablero");
          
          $listado = $this->getList($query);

          if ($listado && count($listado) > 0) {
              $ManagerPacienteTablero = $this->getManager("ManagerPacienteTablero");

              foreach ($listado as $key => $value) {
                  $rdo = $ManagerPacienteTablero->getListTableroPaciente($value[$this->id], $idpaciente);
                  $listado[$key]["isSelect"] = $rdo ? true : false;
              }
              
              return $listado;
          } else {
              return false;
          }
          
      }

  }

?>