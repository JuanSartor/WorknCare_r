<?php

    /**
	*	
	*  
	*
	*	@author Emanuel del Barco
	*
	*/	

    $manager = $this->getManager("ManagerEspecialidades");
 
    $records = $manager->getAutosuggest($this->request);	
	 
    echo $records;

	
?>
