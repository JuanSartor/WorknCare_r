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
class ManagerMedicoPrestador extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "medico_prestador", "idmedico_prestador");
    }

    /*     * Metodo que obtiene el listado en formato JSON de los medicos invitados por un prestador que aun no forman parte de su lista
     * 
     * @param type $idpaginate
     * @param type $request
     * @return type
     */

    public function getListadoInvitacionesJSON($request, $idpaginate = NULL) {

        if ($_SESSION[URL_ROOT][CONTROLLER]['logged_account']['user']['idusuario_prestador'] != "") {
            $request["idprestador"] = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']['user']['prestador_idprestador'];
        }
        if ($request["idprestador"] == "") {
            return false;
        }
        if (!is_null($idpaginate)) {
            $this->paginate($idpaginate, 50);
        }
//buscamos los medicos agregados de doctorplus que no han aceptado
        $query1 = new AbstractSql();
        $query1->setSelect("CONCAT(tp.titulo_profesional,' ', uw.nombre,' ',uw.apellido) as nombre,m.CUIT,uw.email,'Médico en DoctorPlus' as tipo,
            CASE mp.estado
            WHEN 0 THEN 'Pendiente'
            WHEN 1 THEN 'Aceptado'
            WHEN 2 THEN 'Rechazado'
            END as estado                  
                
            ");
        $query1->setFrom("
                $this->table mp inner join medico m ON (mp.medico_idmedico=m.idmedico)
                    inner join usuarioweb uw ON (m.usuarioweb_idusuarioweb=uw.idusuarioweb)
                    LEFT JOIN titulo_profesional tp ON (m.titulo_profesional_idtitulo_profesional=tp.idtitulo_profesional)
            ");



        $query1->setWhere("mp.prestador_idprestador={$request["idprestador"]} AND mp.estado<>1");
        //buscamos los medicos invitados que aun no han creado cuenta

        $query2 = new AbstractSql();
        $query2->setSelect("CONCAT(mpi.nombre,' ',mpi.apellido) as nombre, '' as CUIT,mpi.email,'Invitación' as tipo, 'Pendiente' as estado                  
                
            ");
        $query2->setFrom("medico_prestador_invitacion mpi
                
            ");
        $query2->setWhere("mpi.prestador_idprestador={$request["idprestador"]}");
        $query2->addAnd("mpi.medico_idmedico is null");

        $query = new AbstractSql();
        $query->setSelect("(@idmedico_prestador :=@idmedico_prestador + 1) AS idmedico_prestador,t.*");
        $query->setFrom("((" . $query1->getSql() . ")" .
                "UNION" .
                "(" . $query2->getSql() . ")) as t, (SELECT @idmedico_prestador:= 0) AS idmedico_prestador ");


        if (isset($request["busqueda"]) && $request["busqueda"] != "") {


            $rdo = cleanQuery($request["busqueda"]);

            $query->addAnd("((t.nombre LIKE '%$rdo%') OR (t.apellido LIKE '%$rdo%') OR (t.email LIKE '%$rdo%'))");
        }

        $query->setOrderBy("t.apellido ASC");

        $data = $this->getJSONList($query, array("nombre", "CUIT", "email", "tipo", "estado"), $request, $idpaginate);

        return $data;
    }

    /*     * Metodo que obtiene el listado en formato JSON de los medicos agregados por un prestador
     * 
     * @param type $idpaginate
     * @param type $request
     * @return type
     */

    public function getListadoJSON($request, $idpaginate = NULL) {

        if ($_SESSION[URL_ROOT][CONTROLLER]['logged_account']['user']['idusuario_prestador'] != "") {
            $request["idprestador"] = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']['user']['prestador_idprestador'];
        }
        if ($request["idprestador"] == "") {
            return false;
        }
        if (!is_null($idpaginate)) {
            $this->paginate($idpaginate, 50);
        }

        $query = new AbstractSql();
        $query->setSelect("{$this->id},
            CONCAT(tp.titulo_profesional,' ', uw.nombre,' ',uw.apellido) as nombre,
            m.CUIT,
            uw.email,
            m.numeroCelular,
            m.idmedico,
            esp.especialidad,
            case mp.estado
            WHEN 0 THEN 'Pendiente'
            WHEN 1 THEN 'Aceptado'
            WHEN 2 THEN 'Rechazado' 
            END as estado
                
            ");
        $query->setFrom("
                $this->table mp inner join medico m ON (mp.medico_idmedico=m.idmedico)
                    inner join usuarioweb uw ON (m.usuarioweb_idusuarioweb=uw.idusuarioweb)
                    LEFT JOIN titulo_profesional tp ON (m.titulo_profesional_idtitulo_profesional=tp.idtitulo_profesional)
                    LEFT JOIN especialidadmedico em ON (em.medico_idmedico=m.idmedico)
                    LEFT JOIN especialidad esp ON (esp.idespecialidad=em.especialidad_idespecialidad)
            ");

        $query->setWhere("mp.prestador_idprestador={$request["idprestador"]}");
        //al prestador solo les mostramos los medicos aceptados
        if ($_SESSION[URL_ROOT][CONTROLLER]['logged_account']['user']['idusuario_prestador'] != "") {
            $query->addAnd("mp.estado=1");
        }

        if (isset($request["busqueda"]) && $request["busqueda"] != "") {


            $rdo = cleanQuery($request["busqueda"]);

            $query->addAnd("((uw.nombre LIKE '%$rdo%') OR (uw.apellido LIKE '%$rdo%') OR (uw.email LIKE '%$rdo%'))");
        }

        if (isset($request["especialidad_idespecialidad"]) && $request["especialidad_idespecialidad"] != "") {
            $esp = cleanQuery($request["especialidad_idespecialidad"]);
            $query->addAnd("em.especialidad_idespecialidad={$esp}");
        }
        if (isset($request["subEspecialidad_idsubEspecialidad"]) && $request["subEspecialidad_idsubEspecialidad"] != "") {
            $subesp = cleanQuery($request["subEspecialidad_idsubEspecialidad"]);
            $query->addAnd("em.subEspecialidad_idsubEspecialidad={$subesp}");
        }
        $query->setGroupBy("m.idmedico");
        $query->setOrderBy("uw.apellido ASC");

        $data = $this->getJSONList($query, array("nombre", "CUIT", "email", "numeroCelular", "idmedico", "especialidad", "estado"), $request, $idpaginate);

        return $data;
    }

    /*     * Metodo que obtiene el liostado en formato JSON de los medicos que no estan asignados asignados a un prestador
     * 
     * @param type $idpaginate
     * @param type $request
     * @return type
     */

    public function getListadoMedicosJSON($request, $idpaginate = NULL) {

       
        if ($_SESSION[URL_ROOT][CONTROLLER]['logged_account']['user']['idusuario_prestador'] != "") {
            $request["idprestador"] = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']['user']['prestador_idprestador'];
        }
        if (!is_null($idpaginate)) {
            $this->paginate($idpaginate, 50);
        }

        $query = new AbstractSql();
        $query->setSelect("m.idmedico as {$this->id},CONCAT(tp.titulo_profesional,' ', uw.nombre,' ',uw.apellido) as nombre, esp.especialidad,uw.email
                
            ");
        $query->setFrom("
                medico m 
                    inner join usuarioweb uw ON (m.usuarioweb_idusuarioweb=uw.idusuarioweb)
                    LEFT JOIN titulo_profesional tp ON (m.titulo_profesional_idtitulo_profesional=tp.idtitulo_profesional)
                    LEFT JOIN especialidadmedico em ON (em.medico_idmedico=m.idmedico)
                     LEFT JOIN especialidad esp ON (esp.idespecialidad=em.especialidad_idespecialidad)
            ");



        $query->setWhere("m.idmedico not in (select medico_idmedico from {$this->table} where prestador_idprestador = {$request["idprestador"]})");
        if (isset($request["busqueda"]) && $request["busqueda"] != "") {


            $rdo = cleanQuery($request["busqueda"]);

            $query->addAnd("((uw.nombre LIKE '%$rdo%') OR (uw.apellido LIKE '%$rdo%') OR (uw.email LIKE '%$rdo%'))");
        }

        if (isset($request["especialidad_idespecialidad"]) && $request["especialidad_idespecialidad"] != "") {
            $esp = cleanQuery($request["especialidad_idespecialidad"]);
            $query->addAnd("em.especialidad_idespecialidad={$esp}");
        }
        if (isset($request["subEspecialidad_idsubEspecialidad"]) && $request["subEspecialidad_idsubEspecialidad"] != "") {
            $subesp = cleanQuery($request["subEspecialidad_idsubEspecialidad"]);
            $query->addAnd("em.subEspecialidad_idsubEspecialidad={$subesp}");
        }


        $query->setGroupBy("m.idmedico");
        $query->setOrderBy("uw.apellido ASC");

        $data = $this->getJSONList($query, array("nombre", "especialidad", "email"), $request, $idpaginate);

        return $data;
    }

    public function process($request) {
        if ($_SESSION[URL_ROOT][CONTROLLER]['logged_account']['user']['idusuario_prestador'] != "") {
            $request["idprestador"] = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']['user']['prestador_idprestador'];
        }
        if ($request["idprestador"] == "") {
            $this->setMsg(["msg" => "Error. No se pudo recuperar el prestador", "result" => false]);
            return false;
        }


        $ids_medicos = explode(',', $request["ids"]);

        if (count($ids_medicos) == 0) {
            $this->setMsg(["msg" => "Seleccione al menos un profesional", "result" => false]);
            return false;
        }

        $this->db->StartTrans();
        $ManagerNotificacion = $this->getManager("ManagerNotificacion");
        foreach ($ids_medicos as $idmedico) {
            /* if ($_SESSION[URL_ROOT][CONTROLLER]['logged_account']['user']['idusuario_prestador'] == "") {
              $record["estado"] = 1;
              } */
            $record["estado"] = 1;
            $record["medico_idmedico"] = $idmedico;
            $record["prestador_idprestador"] = $request["idprestador"];
            $exist = $this->getByFieldArray(["medico_idmedico", "prestador_idprestador"], [$idmedico, $request["idprestador"]]);
            if ($exist) {
                $this->setMsg(["msg" => "Error. El profesional seleccionado ya se encuentra asignado", "result" => false]);
                return false;
            }
            $rdo = parent::insert($record);

            $notificacion = $ManagerNotificacion->processNotificacionPrestadorInvitacionMedico($record);
            if (!$rdo || !$notificacion) {
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                $this->setMsg(["msg" => "Error. No se pudo agregar el profesional", "result" => false]);
                return false;
            }
        }
        $this->db->CompleteTrans();
        $this->setMsg(["msg" => "Se ha notificado a los profesionales seleccionados.", "result" => true]);
        return true;
    }

    /*     * Metodo que procesa la respuesta del medico ante la invitacion de agregarlo como medico de un prestador y cambia el estado de la invitacion
     * 
     * @param type $request
     */

    public function respuesta_invitacion_prestador($request) {
        $medico_prestador = $this->getByFieldArray(["prestador_idprestador", "medico_idmedico"], [$request["idprestador"], $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"]]);

        if (!$medico_prestador) {
            $this->setMsg(["msg" => "Error. No se pudo recuperar la invitación", "result" => false]);
            return false;
        }

        if ($medico_prestador["estado"] == 1) {
            $this->setMsg(["msg" => "Ud. ya ha aceptado esta invitación.", "result" => false]);
            return false;
        }

        if ($medico_prestador["estado"] == 2) {
            $this->setMsg(["msg" => "Ud. ya ha rechazado esta invitación.", "result" => false]);
            return false;
        }

        $upd = parent::update(["estado" => $request["estado"]], $medico_prestador["idmedico_prestador"]);
        if ($upd) {
            $this->setMsg(["msg" => "Su respuesta ha sido procesada con éxito", "result" => true]);
            return true;
        } else {
            $this->setMsg(["msg" => "Error. No se pudo procesar la respuesta", "result" => false]);
            return false;
        }
    }

    /**
     * Metodo mediante el cual un medico se agrega como profesional de un prestador  
     * @return boolean
     */
    public function agregar_prestador_from_medico() {
        $record["medico_idmedico"] = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];
        $record["prestador_idprestador"] = ISIC_ID;
        $record["estado"] = 0;
        $exist = $this->getByFieldArray(["medico_idmedico", "prestador_idprestador"], [$record["medico_idmedico"], $record["prestador_idprestador"]]);
        if ($exist) {
            $this->setMsg(["msg" => "Ud. ya se encuentra asociado a ISIC", "result" => false]);
            return false;
        }
        $rdo = parent::insert($record);
        if ($rdo) {
            $medico = $this->getManager("ManagerMedico")->get($_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"]);
            $smarty = SmartySingleton::getInstance();
            $smarty->assign("medico", $medico);

            $mEmail = $this->getManager("ManagerMail");
            $mEmail->setHTML(true);
            $mEmail->setBody($smarty->Fetch("email/nuevo_medico_prestador.tpl"));
            $mEmail->setSubject(sprintf("WorknCare | %s %s %s a accepté l'accord", $medico["tituloprofesional"], $medico["nombre"], $medico["apellido"]));

            $mEmail->setFromName($medico["nombre"] . " " . $medico["apellido"]);
            $mEmail->AddReplyTo($medico["email"], $medico["tituloprofesional"] . " " . $medico["nombre"] . " " . $medico["apellido"]);

            $mEmail->addTo(DEFAULT_CONTACT_EMAIL);


            //ojo solo arnet local
            $mEmail->setPort("587");

            $mEmail->send();

            $this->setMsg(["msg" => "Ha sido vinculado a ISIC con éxito", "result" => true, "id" => $rdo]);
            return true;
        } else {
            $this->setMsg(["msg" => "Ha ocurrido un error al vincular su cuenta a ISIC", "result" => false]);
            return false;
        }
    }

    /**
     * Metodo que elimina la relacion entre el medico y el prestador
     * @param type $id
     * @return boolean
     */
    public function eliminar_relacion_prestador_from_medico($id) {
        $relacion = parent::get($id);

        if ($relacion["medico_idmedico"] != $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"]) {
            $this->setMsg(["msg" => "Ha ocurrido un error al eliminar su ascociación a ISIC", "result" => false]);
            return false;
        }
        $rdo = parent::delete($id, true);
        if ($rdo) {
            $this->setMsg(["msg" => "Ha sido desviculado como profesional de ISIC con éxito", "result" => true]);
            return true;
        } else {
            $this->setMsg(["msg" => "Ha ocurrido un error al desvicular su cuenta de ISIC", "result" => false]);
            return false;
        }
    }

}
