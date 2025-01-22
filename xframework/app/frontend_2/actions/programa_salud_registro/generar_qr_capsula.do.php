<?php

$this->start();
echo $this->getManager("ManagerEmpresa")->generarQRCapsula($this->request["id"]);
