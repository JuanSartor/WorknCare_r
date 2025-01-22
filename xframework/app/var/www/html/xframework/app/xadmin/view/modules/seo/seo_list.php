<?php
/**
 *
 *  Seo >> List
 *
 */
    $manager = $this->getManager("ManagerXSeo");

    $paginate = SmartyPaginate::getPaginate($manager->getDefaultPaginate());
    
	$this->assign("paginate",$paginate);	
	
?>