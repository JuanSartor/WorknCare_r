<?php

  /**
   *  Médicos >>  listado de excepciones
   * */
  if (isset($this->request["id"]) && $this->request["id"] > 0) {
      
      
      $listado_excepciones=$this->getManager("ManagerGrillaExcepcion")->getListadoExcepciones($this->request["id"]);
       $this->assign("listado_excepciones",$listado_excepciones);
       
       
  }
 