<?php

$manager = $this->getManager("ManagerUsuarioEmpresa");
$rdo = $manager->setear_contrasenia_usuario_empresa($this->request);
$this->finish($manager->getMsg());


