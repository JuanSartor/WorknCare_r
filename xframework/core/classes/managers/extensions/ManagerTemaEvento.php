<?php

/**
 * 	@autor Xinergia
 * 	@version 1.0	29/05/2014
 * 	Manager de Los temas utilizados para los eventos
 *
 */
class ManagerTemaEvento extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "temaevento", "idtemaevento");
    }

    /*
     * 	@author Xinergia <info@e-xinergia.com>
     *   @version 1.0
     */

    public function insert($request) {

        $id = parent::insert($request);

        //si se crea correctamente asocio las funcionaldades y si aplica o no
        if ($id) {
            $this->setMsg(["msg"=>"El evento ha sido creado con éxito","result"=>true]);
        }

        return $id;
    }

    public function getListadoJSON($idpaginate = NULL, $request) {

        if (!is_null($idpaginate)) {
            $this->paginate($idpaginate, 50);
        }

        $query = new AbstractSql();
        $query->setSelect("*");
        
        $query->setFrom("
                $this->table
            ");

        // Filtro
        if ($request["temaevento"] != "") {

            $nombre = cleanQuery($request["temaevento"]);

            $query->addAnd("temaevento LIKE '%$nombre%'");
        }


        $query->setOrderBy("temaevento ASC");

        $data = $this->getJSONList($query, array("temaevento"), $request, $idpaginate);

        return $data;
    }

    
    public function getCombo() {

        $query = new AbstractSql();
        $query->setSelect("$this->id,temaevento");
        $query->setFrom("$this->table");
        
        return $this->getComboBox($query, false);
    }
    

}

//END_class
?>