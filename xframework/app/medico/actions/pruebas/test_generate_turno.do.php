<?php

 
  $ManagerConfiguracionAgenda = $this->getManager("ManagerConfiguracionAgenda");
  $ManagerConfiguracionAgenda->debug();
  $configuracion_agenda = $ManagerConfiguracionAgenda->get(61);
  
  $ManagerTurno = $this->getManager("ManagerTurno");
  $ManagerTurno->generateTurnosMedico($configuracion_agenda);