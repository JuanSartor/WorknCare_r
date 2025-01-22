<?php

//$this->start();
  $manager = $this->getManager("ManagerResetsWeb");
//  $manager->debug();
  
  $resets = $manager->getResetByHash($this->request["hash"]);
  if($resets){
      $paciente = $this->getManager("ManagerPaciente")->getFromUsuarioWeb($resets["usuarioweb_idusuarioweb"]);
      if($paciente){
          $this->assign("paciente", $paciente);
      }else{
          $medico = $this->getManager("ManagerMedico")->getFromUsuarioWeb($resets["usuarioweb_idusuarioweb"]);
          if($medico){
              $this->assign("medico", $medico);
          }
      }
  }
  
  $rdo = $manager->validateResets($this->request);

  $this->assign("resultado", $rdo);
  if ($rdo) {
      $this->assign("hash", $this->request["hash"]);
  }