<?php

$manager = $this->getManager("ManagerMedico");

$manager->uploadFiles($this->request);

$this->finish($manager->getMsg());

