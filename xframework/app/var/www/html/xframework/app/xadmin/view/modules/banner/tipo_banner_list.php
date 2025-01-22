<?php

  /**
   *  tipo BANNER >>  Listado
   *  
   * */
  $manager = $this->getManager("ManagerTipoBanner");

  $paginate = SmartyPaginate::getPaginate($manager->getDefaultPaginate());

  $this->assign("paginate", $paginate);
  