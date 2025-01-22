<?php
    /**
	*	
	*  
	*
	*	@author Emanuel del Barco
	*
	*/	

    $manager = $this->getManager("ManagerLocalidad");
 
    $records = $manager->getAutosuggest($this->request);	
	 
    echo $records;
