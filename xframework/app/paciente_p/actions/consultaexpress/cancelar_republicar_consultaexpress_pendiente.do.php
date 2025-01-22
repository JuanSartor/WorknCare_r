<?php

$manager=$this->getManager("ManagerConsultaExpress");
$manager->cancelarRepublicarConsultaExpressPendiente($this->request["id"]);

 $this->finish($manager->getMsg());