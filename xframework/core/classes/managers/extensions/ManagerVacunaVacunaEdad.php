<?php

/**
 * 	@autor Xinergia
 * 	@version 1.0	29/05/2014
 * 	Manager de las vacunas edad
 *
 */
class ManagerVacunaVacunaEdad extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "vacuna_vacunaedad", "idvacuna_vacunaEdad");

        $this->flag = "activo";
    }

    public function getListadoJSON($request, $idpaginate = NULL) {

        if (!is_null($idpaginate)) {
            $this->paginate($idpaginate, 50);
        }

        $query = new AbstractSql();

        $query->setSelect("ve.$this->id, v.vacuna, ve.descripcion, v.descripcion as descripcion_vacuna,
            CASE clase
            WHEN 'va-unica-dosis' THEN 'Única dosis'
            WHEN 'va-primer-dosis' THEN '1&deg; dosis'
            WHEN 'va-segunda-dosis' THEN '2&deg; dosis'
            WHEN 'va-tercera-dosis' THEN '3&deg; dosis'
            WHEN 'va-cuarta-dosis' THEN '4&deg; dosis'
            WHEN 'va-refuerzo' THEN 'Refuerzo'
            WHEN 'va-esquema' THEN 'Iniciar o completar esquema'
            WHEN 'va-anual-dosis' THEN 'Dosis anual'
                END as tipo_aplicacion
                ");

        $query->setFrom("
                $this->table ve
                LEFT JOIN vacuna v ON (v.idvacuna = ve.vacuna_idvacuna)
                ");

        $query->setWhere("ve.activo = 1");

        $query->addAnd("ve.vacunaEdad_idvacunaEdad = " . $request["vacunaEdad_idvacunaEdad"]);



        $data = $this->getJSONList($query, array("vacuna", "descripcion_vacuna", "descripcion", "tipo_aplicacion"), $request, $idpaginate);

        return $data;
    }

    public function process($request) {
  
        $exist = $this->getByFieldArray(["vacunaEdad_idvacunaEdad", "vacuna_idvacuna"], [$request["vacunaEdad_idvacunaEdad"], $request["vacuna_idvacuna"]]);
        if ($exist) {
            if ($exist["activo"] == 1) {
                $this->setMsg(["result" => false, "msg" => "Error. La vacuna ya se encuentra asociada"]);
                return false;
            } else {
                $request["activo"] = 1;
                return parent::update($request, $exist["idvacuna_vacunaEdad"]);
            }
        } else {
            $rdo = parent::process($request);
            if ($rdo) {
                return $rdo;
            } else {
                $this->setMsg(["result" => false, "msg" => "Se produjo un error al ingresar los datos"]);
                return false;
            }
        }
    }

    /**
     * Método que obtiene el registro de vacuna_vacunaedad que contenga los dos id´s pasados como parámetros
     * @param type $idvacuna
     * @param type $idvacunadEdad
     * @return boolean
     */
    public function getXRelacion($idvacuna, $idvacunadEdad, $idpaciente) {
        $query = new AbstractSql();

        $query->setSelect("*");

        $query->setFrom("$this->table t LEFT JOIN paciente_vacuna_vacunaedad pv ON(t.$this->id = pv.vacuna_vacunaEdad_idvacuna_vacunaEdad AND pv.paciente_idpaciente = $idpaciente)");

        $query->setWhere("vacuna_idvacuna = $idvacuna");

        $query->addAnd("t.activo=1 AND vacunaEdad_idvacunaEdad = $idvacunadEdad");

        $execute = $this->db->Execute($query->getSql());
        if ($execute) {
            return $execute->FetchRow();
        } else {
            return false;
        }
    }

    /**
     * Obtener el registro con la vacuna edad y la vacuna relacionada
     * @param type $idvacuna_vacunaEdad
     * @return boolean
     */
    public function getVacunaVacunaEdad($idvacuna_vacunaEdad) {
        $query = new AbstractSql();

        $query->setSelect("*");

        $query->setFrom("$this->table t
                INNER JOIN vacunaedad ve ON(t.vacunaEdad_idvacunaEdad = ve.idvacunaEdad)
                INNER JOIN vacuna v ON(v.idvacuna = t.vacuna_idvacuna)
                ");

        $query->setWhere("t.$this->id = $idvacuna_vacunaEdad");

        $execute = $this->db->Execute($query->getSql());

        if ($execute) {
            return $execute->FetchRow();
        } else {
            return false;
        }
    }

    /**
     * Método que obtiene las vacuna X vacuna_edad que no estén configuradas para el paciente
     * @param type $idpaciente
     * @return type
     */
    public function getListVacunasNoAplicadasPaciente($idpaciente) {

        $query = new AbstractSql();

        $query->setSelect("t.descripcion as descripcion_vacuna_vacuna_edad, "
                . "t.$this->id, "
                . "t.vacuna_idvacuna, "
                . "t.vacunaEdad_idvacunaEdad, "
                . "t.clase, "
                . "ve.*, "
                . "v.vacuna, "
                . "v.descripcion as descripcion_vacuna, "
                . "v.activo as activo_vacuna");

        $query->setFrom("$this->table t
                INNER JOIN vacunaedad ve ON(t.vacunaEdad_idvacunaEdad = ve.idvacunaEdad)
                INNER JOIN vacuna v ON(v.idvacuna = t.vacuna_idvacuna)");
        $query->setWhere("v.genera_notificacion = 1");
        $query->addAnd("t.$this->id NOT IN(SELECT vacuna_vacunaEdad_idvacuna_vacunaEdad
                FROM paciente_vacuna_vacunaedad
                WHERE paciente_idpaciente = $idpaciente
                )");

        $query->setOrderBy("orden ASC");

        $query2 = new AbstractSql();

        $query2->setSelect("*");

        $query2->setFrom("(" . $query->getSql() . ") as t");

        $query2->setGroupBy("t.vacuna_idvacuna");

        return $this->getList($query2
        );
    }

}

//END_class
?>