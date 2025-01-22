<?php

  /**
   *
   *  Notificaciones de pacientes -> LIST
   *
   */
  $manager = $this->getManager("ManagerNotificacionSistema");

  $paginate = SmartyPaginate::getPaginate($manager->getDefaultPaginate() . "_paciente");

  $this->assign("paginate", $paginate);
  