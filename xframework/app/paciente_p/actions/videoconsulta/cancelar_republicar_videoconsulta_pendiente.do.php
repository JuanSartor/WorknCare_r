<?php

$manager=$this->getManager("ManagerVideoConsulta");
$manager->cancelarRepublicarVideoConsultaPendiente($this->request["id"]);

 $this->finish($manager->getMsg());