<?php

  $idmedico = $this->request["idmedico"];

  if ((int) $idmedico > 0) {
      $ManagerMedico = $this->getManager("ManagerMedico");
      $medico = $ManagerMedico->get($idmedico);
      $this->assign("medico", $medico);

      $ManagerMetodoPago = $this->getManager("ManagerMetodoPago");
      $this->assign("combo_metodo_pago", $ManagerMetodoPago->getCombo());
  }