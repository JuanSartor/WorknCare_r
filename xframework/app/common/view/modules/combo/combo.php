<?php
/**
 *
 *  Listado de usuarios 
 *
 */   
 
 
    $manager = $this->getManager($this->request["manager"]);

	$function = $this->request["function"];
   
	$records = $manager->$function();	
	
	
    $this->assign("records",$records);
	$this->assign("idselected",$this->request["id"]);
    
    $this->assign("idcombo",$this->request["idcombo"]);

	
?>
