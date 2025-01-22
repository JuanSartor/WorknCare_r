<?php

 /**
   * Action >> Perfil Alergias
   */
  $manager = $this->getManager("ManagerPaciente");
  
  $result = $manager->changePrivacidad($this->request);

  $this->finish($manager->getMsg());