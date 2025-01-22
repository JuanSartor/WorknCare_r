<?php

$ManagerConsultaExpress = $this->getManager("ManagerConsultaExpress");

$ManagerConsultaExpress->set_medico_consultaexpress($this->request);

  $this->finish($ManagerConsultaExpress->getMsg());