<?php

/**
 * ManagerMotivoRechazo administra los motivos asociados a una consulta express cuando es rechazada
 *
 * @author lucas
 */
class ManagerMotivoRechazo extends AbstractManager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Constructor
        parent::__construct($db, "motivorechazo", "idmotivoRechazo");
    }

    /**
     *  Combo de los motivos de rechazo de una CE
     *
     * */
    public function getCombo() {

        $query = new AbstractSql();
        $query->setSelect("$this->id, motivoRechazo");
        $query->setFrom("$this->table");

        return $this->getComboBox($query, false);
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
        if ($request["motivoRechazo"] != "") {

            $nombre = cleanQuery($request["motivoRechazo"]);

            $query->addAnd("motivoRechazo LIKE '%$nombre%'");
        }


        $query->setOrderBy("motivoRechazo ASC");

        $data = $this->getJSONList($query, array("motivoRechazo"), $request, $idpaginate);

        return $data;
    }

}
