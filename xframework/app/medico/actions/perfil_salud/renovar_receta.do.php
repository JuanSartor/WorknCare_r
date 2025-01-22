<?php
  /**
   * Action >> Renovación de receta
   */
  $manager = $this->getManager("ManagerSolicitudRenovacionPerfilSaludMedicamento");

  $result = $manager->aceptarSolicitudRenovacion($this->request);

  $this->finish($manager->getMsg());
