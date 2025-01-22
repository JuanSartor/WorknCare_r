<?php

 
  $ManagerTurno = $this->getManager("ManagerTurno");
  
  $result = $ManagerTurno->update($this->request, $this->request["idturno"]);
  
  $this->finish($ManagerTurno->getMsg());

