<?php

$ManagerPerfilSaludRecetaArchivo = $this->getManager("ManagerPerfilSaludRecetaArchivo");

$ManagerPerfilSaludRecetaArchivo->crear_receta_electronica($this->request["id"]);

