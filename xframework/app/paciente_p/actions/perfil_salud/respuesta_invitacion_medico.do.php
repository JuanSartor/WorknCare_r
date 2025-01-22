<?php

  /**
   * Action para el procesamiento de la respuesta de un paciente a una invitación del médico
   */
  $manager = $this->getManager("ManagerMedicoPacienteInvitacion");

  $manager->processRespuestaPaciente($this->request);

  $this->finish($manager->getMsg());
  