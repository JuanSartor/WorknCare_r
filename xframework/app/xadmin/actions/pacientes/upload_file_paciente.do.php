<?php

$manager = $this->getManager("ManagerPaciente");

$manager->uploadFiles($this->request);

$this->finish($manager->getMsg());

