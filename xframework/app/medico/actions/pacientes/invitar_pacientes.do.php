<?php

  /** 	
   * 	Accion: Envío de invitación de Paciente
   * 	
   */
  $this->start();
  $manager = $this->getManager("ManagerMedicoPacienteInvitacion");

//$manager->debug();
  $result = $manager->processInvitacion($this->request);


  $this->finish($manager->getMsg());
  