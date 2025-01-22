<?php

  /**
   *
   *  planes de las obras Sociales List
   *
   */
  $manager = $this->getManager("ManagerTipoEnfermedad");
  $ManagerEnfermedad = $this->getManager("ManagerEnfermedad");
  $enfermedad = $ManagerEnfermedad->get($this->request["enfermedad_idenfermedad"]);


  $paginate = SmartyPaginate::getPaginate($manager->getDefaultPaginate());

  $this->assign("paginate", $paginate);
  $this->assign("enfermedad", $enfermedad);
  