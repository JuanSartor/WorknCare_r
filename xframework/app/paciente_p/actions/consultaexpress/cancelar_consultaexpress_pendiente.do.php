<?php

$manager=$this->getManager("ManagerConsultaExpress");
$manager->cancelarConsultaExpressPendiente($this->request["id"]);

 $this->finish($manager->getMsg());