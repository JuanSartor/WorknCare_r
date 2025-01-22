<?php
    

    
    if(isset($_REQUEST['hash'])){

        $hash = $_REQUEST['hash'];            
                    
        if ($_SESSION[$hash]['realName']!=""){
            $this->assign("realName",$_SESSION[$hash]['realName']);
        }                          
		
		
        if ($_SESSION[$hash]['filter']!=""){
            $this->assign("filter",$_SESSION[$hash]['filter']);
        }                          

                
        $this->assign("action_x",$_SESSION[$hash]['action']);
        
        $this->assign("todo",$_SESSION[$hash]['todo']);		
         
        /*$this->assign("type",$_SESSION[$hash]['type']);*/
        $this->assign("hash",$hash);
    }
    
    $this->assign("session_id",session_id() );

    $this->assign("url_js_libs",url_core("libs/libs_js"));

?>
