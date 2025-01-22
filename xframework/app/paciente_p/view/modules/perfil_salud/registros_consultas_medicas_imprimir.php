<?php

  $ManagerPerfilSaludConsulta = $this->getManager("ManagerPerfilSaludConsulta");


  $consulta = $ManagerPerfilSaludConsulta->getConsultaCompleta($this->request["idperfilSaludConsulta"]);

  if ($consulta) {
      $this->assign("consulta", $consulta);
     
  }
 