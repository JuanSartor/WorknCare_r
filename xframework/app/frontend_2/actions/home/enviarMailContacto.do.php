<?php
//Enviamos un mail de contacto desde el frontend
$this->start();
$manager=$this->getManager("ManagerUsuarioWeb");

$manager->enviarMailContacto($this->request);
$this->finish($manager->getMsg());

