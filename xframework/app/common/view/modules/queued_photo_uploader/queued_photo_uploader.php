<?php
    
    $this->assign("id",$this->request["id"]);
    $this->assign("manager",$this->request["manager"]);
    
    $this->assign("parent_reload",$this->request["parent_reload"]);
    
    $this->assign("session_id",session_id() );

    $this->assign("url_js_libs",url_core("libs/libs_js"));

?>
