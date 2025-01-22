<?php


  $ManagerUsuarioEmpresa = $this->getManager("ManagerUsuarioEmpresa");
  
  $result = $ManagerUsuarioEmpresa->enviarMailCodigoValidacionEmail();
  $this->finish($ManagerUsuarioEmpresa->getMsg());
  
