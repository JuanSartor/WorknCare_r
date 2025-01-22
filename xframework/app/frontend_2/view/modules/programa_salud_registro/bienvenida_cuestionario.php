<?php

//recumeramos los registros mediante el hash

$Invitacions = $this->getManager("ManagerEmpresaInvitacionCuestionario")->getByField("hash", $this->request["hash"]);

$cuestionario = $this->getManager("ManagerCuestionario")->get($Invitacions["cuestionario_idcuestionario"]);
$this->assign("cuestionario", $cuestionario);
$req["cuestionarios_idcuestionario"] = $cuestionario["idcuestionario"];
$preguntas_cerradas = $this->getManager("ManagerPregunta")->getListadoPreguntas($req);
$ManagerPreguntaAbierta = $this->getManager("ManagerPreguntaAbierta");
$listado_preguntas_abierta = $ManagerPreguntaAbierta->getListadoPreguntas(["cuestionario_idcuestionario" => $cuestionario["idcuestionario"]]);
$preguntas = array_merge($preguntas_cerradas, $listado_preguntas_abierta);
array_sort_by($preguntas, "orden");
$this->assign("lista_preguntas", $preguntas);
$primerElemento = $preguntas[0];
$ultimoElemento = end($preguntas);
//print_r($primerElemento);
$this->assign("primerElemento", $primerElemento);
$this->assign("ultimoElemento", $ultimoElemento);


if ($cuestionario["programasalud_idprogramasalud"] == '0') {
    // si es cero hago una seleccion aleatorio
    $banners = array("a", "b", "c");
    $urlbanner = $banners[array_rand($banners)];
    $this->assign("url_baner", $urlbanner);
} else {
    $this->assign("url_baner", $cuestionario["programasalud_idprogramasalud"]);
}

function array_sort_by(&$arrIni, $col, $order = SORT_ASC) {
    $arrAux = array();
    foreach ($arrIni as $key => $row) {
        $arrAux[$key] = is_object($row) ? $arrAux[$key] = $row->$col : $row[$col];
        $arrAux[$key] = strtolower($arrAux[$key]);
    }
    array_multisort($arrAux, $order, $arrIni);
}
