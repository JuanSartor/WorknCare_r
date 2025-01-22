<?php

  /**
   *
   *  Solicitudes de 
   *
   */
  $manager = $this->getManager("ManagerSolicitudPagoMedico");
  $this->assign("list_periodos", $this->getManager("ManagerPeriodoPago")->getListPeriodos());
  $paginate = SmartyPaginate::getPaginate($manager->getDefaultPaginate());

  $this->assign("paginate", $paginate);
  