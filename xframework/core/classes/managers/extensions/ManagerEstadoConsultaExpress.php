<?php

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * ManagerEstadoConsultaExpress administra los estados en lo que se encuentra la CE a lo largo de su ciclo
 *
 * @author lucas
 */
class ManagerEstadoConsultaExpress extends AbstractManager{
 	
    /** constructor
	 * 	@param $db instancia de adodb
	 */

	function __construct($db) {

		// Constructor
		parent::__construct($db, "estadoconsultaexpress", "idestadoConsultaExpress");

	}
        /**
	 *  Combo de los estado de CE
	 *
	 **/
            public function getCombo() {

          $query = new AbstractSql();
          $query->setSelect("$this->id, estadoConsultaExpress");
          $query->setFrom("$this->table");

          return $this->getComboBox($query, false);
      }
}
