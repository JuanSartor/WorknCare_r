<?php

/**
 * 	@autor Xinergia
 * 	@version 1.0	20/11/2020
 * 	Manager de excepciones de Programas de salud ofrecidos por empresas.
 *
 */
class ManagerProgramaSaludExcepcion extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "programa_salud_excepcion", "idprograma_salud_excepcion");
    }

    /**
     * Método que registra las excepciones de planes de salud ofrecidos por la empresa
     * @param type $request
     */
    public function registrar_programa_excepcion($request) {

        $record["programa_salud_excepcion"] = $request["ids"];
        if ($request["idEmpresa"] == '') {
            $idempresa = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idempresa"];
        } else {
            $idempresa = $request["idEmpresa"];
        }
        $record["empresa_idempresa"] = $idempresa;
        $excepcion_exist = parent::getByField("empresa_idempresa", $idempresa);

        if ($excepcion_exist) {
            $record["idprograma_salud_excepcion"] = $excepcion_exist["idprograma_salud_excepcion"];
        }

        $rdo = parent::process($record);
        if ($rdo) {

            $this->setMsg(["msg" => "Se actualizaron los programas incluidos en su plan", "result" => true]);
        }
        return $rdo;
    }

    /**
     * Metodo que verifica si el medico está incluido en los planes cubiertos por el plan empresa y la consulta es sin cargo
     * @param type $idmedico
     */
    public function verificar_medico_bonificado($idmedico, $idempresa, $idprograma_categoria = null) {

        //si hay una categoria seleccionada filtramos esa categoria especifica, si no listamos 
        if ($idprograma_categoria != "") {
            $queryAndCategoria = " AND pc.idprograma_categoria=$idprograma_categoria";
        }
        $query = new AbstractSql();
        $query->setSelect("programa_salud_idprograma_salud");
        $query->setFrom("
            (SELECT DISTINCT pc.programa_salud_idprograma_salud from programa_medico_complementario pmc
            INNER JOIN programa_categoria pc ON (pc.idprograma_categoria=pmc.programa_categoria_idprograma_categoria)
            WHERE medico_idmedico=$idmedico {$queryAndCategoria}
            UNION
            SELECT DISTINCT pc.programa_salud_idprograma_salud from programa_medico_referente pmr
            INNER JOIN programa_categoria pc ON (pc.idprograma_categoria=pmr.programa_categoria_idprograma_categoria)
            WHERE medico_idmedico=$idmedico {$queryAndCategoria}
                ) as T
                ");
        $query->setWhere("T.programa_salud_idprograma_salud NOT IN (select idprograma_salud from programa_salud where FIND_IN_SET(idprograma_salud,  
                                       ( select programa_salud_excepcion as programa_salud_idprograma_salud from programa_salud_excepcion where empresa_idempresa=$idempresa))
                  )");
        $listado = $this->getList($query);

        //si encontramos un programa bonificado por la empresa a la que pertenece el medico, entonces las consulta esta bonificado
        return count($listado) > 0;
    }

    /**
     * Metodo que verifica si el programa está incluido en los planes cubiertos por el plan empresa y la consulta es sin cargo
     * @param type $idmedico
     */
    public function verificar_programa_bonificado($idprograma_categoria, $idempresa) {

        $query = new AbstractSql();
        $query->setSelect("programa_salud_idprograma_salud");
        $query->setFrom("programa_categoria pc");
        $query->setWhere("pc.idprograma_categoria=$idprograma_categoria and FIND_IN_SET(programa_salud_idprograma_salud,  
                                        (select programa_salud_excepcion as programa_salud_idprograma_salud from programa_salud_excepcion where empresa_idempresa=$idempresa)
                  )");
        $listado = $this->getList($query);

        //si no hay excpeciones para los programas, esta bonificado
        return count($listado) == 0;
    }

}

//END_class
?>