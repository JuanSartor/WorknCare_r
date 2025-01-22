<?php

/**
 * 	@autor Xinergia
 * 	@version 1.0	29/05/2014
 * 	Manager de los menu de usuarios
 *
 */
class ManagerUsuarioMenu extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "usuario_menu", "idusuario_menu");
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

        $query->setOrderBy("usuario_menu ASC");
        $data = $this->getJSONList($query, array("usuario_menu"), $request, $idpaginate);
        return $data;
    }

    public function getCombo() {

        $query = new AbstractSql();
        $query->setSelect("$this->id,usuario_menu");
        $query->setFrom("$this->table");
        $query->setOrderBy("usuario_menu ASC");

        return $this->getComboBox($query, false);
    }

}

//END_class
?>