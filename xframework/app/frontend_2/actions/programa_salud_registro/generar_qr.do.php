<?php
$this->start();
echo $this->getManager("ManagerEmpresa")->generarQR($this->request["id"]);