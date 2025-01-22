<?php

if ($_COOKIE["user"] != "") {
       $enc=new CookieEncrypt(ENCRYPT_KEY);
     $user=$enc->get_cookie("user");
   
    $arr = unserialize($user);
  
    if ($arr["tipo_usuario"] == "medico") {
        $manager = $this->getManager("ManagerMedico");

        $medico = $manager->get($arr["id"]);
        $medico["image"]=$manager->getImagenMedico($medico["idmedico"]);
        //print_r($medico);
        $this->assign("usuario",$medico);
        
    } else {
        $manager = $this->getManager("ManagerPaciente");

        $paciente = $manager->get($arr["id"]);
      
        $this->assign("usuario",$paciente);
    }
   $this->assign("timeout_modal",1);
}
