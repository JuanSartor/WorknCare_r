<?php

$manager = $this->getManager("ManagerMedico");
$imagenes_tarjetas = $manager->getImagenesIdentificacion($this->request["id"]);

$this->assign("imagenes_tarjetas", $imagenes_tarjetas);
