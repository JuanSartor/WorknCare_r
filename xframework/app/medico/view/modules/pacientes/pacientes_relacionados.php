<?php

  $ManagerPaciente = $this->getManager("ManagerPaciente");
  
  $listado_pacientes_relacionados = $ManagerPaciente->getPacientesRelacionados($this->request["idpaciente"]);

  if (count($listado_pacientes_relacionados) > 0) {
      $this->assign("listado_pacientes_relacionados", $listado_pacientes_relacionados);
  }
  
