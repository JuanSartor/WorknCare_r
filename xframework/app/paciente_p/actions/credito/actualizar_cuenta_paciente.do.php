<?php

$this->start();

$manager=$this->getManager("ManagerCuentaUsuario");
 
  $this->assign("idpaginate", $paginate);

$manager->actualizarCuentaPaciente($this->request["idpaciente"]);
$this->finish($manager->getMsg());

