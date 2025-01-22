<?php

  /**
   * setear estado de facturacion de videoconsulta con reintegro
   */
  $this->start();
  $manager = $this->getManager("ManagerVideoConsulta");
  $result = $manager->facturar_reintegro_consulta($this->request);
  $this->finish($manager->getMsg());

