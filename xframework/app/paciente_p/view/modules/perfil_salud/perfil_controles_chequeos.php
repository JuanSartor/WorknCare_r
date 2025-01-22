<?php




  // Debo instanciar el paciente
  $ManagerPaciente = $this->getManager("ManagerPaciente");

  //Paciente que se encuentra en el array de SESSION de header paciente
  $paciente = $ManagerPaciente->getPacienteXHeader();
  $this->assign("paciente", $paciente);

  $estadoTablero = $this->getManager("ManagerPerfilSaludStatus")->getStatusPerfilPaciente($paciente["idpaciente"]);
  $this->assign("estadoTablero", $estadoTablero);
  
  $ConsultaExpressPermitida = $ManagerPaciente->isPermitidoConsultaExpress($paciente["idpaciente"]);
  $this->assign("ConsultaExpressPermitida", $ConsultaExpressPermitida);
$VideoConsultaPermitida = $ManagerPaciente->isPermitidoVideoConsulta($paciente["idpaciente"]);
  $this->assign("VideoConsultaPermitida", $VideoConsultaPermitida);
  
  $ManagerNotificacion = $this->getManager("ManagerNotificacion");
  $listado = $ManagerNotificacion->getListadoPaginadoControlesChequeosSinPaginarPaciente($paciente["idpaciente"]);

  $this->assign("listado", $listado);
 

  if ($listado && count($listado > 0)) {
      foreach ($listado as $key => $value) {
          if($value["leido"] == 0){
              $this->assign("alguna_activa", 1);
              
          }
      }
  }