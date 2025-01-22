<?php

/**
 *  cargar file
 */
$Manager = $this->getManager("ManagerFileCapsula");

$result = $Manager->processFile($this->request);
$this->finish($Manager->getMsg());

