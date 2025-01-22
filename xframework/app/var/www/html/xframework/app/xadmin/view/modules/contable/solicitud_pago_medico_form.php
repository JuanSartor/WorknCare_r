<?php
/**
 * Form de las solicitudes de pago de los médicos
 */
  if (isset($this->request["id"]) && $this->request["id"] > 0) {
      
      $manager = $this->getManager("ManagerSolicitudPagoMedico");
      $record = $manager->getSolicitud($this->request["id"], true);
      $this->assign("combo_estado_solicitud_pago_medico", $manager->getComboEstadoSolicitudPagoMedico());
      
      $this->assign("record", $record);
  }

  
  

  $paginate = SmartyPaginate::getPaginate($manager->getDefaultPaginate());

  $this->assign("paginate", $paginate);
  
  