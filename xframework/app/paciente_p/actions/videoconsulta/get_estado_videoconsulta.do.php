<?php
$videoconsulta=$this->getManager("ManagerVideoConsulta")->get($this->request["idvideoconsulta"]);

if($videoconsulta){
    $this->finish(["result"=>true,"estado"=>$videoconsulta["estadoVideoConsulta_idestadoVideoConsulta"]]);
}else{
     $this->finish(["result"=>false]);
}