<?php
$manager=$this->getManager("ManagerConsultaExpress");
        $manager->rechazarTomaConsultaExpress($this->request["id"]);
$this->finish($manager->getMsg());
