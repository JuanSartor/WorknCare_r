<?php

  /**
   * Action >> Enfermedades Actuales
   */
  $manager = $this->getManager("ManagerNotificacion");
  $ManagerPaciente = $this->getManager("ManagerPaciente");
  $paciente = $ManagerPaciente->getPacienteXHeader();
  $id_entidad = $paciente["idpaciente"];

  $this->finish([
        "cant_notificaciones" => $manager->getCantidadNotificacionesPaciente($id_entidad),
        "cant_notificaciones_controles" => $manager->getCantidadControlesChequeos($id_entidad)
  ]);


  