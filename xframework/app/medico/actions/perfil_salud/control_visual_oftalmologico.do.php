<?php
$this->start();
$ManagerPerfilSaludControlVisual=$this->getManager("ManagerPerfilSaludControlVisual");
$ManagerPerfilSaludControlVisual->update_control_oftalmologico($this->request);
$this->finish($ManagerPerfilSaludControlVisual->getMsg());