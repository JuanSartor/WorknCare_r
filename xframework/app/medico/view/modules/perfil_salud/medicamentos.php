<?php

  $this->assign("item_menu", "medicine");

  //Id del paciente que el médico elije
  if (isset($_SESSION[URL_ROOT]["medico"]['logged_account']["paciente_session"]) && $_SESSION[URL_ROOT]["medico"]['logged_account']["paciente_session"]["idpaciente"] != "") {
      $idpaciente = $_SESSION[URL_ROOT]["medico"]['logged_account']["paciente_session"]["idpaciente"];
  }else{
      $idpaciente=$this->request["idpaciente"];
  }

  if ((int) $idpaciente > 0) {
      $ManagerMedico = $this->getManager("ManagerMedico");
      $paciente = $ManagerMedico->getPacienteMedico($idpaciente);
      if ($paciente) {
          $this->assign("paciente", $paciente);
      }

      
      //Obtengo los tags INputs
      $ManagerPerfilSaludConsulta = $this->getManager("ManagerPerfilSaludConsulta");    
      $tags = $ManagerPerfilSaludConsulta->getInfoTags($idpaciente);
      if ($tags) {
          $this->assign("tags", $tags);
      }

      $ManagerPerfilSaludMedicamento = $this->getManager("ManagerPerfilSaludMedicamento");
      $listado = $ManagerPerfilSaludMedicamento->getListMedicacionActual(array("paciente_idpaciente" => $idpaciente));
      $this->assign("list_medicacion_actual", $listado);
   

      $listado_medico = $ManagerPerfilSaludMedicamento->getListMedicacionMedico(array("paciente_idpaciente" => $idpaciente));
      $this->assign("list_medicacion_medico", $listado_medico);

    
  }

  $this->assign("idmedico", $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"]);

  $ManagerPaciente = $this->getManager("ManagerPaciente");
 $info_menu = $ManagerPaciente->getInfoMenu($paciente["idpaciente"]);
                    $this->assign("info_menu_paciente", $info_menu);


  
   $estadoTablero=$this->getManager("ManagerPerfilSaludStatus")->getStatusPerfilPaciente($paciente["idpaciente"]);
 $this->assign("estadoTablero", $estadoTablero);