<?php

$manager = $this->getManager("ManagerEmpresa");


$rdo = $manager->cropAndChangeImage($this->request);

$this->finish($manager->getMsg());
