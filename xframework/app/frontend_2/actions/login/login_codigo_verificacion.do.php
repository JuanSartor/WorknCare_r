<?php

  $manager = $this->getManager("ManagerUsuarioWeb");
  $rdo = $manager->validarCodigoVerificacionLogin($this->request);
  
  $this->finish($manager->getMsg());

  