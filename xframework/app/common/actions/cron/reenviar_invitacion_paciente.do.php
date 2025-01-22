<?php

 /**
   * Cron utilizado para enviar por email o sms los recordatorio de invitacion nscripcion pendiente. Una vez al día.
   */
  $ManagerPaciente = $this->getManager("ManagerPaciente");
  $ManagerPaciente->debug();
  
  $resultado = $ManagerPaciente->cronReenviarInvitacionPaciente();
  