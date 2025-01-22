<?php

 /**
   * Cron utilizado para enviar por email el recordatorio de transferencia pendiente
   */
  $ManagerUsuarioEmpresa = $this->getManager("ManagerUsuarioEmpresa");
 // $ManagerUsuarioEmpresa->debug();
  $send_recordatorio = $ManagerUsuarioEmpresa->cronRecordatorioTransferenciaPendiente();
  