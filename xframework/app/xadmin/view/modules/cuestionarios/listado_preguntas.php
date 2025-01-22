<?php

/**
 *  modulo para obtener todos las preguntas del cuestionario
 */
$ManagerPegunta = $this->getManager("ManagerPregunta");

$listado_preguntas_cerrada = $ManagerPegunta->getListadoPreguntas(["cuestionarios_idcuestionario" => $this->request["cuestionarios_idcuestionario"]]);

$ManagerPeguntaAb = $this->getManager("ManagerPreguntaAbierta");

$listado_preguntas_abierta = $ManagerPeguntaAb->getListadoPreguntas(["cuestionario_idcuestionario" => $this->request["cuestionarios_idcuestionario"]]);
$listado_preguntas = array_merge($listado_preguntas_abierta, $listado_preguntas_cerrada);
array_sort_by($listado_preguntas, "orden");
$this->assign("listado_preguntas", $listado_preguntas);


function array_sort_by(&$arrIni, $col, $order = SORT_ASC) {
    $arrAux = array();
    foreach ($arrIni as $key => $row) {
        $arrAux[$key] = is_object($row) ? $arrAux[$key] = $row->$col : $row[$col];
        $arrAux[$key] = strtolower($arrAux[$key]);
    }
    array_multisort($arrAux, $order, $arrIni);
}


