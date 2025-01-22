<?php
    /**	
	*	Modulo PHP: Listado de partidos
	*
	*	@author UTN
	*	@version 1.0
	*	@package app\view\modules\maestros_localizacion
	*
	*/ 
    
    $managerP = $this->getManager("ManagerPais");
    $manager = $this->getManager("ManagerPartido");	


    $paginate = SmartyPaginate::getPaginate($manager->getDefaultPaginate());
	

    if (isset($paginate["request"]["pais_idpais"])){
	    $managerPr = $this->getManager("ManagerProvincia");			
        $this->assign("provincias",$managerPr->getComboProvinciasDePais($paginate["request"]["pais_idpais"]));    
    }
	
    
	$this->assign("paginate",$paginate);
	$this->assign("paises",$managerP->getCombo());	
	
	
?>
