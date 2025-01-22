<?php

/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
  /** 	
   * 	Accion: Marcar como leído las notificaciones
   * 	
   */
  $this->start();

  
  $manager = $this->getManager("ManagerNotificacion");
  
  $result = $manager->getNotificacionesEmergentesSistemaPaciente();
  
  $this->finish($result);
