<?php

   $ManagerProfesionalesFrecuentesPacientes = $this->getManager("ManagerProfesionalesFrecuentesPacientes");

   $idmedicosession=$_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];
  $listado = $ManagerProfesionalesFrecuentesPacientes->getListadoProfesionalesFrecuentesPaciente($this->request["idpaciente"], $idmedicosession);
 $this->assign("idmedicosession", $idmedicosession);
  
 if (count($listado) > 0) {
      $this->assign("listado_profesionales_frecuentes", $listado);
  }
