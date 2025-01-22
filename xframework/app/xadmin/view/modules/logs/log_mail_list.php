<?php

    
    $manager = $this->getManager("ManagerMail");

    $paginate = SmartyPaginate::getPaginate($manager->getDefaultPaginate());
    
	$this->assign("paginate",$paginate);
	
	
?>