<?php
/**
 *  LOGIN
 */
  
    if($_COOKIE['faut_access']){
        
        $cookie_email = $_COOKIE['faut_access'];
        
        if ($cookie_email != ""){
            $this->assign("email",$cookie_email);            
        }
    
    }  

?>
