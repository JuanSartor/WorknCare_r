<?php

/**
 * 	@autor Xinergia
 * 	@version 1.0	29/05/2014
 * 	Manager de los motivos de las visitas
 *
 */
class ManagerLaboratorio extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "laboratorio", "idlaboratorio");
    }

    /*
     * 	@author Xinergia <info@e-xinergia.com>
     *   @version 1.0
     */

    public function insert($request) {

        $id = parent::insert($request);

        //si se crea correctamente asocio las funcionaldades y si aplica o no
        if ($id) {
               
            $this->setMsg(["msg"=>"El Laboratorio ha sido creado con éxito","result"=>true]);
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
        if ($request["laboratorio"] != "") {

            $nombre = cleanQuery($request["laboratorio"]);

            $query->addAnd("laboratorio LIKE '%$nombre%'");
        }


        $query->setOrderBy("laboratorio ASC");

        $data = $this->getJSONList($query, array("laboratorio"), $request, $idpaginate);

        return $data;
    }

    
    public function getCombo() {

        $query = new AbstractSql();
        $query->setSelect("$this->id,laboratorio");
        $query->setFrom("$this->table");
        
        return $this->getComboBox($query, false);
    }
    

}

//END_class
?>