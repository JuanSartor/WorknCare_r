<?php

  /**
   *
   *  Solicitudes de 
   *
   */
  $manager = $this->getManager("ManagerSolicitudPagoMedico");

  $paginate = SmartyPaginate::getPaginate($manager->getDefaultPaginate()."_recaudaciones");

  $this->assign("paginate", $paginate);
  $this->assign("list_periodos", $this->getManager("ManagerPeriodoPago")->getListPeriodos());