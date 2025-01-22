<?php

  /**
   *
   * Sector List
   *
   */
  $manager = $this->getManager("ManagerSector");

  $paginate = SmartyPaginate::getPaginate($manager->getDefaultPaginate());

  $this->assign("paginate", $paginate);
  