<?php

$manager=$this->getManager("ManagerVideoConsulta");
$result=$manager->insert($this->request);

if($result["id"]>0){
   header("Location: ".URL_ROOT."/panel-medico/videoconsulta/".$result["id"]."/"); 
}


