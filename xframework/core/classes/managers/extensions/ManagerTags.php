<?php

/**
 * 	@autor Xinergia
 * 	@version 1.0	29/05/2014
 * 	Manager de los packs de SMS del Médico
 *
 */
class ManagerTags extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "tags", "idtags");
    }

    /*
     * 	@author Xinergia <info@e-xinergia.com>
     *   @version 1.0
     */

    public function insert($request) {
        $nombre = cleanQuery($request["nombreTag"]);
        $rdo = $this->getByField("nombreTag", $nombre);

        if ($rdo != false) {
            $this->setMsg(["msg" => "Error: El tag ya existe", "result" => false]);
            return false;
        }
        $id = parent::insert($request);

        //si se crea correctamente asocio las funcionaldades y si aplica o no
        if ($id) {
            $this->setMsg(["msg" => "El tag ha sido creado con éxito", "result" => false]);
        }

        return $id;
    }

    public function getListadoJSON($idpaginate = NULL, $request) {

        if (!is_null($idpaginate)) {
            $this->paginate($idpaginate, 50);
        }

        $query = new AbstractSql();
        $query->setSelect("t.*");
        $query->setFrom("
                $this->table t
            ");


        // Filtro
        if ($request["nombreTag"] != "") {

            $rdo = cleanQuery($request["nombreTag"]);

            $query->addAnd("t.nombreTag LIKE '%$rdo%'");
        }


        $query->setOrderBy("t.nombreTag ASC");

        $data = $this->getJSONList($query, array("nombreTag"), $request, $idpaginate);

        return $data;
    }

}

//END_class
?>