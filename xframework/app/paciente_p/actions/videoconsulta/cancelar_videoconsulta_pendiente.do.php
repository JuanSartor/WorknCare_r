<?php

$manager=$this->getManager("ManagerVideoConsulta");
$manager->cancelarVideoConsultaPendiente($this->request["id"]);

 $this->finish($manager->getMsg());