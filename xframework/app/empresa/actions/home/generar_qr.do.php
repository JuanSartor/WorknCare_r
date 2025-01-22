<?php
$this->start();
echo $this->getManager("ManagerUsuarioEmpresa")->generarQR($this->request["id"]);