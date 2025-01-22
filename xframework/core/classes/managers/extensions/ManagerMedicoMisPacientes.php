<?php

/**
 * 	@autor Xinergia
 * 	@version 1.0	29/05/2014
 * 	Manager que contiene la asociación de los médicos y pacientes 
 *      Un paciente pertenece a Mis Paciente cuando saca un turno, VC o CE para que el medico pueda acceder a su perfil de salud y visualizarlo
 */
class ManagerMedicoMisPacientes extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "medicomispacientes", "idmedicoMedicosMisPacientes");
    }

    public function process($request) {

        $request["medico_idmedico"] = CONTROLLER == "medico" ? $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"] : $request["medico_idmedico"];

        if ($request["medico_idmedico"] == "" || $request["paciente_idpaciente"] == "") {
            $this->setMsg([
                "msg" => "Error. No se pudo crear la relación entre medico y mis pacientes",
                "result" => false
            ]);

            return false;
        }

        return parent::process($request);
    }

    /**
     * Obtiene la relación entre médico y paciente
     * @param type $idmedico
     * @param type $idpaciente
     */
    public function getRelacion($idmedico, $idpaciente) {
        $query = new AbstractSql();

        $query->setSelect("*");

        $query->setFrom("$this->table");

        $query->setWhere("medico_idmedico = $idmedico");

        $query->addAnd("paciente_idpaciente = $idpaciente");

        $execute = $this->db->Execute($query->getSql());

        if ($execute) {
            return $execute->FetchRow();
        } else {
            return false;
        }
    }

    /*     * Metodo que inserta un registro de paciente  al listado de Mis  Pacientes
     * Un paciente pertenece a Mis Paciente cuando saca un turno, VC o CE para que el medico pueda acceder a su perfil de salud y visualizarlo
     * @param type $record
     * @return boolean
     */

    public function insert($record) {

        $rdo = $this->getRelacion($record["medico_idmedico"], $record["paciente_idpaciente"]);


        if ($rdo) {
            //Si hay resultado, quiere decir que ya se encuentra la relación entre el médico y el paciente
            return true;
        } else {
            $this->db->StartTrans();
            $insert = parent::insert($record);
            $insert_prof_frecuentes = $this->getManager("ManagerProfesionalesFrecuentesPacientes")->insert($record);

            if ($insert && $insert_prof_frecuentes) {
                $this->getManager("ManagerMedicoPacienteInvitacion")->verificar_invitacion_pendiente($record["medico_idmedico"], $record["paciente_idpaciente"]);

                $this->db->CompleteTrans();
                return true;
            } else {
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                return false;
            }
        }
    }

    /**
     * Listado paginado a mis pacientes
     * @param array $request
     * @param type $idpaginate
     */
    public function getListadoPaginadoMisPacientes($request, $idpaginate, $sin_cargo = false) {

        if (isset($request["do_reset"]) && $request["do_reset"] == 1) {
            $this->resetPaginate($idpaginate);
        }

        if (!is_null($idpaginate)) {
            $this->paginate($idpaginate, 10);
        }

        $idmedico = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];

        //Seteo el current page
        $request["current_page"] = $request["current_page"] != "" ? $request["current_page"] : 1;
        SmartyPaginate::setCurrentPage($request["current_page"], $idpaginate);

        $query = new AbstractSql();

        $query->setSelect("t.*");

        $query->setFrom("(
        
                            (   SELECT u.nombre, 
                                        u.apellido,
                                        p.DNI,
                                        p.tarjeta_vitale,
                                        p.tarjeta_cns,
                                        p.tarjeta_eID,
                                        p.tarjeta_pasaporte,
                                        p.trabaja_otro_pais,
                                        p.pais_idpais,
                                        p.pais_idpais_trabajo,
                                        p.beneficios_reintegro,
                                        p.beneficia_ald,
                                        p.fechaNacimiento, 
                                        p.estado, 
                                        p.active, 
                                        IF(p.celularValido = 1, p.numeroCelular, ' - ' ) as numeroCelular, 
                                        p.caracteristicaCelular, 
                                        u.sexo, 
                                        0 as animal,
                                        mmp.medico_idmedico,
                                        p.idpaciente,
                                        '' as estado_solicitud,
                                        u.email,
                                        '0' as idmedico_paciente_invitacion,
                                        '' as ultimoenvio,
                                        mmp.sin_cargo
                                FROM medicomispacientes mmp 
                                    INNER JOIN paciente p ON (mmp.paciente_idpaciente = p.idpaciente) 
                                    INNER JOIN usuarioweb u ON (p.usuarioweb_idusuarioweb = u.idusuarioweb) 
                                WHERE mmp.medico_idmedico = $idmedico
                            )
                        UNION
                            ( SELECT pf.nombre, 
                                        pf.apellido, 
                                        pf.DNI,
                                        pf.tarjeta_vitale,
                                        pf.tarjeta_cns,
                                        pf.tarjeta_eID,
                                        pf.tarjeta_pasaporte,
                                        pf.trabaja_otro_pais,
                                        pf.pais_idpais,
                                        '' as pais_idpais_trabajo,
                                        '' as beneficios_reintegro,
                                        '' as beneficia_ald,
                                        p.fechaNacimiento, 
                                        p.estado, 
                                        p.active, 
                                        IF(p.celularValido = 1, p.numeroCelular, ' - ' ) as numeroCelular, 
                                        p.caracteristicaCelular, 
                                        pf.sexo, 
                                        pf.animal, 
                                        mmp.medico_idmedico,
                                        p.idpaciente,
                                        '' as estado_solicitud,
                                        '' as email,
                                        '0' as idmedico_paciente_invitacion,
                                        '' as ultimoenvio,
                                        mmp.sin_cargo
                                FROM medicomispacientes mmp 
                                    INNER JOIN paciente p ON (mmp.paciente_idpaciente = p.idpaciente) 
                                    INNER JOIN pacientegrupofamiliar pf ON (p.idpaciente = pf.pacienteGrupo)  
                                WHERE mmp.medico_idmedico = $idmedico
                            ) 
                        UNION
                        (SELECT u.nombre, 
                                        u.apellido, 
                                        p.DNI,
                                        p.tarjeta_vitale,
                                        p.tarjeta_cns,
                                        p.tarjeta_eID,
                                        p.tarjeta_pasaporte,
                                        p.trabaja_otro_pais,
                                        p.pais_idpais,
                                        p.pais_idpais_trabajo,
                                        p.beneficios_reintegro,
                                        p.beneficia_ald,
                                        p.fechaNacimiento, 
                                        p.estado,
                                        p.active, 
                                        IF(p.celularValido = 1, p.numeroCelular, ' - ' ) as numeroCelular, 
                                        p.caracteristicaCelular, 
                                        u.sexo, 
                                        0 as animal,
                                        mpi.medico_idmedico, 
                                        p.idpaciente,
                                        mpi.estado as estado_solicitud,
                                        u.email,
                                        mpi.idmedico_paciente_invitacion,
                                        mpi.ultimoenvio,
                                        '' as sin_cargo
                                FROM medico_paciente_invitacion mpi 
                                    INNER JOIN paciente p ON (mpi.paciente_idpaciente = p.idpaciente) 
                                    INNER JOIN usuarioweb u ON (p.usuarioweb_idusuarioweb = u.idusuarioweb) 
                                WHERE mpi.medico_idmedico = $idmedico
                                        AND p.active = 1
                                        AND mpi.estado = 0
                            ) 
                        UNION 
                            (SELECT pgf.nombre, 
                                        pgf.apellido,
                                        pgf.DNI,
                                        pgf.tarjeta_vitale,
                                        pgf.tarjeta_cns,
                                        pgf.tarjeta_eID,
                                        pgf.tarjeta_pasaporte,
                                        pgf.trabaja_otro_pais,
                                        pgf.pais_idpais,
                                        '' as pais_idpais_trabajo,
                                        '' as beneficios_reintegro,
                                        p.beneficia_ald,
                                        p.fechaNacimiento, 
                                        p.estado, 
                                        p.active, 
                                        '' as numeroCelular, 
                                        '' as caracteristicaCelular, 
                                        pgf.sexo,
                                        pgf.animal,
                                        mpi.medico_idmedico, 
                                        p.idpaciente,
                                        mpi.estado as estado_solicitud,
                                        '' as email,
                                        mpi.idmedico_paciente_invitacion,
                                        mpi.ultimoenvio,
                                        '' as sin_cargo
                                FROM medico_paciente_invitacion mpi 
                                    INNER JOIN paciente p ON (mpi.paciente_idpaciente = p.idpaciente) 
                                    INNER JOIN pacientegrupofamiliar pgf ON (p.idpaciente = pgf.pacienteGrupo) 
                                WHERE mpi.medico_idmedico = $idmedico
                                        AND p.active = 1
                                        AND mpi.estado = 0
                            ) 
                        UNION 
                            (   SELECT  mpi.nombre, 
                                        mpi.apellido,
                                        mpi.DNI,
                                        '' as tarjeta_vitale,
                                        '' as tarjeta_cns,
                                        '' as tarjeta_eID,
                                        '' as tarjeta_pasaporte,
                                        '' as trabaja_otro_pais,
                                        '' as pais_idpais,
                                        '' as pais_idpais_trabajo,
                                        '' as beneficios_reintegro,
                                        '' as beneficia_ald,
                                        mpi.fechaNacimiento, 
                                        '' as estado, 
                                        '' as active, 
                                        mpi.celular as numeroCelular, 
                                        '' as caracteristicaCelular, 
                                        '' as sexo, 
                                        '' as animal,
                                        mpi.medico_idmedico, 
                                        '' as idpaciente,
                                        mpi.estado as estado_solicitud,
                                        mpi.email,
                                        mpi.idmedico_paciente_invitacion,
                                        mpi.ultimoenvio,
                                        '' as sin_cargo
                                FROM medico_paciente_invitacion mpi 
                                WHERE mpi.medico_idmedico = $idmedico
                                    AND mpi.paciente_idpaciente IS NULL
                                        AND mpi.estado = 0
                                ) 
                        
                        ) AS t
                        ");

        $query->setWhere("(t.medico_idmedico = $idmedico )");
        if ($sin_cargo) {
            $query->addAnd("t.sin_cargo=1");
        }



        if (isset($request["query_str"]) && $request["query_str"] != "") {
            $rdo = cleanQuery($request["query_str"]);
            $query->addAnd("(t.email LIKE '%$rdo%' OR CONCAT(t.nombre, ' ', t.apellido) LIKE '%$rdo%' OR t.DNI='$rdo')");
        }
        $query->setGroupBy("t.idpaciente, t.email");
        $query->setOrderBy("t.apellido ASC");

        $listado = $this->getListPaginado($query, $idpaginate);


        if ($listado["rows"] && count($listado["rows"]) > 0) {

            $ManagerPaciente = $this->getManager("ManagerPaciente");
            $ManagerProfesionalesFrecuentesPacientes = $this->getManager("ManagerProfesionalesFrecuentesPacientes");


            $calendar = new Calendar();

            foreach ($listado["rows"] as $key => $value) {

                //Tengo que formatear la fecha si es una invitación..
                if ($value["ultimoenvio"] != "") {
                    list($y, $m, $d) = preg_split("[-]", $value["ultimoenvio"]);
                    $mes = $calendar->getMonthsShort((int) $m);
                    $listado["rows"][$key]["ultimoenvio_format"] = "$d $mes $y";
                }

                //Traigo las imágenes de los pacientes
                $listado["rows"][$key]["imagenes"] = $ManagerPaciente->getImagenPaciente($value["idpaciente"]);
                $listado["rows"][$key]["imagenes_tarjeta"] = $ManagerPaciente->getImagenesIdentificacion($value["idpaciente"]);

                //Traemos el telefono del paciente o titular
                $listado["rows"][$key]["numeroCelular"] = $ManagerPaciente->getPacienteTelefono($value["idpaciente"]);

                //Si no es un paciente perteneciente a una invitación
                if ($value["estado_solicitud"] === "") {
                    //Debo buscar todos los pacientes relacionados del paciente.
                    $listado["rows"][$key]["pacientes_relacionados"] = $ManagerPaciente->getPacientesRelacionados($value["idpaciente"]);

                    //Tengo que buscar todos los profesionales frecuentes..
                    $listado["rows"][$key]["medicos_relacionados"] = $ManagerProfesionalesFrecuentesPacientes->getListadoProfesionalesFrecuentesPaciente($value["idpaciente"], $idmedico);
                }

                //Tengo que buscar la información completa del paciente
            }
            return $listado;
        }
    }

    /**
     * Método que elimina la asociación de un paciente
     * @param type $request
     * @return boolean
     */
    public function deleteAsociacion($request) {
        $idmedico = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];
        $relacion_to_delete = $this->getRelacion($idmedico, $request["id"]);

        $managerMedicoPacienteinvitacion = $this->getManager("ManagerMedicoPacienteInvitacion");
        $invitacion = $managerMedicoPacienteinvitacion->getXRelacion($idmedico, $relacion_to_delete["paciente_idpaciente"]);

        if ($invitacion["estado"] != 2) {
            $managerMedicoPacienteinvitacion->deleteAsociacion(["id" => $invitacion["idmedico_paciente_invitacion"]]);
        }

        if ($relacion_to_delete) {
            $delete = parent::delete($relacion_to_delete[$this->id], true);

            if ($delete) {
                $this->setMsg(["msg" => "El paciente seleccionado fue eliminado de 'Mis Pacientes'", "result" => true]);
                return true;
            } else {
                $this->setMsg(["msg" => "Error. No se pudo eliminar el paciente seleccionado de 'Mis Pacientes'", "result" => false]);
                return false;
            }
        } else {
            $this->setMsg(["msg" => "Error. No se encontró la relación paciente/médico en el sistema. Recargue la página", "result" => false]);
            return false;
        }
    }

    /*     * Metodo que setea o elimina a un paciente sin cargo del listado de pacientes de medico
     * flag sin_cargo=0/1;
     * @param type $request
     */

    public function actualizarPacienteSinCargo($request) {

        if ($request["id"] != "" && ($request["sin_cargo"] == "1" || $request["sin_cargo"] == "0")) {
            $idmedico = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];
            if ($request["sin_cargo"] == "1") {
                $cantidad = $this->getCantidadPacientesSinCargo($idmedico);

                if ((int) $cantidad > 50) {

                    $this->setMsg(["result" => false, "msg" => "Ya ha superado la cantidad maxima de pacientes sin cargo"]);
                    return false;
                }
            }
            $relacion = $this->getRelacion($idmedico, $request["id"]);
            $rdo = parent::update(["sin_cargo" => $request["sin_cargo"]], $relacion["$this->id"]);
            if ($rdo) {
                if ($request["sin_cargo"] == "1") {

                    $this->setMsg(["result" => true, "msg" => "El paciente ha sido agregado a su lista sin cargo"]);
                } else {

                    $this->setMsg(["result" => true, "msg" => "El paciente ha sido eliminado de su lista sin cargo"]);
                }

                return true;
            } else {
                $this->setMsg(["result" => false, "msg" => "Error. No se pudo actualizar el listado de pacientes sin cargo"]);
                return false;
            }
        } else {
            $this->setMsg(["result" => false, "msg" => "Error. No se pudo recuperar el paciente seleccionado"]);
            return false;
        }
    }

    /* Metodo que retorna verdadero/falso si el paciente corresponde a un paciente sin cargo seleccionado por el medico 
     * 
     */

    public function is_paciente_sin_cargo($idpaciente, $idmedico) {

        $rdo = $this->db->getRow("select count(*)as qty from $this->table mmp inner JOIN medico m on (m.idmedico=mmp.medico_idmedico) where mmp.medico_idmedico=$idmedico and mmp.paciente_idpaciente=$idpaciente and mmp.sin_cargo=1 and m.planProfesional=1");

        if ((int) $rdo["qty"] > 0) {
            return true;
        } else {
            return false;
        }
    }

    /*     * Metodo que retorna el listado de idmedicos que tienen al paciente sin cargo concatenados en formato de string
     * 
     * @param type $idpaciente
     */

    public function getProfesionalesSinCargo($idpaciente) {
        $list = $this->getListadoProfesionalesSinCargo($idpaciente);
        $result = "";
        foreach ($list as $medico) {
            $result = $result . "," . $medico["medico_idmedico"];
        }

        $rdo = substr($result, 1);

        return $rdo;
    }

    /* Metodo que devuelve un array de idmedico que tienen al paciente sin cargo
     * 
     */

    public function getListadoProfesionalesSinCargo($idpaciente) {
        $query = new AbstractSql();
        $query->setSelect("medico_idmedico");
        $query->setFrom("$this->table");
        $query->setWhere("paciente_idpaciente=$idpaciente and sin_cargo=1");

        $rdo = $this->getList($query);

        return $rdo;
    }

    /*     * Metodo que retorn al cuenta de listado de pacientes sin cargo que tiene un medico
     * 
     * @param type $idmedico
     * @param type $idpaciente
     * @return boolean
     */

    public function getCantidadPacientesSinCargo($idmedico) {
        $query = new AbstractSql();

        $query->setSelect("count(*) as qty");

        $query->setFrom("$this->table");

        $query->setWhere("medico_idmedico = $idmedico");

        $query->addAnd("sin_cargo=1");

        $execute = $this->db->Execute($query->getSql());

        if ($execute) {
            $rdo = $execute->FetchRow();

            return $rdo["qty"];
        } else {
            return false;
        }
    }

}

//END_class
?>