<?php

  /**
   * 	@autor Xinergia
   * 	Manager de los motivos de Video Consulta asociados a un programa de salud
   *
   */
  class ManagerMotivoVideoConsultaProgramaCategoria extends Manager {

      /** constructor
       * 	@param $db instancia de adodb
       */
      function __construct($db) {

          // Llamamos al constructor del a superclase
          parent::__construct($db, "motivovideoconsulta_programa_categoria", "idmotivovideoconsulta_programa_categoria");

          
      }
      
      function getByMotivo($id){

          $query=new AbstractSql();
          $query->setSelect("*");
          $query->setFrom("{$this->table} t INNER JOIN programa_categoria e ON (t.idprograma_categoria=e.idprograma_categoria) INNER JOIN programa_salud p on (p.idprograma_salud=e.programa_salud_idprograma_salud)");
          $query->setWhere("t.motivoVideoConsulta_idmotivoVideoConsulta=$id");
          return $this->getList($query);
      }
    
      

    

  }

//END_class
?>