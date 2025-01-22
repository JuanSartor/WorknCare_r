<?php

$manager = $this->getManager("ManagerTraduccion");

if(IDIOMAS_TRADUCCION!=""){
    $idiomas=explode(",",IDIOMAS_TRADUCCION);
    $this->assign("idiomas_traduccion",$idiomas);
}
if (isset($this->request["id"]) && $this->request["id"] > 0) {

    $record = $manager->get($this->request["id"]);
    $this->assign("record",$record);
}
?>
