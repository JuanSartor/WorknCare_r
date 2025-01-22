<?php


//Servicios que puede ofrecer el médico, cargados en el sistema
  $managerServiciosMedicos = $this->getManager("ManagerServiciosMedicos");
  $servicios = $managerServiciosMedicos->getCombo();
  $this->assign("servicios_medicos", $servicios);
  
  //Especialidades del profesional
  $managerEspecialidades = $this->getManager("ManagerEspecialidades");
  $combo_especialidades = $managerEspecialidades->getCombo(1);
  $this->assign("combo_especialidades", $combo_especialidades);
  
  $managerPais = $this->getManager("ManagerPais");
$paises = $managerPais->getCombo();
$this->assign("combo_pais", $paises);

 