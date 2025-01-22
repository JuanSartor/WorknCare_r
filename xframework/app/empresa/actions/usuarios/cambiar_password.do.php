<?php

$this->start();
$manager = $this->getManager("ManagerUsuarioEmpresa");

$manager->changePassword($this->request);
$this->finish($manager->getMsg());
