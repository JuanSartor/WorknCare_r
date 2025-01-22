<?php

  /**
   * FORM >> perfil ginecológico de paciente familiar
   */
  $this->start();
  
  $manager = $this->getManager("ManagerPerfilSaludGinecologico");

  $result = $manager->process($this->request);
  
  $this->finish($manager->getMsg());

  