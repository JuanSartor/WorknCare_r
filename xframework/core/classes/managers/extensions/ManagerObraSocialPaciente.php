<?php

/**
 * 	@autor Xinergia
 * 	@version 1.0	29/05/2014
 * 	Manager de Los tipos de DNI.
 *
 */
class ManagerObraSocialPaciente extends Manager {

	/** constructor
	 * 	@param $db instancia de adodb
	 */
	function __construct($db) {

		// Llamamos al constructor del a superclase
		parent::__construct($db, "obrasocialpaciente", "idobraSocialPaciente");
	}

	/**
	 * Función que retorna la fila de la tabla "obrasocialpaciente"
	 * que le pertenece al id del paciente recibido como atributo. 
 	*/
	public function get($idpaciente){
		$rdo = $this->getByField("paciente_idpaciente", $idpaciente);
		return $rdo;
	} 
        
        /**
         * Retorna los datos de la obra social del paciente
         * @param type $idpaciente
         * @return type
         */
        public function getObraSocialPaciente($idpaciente){
            $query = new AbstractSql();
            
            $query->setSelect("osp.*, os.*, pos.nombrePlan");
            
            $query->setFrom("{$this->table} osp
                                INNER JOIN obrasocial os ON (osp.obraSocial_idobraSocial = os.idobraSocial)
                                LEFT JOIN planobrasocial pos ON (osp.planObraSocial_idplanObraSocial = pos.idplanObraSocial)
            ");
            
            $query->setWhere("paciente_idpaciente = {$idpaciente}");
            
            return $this->db->GetRow($query->getSql());
        }


}

//END_class
?>