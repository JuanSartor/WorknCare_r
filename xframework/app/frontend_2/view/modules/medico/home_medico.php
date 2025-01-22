<?php

if(isset($this->request["load_login"])&&$this->request["load_login"]=="true"){
$this->assign("load_login",1);
}

if (isset($this->request["connecter"])) {
    $this->assign("show_login", 1);
    $this->assign("tipousuario", "medico");
}