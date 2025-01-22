<?php

  $this->assign("combo_especialidades", $this->getManager("ManagerEspecialidades")->getComboList());



  if(isset($this->request["i"])&&$this->request["i"]!=""){

  
      $invitacion=$this->getManager("ManagerMedicoPrestadorInvitacion")->get(base64_decode($this->request["i"]));
       
      if($invitacion){
          $this->assign("invitacion",$invitacion);
      }
  }
  $manager=$this->getManager("ManagerPreregistro");
$manager->insert(["email"=>"{$this->request["email"]}"]);
  