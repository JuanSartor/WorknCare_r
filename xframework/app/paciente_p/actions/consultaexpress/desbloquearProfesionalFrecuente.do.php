<?php

/**
   * Action para el bloqueo de profesionales en la consulta express
   */
  $manager = $this->getManager("ManagerProfesionalBloqueo");
  
  $result = $manager->desbloquear($this->request["idmedico"]);
  
  $this->finish($manager->getMsg());
