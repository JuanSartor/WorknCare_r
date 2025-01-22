<?php

  
  /**
   * Acción para la modificación del destacado
   */
  $managerEspecialidades = $this->getManager("ManagerEspecialidades");
  
  $result = $managerEspecialidades->update($this->request, $this->request["idespecialidad"]);
  
  $this->finish($managerEspecialidades->getMsg());