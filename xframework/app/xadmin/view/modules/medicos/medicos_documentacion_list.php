<?php

  /**
   *  Médicos >>  listado de docuementacion
   * */
  if (isset($this->request["id"]) && $this->request["id"] > 0) {
      
      
      $listado=$this->getManager("ManagerDocumentacionMedico")->getListadoDocumentacion($this->request["id"]);
       $this->assign("listado_documentacion",$listado);
       
       
  }
 