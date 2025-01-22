<?php
    $ManagerPaciente = $this->getManager("ManagerPaciente");
   //medicos frecuentes
    $medicos_frecuentes_list = $ManagerPaciente->getMedicosFrecuentesList($this->request, NULL, NULL, NULL);

    $this->assign("medicos_frecuentes_list", $medicos_frecuentes_list);
    

$paciente = $ManagerPaciente->getPacienteXHeader();
$this->assign("paciente", $paciente);