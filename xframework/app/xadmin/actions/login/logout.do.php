<?php
    //guarda el status
    $this->start();    
    
     $this->getManager("ManagerUsuarios")->logOut();
    
    
    $this->finish(array("result"=>true));
    //header("Location:".CONTROLLER.".php");        

?>
