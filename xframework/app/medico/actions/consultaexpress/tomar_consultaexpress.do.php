<?php
$manager=$this->getManager("ManagerConsultaExpress");
        $manager->tomarConsultaExpress($this->request["id"]);
$this->finish($manager->getMsg());
