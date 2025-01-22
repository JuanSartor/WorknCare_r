<?php

$ManagerVideoConsulta=$this->getManager("ManagerVideoConsulta");
$result=$ManagerVideoConsulta->delete($this->request["idvideoconsulta"],true);

  $this->finish($ManagerVideoConsulta->getMsg());