<?php

$manager = $this->getManager("ManagerPaciente");
$imagenes_tarjetas = $manager->getImagenesIdentificacion($this->request["id"]);

$this->assign("imagenes_tarjetas", $imagenes_tarjetas);
