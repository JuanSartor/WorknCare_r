<?php

  /**
   *
   * Vacuna >> List
   *
   */
  $manager = $this->getManager("ManagerCirugiaOcular");

  $paginate = SmartyPaginate::getPaginate($manager->getDefaultPaginate());

  $this->assign("paginate", $paginate);
  