<?php
 
    $manager = $this->getManager("ManagerTraduccion");
 
	$records = $manager->getListadoJSON($this->request,$manager->getDefaultPaginate());	
	 
    echo $records;
    
	
?>
