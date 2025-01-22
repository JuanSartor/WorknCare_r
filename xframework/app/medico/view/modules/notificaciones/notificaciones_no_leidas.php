<?php

  
  $idmedico = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];
  
  $ManagerNotificacion = $this->getManager("ManagerNotificacion");
  $paginate = $ManagerNotificacion->getDefaultPaginate();
  $this->assign("idpaginate", $paginate . "_" . $idmedico);
  
  $listado = $ManagerNotificacion->getListadoPaginadoMedico($this->request, $paginate . "_" . $idmedico);
  
  if(count($listado["rows"]) > 0){
      $this->assign("listado_notificaciones", $listado);
      
  }
