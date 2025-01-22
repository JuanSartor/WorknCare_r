
<?php

if ($this->request["tipo"] == "presencial") {
    $consultorios_list = $this->getManager("ManagerConsultorio")->getListconsultorioMedico($this->request["idmedico"], true);
   
     $this->assign("consultorios_list", $consultorios_list);
    

    
} else {
    $consultorio = $this->getManager("ManagerConsultorio")->getConsultorioVirtual($this->request["idmedico"]);
    $consultorios_list[]=$consultorio;
      $this->assign("consultorios_list", $consultorios_list);
  
}



