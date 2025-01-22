<?php
	
    $manager = $this->getManager("ManagerTraduccion");
	
    $manager->delete($this->request['id'], true);    
    
    $this->finish($manager->getMsg());

?>
