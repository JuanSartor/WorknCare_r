<?php

  
  $idmedico = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];
  
  $ManagerNotificacion = $this->getManager("ManagerNotificacion");
  $paginate = "list_renovacion_receta";
  $this->assign("idpaginate", $paginate . "_" . $idmedico);
  
  $listado = $ManagerNotificacion->getNotificacionesRenovacion($this->request, $paginate . "_" . $idmedico);
  
  if(count($listado["rows"]) > 0){
      $this->assign("listado_notificaciones", $listado);
  }