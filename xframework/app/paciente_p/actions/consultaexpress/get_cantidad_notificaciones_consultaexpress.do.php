<?php

  /**
   * 
   */
  $manager = $this->getManager("ManagerConsultaExpress");
 

  $this->finish([
        "notificacion_general" => $manager->getNotificacionConsultasExpressPacienteXEstadoJSON()
  ]);


  