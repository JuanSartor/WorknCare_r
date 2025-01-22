<?php

$manager = $this->getManager("ManagerMedico");

$manager->deleteFiles($this->request['idmedico'], $this->request['name']);

$this->finish($manager->getMsg());

