<?php

  /** 	
   * 	Accion: Grilla del Listado de Los tipos de banners
   * 	
   */
  $manager = $this->getManager("ManagerTipoBanner");

  $records = $manager->getListadoJSON($this->request, $manager->getDefaultPaginate());

  echo $records;
  