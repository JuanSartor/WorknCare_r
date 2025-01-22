<?php

  if (isset($this->request["id"]) && $this->request["id"] != "") {
      $ManagerNotificacionSistema = $this->getManager("ManagerNotificacionSistema");
      $this->assign("record", $ManagerNotificacionSistema->get($this->request["id"]));


      $paginate = SmartyPaginate::getPaginate($ManagerNotificacionSistema->getDefaultPaginate() . "_" . $this->request["id"]);

      $this->assign("paginate", $paginate);
  }