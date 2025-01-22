<?php


    $this->start();        
    $manager = $this->getManager("ManagerTraduccion");
    $result = $manager->compilarTraducciones();            
	$this->finish($manager->getMsg()); 
	
?>
