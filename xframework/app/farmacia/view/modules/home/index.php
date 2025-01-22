<?php

$ManagerPerfilSaludRecetaArchivo = $this->getManager("ManagerPerfilSaludRecetaArchivo");
$receta = $ManagerPerfilSaludRecetaArchivo->getByField("codigo", $this->request["codigo"]);

if ($receta) {
    $receta["file_original"] = url_web("imprimer_ordonnance.do?code={$receta["codigo"]}");
    $receta["file_copia"] = url_web("preview_ordonnance.do?code={$receta["codigo"]}");
    $this->assign("receta", $receta);
}