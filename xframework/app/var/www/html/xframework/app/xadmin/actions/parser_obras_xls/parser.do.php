<?php

  //localhost/doctorplus_v2/xadmin.php?action=1&modulo=parser_obras_xls&submodulo=parser
  $managerObraSocial = $this->getManager("ManagerObrasSociales");
  
  $rdo = $managerObraSocial->parserObrasSociales();
  if($rdo){
      echo "procesado bien";
  }
  else{
      echo "hubo un error";
  }