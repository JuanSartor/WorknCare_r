<?php

  $managerUsu = $this->getManager("ManagerUsuarioWeb");

  $ManagerPaciente = $this->getManager("ManagerPaciente");
  $paciente = $ManagerPaciente->get($this->request["id"]);
  
  if ($paciente) {
      
      $managerUsu->basic_update(array("password" => $this->request["password"]), $paciente["usuarioweb_idusuarioweb"]);
      $this->finish($managerUsu->getMsg());
      die();
  }
  else{
      $this->finish(array(
          "result" => false,
          "msg" => "Ocurrió un error al modificar la contraseña, intentelo nuevamente."
      ));
      die();
  }