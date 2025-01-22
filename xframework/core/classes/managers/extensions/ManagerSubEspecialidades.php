<?php

/**
 * 	@autor Xinergia
 * 	@version 1.0	29/05/2014
 * 	Manager de Los PLANES de las Obras Sociales - Prepagas
 *
 */
class ManagerSubEspecialidades extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "subEspecialidad", "idsubEspecialidad");
    }

    /*
     * 	@author Xinergia <info@e-xinergia.com>
     *   @version 1.0
     */

    public function insert($request) {

        $id = parent::insert($request);

        //si se crea correctamente asocio las funcionaldades y si aplica o no
        if ($id) {
            $this->setMsg(["msg"=>"La subespecialidad ha sido creado con éxito","result"=>true]);
        }
        return $id;
    }

    public function getListadoJSON($idpaginate = NULL, $request) {

        if (!is_null($idpaginate)) {
            $this->paginate($idpaginate, 50);
        }

        $query = new AbstractSql();
        $query->setSelect("
                $this->id,
                subEspecialidad
            ");
        $query->setFrom("
                $this->table
            ");
        $idespecialidad = (int) $request["especialidad_idespecialidad"];
        $query->setWhere("especialidad_idespecialidad=$idespecialidad");
        // Filtro
        if ($request["subEspecialidad"] != "") {

            $nombre = cleanQuery($request["subEspecialidad"]);

            $query->addAnd("subEspecialidad LIKE '%$nombre%'");
        }

        $query->setOrderBy("subEspecialidad ASC");

        $data = $this->getJSONList($query, array("subEspecialidad"), $request, $idpaginate);

        return $data;
    }
    
    
    public function getCombo($idespecialidad) {

        $query = new AbstractSql();
        $query->setSelect("$this->id,subEspecialidad");
        $query->setFrom("$this->table");
        $query->setWhere("especialidad_idespecialidad=$idespecialidad");
         $query->setOrderBy("subEspecialidad ASC");
        
        return $this->getComboBox($query, false);
    }

    
    
    
    /**
       *  Todas los idiomas que maneja un profesional
       *
       * */
      public function getSubEspecialidadesTagsInputMedico($idMedico) {

          $query = new AbstractSql();
          $query->setSelect("
            s.$this->id  AS id ,
            s.subEspecialidad AS value
        ");
          $query->setFrom("
                   especialidadmedico em
                   JOIN $this->table s ON (em.subEspecialidad_idsubEspecialidad = s.$this->id)
        ");

          $query->setWhere("em.medico_idMedico = $idMedico");

          $subespecialidades_medico_list = $this->getList($query, false);

          return $subespecialidades_medico_list;
      }

}

//END_class
?>