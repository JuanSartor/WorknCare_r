<?php

/**
 * 	@autor Xinergia
 * 	@version 1.0	20/11/2020
 * 	Manager de Programas de salud.
 *
 */
class ManagerRecompensa extends ManagerMedia {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "recompensa_encuestas", "idrecompensa");
    }

    public function get($id) {
        $record = parent::get($id);
        return $record;
    }

    public function getComboRecompensas() {
        $query = new AbstractSQL();
        $query->setSelect("t.idrecompensa as id, t.monto as monto");
        $query->setFrom("$this->table t");
        $query->setWhere("t.idrecompensa>0");
        $listado = $this->getList($query);
        return $listado;
    }

}

//END_class
?>