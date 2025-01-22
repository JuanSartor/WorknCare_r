<?php

/**
 *  cargar file
 */
$Manager = $this->getManager("ManagerFileCapsula");


if ($this->request["banderaGenerica"] == '0') {
    $result = $Manager->processFile($this->request);
} else {
    $result = $Manager->processFileGenerico($this->request);
}

$this->finish($Manager->getMsg());

