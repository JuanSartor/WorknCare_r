<?php

/**
 * 	@autor Xinergia
 * 	@version 1.0	29/05/2014
 * 	Manager de afeecion del paciente
 *
 */
class ManagerAfeccionPaciente extends Manager {

	/** constructor
	 * 	@param $db instancia de adodb
	 */
	function __construct($db) {

		// Llamamos al constructor del a superclase
		parent::__construct($db, "afeccion_paciente", "idafeccion_paciente");
	}

	

        /**
         * Retorna los datos de la obra social del paciente
         * @param type $idpaciente
         * @return type
         */
        public function getAfeccionPaciente($idpaciente){
            $query = new AbstractSql();
            
            $query->setSelect("a.*");
            
            $query->setFrom("{$this->table} ap 
                INNER JOIN afeccion a ON (a.idafeccion=ap.afeccion_idafeccion)
                              
            ");
            
            $query->setWhere("paciente_idpaciente = {$idpaciente}");
            
            return $this->db->GetRow($query->getSql());
        }


}

//END_class
?>