<?php

  $manager = $this->getManager("ManagerUsuarioWeb");
  $rdo = $manager->resetPass($this->request);
  $msg = $manager->getMsg();

  $this->finish(
          array(
              "result" => $msg["result"],
              "msg" => $msg["msg"],
              "location" => URL_ROOT
          )
  );

  