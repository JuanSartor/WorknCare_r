<?php

  //Id del paciente que el médico elije
  $idpaciente = $this->request["id"];

  if ((int) $idpaciente > 0) {

      $ManagerPerfilSaludMedicamento = $this->getManager("ManagerPerfilSaludMedicamento");
      $listado_medico = $ManagerPerfilSaludMedicamento->getListMedicacionMedicoConsulta(array("paciente_idpaciente" => $idpaciente, 
            "idperfilSaludConsulta" => $this->request["idperfilSaludConsulta"]));
      if ($listado_medico) {
          $this->assign("list_medicacion_medico", $listado_medico);
    
      }
  }