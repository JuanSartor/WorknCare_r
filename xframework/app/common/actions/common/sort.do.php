<?php
    /**
	*	
	*  alta/modificacion de registros
	*
	*	@author Emanuel del Barco
	*
	*/	
    
    //ejemplo de como utilizar el manager general, pasandole el nombre de la tabal
    //y el nombre de la clave primaria
    $this->start();    
	$manager = $this->request["manager"];
	//$filter = (isset($_REQUEST["filter"]))?$_REQUEST["filter"]:NULL;
    $manager = $this->getManager("Manager$manager");
	$secuencia = $this->request["sec"];	
    //si existe el manager ordenamos
	
	if ($manager){
	    $manager->sort($secuencia); 			
    	$this->finish($manager->getMsg());
	}else{
        echo "Not manager found";
    }
?>