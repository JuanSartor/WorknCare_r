<?php

  
  /**
   * Cron utilizado para enviar por email o sms los recordatorios de los eventos
   */
  $ManagerEventoPaciente = $this->getManager("ManagerEventoPaciente");
  //$ManagerEventoPaciente->debug();
  
  $send_recordatorio_paciente = $ManagerEventoPaciente->cronSendRecordatorioEventoPaciente();
  
  