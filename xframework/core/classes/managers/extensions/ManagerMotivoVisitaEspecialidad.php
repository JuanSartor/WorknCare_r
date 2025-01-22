<?php

  /**
   * 	@autor Xinergia
   * 	Manager de los motivos de visita asociados a una especialidad
   *
   */
  class ManagerMotivoVisitaEspecialidad extends Manager {

      /** constructor
       * 	@param $db instancia de adodb
       */
      function __construct($db) {

          // Llamamos al constructor del a superclase
          parent::__construct($db, "motivovisita_especialidad", "idmotivovisita_especialidad");

          
      }
      
      function getByMotivo($id){
  
          $query=new AbstractSql();
          $query->setSelect("*");
          $query->setFrom("{$this->table} t INNER JOIN especialidad e ON (t.especialidad_idespecialidad=e.idespecialidad)");
          $query->setWhere("t.motivoVisita_idmotivoVisita=$id");
          return $this->getList($query);
      }
    
      

    

  }

//END_class
?>