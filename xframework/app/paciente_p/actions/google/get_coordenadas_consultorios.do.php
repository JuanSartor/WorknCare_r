<?php

  $managerConsultorio = $this->getManager("ManagerConsultorio");

  $consultorio = $managerConsultorio->get($this->request["id"]);
          
//header('Content-Type: application/json');
  echo json_encode($consultorio);