<?php

  /**
   *
   *  Banco List
   *
   */
  $manager = $this->getManager("ManagerBanco");

  $paginate = SmartyPaginate::getPaginate($manager->getDefaultPaginate());

  $this->assign("paginate", $paginate);
