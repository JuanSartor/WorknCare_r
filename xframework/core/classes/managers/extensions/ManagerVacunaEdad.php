<?php

/**
 * 	@autor Xinergia
 * 	@version 1.0	29/05/2014
 * 	Manager de las vacunas edad
 *
 */
class ManagerVacunaEdad extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "vacunaedad", "idvacunaEdad");

        $this->flag = "activo";
    }

    public function process($record) {
        if ($record["unidadTemporal_idunidadTemporal"] != "") {
            if ($record["unidadTemporal_idunidadTemporal"] == 1) {
                $record["tiempo_meses"] = $record["valor_unidad"];
            }
            if ($record["unidadTemporal_idunidadTemporal"] == 2) {
                $record["tiempo_meses"] = $record["valor_unidad"] * 12;
            }
        }
        return parent::process($record);
    }

    public function getListadoJSON($request, $idpaginate = NULL) {

        if (!is_null($idpaginate)) {
            $this->paginate($idpaginate, 50);
        }

        $query = new AbstractSql();

        $query->setSelect("ve.*, ut.unidadTemporal");

        $query->setFrom("
                $this->table ve 
                    LEFT JOIN unidadtemporal ut ON (ve.unidadTemporal_idunidadTemporal = ut.idunidadTemporal)
            ");

        $query->setWhere("ve.activo = 1");
        $query->setOrderBy("tiempo_meses asc");

        $data = $this->getJSONList($query, array("edad", "valor_unidad", "unidadTemporal", "tiempo_meses"), $request, $idpaginate);

        return $data;
    }

    /**
     * ComboBox de vacunas
     * @return type
     */
    public function getCombo() {

        $query = new AbstractSql();

        $query->setSelect("$this->id, vacuna");

        $query->setFrom("$this->table");

        $query->setWhere("activo = 1");
        $query->setOrderBy("tiempo_meses asc");

        return $this->getComboBox($query, false);
    }

    /**
     * Listado de vacunas Edad
     * @return type
     */
    public function getListvacunaEdad() {

        $query = new AbstractSql();

        $query->setSelect("*");

        $query->setFrom("$this->table");

        $query->setWhere("activo = 1");
        $query->setOrderBy("tiempo_meses asc");


        return $this->getList($query);
    }

}

//END_class
?>