<?php

 
  $ManagerTipoTomaMedicamentos = $this->getManager("ManagerTipoTomaMedicamentos");
  $this->assign("combo_tipo_toma_medicamento", $ManagerTipoTomaMedicamentos->getCombo());
  
  