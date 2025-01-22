<?php

  $ManagerPerfilSaludConsulta = $this->getManager("ManagerPerfilSaludConsulta");

//  $ManagerPerfilSaludConsulta->debug();
  $listado = $ManagerPerfilSaludConsulta->getListadoOtrosProfesionales($this->request);
 
  if ($listado) {
      $this->assign("listado", $listado);
      
   
    
  }

