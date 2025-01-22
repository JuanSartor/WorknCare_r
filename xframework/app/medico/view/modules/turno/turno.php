<?php

//Id es el correspondiente al turno
if (isset($this->request["id"]) && $this->request["id"] != "") {
    $ManagerTurno = $this->getManager("ManagerTurno");

    //$ManagerTurno->debug();
    $detalle_turno = $ManagerTurno->getDetalleTurno($this->request["id"]);

    $idmedico = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];
    //obtenemos el listado de consultorios del medico
    $managerConsultorio = $this->getManager("ManagerConsultorio");
    $listado_consultorios = $managerConsultorio->getListconsultorioMedico($idmedico);
    $this->assign("consultorio_list", $listado_consultorios);

//obtenemos la cantidad de turnos por consultorio para la fecha del turno
     list($y, $m, $d) = preg_split("[-]", $detalle_turno["fecha"]);
     $fecha_format_arg = date('d/m/Y', mktime(0, 0, 0, $m, $d, $y));
    
    $listado_datos_consultorios = $managerConsultorio->getDatosTurnosXConsultorio($fecha_format_arg, 1);
    if ($listado_datos_consultorios) {
        $this->assign("datos_consultorios", $listado_datos_consultorios);
    }


    if ($detalle_turno == FALSE) {
        throw new ExceptionErrorPage("No se puede acceder a la información solicitada");
    }
}
