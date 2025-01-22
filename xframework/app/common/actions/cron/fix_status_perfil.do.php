<?php

 /**
   * Cron utilizado para actulizar la edad del paciente
   */
  $ManagerPerfilSaludStatus = $this->getManager("ManagerPerfilSaludStatus");
  $ManagerPerfilSaludStatus->debug();
  
  $ersultado = $ManagerPerfilSaludStatus->fix_status_perfil();
  