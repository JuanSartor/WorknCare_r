<?php
/**
 *
 *  Usuarios
 *
 */
    
    $manager = $this->getManager("ManagerUsuarios");
   
    $paginate = SmartyPaginate::getPaginate("usuarios_listado");
    
    if (isset($paginate["request"]["Activo"])){
        $this->assign("estado",$paginate["request"]["Activo"]);    
    }else{
        $this->assign("estado",1);
    }
    
	$this->assign("paginate",$paginate);
	
	$this->assign("estados",$manager->getComboEstados(true));


	
?>