<?php

  $ManagerEspecialidades = $this->getManager("ManagerEspecialidades");
  $especialidades = $ManagerEspecialidades->getCombo(1);
  $this->assign("combo_especialidades", $especialidades);
  