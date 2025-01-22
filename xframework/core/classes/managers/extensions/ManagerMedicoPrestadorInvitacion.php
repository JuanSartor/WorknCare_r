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
class ManagerMedicoPrestadorInvitacion extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "medico_prestador_invitacion", "idmedico_prestador_invitacion");
    }

    /*     * Metodo que obtiene el liostado en formato JSON de los medicos asignados a un prestador
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
        $query->setSelect("*");
        $query->setFrom("  $this->table mp  ");

        $query->setWhere("mp.prestador_idprestador={$request["idprestador"]}");

        $data = $this->getJSONList($query, array("nombre", "email", "estado"), $request, $idpaginate);

        return $data;
    }

    public function enviar_invitacion($request) {

        if ($request["nombre"] == "" || $request["apellido"] == "" || $request["email"] == "") {
            $this->setMsg(["result" => false, "msg" => "Complete los campos obligatorios"]);
            return false;
        }

        //buscamos si ya existe una cuenta con ese email
        $usuario_web = $this->getManager("ManagerUsuarioWeb")->getByField("email", $request["email"]);
        if ($usuario_web && $usuario_web["tipousuario"] == "medico") {
            $ManagerMedico = $this->getManager("ManagerMedico");
            $medico_aux = $ManagerMedico->getByField("usuarioweb_idusuarioweb", $usuario_web["idusuarioweb"]);
            $medico = $ManagerMedico->get($medico_aux["idmedico"]);
            $this->setMsg(["result" => true, "medico_existente" => 1, "idmedico" => $medico["idmedico"], "medico" => "{$medico["tituloprofesional"]} {$medico["nombre"]} {$medico["apellido"]}", "msg" => "Ya existe una cuenta registrada con el mail [[{$request["email"]}]]"]);
            return true;
        }

        //buscamos si ya se ha enviado una invitacion
        $invitacion_medico = $this->getByField("email", $request["email"]);
        if ($invitacion_medico["prestador_idprestador"] == $_SESSION[URL_ROOT][CONTROLLER]['logged_account']['user']['prestador_idprestador']) {
            $this->setMsg(["result" => false, "msg" => "El profesional tiene una invitación de registro pendiente"]);
            return false;
        }


        $request["prestador_idprestador"] = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']['user']['prestador_idprestador'];
        $this->db->StartTrans();
        $id = parent::process($request);
        if (!$id) {
            $this->db->FailTrans();
            $this->db->CompleteTrans();
            $this->setMsg(["result" => false, "msg" => "No se pudo enviar la invitación"]);
            return false;
        }



        $mEmail = $this->getManager("ManagerMail");
        $mEmail->setHTML(true);

        //ojo solo arnet local
        $mEmail->setPort("587");

        $mEmail->setSubject("WorknCare | Invitation d'inscription ");


        $smarty = SmartySingleton::getInstance();


        $request["idinvitacion"] = base64_encode($id);
        $prestador = $this->getManager("ManagerPrestador")->get($request["prestador_idprestador"]);
        $smarty->assign("prestador", $prestador);

        $smarty->assign("medico", $request);


        $mEmail->setBody($smarty->Fetch("email/invitacion_registro_medico.tpl"));


        $mEmail->addTo($request["email"]);


        //header a todos los comentarios!
        if ($mEmail->send()) {

            $this->setMsg(["result" => true, "msg" => "La invitación ha sido enviada con éxito "]);
            $this->db->CompleteTrans();

            return true;
        } else {
            $this->db->FailTrans();
            $this->db->CompleteTrans();
            $this->setMsg(["result" => false, "msg" => "No se pudo enviar la invitación"]);
            return false;
        }
    }

}
