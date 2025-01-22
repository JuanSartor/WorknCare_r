<?php

// obtengo el cuestionario y sus preguntas para personalizar
$ManagerCuestionario = $this->getManager("ManagerCuestionario");
$cuestionario = $ManagerCuestionario->get($this->request["cuestionarios_idcuestionario"]);
$this->assign("cuestionario", $cuestionario);
$ManagerPregunta = $this->getManager("ManagerPregunta");
$listado_preguntas_cerradas = $ManagerPregunta->getListadoPreguntas(["cuestionarios_idcuestionario" => $this->request["cuestionarios_idcuestionario"]]);
$ManagerPreguntaAbierta = $this->getManager("ManagerPreguntaAbierta");
$listado_preguntas_abierta = $ManagerPreguntaAbierta->getListadoPreguntas(["cuestionario_idcuestionario" => $this->request["cuestionarios_idcuestionario"]]);
$listado_preguntas = array_merge($listado_preguntas_cerradas, $listado_preguntas_abierta);
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
