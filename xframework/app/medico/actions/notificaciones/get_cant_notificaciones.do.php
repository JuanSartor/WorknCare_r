<?php

  /**
   * Action >> Cantidad de notificaciones
   */
  $manager = $this->getManager("ManagerNotificacion");
  $id_entidad = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];
  $result = $manager->getCantidadNotificacionesMedico($id_entidad);

  $this->finish(["cant_notificaciones" => $result]);
  