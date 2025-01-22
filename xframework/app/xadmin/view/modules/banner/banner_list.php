<?php

  /**
   *  BANNER >>  Listado
   *  
   * */
  $manager = $this->getManager("ManagerTipoBanner");

  $paginate = SmartyPaginate::getPaginate($manager->getDefaultPaginate());

  $this->assign("paginate", $paginate);
  
  $this->assign("combo_tipo_banner", $this->getManager("ManagerTipoBanner")->getCombo());
  