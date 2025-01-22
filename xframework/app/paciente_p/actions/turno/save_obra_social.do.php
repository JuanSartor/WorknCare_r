<?php

 
  $manager = $this->getManager("ManagerObraSocialPaciente");
  
  $result = $manager->process($this->request);
  
  $this->finish($manager->getMsg());
