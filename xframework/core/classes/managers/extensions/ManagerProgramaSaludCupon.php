<?php

/**
 * 	@autor Xinergia
 * 	@version 1.0	20/11/2020
 * 	Manager de planes de Programas de salud.
 *
 */
class ManagerProgramaSaludCupon extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "programa_salud_cupon", "idprograma_salud_cupon");
    }

    public function getListadoJSON($request, $idpaginate = NULL) {

        if (!is_null($idpaginate)) {
            $this->paginate($idpaginate, 20);
        }

        $query = new AbstractSql();
        $query->setSelect("*,
                    CASE activo
                    WHEN  1 THEN 'Actif'
                    WHEN  0 THEN 'Inactif' 
                    END as estado
                            ");
        $query->setFrom("$this->table");

        if ($request["nombre"] != "") {
            $busqueda = cleanQuery($request["nombre"]);
            $query->addAnd("nombre  LIKE '%$busqueda%' ");
        }

        $data = $this->getJSONList($query, array("nombre", "codigo_cupon", "estado"), $request, $idpaginate);

        return $data;
    }

    public function process($request) {
        $request["codigo_cupon"] = strtoupper(trim($request["codigo_cupon"]));
        return parent::process($request);
    }

    /**
     * ComboBox de vacunas
     * @return type
     */
    public function getList() {

        $query = new AbstractSql();

        $query->setSelect("*");

        $query->setFrom("$this->table");
        $query->setWhere("activo=1");

        return parent::getList($query);
    }

}

//END_class
?>