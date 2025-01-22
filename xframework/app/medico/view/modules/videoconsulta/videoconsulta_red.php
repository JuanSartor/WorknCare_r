<?php

//Consulta en la Red
$idmedico = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];
$this->assign("idmedico", $idmedico);
$medico = $this->getManager("ManagerMedico")->get($idmedico, true);
$this->assign("medico", $medico);
//print_r($medico);

$this->assign("preferencia", $this->getManager("ManagerPreferencia")->getPreferenciaMedico($idmedico));

$ManagerVideoConsulta = $this->getManager("ManagerVideoConsulta");

$cantidad_consulta = $ManagerVideoConsulta->getCantidadVideoConsultasMedicoXEstado();
$this->assign("cantidad_consulta", $cantidad_consulta);
// print_r($cantidad_consulta);

$ManagerFiltroBusqueda = $this->getManager("ManagerFiltrosBusquedaVideoConsulta");
$rango_precios = $ManagerFiltroBusqueda->getRangoPreciosVideoConsulta($this->request);
$this->assign("rango_precios", $rango_precios);

//obtenemos la especialidad seteada en el request si viene del filtro
if ($this->request["from_filtro"] == "1") {
    $tags_filtros = $ManagerFiltroBusqueda->getTagsFiltro($this->request);
    $this->assign("tags_filtros", $tags_filtros);
} else {


    if (COUNT($this->request["idespecialidad"]) == 1) {
        $especialidad = $ManagerVideoConsulta->getCantidadVideoConsultaXEspecialidad($this->request["idespecialidad"][0]);
        $this->assign("especialidad", $especialidad[0]);
    } else {//si no viene seteada la especialidad la obtenemos del medico    
        $especialidades_medico = $this->getManager("ManagerEspecialidadMedico")->getEspecialidadesList($idmedico);
        //si es una sola, la mostramos con su cantidad de consultas
        if (COUNT($especialidades_medico) == 1) {
            $especialidad = $ManagerVideoConsulta->getCantidadVideoConsultaXEspecialidad($especialidades_medico[0]["especialidad_idespecialidad"]);
            if ($especialidad) {
                $this->assign("especialidad", $especialidad[0]);
            } else {

                //si no hay consultas para esa especialidad, solo obtenego el nombre para  mostrar en la pantalla
                $especialidad = $this->getManager("ManagerEspecialidades")->get($especialidades_medico[0]["especialidad_idespecialidad"]);
                $this->assign("especialidad", $especialidad);
            }
        }
    }
}

//guardo los filtros de busqueda mediante smarty para pasarselo al x_loadModule del listado;
$cut = strrpos($_SERVER["QUERY_STRING"], "from_filtro");
if ($cut > 0) {
    $qs = substr($_SERVER["QUERY_STRING"], $cut);

    $this->assign("query_string", $qs);
}

//Especialidades del profesional
$managerEspecialidades = $this->getManager("ManagerEspecialidades");
$combo_especialidades = $managerEspecialidades->getCombo(1);
$this->assign("combo_especialidades", $combo_especialidades);

// <-- LOG
$log["data"] = "-";
$log["page"] = "Video Consultation";
$log["action"] = "vis"; //"val" "vis" "del"
$log["purpose"] = "See Video Consultation request PUBLICATED";

$ManagerLog = $this->getManager("ManagerLog");
$ManagerLog->track($log);
