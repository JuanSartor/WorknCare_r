<?php

  /**
   * Action >> Perfil Salud Estilo Vida
   */
  $manager = $this->getManager("ManagerPerfilSaludEstiloVida");

  $result = $manager->process($this->request);

  $this->finish($manager->getMsg());