<?php

  
  $this->start();
  $manager = $this->getManager("ManagerUsuarioWeb");
  $result = $manager->reset_intentos_fallidos($this->request["idusuarioweb"]);
  $this->finish($manager->getMsg());
  