<?php

  $manager = $this->getManager("ManagerPaciente");

  $manager->change_member_session_withID($this->request["id"]);

  $this->finish($manager->getMsg());
  