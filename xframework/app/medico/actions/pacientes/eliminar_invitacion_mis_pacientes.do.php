<?php

  /**
   * Eliminación de la asociación entre la INVITACIÓN un médico y un paciente
   */
  $manager = $this->getManager("ManagerMedicoPacienteInvitacion");

  $result = $manager->deleteAsociacion($this->request);

  $this->finish($manager->getMsg());
  