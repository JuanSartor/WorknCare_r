<?php

/**
 * 	@autor Xinergia
 * 	@version 1.0	29/05/2014
 * 	Manager de Los tipos de DNI.
 *
 */
class ManagerTipoDNI extends Manager {

	/** constructor
	 * 	@param $db instancia de adodb
	 */
	function __construct($db) {

		// Llamamos al constructor del a superclase
		parent::__construct($db, "tipodni", "idtipoDNI");
	}

	/**
	 *  Combo de los tipos de DNI
	 *
	 **/
	public function getCombo() {

		$query = new AbstractSql();
		$query -> setSelect(" c.$this->id , c.tipoDNI");
		$query -> setFrom(" $this->table c");
		$query -> setOrderBy("c.tipoDNI ASC");

		return $this -> getComboBox($query, false);

	}


}

//END_class
?>