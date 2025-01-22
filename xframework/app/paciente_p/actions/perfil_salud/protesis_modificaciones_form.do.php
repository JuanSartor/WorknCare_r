<?php

 /**
   * Action >> Perfil Alergias
   */
  $manager = $this->getManager("ManagerPerfilSaludProtesis");

  $result = $manager->processModificaciones($this->request);

  $this->finish($manager->getMsg());
  
