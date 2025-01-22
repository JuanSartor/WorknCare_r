<?php
/**
 *  Seo >> Nuevo/Editar
 * 
 **/
  
    $manager = $this->getManager("ManagerXSeo");	
    
    if (isset($this->request["id"]) &&  $this->request["id"] > 0){                

		$record = $manager->get($this->request["id"]);
        
		$this->assign("record",$record);
				
    }
?>