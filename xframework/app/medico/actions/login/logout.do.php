<?php
    //guarda el status
    $this->start();    
    
  
  $this->getManager("ManagerUsuarioWeb")->logOutMedico();
    
      setcookie("recordar", "",time()-3600);
        setcookie("user", "",time()-3600);
    $this->finish(array("result"=>true, "location"=>URL_ROOT ));
    //header("Location:".CONTROLLER.".php");        

?>
