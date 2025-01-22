<?php


  $ManagerUsuarioEmpresa = $this->getManager("ManagerUsuarioEmpresa");
  
  $result = $ManagerUsuarioEmpresa->checkValidacionEmail($this->request);
  $this->finish($ManagerUsuarioEmpresa->getMsg());
  
