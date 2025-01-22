<?php

 
  
  $idpaginate="solicitudes_pago_".$_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];
  $this->assign("idpaginate",$idpaginate);
  
  $ManagerSolicitudPagoMedico=$this->getManager("ManagerSolicitudPagoMedico");
  $list_medico_pagos=$ManagerSolicitudPagoMedico->getListadoPaginadoSolicitudesPagoMedico($this->request,$idpaginate);
 
  $this->assign("list_medico_pagos",$list_medico_pagos);
