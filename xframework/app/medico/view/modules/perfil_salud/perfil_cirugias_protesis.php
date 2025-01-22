<?php

  $this->assign("item_menu", "surgery");

  //Paciente que se encuentra en el array de SESSION de header paciente
  $ManagerPaciente = $this->getManager("ManagerPaciente");
  $paciente = $ManagerPaciente->getPacienteXSelectMedico($this->request["idpaciente"]);
  $this->assign("paciente", $paciente);

  $ManagerPerfilSaludCirugias = $this->getManager("ManagerPerfilSaludCirugias");
  $listado = $ManagerPerfilSaludCirugias->getListCirugias($paciente["idpaciente"]);
  if ($listado && count($listado) > 0) {
      $this->assign("cantidad_cirugias", count($listado));
      $this->assign("listado_cirugias", $listado);
  } else {
      $this->assign("cantidad_cirugias", 0);
  }

  $ManagerPerfilSaludProtesis = $this->getManager("ManagerPerfilSaludProtesis");
  $listado_protesis = $ManagerPerfilSaludProtesis->getListProtesis($paciente["idpaciente"]);
  if ($listado_protesis && count($listado_protesis) > 0) {
      $this->assign("listado_protesis", $listado_protesis);
      $this->assign("cantidad_protesis", count($listado_protesis));
  } else {
      $this->assign("cantidad_protesis", 0);
  }
  
  //Obtengo los tags INputs
      $ManagerPerfilSaludConsulta = $this->getManager("ManagerPerfilSaludConsulta");    
      $tags = $ManagerPerfilSaludConsulta->getInfoTags($paciente["idpaciente"]);
      if ($tags) {
          $this->assign("tags", $tags);
      }
      
       $estadoTablero=$this->getManager("ManagerPerfilSaludStatus")->getStatusPerfilPaciente($paciente["idpaciente"]);
 $this->assign("estadoTablero", $estadoTablero);

  $cirugias_protesis=$this->getManager("ManagerPerfilSaludCirugiasProtesis")->getByField("paciente_idpaciente",$paciente["idpaciente"]);
   $this->assign("cirugias_protesis", $cirugias_protesis);
   
  
 
 $info_menu = $ManagerPaciente->getInfoMenu($paciente["idpaciente"]);
                    $this->assign("info_menu_paciente", $info_menu);
