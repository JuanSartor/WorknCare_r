<?php

$ManagerConsultaExpress = $this->getManager("ManagerConsultaExpress");


$ManagerConsultaExpress->back_step($this->request);


$this->finish($ManagerConsultaExpress->getMsg());

