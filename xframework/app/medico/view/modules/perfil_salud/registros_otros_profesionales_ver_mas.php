<?php

  $ManagerPerfilSaludConsulta = $this->getManager("ManagerPerfilSaludConsulta");

  $this->assign("idpaginate", "profesionales_ver_mas_list");
  $this->assign("idmedico", $this->request["idmedico"]);
  $this->assign("idpaciente", $this->request["idpaciente"]);

  $listado = $ManagerPerfilSaludConsulta->getListPaginadoMedico($this->request, "profesionales_ver_mas_list");

  if ($listado) {
      $this->assign("listado", $listado);
  }