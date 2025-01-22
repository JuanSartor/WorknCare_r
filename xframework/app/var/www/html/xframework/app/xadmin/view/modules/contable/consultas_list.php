<?php

  /**
   *
   *  listado de consultas
   *
   */


  $paginate = SmartyPaginate::getPaginate("recaudaciones_consultas_list");

  $this->assign("paginate", $paginate);
$this->assign("list_periodos", $this->getManager("ManagerPeriodoPago")->getListPeriodos());