<?php

$manager = $this->getManager("ManagerPaciente");

$manager->deleteFiles($this->request['idpaciente'], $this->request['name']);

$this->finish($manager->getMsg());

