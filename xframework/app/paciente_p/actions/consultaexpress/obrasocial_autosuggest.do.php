<?php
    /**
	*	
	*  
	*
	*	@author Emanuel del Barco
	*
	*/	

    $manager = $this->getManager("ManagerObrasSociales");
 
    $records = $manager->getAutosuggest($this->request);	
	 
    echo $records;
