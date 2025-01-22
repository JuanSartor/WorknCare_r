<?php

/**
 * 	@autor Juan Sartor
 * 	@version 1.0	27/12/2021
 * 	Manager de Reembolsos
 *
 */
class ManagerReembolso extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "reembolsos", "idReembolso");
    }

    /**
     * Metodo que carga el reembolso y llama al metodo para cargar los archivos adjuntos
     */
    public function cargarReembolso($request) {
        //$this->debug();
        $requesInsert["iban"] = $request["ibanForm2"];
        $requesInsert["usuarioWeb_idusuarioweb"] = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idusuarioweb"];
        $requesInsert["fecha_en_curso"] = date("Y-m-d H:i:s");

        // aumento el valor de cant_videoconsulta porque realizar un reembolso
        $idpaciente_empresa = $_SESSION[URL_ROOT]["paciente_p"]['logged_account']["paciente"]["idpaciente_empresa"];
        $managerPacienteEmpresa = $this->getManager("ManagerPacienteEmpresa");
        $rdoDescuento = $managerPacienteEmpresa->aumentarReembolso($idpaciente_empresa);

        //inserto el nuevo reembolso
        $rdo = parent::insert($requesInsert);
        if ($rdo && $rdoDescuento) {

            $ultimoRegistro = $this->getLatest("1");
            $request["reembolsos_idReembolso"] = $ultimoRegistro[0]["idReembolso"];
            $request["usuarioWeb_idusuarioweb"] = $ultimoRegistro[0]["usuarioWeb_idusuarioweb"];

            //inserto el movimiento en movimientocuenta del reembolso
            $ManagerMovimientoCuenta = $this->getManager("ManagerMovimientoCuenta");
            $ManagerMovimientoCuenta->cargarMovimientoReembolso($request);

            // llamo al manager para insertar todos los archivos adjuntos
            $ManagerArchivosReembolso = $this->getManager("ManagerArchivosReembolsoBeneficiario");
            $result = $ManagerArchivosReembolso->processAllFiles($request);

            if ($result) {
                $this->setMsg(["msg" => "Exito. Se han cargado los archivos correctamente", "result" => true]);
                return true;
            } else {
                $this->setMsg(["msg" => "Error. No se pudo cargar los archivos", "result" => false]);
                return false;
            }
        } else {
            $this->setMsg(["msg" => "Error. No se pudo cargar el reembolso", "result" => false]);
            return false;
        }
    }

    /**
     *  obtengo todos los reembolsos no eliminados
     * 
     * @param type $idusuarioweb
     * @return type
     */
    public function getReembolsos($idusuarioweb) {
        $query = new AbstractSql();
        $query->setSelect("
                *
            ");
        $query->setFrom("
                $this->table 
            ");
        $query->setWhere("usuarioWeb_idusuarioweb=$idusuarioweb");
        $query->addAnd("eliminado =0");
        $listado = $this->getList($query);
        return $listado;
    }

    /**
     *  obtengo la cantidad de estados que existen
     */
    public function getCantEstados($idusuarioweb) {
        $query = new AbstractSql();
        $query->setSelect("estado, COUNT(*) as cantidad ");
        $query->setFrom("
                $this->table 
            ");
        $query->setWhere("usuarioWeb_idusuarioweb=$idusuarioweb");
        $query->addAnd("eliminado =0");
        $query->setGroupBy("estado");
        $listado = $this->getList($query);
        return $listado;
    }

    /**
     *  envio de mail a soporte desde el reembolso
     */
    public function enviarMailASoporte($request) {

        $mEmail = $this->getManager("ManagerMail");
        $mEmail->setHTML(false);

        $mEmail->setSubject("DoctorPlus | Reembolso");

        $mEmail->setBody("ID Reembolso: " . $request["idReembolso"] . "<br>Estado: " . $request["estado"]
                . "<hr><br>"
                . $request["textarea"] . "<br><br>"
                . "Responder a: " . $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["email"]
                . "<hr>");
        $mEmail->addTo("support@workncare.io");

        if ($mEmail->send()) {
            $this->setMsg(array("result" => true, "msg" => "Se envio el mensaje"));
            return true;
        } else {
            $this->setMsg(array("result" => false, "msg" => "No se pudo enviar el mensaje"));
            return false;
        }
    }

    /**
     *  metodo para obtener listado de reembolsos para xadmin
     * 
     */
    public function getListadoReembolsosJSON($request, $idpaginate = NULL) {
        // $this->debug();

        if (!is_null($idpaginate)) {
            $this->paginate($idpaginate, 50);
        }
        $query = new AbstractSql();
        $query->setSelect("r.idReembolso,r.iban as iban, 
            CONCAT( u.nombre,' ',u.apellido) as nombre, 
            e.empresa as empresa, ps.programa_salud as programa,
            CASE r.estado
                           WHEN  0 THEN 'En curso'
                           WHEN  1 THEN 'Efectuado'
                           WHEN  2 THEN 'Rechazado'
                           END as estado
                           ");

        $query->setFrom("reembolsos r 
            INNER JOIN usuarioweb u ON(r.usuarioWeb_idusuarioweb=u.idusuarioweb)
            INNER JOIN programa_salud ps ON(r.programaSalud_idprogramasalud=ps.idprograma_salud)
            INNER JOIN paciente pa ON(pa.usuarioweb_idusuarioweb=r.usuarioWeb_idusuarioweb)
            INNER JOIN paciente_empresa pe ON(pa.idpaciente = pe.paciente_idpaciente)
            INNER JOIN empresa e ON(e.idempresa = pe.empresa_idempresa)");

        $query->setWhere("r.eliminado = 0");

        // Filtro

        if ($request["nombre_programa"] != "") {

            $nombre_programa = cleanQuery($request["nombre_programa"]);

            $query->addAnd("ps.descripcion LIKE '%$nombre_programa%'");
        }
        if ($request["nombre_beneficiario"] != "") {

            $nombre_beneficiario = cleanQuery($request["nombre_beneficiario"]);

            $query->addAnd("u.nombre LIKE '%$nombre_beneficiario%'");
        }
        if ($request["apellido_beneficiario"] != "") {

            $apellido_beneficiario = cleanQuery($request["apellido_beneficiario"]);

            $query->addAnd("u.nombre LIKE '%$apellido_beneficiario%'");
        }
        if ($request["iban"] != "") {

            $iban = cleanQuery($request["iban"]);

            $query->addAnd("r.iban LIKE '%$iban%'");
        }
        if ($request["empresa"] != "") {

            $empresa = cleanQuery($request["empresa"]);

            $query->addAnd("e.empresa LIKE '%$empresa%'");
        }
        if ($request["estado"] != "") {

            $estado = cleanQuery($request["estado"]);

            $query->addAnd("r.estado = '$estado'");
        }

        $data = $this->getJSONList($query, array("programa", "nombre", "iban",
            "empresa", "estado"), $request, $idpaginate);

        return $data;
    }

    /**
     *   metodo que actualiza los campos de validacion del reembolso
     * @param type $request
     * @return type boolean
     */
    public function validarReembolso($request) {
        $hoy = date("Y-m-d H:i:s");
        // aca ingresa si el reembolso fue cancelado
        if ($request["motivo"] != '') {
            // disminuyo el valor de cant_videoconsulta porque se cancelo el reembolso
            $idpaciente_empresa = $_SESSION[URL_ROOT]["paciente_p"]['logged_account']["paciente"]["idpaciente_empresa"];
            $managerPacienteEmpresa = $this->getManager("ManagerPacienteEmpresa");
            $managerPacienteEmpresa->descontarReembolso($idpaciente_empresa);

            //inserto el movimiento en movimientocuenta del reembolso que ha sido rechazado
            $request["rechazarreembolso"] = 1;
            $ManagerMovimientoCuenta = $this->getManager("ManagerMovimientoCuenta");
            $ManagerMovimientoCuenta->cargarMovimientoReembolso($request);

            $actualizar["comentario"] = $request["motivo"];
            $actualizar["usuarioweb_idusuariowebResponsable"] = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idusuario"];
            $actualizar["estado"] = '2';
            $actualizar["fecha_rechazado"] = $hoy;
            if (!$this->enviarMailValidacionReembolso($request)) {
                $this->setMsg(["msg" => "Error, El mail de validacion no pudo enviarse ", "result" => false]);
                return false;
            }
            // si se acepta el reembolso ingreso aca    
        } else {
            // valido que seleccione un programa
            if ($request["id_programa"] == '') {
                $this->setMsg(["msg" => "Error, Debe seleccionar un programa", "result" => false]);
                return false;
                // valido el monto
            } else if ($request["importe_reintegro"] <= 0 || $request["importe_reintegro"] > 65) {
                $this->setMsg(["msg" => "Error, El importe debe ser mayot a 0 € y menor a 65 € ", "result" => false]);
                return false;
            } else {
                $actualizar["monto"] = $request["importe_reintegro"];
                $actualizar["usuarioweb_idusuariowebResponsable"] = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idusuario"];
                $actualizar["estado"] = '1';
                $actualizar["fecha_efectuado"] = $hoy;
                $actualizar["programaSalud_idprogramasalud"] = $request["id_programa"];
                if (!$this->enviarMailValidacionReembolso($request)) {
                    $this->setMsg(["msg" => "Error, El mail de validacion no pudo enviarse ", "result" => false]);
                    return false;
                }
            }
        }

        $rdo = parent::update($actualizar, $request["idreembolso"]);
        if ($rdo) {
            $siguiente_reembolso = $this->getByField("estado", 0);
            if ($siguiente_reembolso != '') {
                $this->setMsg(["msg" => "El reembolso ha sido validado con éxito", "result" => true, "idsigrem" => $siguiente_reembolso["idReembolso"]]);
            } else {
                $this->setMsg(["msg" => "El reembolso ha sido validado con éxito", "result" => true, "idsigrem" => 0]);
            }
            return true;
        } else {
            $this->setMsg(["msg" => "Error, El reembolso no pudo ser validado", "result" => false]);
            return false;
        }
    }

    /**
     *  mail de validacion del reembolso, si fue aceptado o rechazado
     * @return boolean
     */
    public function enviarMailValidacionReembolso($request) {

        $Manager = $this->getManager("ManagerUsuarioWeb");
        $usuario = $Manager->get($request["usuarioWeb_idusuarioweb"]);

        //envio de la invitacion por mail

        $smarty = SmartySingleton::getInstance();

        $smarty->assign("usuario", $usuario);
        if ($request["motivo"] == '') {
            $smarty->assign("texto", "Votre remboursement a été approuvé.");
        } else {
            $smarty->assign("texto", "Votre remboursement a été refusé.");
        }

        $mEmail = $this->getManager("ManagerMail");
        $mEmail->setHTML(true);

        //ojo solo arnet local
        $mEmail->setPort("587");
        $mEmail->setSubject(sprintf("WorknCare | Rembourser"));

        $mEmail->setBody($smarty->Fetch("email/mensaje_validacion_reembolso.tpl"));
        $email = $usuario["email"];
        $mEmail->addTo($email);

        if ($mEmail->send()) {
            $this->setMsg(["msg" => "Mensaje enviado con éxito", "result" => true]);
            return true;
        } else {
            $this->setMsg(["msg" => "No se ha podido enviar el mensaje. Inténtelo más tarde", "result" => false]);
            return false;
        }
    }

}

//END_class
?>