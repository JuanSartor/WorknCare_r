<?php
    /**
	*	
	*  
	*
	*	@author Emanuel del Barco
	*
	*/	

    $manager = $this->getManager("ManagerXSeo");
 
	$records = $manager->getListadoJSON($manager->getDefaultPaginate(),$this->request);	
	 
    echo $records;
    
	
?>
