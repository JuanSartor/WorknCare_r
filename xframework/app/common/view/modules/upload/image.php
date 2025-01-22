<?php
    
    if(isset($_REQUEST['hash'])){
        $hash = $_REQUEST['hash'];            
                
        /*if (!is_null($_SESSION[$hash]['img']) && file_exists($_SESSION[$hash]['target'].$_SESSION[$hash]['name']) ){
            $this->assign("img",$_SESSION[$hash]['img']);   
        } */                  
        $this->assign("action_x",trim($_SESSION[$hash]['action']));
        $this->assign("todo",$_SESSION[$hash]['todo']);
         
        //echo "imagen es ".$_SESSION[$hash]["image"]; 
        
        $image = path_entity_files($_SESSION[$hash]["image"]);
         
        if (file_exists($image) && is_file($image)   ){          
            $this->assign("image","xframework/files/entities/".$_SESSION[$hash]["image"]);
        }

        if ($_SESSION[$hash]['filter']!=""){
            $this->assign("filter",$_SESSION[$hash]['filter']);
        }           


        $this->assign("hash",$hash);
    }
    
    
    $this->assign("session_id",session_id() );

	$this->assign("entity",$_REQUEST["entity"] );

    $this->assign("url_js_libs",url_core("libs/libs_js"));

?>
