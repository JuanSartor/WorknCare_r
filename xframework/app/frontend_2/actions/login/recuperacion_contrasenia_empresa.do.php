<?php

  $manager = $this->getManager("ManagerUsuarioEmpresa");
  $rdo = $manager->resetPass($this->request);
  $msg = $manager->getMsg();

  $this->finish(
          array(
              "result" => $msg["result"],
              "msg" => $msg["msg"],
              "location" => URL_ROOT."creer-compte.html"
          )
  );

  