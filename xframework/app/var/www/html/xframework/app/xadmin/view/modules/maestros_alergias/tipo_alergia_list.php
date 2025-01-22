<?php

  /**
   *
   *  planes de las obras Sociales List
   *
   */
  $manager = $this->getManager("ManagerSubTipoAlergia");
  $ManagerTipoAlergia = $this->getManager("ManagerTipoAlergia");
  $tipoAlergia = $ManagerTipoAlergia->get($this->request["tipoAlergia_idtipoAlergia"]);


  $paginate = SmartyPaginate::getPaginate($manager->getDefaultPaginate());

  $this->assign("paginate", $paginate);
  $this->assign("tipoAlergia", $tipoAlergia);
  