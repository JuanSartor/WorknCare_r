<?php
    /**	
	*	Accion: Alta/Modificacion de localidad
	*
	*	@author UTN
	*	@version 1.0
	*	@package app\actions\maestros_localizacion
	*
	*/

    $this->start();        
    $managerCenso = $this->getManager("ManagerCenso2010");
    $censo = $managerCenso->getByField("localidad_idlocalidad",$this->request["localidad_idlocalidad"]);
    if ($censo){
        $censo["poblacionTotal"] = (int)$censo["poblacionMujeres"]+ (int)$censo["poblacionHombres"];        
    }          
	echo json_encode($censo); 
	
?>
