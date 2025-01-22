<?php

  /**
   *
   *  OBras Sociales List
   *
   */
  $manager = $this->getManager("ManagerLaboratorio");

  $paginate = SmartyPaginate::getPaginate($manager->getDefaultPaginate());

  $this->assign("paginate", $paginate);
  