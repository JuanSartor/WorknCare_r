<?php

  /**
   *  Archivos documentacion medico >>  Obtenemos el listado de archivos adjuntados
   *  
   * */
  if (isset($this->request["iddocumentacion"]) && $this->request["iddocumentacion"] > 0) {
      $manager = $this->getManager("ManagerArchivosDocumentacionMedico");
      $listado = $manager->getListadoArchivosDocumentacionMedico($this->request["iddocumentacion"]);

      $this->assign("listado", $listado);
      
      

  }

  