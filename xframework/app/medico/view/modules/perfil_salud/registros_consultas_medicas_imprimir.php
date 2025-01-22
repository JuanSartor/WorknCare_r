<?php

$ManagerPerfilSaludConsulta = $this->getManager("ManagerPerfilSaludConsulta");

if ($this->request["rango"] == 1) {
    $listado_consulta = [];
    $ids_consulta = $ManagerPerfilSaludConsulta->getListadoConsultasRango($this->request);
    foreach ($ids_consulta as $consulta) {
        $consulta = $ManagerPerfilSaludConsulta->getConsultaCompleta($consulta["idperfilSaludConsulta"]);
        $listado_consulta[] = $consulta;
        $this->assign("listado_consulta", $listado_consulta);
    }
}
if ($this->request["idperfilSaludConsulta"] != "") {
    $consulta = $ManagerPerfilSaludConsulta->getConsultaCompleta($this->request["idperfilSaludConsulta"]);
    if ($consulta["medico_idmedico"] != $_SESSION[URL_ROOT]["medico"]['logged_account']["medico"]["idmedico"]) {
        $this->assign("otro_profesional", 1);
    }
    if ($consulta) {
        $listado_consulta[] = $consulta;
        $this->assign("listado_consulta", $listado_consulta);
    }
}
 
