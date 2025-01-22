<?php

    
    $manager = $this->getManager("ManagerLogSMS");

    $paginate = SmartyPaginate::getPaginate($manager->getDefaultPaginate());
    
	$this->assign("paginate",$paginate);
	
	
?>