<?php

$this->start();
echo $this->getManager("ManagerEmpresa")->generarQRCuestionario($this->request["id"]);
