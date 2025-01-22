<?php

  $ManagerPaciente = $this->getManager("ManagerPaciente");
 
if(isset($this->request["idpaciente"])&&$this->request["idpaciente"]!=""){
     $paciente = $ManagerPaciente->getPacienteXSelectMedico($this->request["id"]);
   
}else{
     $paciente = $ManagerPaciente->getPacienteXSelectMedico($this->request["idpaciente"]);
}
 

  $this->assign("paciente", $paciente);


          
  

  $this->assign("idpaciente", $paciente["idpaciente"]);
  
   //Obtengo los tags INputs
      $ManagerPerfilSaludConsulta = $this->getManager("ManagerPerfilSaludConsulta");    
      $tags = $ManagerPerfilSaludConsulta->getInfoTags($paciente["idpaciente"]);
      if ($tags) {
          $this->assign("tags", $tags);
      }

  $ManagerPerfilSaludBiometrico = $this->getManager("ManagerPerfilSaludBiometrico");
  $perfil_salud_biometrico = $ManagerPerfilSaludBiometrico->getByField("paciente_idpaciente", $paciente["idpaciente"]);
  
  if ($perfil_salud_biometrico) {
      $ManagerMasaCorporal = $this->getManager("ManagerMasaCorporal");
      $masa_corporal = $ManagerMasaCorporal->getLastInformation($perfil_salud_biometrico["idperfilSaludBiometricos"]);
      if ($masa_corporal) {
          $this->assign("masa_corporal", $masa_corporal);
      }

      $ManagerPresionArterial = $this->getManager("ManagerPresionArterial");
      $presion_arterial = $ManagerPresionArterial->getLastInformation($perfil_salud_biometrico["idperfilSaludBiometricos"]);
      if ($presion_arterial) {
          $this->assign("presion_arterial", $presion_arterial);
      }

      $ManagerColesterol = $this->getManager("ManagerColesterol");
      $colesterol = $ManagerColesterol->getLastInformation($perfil_salud_biometrico["idperfilSaludBiometricos"]);
      if ($colesterol) {
          $this->assign("colesterol", $colesterol);
      }

      $this->assign("perfil_salud_biometrico", $perfil_salud_biometrico);
      
     
     
  }
  
  
      $ultima_consulta = $ManagerPerfilSaludConsulta->getLastConsultaMedica($paciente["idpaciente"]);
  
      if($ultima_consulta){
          $this->assign("ultima_consulta", $ultima_consulta);
        

      }
  
  
   $estadoTablero=$this->getManager("ManagerPerfilSaludStatus")->getStatusPerfilPaciente($paciente["idpaciente"]);
 $this->assign("estadoTablero", $estadoTablero);
 
 
 $info_menu = $ManagerPaciente->getInfoMenu($paciente["idpaciente"]);
                    $this->assign("info_menu_paciente", $info_menu);
