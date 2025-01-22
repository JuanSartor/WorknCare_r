<?php

/**
 * 	@autor Juan Sartor
 * 	@version 	01/10/2021
 * 	Manager de Medicos referentes de Programas de salud grupo asociacion.
 *
 */
class ManagerPreguntaAbierta extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    public function __construct($db) {

// Llamamos al constructor del a superclase
        parent::__construct($db, "preguntas_abiertas", "idpregunta_abierta_cuestionario");
    }

    public function process($request) {

        return parent::process($request);
    }

    public function insertPregAbierta($request) {

        $rdo = parent::process($request);
        if ($rdo) {
            $this->setMsg(["result" => true, "msg" => "Pregunta agregada correctamente.", "idcuestionario" => $request["cuestionario_idcuestionario"]]);
            return true;
        } else {
            $this->setMsg(["result" => false, "msg" => "No se pudo agregar la pregunta."]);
            return false;
        }
    }

    public function getListadoPreguntas($request, $idpaginate = null) {

        $query = new AbstractSql();
        $query->setSelect("t.*");
        $query->setFrom(" $this->table  t");
        $query->setWhere("t.cuestionario_idcuestionario=" . $request["cuestionario_idcuestionario"]);
        $query->setOrderBy("t.idpregunta_abierta_cuestionario ASC");
        $preguntas_abiertas = $this->getList($query);
        foreach ($preguntas_abiertas as $key => $value) {
            $preguntas_abiertas[$key]["cerrada"] = false;
        }
        return $preguntas_abiertas;
    }

    public function insertUnaPregunta($request) {
        $rdo = parent::process($request);
        if ($rdo) {
            $this->setMsg(["result" => true, "msg" => "Pregunta agregada correctamente.", "idcuestionarionuevo" => $request["cuestionario_idcuestionario"]]);
            return true;
        } else {
            $this->setMsg(["result" => false, "msg" => "No se pudo agregar la pregunta."]);
            return false;
        }
    }

    public function eliminarUnaPregunta($request) {
        $rdo = parent::delete($request["idpregunta_abierta_cuestionario"]);
        if ($rdo) {
            $this->setMsg(["result" => true, "msg" => "Pregunta eliminada correctamente.", "idcuestionarionuevo" => $request["cuestionarios_idcuestionario"]]);
            return true;
        } else {
            $this->setMsg(["result" => false, "msg" => "No se pudo eliminar pregunta."]);
            return false;
        }
    }

    public function update($request, $id) {
        $rdo = parent::update($request, $id);
        if ($rdo) {
            $this->setMsg(["result" => true, "msg" => "Pregunta actualizada.", "idcuestionario" => $request["idcuestionario"]]);
            return true;
        } else {
            $this->setMsg(["result" => false, "msg" => "No se pudo actualizar la pregunta."]);
            return false;
        }
    }

    public function getCantidadPreguntas($request) {
        $query = new AbstractSql();
        $query->setSelect("COUNT(*) as cantidad");
        $query->setFrom("$this->table ");
        $query->setWhere("cuestionarios_idcuestionario=" . $request);
        return $this->db->GetRow($query->getSql());
    }

}

//END_class


