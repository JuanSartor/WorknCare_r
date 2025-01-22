<?php
	
    $manager = $this->getManager("ManagerTraduccion");
	
    $manager->deleteMultiple($this->request['ids'], false);    
    
    $this->finish($manager->getMsg());

?>
