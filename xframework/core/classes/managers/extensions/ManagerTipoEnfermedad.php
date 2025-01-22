<?php

/**
 * 	@autor Xinergia
 * 	@version 1.0	29/05/2014
 * 	Manager de Los PLANES de las Obras Sociales - Prepagas
 *
 */
class ManagerTipoEnfermedad extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "tipoenfermedad", "idtipoEnfermedad");
    }

    /*
     * 	@author Xinergia <info@e-xinergia.com>
     *   @version 1.0
     */

    public function insert($request) {

        $id = parent::insert($request);

        //si se crea correctamente asocio las funcionaldades y si aplica o no
        if ($id) {
            $this->setMsg(["msg" => "La tipo enfermedad ha sido creado con éxito", "result" => true]);
        }

        return $id;
    }

    public function getListadoJSON($request, $idpaginate = NULL) {

        if (!is_null($idpaginate)) {
            $this->paginate($idpaginate, 50);
        }

        $query = new AbstractSql();
        $query->setSelect("
                $this->id,
                tipoEnfermedad
            ");
        $query->setFrom("
                $this->table
            ");
        $idenfermedad = (int) $request["enfermedad_idenfermedad"];
        $query->setWhere("enfermedad_idenfermedad=$idenfermedad");
        // Filtro
        if ($request["tipoEnfermedad"] != "") {

            $nombre = cleanQuery($request["tipoEnfermedad"]);

            $query->addAnd("tipoEnfermedad LIKE '%$nombre%'");
        }

        $query->setOrderBy("tipoEnfermedad ASC");

        $data = $this->getJSONList($query, array("tipoEnfermedad"), $request, $idpaginate);

        return $data;
    }

    public function getCombo($idenfermedad) {

        $query = new AbstractSql();
        $query->setSelect("$this->id,tipoEnfermedad");
        $query->setFrom("$this->table");
        $query->setWhere("enfermedad_idenfermedad=$idenfermedad");

        return $this->getComboBox($query, false);
    }

}

//END_class
?>