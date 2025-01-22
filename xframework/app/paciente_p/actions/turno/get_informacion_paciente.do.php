<?php

  $informacion = $this->getManager("ManagerObraSocialPaciente")->getObraSocialPaciente($this->request["idpaciente"]);
  $informacion["is_frecuente"]=$this->getManager("ManagerProfesionalesFrecuentesPacientes")->isFrecuente($this->request["idmedico"],$this->request["idpaciente"]);
  $paciente=$this->getManager("ManagerPaciente")->get($this->request["idpaciente"]);
  $informacion["privacidad_perfil_salud"]=$paciente["privacidad_perfil_salud"];
  $informacion["is_permitido"]=$paciente["is_permitido"];
  
  $this->finish($informacion);
  
  