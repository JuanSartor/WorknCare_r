<?php
    //borrar cookie de usuario logueado
    $this->start();    
   
  
      setcookie("user", "",time()-3600);
    $this->finish(array("result"=>true ));
          

?>
