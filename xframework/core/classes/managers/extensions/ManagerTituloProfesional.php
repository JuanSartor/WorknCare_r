<?php

/**
 * 	@autor Xinergia
 * 	@version 1.0	29/05/2014
 * 	Manager de los títulos profesonales
 *
 */
class ManagerTituloProfesional extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "titulo_profesional", "idtitulo_profesional");
    }

    /*
     * 	@author Xinergia <info@e-xinergia.com>
     *   @version 1.0
     */

    public function insert($request) {

        $id = parent::insert($request);

        //si se crea correctamente asocio las funcionaldades y si aplica o no
        if ($id) {
            $this->setMsg(["msg"=>"El Título Profesional ha sido creado con éxito","result"=>true]);
        }

        return $id;
    }

    public function getListadoJSON($request, $idpaginate = NULL) {

        if (!is_null($idpaginate)) {
            $this->paginate($idpaginate, 50);
        }

        $query = new AbstractSql();
        $query->setSelect("*");
        
        $query->setFrom("
                $this->table
            ");

        // Filtro
        if ($request["titulo_profesional"] != "") {

            $nombre = cleanQuery($request["titulo_profesional"]);

            $query->addAnd("titulo_profesional LIKE '%$nombre%'");
        }


        $query->setOrderBy("titulo_profesional ASC");

        $data = $this->getJSONList($query, array("titulo_profesional"), $request, $idpaginate);

        return $data;
    }

    
    public function getCombo() {

        $query = new AbstractSql();
        $query->setSelect("$this->id,titulo_profesional");
        $query->setFrom("$this->table");
        
        return $this->getComboBox($query, false);
    }
    

}

//END_class
?>