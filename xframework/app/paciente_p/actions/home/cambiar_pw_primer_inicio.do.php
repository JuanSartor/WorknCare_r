<?php

$this->start();
$manager = $this->getManager("ManagerUsuarioWeb");
$actuzalizacion = array("cambiar_pass" => 0);
$manager->update($actuzalizacion, $_SESSION[URL_ROOT]["paciente_p"]['logged_account']["paciente"]["usuarioweb_idusuarioweb"]);
$this->finish($manager->getMsg());
