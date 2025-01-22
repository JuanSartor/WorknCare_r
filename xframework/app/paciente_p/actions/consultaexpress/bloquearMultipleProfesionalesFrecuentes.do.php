<?php

/**
   * Action para el bloqueo de profesionales en la consulta express
   */
  $manager = $this->getManager("ManagerProfesionalBloqueo");
  
  $result = $manager->bloquear($this->request["ids"]);
  
  $this->finish($manager->getMsg());
