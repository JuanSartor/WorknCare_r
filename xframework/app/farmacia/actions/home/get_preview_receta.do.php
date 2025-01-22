<?php

$ManagerPerfilSaludRecetaArchivo = $this->getManager("ManagerPerfilSaludRecetaArchivo");

$ManagerPerfilSaludRecetaArchivo->get_receta_electronica($this->request["code"],true);

