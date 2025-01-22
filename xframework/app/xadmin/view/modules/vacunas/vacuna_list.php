<?php

  /**
   *
   * Vacuna >> List
   *
   */
  $manager = $this->getManager("ManagerVacuna");

  $paginate = SmartyPaginate::getPaginate($manager->getDefaultPaginate());

  $this->assign("paginate", $paginate);
  