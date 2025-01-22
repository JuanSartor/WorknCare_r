<?php

  $request = [
        "idconsultaExpress" => 26,
        "mensaje" => "Respuesta para el paciente de la garganta"
  ];
  $manager = $this->getManager("ManagerCuentaUsuario");
  
  $manager->debug();
  
  $manager->actualizarCuentaMedico(17);
  
  $manager->print_r($manager->getMsg());