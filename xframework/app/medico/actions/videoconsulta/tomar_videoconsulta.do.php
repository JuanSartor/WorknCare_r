<?php

$manager = $this->getManager("ManagerVideoConsulta");
$manager->tomarVideoConsulta($this->request);
$this->finish($manager->getMsg());
