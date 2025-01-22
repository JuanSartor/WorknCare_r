<?php

  $ManagerConsultaExpress = $this->getManager("ManagerConsultaExpress");

  $idperiodoPago = $this->request["idperiodoPago"];

  if ((int) $idperiodoPago > 0) {
      $listado_pacientes = $ManagerConsultaExpress->getListPacientesConsultaExpressPeriodoPago($idperiodoPago);
      $ManagerConsultaExpress->print_r($listado_pacientes);
      if ($listado_pacientes) {
          $this->assign("listado_paciente", $listado_pacientes);
      }
  }
