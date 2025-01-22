<?php

/**
 * 	@autor Xinergia
 * 	@version 1.0	20/11/2020
 * 	Manager de vacaciones del medico
 *
 */
class ManagerMedicoVacaciones extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "medico_vacaciones", "idmedico_vacaciones");
    }

    public function agregar_vacaciones($request) {
        $record["desde"] = $this->sqlDate($request["desde"]);
        $record["hasta"] = $this->sqlDate($request["hasta"]);
        $record["medico_idmedico"] = (int) $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"];

        $turno_vacaciones = $this->chequear_turno_existente_durante_vacaciones($record);
        if ($turno_vacaciones["idturno"] != "") {
            list($y, $m, $d) = preg_split("[-]", $turno_vacaciones["fecha"]);
            $fecha_format = "$d/$m/$y";
            $this->setMsg(["msg" => "Usted tiene citas asignadas durante este período. Debes cancelarlos antes de cargar las vacaciones.", "result" => false, "turno_existente" => 1, "fecha" => $fecha_format, "idconsultorio" => $turno_vacaciones["consultorio_idconsultorio"]]);
            return false;
        }
        $id = parent::insert($record);
        if ($id) {
            $this->setMsg(["msg" => "Se ha registrado su periodo de vacaciones", "result" => true]);
            return $id;
        } else {
            $this->setMsg(["msg" => "Error. No se ha podido registrar su periodo de vacaciones", "result" => false]);
            return false;
        }
    }

    /*
     * Metodo que devuelve el listado de vacaciones cargadas por el medico
     */

    public function listado_vacaciones($idmedico = null) {
        if (is_null($idmedico)) {
            $idmedico = (int) $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"];
        }

        $query = new AbstractSql();
        $query->setSelect("*");
        $query->setFrom("$this->table");
        $query->setWhere("medico_idmedico=$idmedico");
        return $this->getList($query);
    }

    /**
     * Metodo que chequea si el medico tiene un turno asignado pendiente o confirmado en el periodo de vacaciones que desea cargar
     * @param type $periodo_vacaciones
     * @return type bool
     */
    public function chequear_turno_existente_durante_vacaciones($periodo_vacaciones) {

        $idmedico = (int) $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"];

        //Obtengo la configuración de la agenda para el médico
        $query = new AbstractSql();
        $query->setSelect("t.*");
        $query->setFrom("turno t");
        $query->setWhere("t.medico_idmedico = $idmedico");
        $query->addAnd("t.paciente_idpaciente IS NOT NULL AND (t.estado = 1 OR t.estado = 0)");
        $query->addAnd("fecha BETWEEN '{$periodo_vacaciones["desde"]}' and '{$periodo_vacaciones["hasta"]}'");

        $listado = $this->getList($query);
        return $listado[0];
    }

    /**
     * Metodo que devuelve el periodo de vacaciones activo de un medico
     * @param type $idmedico
     */
    public function getVacacionesMedico($idmedico) {

        $hoy = date("y-m-d");

        $query = new AbstractSql();
        $query->setSelect("*");
        $query->setFrom("$this->table");
        $query->setWhere("medico_idmedico=$idmedico");
        $query->addAnd("'$hoy' BETWEEN desde and hasta");
        $vacaciones = $this->getList($query)[0];
        if ($vacaciones["hasta"] != "") {
            list($y, $m, $d) = preg_split("[-]", $vacaciones["hasta"]);
            $nombre_mes = getNombreMes($m);
            $vacaciones["hasta_format"] = "{$d} {$nombre_mes}";
        }
        return $vacaciones;
    }

}

//END_class
?>