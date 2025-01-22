<?php

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * ManagerEstadoVideoConsulta administra los estados en lo que se encuentra la VC a lo largo de su ciclo
 *
 * @author lucas
 * @package managers\extensions
 */
class ManagerEstadoVideoConsulta extends AbstractManager{
 	
    /** constructor
	 * 	@param $db instancia de adodb
	 */

	function __construct($db) {

		// Constructor
		parent::__construct($db, "estadovideoconsulta", "idestadoVideoConsulta");

	}
        public function getCombo() {

          $query = new AbstractSql();
          $query->setSelect("$this->id, estadoVideoConsulta");
          $query->setFrom("$this->table");

          return $this->getComboBox($query, false);
      }
}
