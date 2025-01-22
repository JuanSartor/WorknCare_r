<?php
    /**	
	*	Modulo PHP: Formulario de creacion/edicion de partidos
	*
	*	@author UTN
	*	@version 1.0
	*	@package app\view\modules\maestros_localizacion
	*
	*/
  
    $managerP = $this->getManager("ManagerPais");
    $manager = $this->getManager("ManagerPartido");		
	$managerPr = $this->getManager("ManagerProvincia");
    
    if (isset($this->request["id"]) &&  $this->request["id"] > 0){                

		$record = $manager->get($this->request["id"]);
		
		$provincia = $managerPr->get($record["provincia_idprovincia"]);	

		$this->assign("provincias",$managerPr->getComboProvinciasDePais($provincia["pais_idpais"]));         
        $this->assign("record",$record);
        $this->assign("provincia",$provincia);		
		
   }else{
        $this->assign("provincias",$managerPr->getComboProvinciasDePais(1));
   } 


	$this->assign("paises",$managerP->getCombo());	
           
?>
