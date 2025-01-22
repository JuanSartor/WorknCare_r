<?php

//$this->start();
  $manager = $this->getManager("ManagerResetsEmpresa");
//  $manager->debug();
  
  $resets = $manager->getResetByHash($this->request["hash"]);
  if($resets){
      $usuario = $this->getManager("ManagerUsuarioEmpresa")->get($resets["usuario_empresa_idusuario_empresa"]);
   
          $this->assign("usuario", $usuario);
     
  }
  
  $rdo = $manager->validateResets($this->request);

  $this->assign("resultado", $rdo);
  if ($rdo) {
      $this->assign("hash", $this->request["hash"]);
  }