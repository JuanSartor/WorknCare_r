<?php

 /**
   * Cron utilizado para enviar por email o sms los recordatorios de los eventos
   */
  $ManagerTurno = $this->getManager("ManagerTurno");
 // $ManagerTurno->debug();
  $send_turno_paciente = $ManagerTurno->cronSendRecordatorioTurnoPaciente();
  