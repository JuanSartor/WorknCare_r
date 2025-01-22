<?php

  
  $request = [
        "rango_minimo" => 50,
        "rango_maximo" => 90,
        "especialidad_idespecialidad" => 183,
        "mensaje" => "Hola doctor necesito que analice mi garganta"
  ];
  //die("asdfasdf");
  $manager = $this->getManager("ManagerPerfilSaludEstudios");
  
  $manager->debug();
  
  $manager->processFromConsultaExpress(319);
  
  $manager->print_r($manager->getMsg());