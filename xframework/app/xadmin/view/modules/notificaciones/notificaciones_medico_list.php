<?php

  /**
   *
   *  Notificaciones de pacientes -> LIST
   *
   */
  $manager = $this->getManager("ManagerNotificacionSistema");

  $paginate = SmartyPaginate::getPaginate($manager->getDefaultPaginate() . "_medico");

  $this->assign("paginate", $paginate);
  