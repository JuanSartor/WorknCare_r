<?php

// obtengo el cuestionario y sus preguntas para personalizar
$ManagerModelo = $this->getManager("ManagerModeloRiesgo");
$modelo = $ManagerModelo->get($this->request["idmodelos_riesgos"]);
$this->assign("modelo", $modelo);


$ManagerFam = $this->getManager("ManagerFamiliaRiesgo");

$listado = $ManagerFam->getListadoFamiliasPorModelo(["modelos_riesgo_idmodelos_riesgo" => $this->request["idmodelos_riesgos"]]);

array_sort_by($listado, "orden");
$this->assign("listado", $listado);

function array_sort_by(&$arrIni, $col, $order = SORT_ASC) {
    $arrAux = array();
    foreach ($arrIni as $key => $row) {
        $arrAux[$key] = is_object($row) ? $arrAux[$key] = $row->$col : $row[$col];
        $arrAux[$key] = strtolower($arrAux[$key]);
    }
    array_multisort($arrAux, $order, $arrIni);
}
