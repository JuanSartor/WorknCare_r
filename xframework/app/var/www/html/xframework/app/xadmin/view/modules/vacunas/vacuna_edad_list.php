<?php

  /**
   *
   * Vacuna >> List
   *
   */
  $manager = $this->getManager("ManagerVacunaEdad");

  $paginate = SmartyPaginate::getPaginate($manager->getDefaultPaginate());

  $this->assign("paginate", $paginate);
  