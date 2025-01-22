
<?php
$ManagerPaciente=$this->getManager("ManagerPaciente");
$ManagerPaciente->no_completar_perfil_salud_home();
$this->finish($ManagerPaciente->getMsg());
