<?php
//accion para exportar la agenda de turnos mensual del medico a XLS

$this->getManager("ManagerTurno")->ExportarAgendaXLS($this->request["fecha"],$this->request["agenda"]);

