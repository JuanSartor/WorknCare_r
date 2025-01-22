<?php

/**
 * ManagerProfesionalValoracion administra las valoraciones de los pacientes a los medicos en las consultas express
 *
 * @author lucas
 */
class ManagerProfesionalValoracion extends AbstractManager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Constructor
        parent::__construct($db, "profesionalvaloracion", "idprofesionalValoracion");
    }

    /**
     * bloqueo multiple de profesionales
     * 
     * @param type $ids
     * @param type $forced
     * @return boolean
     */
    public function processValoracion($request) {

        $paciente = $this->getManager("ManagerPaciente")->getPacienteXHeader();
        $idpaciente = $paciente["idpaciente"];

        $consulta = $this->getManager("ManagerPerfilSaludConsulta")->get($request["idperfilSaludConsulta"]);

        //Busco si hay alguna valoración del paciente al médico
        $valoracion = $this->db->getRow("select * from $this->table where paciente_idpaciente=$idpaciente and medico_idmedico=" . $consulta["medico_idmedico"]);

        if ($consulta["recomendacion"] == "1") {
            $this->setMsg([ "msg" => "Ya posee una recomendacion en esta consulta", "result" => false]);
            return false;
        }
        if ($consulta["paciente_idpaciente"] != $idpaciente) {
            $this->setMsg([ "msg" => "No se pudo recuperar la consulta", "result" => false]);
            return false;
        }
        if (!isset($request["recomendado"]) || $request["recomendado"] == "") {
            $this->setMsg([ "msg" => "Seleccione una opcion", "result" => false]);
            return false;
        }

        if ($valoracion["idprofesionalValoracion"] == "") {

            $record["medico_idmedico"] = $consulta["medico_idmedico"];
            $record["paciente_idpaciente"] = $idpaciente;
            $record["recomendado"] = $request["recomendado"];

            $this->db->StartTrans();
            $result = parent::insert($record);
            $rdo1 = $this->getManager("ManagerPerfilSaludConsulta")->update(["recomendacion" => 1], $consulta["idperfilSaludConsulta"]);
            if ($result && $rdo1) {

                //Actualizo las cantidad de recomendaciones y de estrellas
                $ManagerMedico = $this->getManager("ManagerMedico");
                $ManagerMedico->updateCantidadRecomendacion($consulta["medico_idmedico"]);


                $this->setMsg([ "msg" => "Se ha guardado su recomendación", "result" => true]);

                $this->db->CompleteTrans();
                return true;
            } else {
                $this->setMsg([ "msg" => "No se ha podido guardar su recomendacion", "result" => false]);
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                return false;
            }
        } else {


            $record["recomendado"] = $request["recomendado"];

            //Actualizo las cantidad de recomendaciones y de estrellas
            $ManagerMedico = $this->getManager("ManagerMedico");
            $ManagerMedico->updateCantidadRecomendacion($consulta["medico_idmedico"]);


            $this->db->StartTrans();
            $result = parent::update($record, $valoracion["idprofesionalValoracion"]);
            $rdo1 = $this->getManager("ManagerPerfilSaludConsulta")->update(["recomendacion" => 1], $consulta["idperfilSaludConsulta"]);

            if ($result && $rdo1) {
                $this->setMsg([ "msg" => "Se ha guardado su recomendación", "result" => true]);

                $this->db->CompleteTrans();
                return true;
            } else {
                $this->setMsg([ "msg" => "No se ha podido guardar su recomendacion", "result" => false]);
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                return false;
            }
        }
    }

    /**
     *  Metodo que devuelve la cantidad de recomendaciones de un medico
     * @param type $idmedico
     * @return type
     */
    public function getCantidadRecomendaciones($idmedico) {
        $query = new AbstractSql();
        $query->setSelect("cantidad_recomendaciones as qty ");
        $query->setFrom("medico");
        $query->setWhere("idmedico={$idmedico}");

        $rs = $this->db->getRow($query->getSql());

        return $rs["qty"];
    }

    /*     * Metodo que retorna la cantidad de estrellas del medico segun las recomendaciones
     * 
     * @param type $idmedico
     */

    public function getCantidadEstrellas($idmedico) {

        $query = new AbstractSql();
        $query->setSelect("cantidad_estrellas as qty ");
        $query->setFrom("medico");
        $query->setWhere("idmedico={$idmedico}");

        $rs = $this->db->getRow($query->getSql());

        return (int) $rs["qty"];
    }

    /* Metodo que devuelve la recomendacion de un paciente a un medico
     * 
     */

    public function getRecomendacion($idmedico, $idpaciente) {

        $query = new AbstractSql();
        $query->setSelect("recomendado");
        $query->setFrom("$this->table");
        $query->setWhere("medico_idmedico=$idmedico and paciente_idpaciente=$idpaciente");
        $rdo = $this->db->getRow($query->getSql());
        return $rdo["recomendado"];
    }

}
