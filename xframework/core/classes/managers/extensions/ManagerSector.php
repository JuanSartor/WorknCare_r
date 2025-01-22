<?php

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Description of ManagerPrestador
 *
 * @author lucas
 */
class ManagerSector extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "sector", "idsector");
    }

    /*     * Metodo que devuelve un combo sectores 
     *  Con la opcion $medico=1 devuelve solo los sectores de medicos activos en el sistema
     * @param type $idprestado
     */

    public function getCombo($medicos = 0) {
        $query = new AbstractSql();
        $query->setSelect("s.$this->id,s.sector");
        if ($medicos) {
            $query->setFrom(" $this->table s 
                            INNER JOIN medico m ON (m.sector_idsector=s.idsector)");
            $query->setGroupBy("s.$this->id");
        } else {
            $query->setFrom("$this->table s");
        }


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
        if ($request["sector"] != "") {

            $nombre = cleanQuery($request["sector"]);

            $query->addAnd("sector LIKE '%$nombre%'");
        }


        $query->setOrderBy("sector ASC");

        $data = $this->getJSONList($query, array("sector", "tarifa"), $request, $idpaginate);

        return $data;
    }

}
