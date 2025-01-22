<?php
$this->start();
$ManagerPerfilSaludControlVisual=$this->getManager("ManagerPerfilSaludControlVisual");
$ManagerPerfilSaludControlVisual->update_control_anteojos($this->request);
$this->finish($ManagerPerfilSaludControlVisual->getMsg());