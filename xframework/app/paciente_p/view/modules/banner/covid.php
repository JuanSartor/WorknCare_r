<?php

  //obtenemos el estado de avance del perfil completado
  $paciente = $ManagerPaciente->getPacienteXHeader();
  $this->assign("paciente",$paciente);