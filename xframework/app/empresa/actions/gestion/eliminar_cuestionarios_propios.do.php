<?php

/**
 * action que permite eliminar los cuestionarios propios que no estan listos
 */
$ids = explode("-", $this->request["idsaEliminar"]);
array_pop($ids);

$this->start();
$manager = $this->getManager("ManagerCuestionario");

foreach ($ids as $id) {
    $result = $manager->deleteCuestionario($id);
}
$this->finish($manager->getMsg());

