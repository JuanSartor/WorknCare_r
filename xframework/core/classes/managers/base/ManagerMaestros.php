<?php

/**
 * 	@autor Xinergia
 * 	@version 1.0
 *
 */
require_once(path_managers("base/Manager.php"));

/**
 * @autor Xinergia
 * Class ManagerTipoBanda
 * 
 */
class ManagerMaestros extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db, $table, $id) {

        // Constructor
        parent::__construct($db, $table, $id);
    }

    /*
     * 	@author Xinergia <info@e-xinergia.com>
     *
     *   Listado standard 
     */

    public function getListadoJSON($idpaginate = NULL, $request) {

        if (!is_null($idpaginate)) {
            $this->paginate($idpaginate, 25);
        }

        $query = new AbstractSql();
        $query->setSelect("$this->id,$this->table");
        $query->setFrom("$this->table");

        // Filtro


        if ($request["descripcion"] != "") {

            $descripcion = cleanQuery($request["descripcion"]);

            $query->addAnd($this->table . " LIKE '%$descripcion%'");
        }

        $data = $this->getJSONList($query, array($this->table), $request, $idpaginate);


        return $data;
    }

    /**
     * @author Emanuel del Barco
     * @version 1.0
     * Devuelve un listado de la entidad en forma de combo
     *
     *
     * @return array
     */
    public function getCombo() {

        $query = new AbstractSql();
        $query->setSelect("$this->id,$this->table");
        $query->setFrom($this->table);
        $query->setOrderBy("$this->table ASC");

        return $this->getComboBox($query, false);
    }

    /**
     * Delete mutiple
     *
     * */
    public function deleteMultiple($ids, $force = false) {

        $result = parent::deleteMultiple($ids, $force);

        if ($result) {


            $this->setMsg(["msg" => "Se dió de baja el/los registro/s del sistema", "result" => true]);
        }

        return $result;
    }

}

//END_class 
?>