<?php

 /**
   * Action >> Perfil Alergias
   */
  $manager = $this->getManager("ManagerPerfilSaludCirugias");

  $result = $manager->processModificaciones($this->request);

  $this->finish($manager->getMsg());
  
