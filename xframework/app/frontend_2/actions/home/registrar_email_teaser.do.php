<?php

$this->start();
$manager=$this->getManager("ManagerPreregistro");
$manager->insert(["email"=>$this->request["email"],"teaser"=>1]);
$this->finish($manager->getMsg());