<?php

  $manager = $this->getManager("ManagerPaciente");

  $manager->change_member_session_go_home();
  
  $this->finish($manager->getMsg());
  