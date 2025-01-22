<?php

$array_cursos = $this->request["miorden"];
$orden = 1;
$bandera = 0;
foreach ($array_cursos as $id_curso) {
    if (strpos($id_curso, 'c') != false) {
        $managerPregunta = $this->getManager("ManagerPregunta");
        $id = substr($id_curso, 0, -1);
        $managerPregunta->update(["orden" => $orden], $id);
        $bandera = 1;
    } else {
        $managerPreguntaAbierta = $this->getManager("ManagerPreguntaAbierta");
        $id = substr($id_curso, 0, -1);
        $managerPreguntaAbierta->update(["orden" => $orden], $id);
        $bandera = 2;
    }
    $orden++;
}
if ($bandera == 1) {
    $this->finish($managerPregunta->getMsg());
} else {
    $this->finish($managerPreguntaAbierta->getMsg());
}


