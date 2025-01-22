<?php

    
    $manager = $this->getManager("ManagerTraduccion");

    $paginate = SmartyPaginate::getPaginate($manager->getDefaultPaginate());
    
	$this->assign("paginate",$paginate);
	
	
?>