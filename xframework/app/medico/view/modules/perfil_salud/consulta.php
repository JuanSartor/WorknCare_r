<?php

  $this->assign("item_menu", "consults");

  //Id del paciente que el médico elije
  $idpaciente = $this->request["id"];

  if ((int) $idpaciente > 0) {
      $ManagerMedico = $this->getManager("ManagerMedico");
      $paciente = $ManagerMedico->getPacienteMedico($idpaciente);
      if ($paciente) {
          $this->assign("paciente", $paciente);
      }


      if (isset($this->request["idperfilSaludConsulta"]) && $this->request["idperfilSaludConsulta"]) {

          $ManagerPerfilSaludConsulta = $this->getManager("ManagerPerfilSaludConsulta");
          
          $record = $ManagerPerfilSaludConsulta->get($this->request["idperfilSaludConsulta"]);
          $this->assign("record", $record);

          //Obtengo los tags INputs
          $tags = $ManagerPerfilSaludConsulta->getInfoTags($idpaciente);
          if($tags){
              $this->assign("tags", $tags);
          }

          $ManagerPerfilSaludMedicamento = $this->getManager("ManagerPerfilSaludMedicamento");
          $listado_medico = $ManagerPerfilSaludMedicamento->getListMedicacionMedicoConsulta(array("paciente_idpaciente" => $idpaciente, "idperfilSaludConsulta" => $this->request["idperfilSaludConsulta"]));
          if ($listado_medico) {
              $this->assign("list_medicacion_medico", $listado_medico);
          }


          $ManagerPerfilSaludEstudios = $this->getManager("ManagerPerfilSaludEstudios");
          $paginate = $ManagerPerfilSaludEstudios->getDefaultPaginate();
          $this->assign("idpaginate", $paginate . "_" . $idpaciente);
          $listado = $ManagerPerfilSaludEstudios->getListEstudiosConsulta(array(
                "idpaciente" => $idpaciente,
                "do_reset" => $_SESSION['SmartyPaginate'][$paginate . "_" . $idpaciente]["current_item"] == "1" ? 1 : "",
                "idperfilSaludConsulta" => $this->request["idperfilSaludConsulta"]), $paginate . "_" . $idpaciente
          );
          if ($listado) {
              $this->assign("listado_imagenes", $listado);
              $this->assign("cantidad_imagenes", count($listado));
          }
      }
  }

  $this->assign("idmedico", $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"]);
  