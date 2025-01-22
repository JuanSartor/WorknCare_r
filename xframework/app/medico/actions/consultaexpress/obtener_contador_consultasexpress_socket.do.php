<?php

$this->start();
$ManagerConsultaExpress=$this->getManager("ManagerConsultaExpress");
$ManagerConsultaExpress->obtener_contador_consultasexpress_socket();
$this->finish($ManagerConsultaExpress->getMsg());
