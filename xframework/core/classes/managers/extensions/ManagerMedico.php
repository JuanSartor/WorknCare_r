<?php

/**
 * 	@autor Xinergia
 * 	@version 1.0	29/05/2014
 * 	Manager de Los médicos
 *
 */
class ManagerMedico extends ManagerMedia {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

// Llamamos al constructor del a superclase
        parent::__construct($db, "medico", "idmedico");

        $this->flag = "active";

        $this->default_paginate = "medicos_list";
        $this->setImgContainer("medicos");
        $this->addImgType("jpg");
        $this->setFilters("img_pdf");
        $this->addThumbConfig(50, 50, "_perfil");
        $this->addThumbConfig(150, 150, "_usuario");
        $this->addThumbConfig(110, 110, "_list");
    }

    public function processFromAdmin($request) {

        if (isset($request["idmedico"]) && $request["idmedico"] != "") {
            $medico = $this->get($request["idmedico"]);
            $rdo1 = $this->basic_update($request, $request["idmedico"]);

            $rdo2 = $this->getManager("ManagerUsuarioWeb")->basic_update($request, $medico["usuarioweb_idusuarioweb"]);

            if ($request["especialidad_medico"] != "") {
                $this->db->Execute("update especialidadmedico set especialidad_idespecialidad={$request["especialidad_medico"]} where medico_idmedico={$request["idmedico"]}");
            }

            if ($rdo1 && $rdo2) {
                $this->setMsg(["msg" => "Se acualizaron los datos de médico con éxito", "result" => true]);
                return true;
            } else {
                $this->setMsg(["msg" => "No se pudo acualizar los datos del médico", "result" => false]);
                return false;
            }
        } else {
            $this->setMsg(["msg" => "No se pudo acualizar los datos del médico", "result" => false]);
            return false;
        }
    }

    /**
     * Método que realiza el update básico para que no se pise con el update de 
     * implementación en este método
     * @param type $request
     * @param type $id
     * @return type
     */
    public function basic_update($request, $id) {
        return parent::update($request, $id);
    }

    /*
     * 	@author Xinergia <info@e-xinergia.com>
     *   @version 1.0
     */

    public function insert($request) {

//Insertamos el usuario web
        $managerUsuarioWeb = $this->getManager("ManagerUsuarioWeb");
        $request["tipousuario"] = "medico";
        $idusuarioweb = $managerUsuarioWeb->insert($request);

//Si hubo un problema al momento de crear un usuario
        if (!$idusuarioweb) {
//Seteo el mensaje por el problema que ocurrió en el ManagerUsuarioWeb
            $this->setMsg($managerUsuarioWeb->getMsg());
            return false;
        }

        $request["usuarioweb_idusuarioweb"] = $idusuarioweb;

//Colocamos el estado del médico como activo.
        $request["estado"] = 1;

        $id = parent::insert($request);

//si se crea correctamente asocio las funcionaldades y si aplica o no
        if ($id) {

//Si se crea el médico le asigno por defecto el IDIOMA ESPAÑOL
            $ManagerIdiomaMedico = $this->getManager("ManagerIdiomaMedico");
            $ididiomaMedico = $ManagerIdiomaMedico->addIdiomaMedico(1, $id);

//Creo la cuenta del usuario
            $ManagerCuentaUsuario = $this->getManager("ManagerCuentaUsuario");
            $idcuenta_usuario = $ManagerCuentaUsuario->insert([
                "medico_idmedico" => $id,
                "saldo" => 0
            ]);

            $msg = $this->getMsg();



            $this->setMsg(["msg" => "Se dió de alta el médico", "result" => true]);
        }

        return $id;
    }

    /**
     * Método utilizado para la validación de los médicos
     * @param type $request
     */
    public function validarMedico($request) {


        $medico = $this->get($request[$this->id]);

        if ($medico) {

            $status = (int) $medico["validado"] == 0 ? 1 : 0;

            $rdo = parent::update(array("validado" => $status), $medico[$this->id]);
            if ($rdo) {


//Envío del Email
                if ($status == 1) {
//Se debe enviar el email
                    $ManagerUsuarioWeb = $this->getManager("ManagerUsuarioWeb");

                    $send = $ManagerUsuarioWeb->sendEmailActivacion($medico["usuarioweb_idusuarioweb"]);



// <------------------
// Fix 20191125 Enviamos SMS de creación de nueva cuenta
                    $cuerpo = "Votre compte a été validé. Vous pouvez maintenant vous connecter!" . URL_ROOT . "medecin-ou-professionnel/?connecter";

                    $ManagerLogSMS = $this->getManager("ManagerLogSMS");
                    $sms = $ManagerLogSMS->insert([
                        "dirigido" => 'M',
                        //"paciente_idpaciente" => $paciente["idpaciente"],
                        "medico_idmedico" => $request["idmedico"],
                        "contexto" => "SMS Validacion admin",
                        "texto" => $cuerpo,
                        "numero_cel" => $medico["numeroCelular"]
                    ]);
// <------------------

                    $this->setMsg(["result" => true, "msg" => "El médico ha sido validado con éxito."]);
                } else {
                    $this->setMsg(["result" => true, "msg" => "El médico ha sido suspendido."]);
                }


                return $rdo;
            } else {
                $this->setMsg(["result" => false, "msg" => "Error. No se pudo validar el médico"]);
                return false;
            }
        } else {
            $this->setMsg(["result" => false, "msg" => "Error. El médico seleccionado no fue encontrado en el sistema"]);
            return false;
        }
    }

    /**
     * Método que obtiene el menu del médico...
     * @param type $idmedico
     * @return boolean
     */
    public function getInfoMenuMedico($idmedico = null) {
        if (is_null($idmedico)) {
            $idmedico = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];
        }



//Array que voy a retornar.
        $info = array();

        $medico = $this->get($idmedico, true);
        if ($medico["pais_idpais"] == 1) {
//Inicialmente es el 30 porciento para medicos franceses
            $count = 30;

            //verificamos si tiene numero ADELI o RPPS completo
            if ($medico["mis_especialidades"][0]["tipo_identificacion"] == 1) {
                if ($medico["numero_adeli"] == "") {
                    $count += 0;
                } else {
                    $count += 10;
                }
            } else if ($medico["mis_especialidades"][0]["tipo_identificacion"] == 0) {
                if ($medico["numero_rpps"] == "") {
                    $count += 0;
                } else {
                    $count += 10;
                }
            } else {
                $count += 10;
            }

            //verificamos si tiene numero AM requerido
            if ($medico["mis_especialidades"][0]["requiere_numero_am"] == 1 && $medico["numero_am"] == "") {
                $count += 0;
            } else {
                $count += 10;
            }

            //verificamos si tiene sector requerido
            if ($medico["mis_especialidades"][0]["requiere_sector"] == 1 && $medico["sector_idsector"] == "") {
                $count += 0;
            } else {
                $count += 10;
            }

            //verificamos si tiene modo de facturacion requerido
            if ($medico["mis_especialidades"][0]["requiere_modo_facturacion"] == 1 && $medico["facturacion_teleconsulta"] == "") {
                $count += 0;
            } else {
                $count += 10;
            }
        } else {
//Inicialmente es el 70 porciento para medicos NO franceses
            $count = 70;
        }



//Formación académica
        $count += $medico["formacionAcademica"] != "" ? 10 : 0;


//Experiencia Profesional
        $count += $medico["experienciaProfesional"] != "" ? 10 : 0;

//Si tiene imagen
        $count += ($this->tieneImagen($idmedico) == false) ? 0 : 10;



        $count = ($count >= 100) ? 100 : $count;
//Información personal PORCENTAJE
        $info["porcentaje_info_personal"] = $count;

        $ManagerConsultorio = $this->getManager("ManagerConsultorio");
        $info["cantidad_consultorios"] = $ManagerConsultorio->getCantidadConsultorios();
        $info["consultorio_virtual"] = $ManagerConsultorio->getConsultorioVirtual($idmedico);

//Información comercial médico
        $ManagerInformacionComercialMedico = $this->getManager("ManagerInformacionComercialMedico");
        $informacion_comercial = $ManagerInformacionComercialMedico->getInformacionComercialMedico($idmedico);



//Razón social
        $count_comercial += $informacion_comercial["nombre_beneficiario"] != "" ? 50 : 0;
        $count_comercial += $informacion_comercial["iban"] != "" ? 50 : 0;


//Método de pago
//CUIT


        $info["porcentaje_info_comercial"] = $count_comercial;
        $info["medico"] = $medico;

        return $info;
    }

    /*
     * 	@author Xinergia <info@e-xinergia.com>
     *   @version 1.0
     */

    public function update($request, $idmedico) {

        if ((int) $idmedico != (int) $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"] && CONTROLLER == "medico") {

            $this->setMsg(["msg" => "Se produjo un error", "result" => false]);
            return false;
        }

        $medico = $this->get($idmedico);

        $this->db->StartTrans();

//Se realiza el update de los campos que vengan de la tabla usuarioweb
        $to_save = array("email", "password", "DNI", "sexo", "tipoDNI_idtipoDNI", "tipousuario");
        $fields = array();

        foreach ($request as $key => $value) {

            if (in_array($key, $to_save)) {

                $fields[$key] = $value;
            }
        }

        if (count($fields) > 0) {//Si vienen datos para editarse en usuarioweb
            $managerUsuarioWeb = $this->getManager("ManagerUsuarioWeb");
            $idusuarioweb = $managerUsuarioWeb->update($fields, $medico["usuarioweb_idusuarioweb"]);
//Si hubo un problema al momento de crear un usuario
            if (!$idusuarioweb) {
                $this->db->FailTrans();
                $this->db->CompleteTrans();
//Seteo el mensaje por el problema que ocurrió en el ManagerUsuarioWeb
                $this->setMsg($managerUsuarioWeb->getMsg());
                return false;
            }

            $request["usuarioweb_idusuarioweb"] = $idusuarioweb;
        }

        unset($to_save);
        unset($fields);

        $to_save = array("cuit", "numeroCelular", "matriculaNacional", "colegioInscripto", "colegioInscriptoProvincial", "matriculaProvincial", "estado", "formacionAcademica",
            "experienciaProfesional", "areasCompetencia", "cantidadPines", "cantidadSMS", "preferencia_idPreferencia",
            "usuarioweb_idusuarioweb", "caracteristicaCelular");
        $fields = array();

        foreach ($request as $key => $value) {

            if (in_array($key, $to_save)) {

                $fields[$key] = $value;
            }
        }


//Si el número de celular es modificado, se setea celular válido como 0

        if (isset($fields["numeroCelular"]) && $fields["numeroCelular"] != "" && $medico["numeroCelular"] != $fields["numeroCelular"]) {
            $fields["celularValido"] = 0;
            $fields["codigoValidacionCelular"] = "";


//mODIFICO la preferencia en caso de que tenga que recibe notificaciones por SMS
            $ManagerPreferencia = $this->getManager("ManagerPreferencia");
            $preferencia = $ManagerPreferencia->getPreferenciaMedico($idmedico);
            if ($preferencia) {
                $idpreferencia = $ManagerPreferencia->update(array("recibirAgendaDiariaSMS" => 0), $preferencia["idpreferencia"]);
                if (!$idpreferencia) {
                    $this->setMsg(["result" => false, "msg" => "Se produjo un error al guardar datos del médico"]);
                    $this->db->FailTrans();
                    $this->db->CompleteTrans();
                    return false;
                }
            }
        }

        if (count($fields) > 0) {//Si vienen datos para editarse en usuarioweb
            $id = parent::update($fields, $idmedico);

//si se crea correctamente asocio las funcionaldades y si aplica o no
            if (!$id) {
                $this->setMsg(["result" => false, "msg" => "Se produjo un error al guardar datos del médico"]);
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                return false;
            }

            $this->setMsg(["msg" => "Se modificaron los datos del médico", "result" => true]);

            $this->db->CompleteTrans();
            return $id;
        }

        $this->db->CompleteTrans();
        return $idmedico;
    }

    /* Metodo que realiza la actualizacion de los campos de email y numero de celular en la configuracion de administracion del medico
     * 	@author Xinergia <info@e-xinergia.com>
     *   @version 1.0
     */

    public function updateCelularEmail($request, $idmedico) {


        if ((int) $idmedico != (int) $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"] && CONTROLLER == "medico") {
            $this->setMsg(["msg" => "Se produjo un error", "result" => false]);
            return false;
        }

        $medico = $this->get($idmedico);

        $this->db->StartTrans();
        $result = true;

//Verificamos si cambio el mail

        $managerUsuarioWeb = $this->getManager("ManagerUsuarioWeb");
        $usuario = $managerUsuarioWeb->get($medico["usuarioweb_idusuarioweb"]);
        $EmailValidado = 1;
        if ($request["email"] != "" && $request["email"] != $usuario["email"]) {

//valido descripcion unica Email
            if (!$managerUsuarioWeb->validateUnique("email", $request["email"])) {

                $this->setMsg(["result" => false, "msg" => "La cuenta, [[" . $request["email"] . "]] ya se encuentra registrada", "field" => "email"]);
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                return false;
            }



            $id = parent::update(["cambioEmail" => $request["email"]], $idmedico);
            $mail = $this->enviarMailCodigoValidacionEmail();
            $EmailValidado = 0;
//Si hubo un problema al momento de cambiar el mail
            if (!$id) {
                $result = false;
                $this->db->FailTrans();
                $this->db->CompleteTrans();
            }
        }



//Si el número de celular es modificado, se setea celular válido como 0
        $validado = $medico["celularValido"];

        if (isset($request["numeroCelular"]) && $request["numeroCelular"] != "" && $medico["numeroCelular"] != $request["numeroCelular"]) {
            $validado = $fields["celularValido"] = 0;
            $fields["codigoValidacionCelular"] = "";
            $fields["numeroCelular"] = $request["numeroCelular"];
            $id = parent::update($fields, $idmedico);
            $sms = $this->sendSMSValidacion();
            if (!$id) {
                $result = false;
                $this->db->FailTrans();
                $this->db->CompleteTrans();
            }
        }




//si se crea correctamente asocio las funcionaldades y si aplica o no
        if ($result) {



//si ingresa el mismo numero y no esta validado le recuero que debe validarlo
            if ($medico["numeroCelular"] == $request["numeroCelular"] && $medico["celularValido"] == "0") {
                $revalidar_cel = 1;
            }

// <-- LOG
            $log["data"] = "email / password / tel";
            $log["action"] = "val"; //"val" "vis" "del"
            $log["page"] = "Account settings";
            $log["purpose"] = "User ID";

            $ManagerLog = $this->getManager("ManagerLog");
            $ManagerLog->track($log);

// <--    

            $this->setMsg(["result" => true, "msg" => "Se modificaron sus datos con éxito", "celularValido" => $validado, "emailValido" => $EmailValidado, "revalidar_cel" => $revalidar_cel]);

            $this->db->CompleteTrans();
            return $id;
        } else {
            $this->setMsg(["result" => false, "msg" => "Se produjo un error al modificar sus datos"]);

            $this->db->FailTrans();
            $this->db->CompleteTrans();
            return false;
        }




        $this->db->CompleteTrans();
        return $idmedico;
    }

    /**
     * Mpétodo utilizado para guardar formularios donde se mezclan las entidades
     * @param type $request
     * @return boolean
     */
    public function controllerUpdateAllEntities($request) {

        $idmedico = (int) $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"];

        $medico = $this->get($idmedico);

        if (isset($request["numeroCelular"]) && $request["numeroCelular"] != "") {
            $is_cambio_celular = $request["numeroCelular"] != $medico["numeroCelular"] ? true : false;
        }
//Guardo el médico

        $save_medico = $this->update($request, $idmedico);
        if (!$save_medico) {
            return false;
        }

//Guardar las preferencias
        $ManagerPreferencia = $this->getManager("ManagerPreferencia");
        $update_preferencia = $ManagerPreferencia->guardarPreferencia($request);

        if (!$update_preferencia) {
            $this->setMsg($ManagerPreferencia->getMsg());
            return false;
        }

        $this->setMsg(["result" => true, "msg" => "Se actualizaron los campos con éxito", "is_cambio_celular" => $is_cambio_celular]);

        return true;
    }

    /**
     * Listado de todos los médicos activos
     * @return type
     */
    public function getListAllMedicos() {
        $query = new AbstractSql();
        $query->setSelect("*");
        $query->setFrom("$this->table");
        $query->setWhere("$this->flag = 1");


        return $this->getList($query);
    }

    /**
     * Listado de todos los médicos activos
     * @return type
     */
    public function getListAllMedicosCron() {
        $fecha = date("Y-m-d");

        $query = new AbstractSql();

        $query->setSelect("*");

        $query->setFrom("$this->table");

        $query->setWhere("$this->flag = 1");

        $query->addAnd("idmedico NOT IN (SELECT medico_idmedico
                                            FROM campaniascronmedico
                                            WHERE fechaGeneracionAgenda = '$fecha')");


        return $this->getList($query);
    }

    /**
     * Obtiene los valores del medico
     * @param type $idmedico
     * @param type $all : flag que permite elegir si se  requieren todos los datos o no (Por defecto busca todo de los médicos)
     * @return type
     */
    public function get($idmedico, $all = false) {
//$medico = parent::get($idmedico);

        $execute = $this
                ->db
                ->Execute("SELECT m.*,p.pais as pais_medico,tp.titulo_profesional as tituloprofesional,uw.* FROM $this->table m
                            INNER JOIN usuarioweb uw ON (m.usuarioweb_idusuarioweb=uw.idusuarioweb and uw.registrado=1) 
                            INNER JOIN pais p ON (p.idpais=m.pais_idpais)
                            LEFT JOIN titulo_profesional tp ON (m.titulo_profesional_idtitulo_profesional=tp.idtitulo_profesional)
                            WHERE m.idmedico = $idmedico");

        if ($execute) {
            $medico = $execute->FetchRow();

            if ($medico) {
                if ($all) {

                    $medico["mis_especialidades"] = $this
                            ->getManager("ManagerEspecialidadMedico")
                            ->getEspecialidadesMedico($idmedico);

                    $managerTituloProfesional = $this->getManager("ManagerTituloProfesional");

                    if ($medico["titulo_profesional_idtitulo_profesional"] != "") {
                        $medico["titulo_profesional"] = $managerTituloProfesional->get($medico["titulo_profesional_idtitulo_profesional"]);
                    }
                    if ($medico["direccion_iddireccion"] != "") {
                        $medico["direccion"] = $this->getManager("ManagerDireccion")->get($medico["direccion_iddireccion"]);
                    }

//Agrego la preferencia...
                    $medico["preferencia"] = $this->getManager("ManagerPreferencia")->get($medico["preferencia_idPreferencia"]);

                    $medico["images"] = $this->getImagenMedico($idmedico);
                }

                return $medico;
            } else {
                return false;
            }
        } else {
            return false;
        }
    }

    /**
     * Retorno El médico desde el id del usuario web
     * @param type $idusuarioweb
     * @return type
     */
    public function getFromUsuarioWeb($idusuarioweb) {
        return $this->getByField("usuarioweb_idusuarioweb", $idusuarioweb);
    }

    /**
     * Método que retorna el listado JSON de los médicos utilizadas para la jQGrid del ADMIN
     * @param type $request
     * @param type $idpaginate
     * @return type
     */
    public function getListadoJSON($request, $idpaginate = NULL) {

        if (!is_null($idpaginate)) {
            $this->paginate($idpaginate, 50);
        }

        $query = new AbstractSql();
        $query->setSelect("
                $this->id,
                CONCAT(uw.apellido,', ', uw.nombre) as nombre,
                esp.especialidad,
                IF(m.pais_idpais=1,'France','Luxembourg') as pais,
                m.numeroCelular,
                uw.email,
                IFNULL(m.numero_rpps,IFNULL(m.numero_adeli,IFNULL(m.numero_identificacion,'-'))) as nro_identificacion,
                DATE_FORMAT(uw.fecha_alta,'%d-%m-%Y') as fecha_alta_format,
                IF(uw.estado=1,'SI','NO') as estado, 
                IF(m.active=1,'SI','NO') as active, 
                IF(m.validado=1,'SI','NO') as validado,
                CASE m.fundador
                WHEN 1 THEN 'Fundador'
                WHEN 0 THEN  IF(m.planProfesional=1,'Profesional','Gratuita')
                END as cuenta
                
            ");
        $query->setFrom("
                $this->table m 
                    INNER JOIN usuarioweb uw ON (m.usuarioweb_idusuarioweb = uw.idusuarioweb and uw.registrado=1)
                    LEFT JOIN especialidadmedico em ON (em.medico_idmedico=m.idmedico)
                    LEFT JOIN especialidad esp ON (esp.idespecialidad=em.especialidad_idespecialidad)
                    LEFT JOIN informacion_comercial_medico icm ON (m.idmedico = icm.medico_idmedico)
            ");


        if ($request["active"] != "") {

            $rdo = cleanQuery($request["active"]);

            $query->addAnd("m.active=$rdo");
        }

// Filtro
        if ($request["nombre"] != "") {

            $rdo = cleanQuery($request["nombre"]);

            $query->addAnd("uw.nombre LIKE '%$rdo%'");
        }

        if ($request["apellido"] != "") {

            $rdo = cleanQuery($request["apellido"]);

            $query->addAnd("uw.apellido LIKE '%$rdo%'");
        }

        if ($request["validado"] != "") {

            $rdo = cleanQuery($request["validado"]);

            $query->addAnd("m.validado=$rdo");
        }

        if ($request["email"] != "") {

            $rdo = cleanQuery($request["email"]);

            $query->addAnd("uw.email LIKE '%$rdo%'");
        }

        if (isset($request["especialidad_idespecialidad"]) && $request["especialidad_idespecialidad"] != "") {
            $esp = cleanQuery($request["especialidad_idespecialidad"]);
            $query->addAnd("em.especialidad_idespecialidad={$esp}");
        }
        /* if (isset($request["subEspecialidad_idsubEspecialidad"]) && $request["subEspecialidad_idsubEspecialidad"] != "") {
          $subesp = cleanQuery($request["subEspecialidad_idsubEspecialidad"]);
          $query->addAnd("em.subEspecialidad_idsubEspecialidad={$subesp}");
          } */
        $query->setGroupBy("m.idmedico");
        $query->setOrderBy("uw.nombre ASC");

        $data = $this->getJSONList($query, array("nombre", "especialidad", "pais", "nro_identificacion", "numeroCelular", "email", "estado", "validado", "active", "cuenta", "fecha_alta_format"), $request, $idpaginate);



        return $data;
    }

    /**
     * Generacion de listado CSV con los médicos registrados 
     * 
     * @param type $request
     * 
     */
    public function ExportarMedicosCSV($request) {



        $data = $this->getListadoJSON($request);
        $data_2 = json_decode($data, 1);

        $fecha_actual = date("Y-m-d");
        header('Content-Type: text/csv');
        header('Content-Disposition: attachment;filename=medicos-' . $fecha_actual . ".csv");


        $out = fopen('php://output', 'w');
        $cabecera = array('Nombre', 'Especialidad', 'Pais', 'Identificacion', 'Celular', 'Email', 'Email Confirmado', 'Validado', "Activo", "Cuenta", 'Alta');
        fputcsv($out, $cabecera, ";");
        foreach ($data_2["rows"] as $registro) {
            unset($registro["cell"][0]);
            utf8_decode_ar($registro["cell"]);
            fputcsv($out, $registro["cell"], ";");
        }

        fclose($out);
    }

    /**
     * Método que realiza la registración web del médico en el sistema desde el panel de administracion.
     * @param type $request
     * @return boolean
     */
    public function registracion_medico_admin($request) {


        $managerUsuarioWeb = $this->getManager("ManagerUsuarioWeb");

//Apertura Transaccion
        $this->db->StartTrans();

        $request["tipousuario"] = "medico";

        $medico_exist = $managerUsuarioWeb->getByField("email", $request["email"]);
        if ($medico_exist) {
            $this->db->FailTrans();
            $this->setMsg(["msg" => "La dirección de correo [[{$request["email"]}]] ya se encuentra registrada", "result" => false]);

            $this->db->CompleteTrans();
            return false;
        }


        $idusuarioweb = $managerUsuarioWeb->registracion_admin($request);

//Si hubo un problema al momento de crear un usuario
        if (!$idusuarioweb) {
//Seteo el mensaje por el problema que ocurrió en el ManagerUsuarioWeb
            $this->db->FailTrans();

            $this->setMsg($managerUsuarioWeb->getMsg());

            $this->db->CompleteTrans();
            return false;
        }

        $request["usuarioweb_idusuarioweb"] = $idusuarioweb;


//Insertar la preferencia
        $managerPreferencia = $this->getManager("ManagerPreferencia");
        $preferencia = array(
            "recibirAgendaDiariaSMS" => 1,
            "recibirAgendaDiariaEmail" => 1
        );

        $idpreferencia = $managerPreferencia->insert($preferencia);
        if (!$idpreferencia) {
            $this->db->FailTrans();

            $this->setMsg(["msg" => "No se ha podido dar de alta el médico", "result" => false]);


            $this->db->CompleteTrans();
            return false;
        }


        $request["preferencia_idPreferencia"] = $idpreferencia;

//Inserto la imagen del DNI
        /* $ManagerImageDNI = $this->getManager("ManagerImageDNI");
          $request["idimageDNI"] = "";

          $id_dni = $ManagerImageDNI->process($request);
          if ($id_dni) {

          $request["imageDNI_idimageDNI"] = $id_dni;
          } else {
          $this->db->FailTrans();


          $this->db->CompleteTrans();
          return false;
          } */

//print_r($request["cuit"]);
//insertamos el titulo profesional DR/DRA

        $request["titulo_profesional_idtitulo_profesional"] = 1;


        if (strlen($request["cuit"]) != "11" || (substr($request["cuit"], 0, 2) != "20" && substr($request["cuit"], 0, 2) != "23" && substr($request["cuit"], 0, 2) != "27")) {
            $this->db->FailTrans();

            $this->setMsg(["msg" => "Error. Cuit invalido.", "result" => false]);

            $this->db->CompleteTrans();
            return false;
        }

        $idmedico = parent::insert($request);

        if (!$idmedico) {
            $this->db->FailTrans();

            $this->setMsg(["msg" => "No se ha podido dar de alta el médico", "result" => false]);

            $this->db->CompleteTrans();
            return false;
        }

//genero el idioma en español por defecto
        $this->getManager("ManagerIdiomaMedico")->insert(array("medico_idmedico" => $idmedico, "idioma_ididioma" => 1));

//Creo la cuenta del usuario
        $ManagerCuentaUsuario = $this->getManager("ManagerCuentaUsuario");
        $idcuenta_usuario = $ManagerCuentaUsuario->insert([
            "medico_idmedico" => $idmedico,
            "saldo" => 0
        ]);

//Insertar la especialidad del médico
        $especialidad = array(
            "medico_idmedico" => $idmedico,
            "especialidad_idespecialidad" => $request["especialidad_medico"],
            "subEspecialidad_idsubEspecialidad" => $request["subespecialidad_medico"]
        );
        $managerEspecialidadMedico = $this->getManager("ManagerEspecialidadMedico");
        $idespecialidadMedico = $managerEspecialidadMedico->insert($especialidad);
        if (!$idespecialidadMedico) {

            $this->db->FailTrans();
            $this->setMsg(["msg" => "No se ha podido dar de alta el médico", "result" => false]);

            $this->db->CompleteTrans();
            return false;
        }



        $this->setMsg(["msg" => "El médico ha sido dado de alta en el sistema", "result" => true]);

        $this->db->CompleteTrans();

        return true;
    }

    /*
     * Realización de la registración web del medico. Carga los pasos desagregados
     * @param type $request
     * @return boolean
     */

    public function registracion_medico($request) {

        if ($request["step"] == "") {
            $this->setMsg(["msg" => "Error.", "result" => false]);

            return false;
        }
        switch ($request["step"]) {
            case 1:
                return $this->registracion_medico_step1($request);
            case 2:
                return $this->checkValidacionCelular($request);
            case 3:
                return $this->registracion_medico_step3($request);
            case 4:
                return $this->registracion_medico_step4($request);
            case 5:
                return $this->registracion_medico_step5($request);
            case 6:
                return $this->registracion_medico_step6($request);

            default:
                $this->setMsg(["msg" => "Error.", "result" => false]);

                return false;
        }
    }

    /**
     * Realización de la registración web del medico.
     * @param type $request
     * @return boolean
     */
    public function registracion_medico_step1($request, $alta_from_medico = 0) {

        $managerUsuarioWeb = $this->getManager("ManagerUsuarioWeb");

        if ($request["email"] == "" || $request["password"] == "" || $request["numeroCelular"] == "") {
            $this->setMsg(["msg" => "Error. Verifique los campos obligatrios", "result" => false]);
            return false;
        }
        if ($request["terminos_condiciones"] == "") {

            $this->setMsg(["msg" => "Debe aceptar los Términos y condiciones de uso del sistema.", "result" => false]);
            return false;
        }

        $captcha = $managerUsuarioWeb->validateGReCaptcha($request);

        if (!$captcha && $_SERVER["HTTP_HOST"] != "localhost") {
            $this->setMsg(["msg" => "Error, verificación captcha incorrecta", "result" => false]);
            return false;
        }

//valido  Email registro pendiente
        $usuarioWeb = $managerUsuarioWeb->getByFieldArray(["email", "registrado"], [$request["email"], 0]);

        if ($usuarioWeb) {
            $managerUsuarioWeb->delete($usuarioWeb["idusuarioweb"], true);
        }

//Apertura Transaccion
        $this->db->StartTrans();

//Registración de usuario 
        $request["tipousuario"] = "medico";
        $request["numeroCelular"] = str_replace(' ', '', $request["numeroCelular"]);
        $idusuarioweb = $managerUsuarioWeb->registracion_web($request);

//Si hubo un problema al momento de crear un usuario
        if (!$idusuarioweb) {
//Seteo el mensaje por el problema que ocurrió en el ManagerUsuarioWeb
            $this->db->FailTrans();
            $this->setMsg($managerUsuarioWeb->getMsg());

            $this->db->CompleteTrans();
            return false;
        }
        $ManagerPreregistro = $this->getManager("ManagerPreregistro");
        $ManagerPreregistro->insert(["email" => $request["email"]]);


        $request["usuarioweb_idusuarioweb"] = $idusuarioweb;
//Insertar la preferencia
        $managerPreferencia = $this->getManager("ManagerPreferencia");
        $preferencia = array(
            "recibirAgendaDiariaSMS" => 1,
            "recibirAgendaDiariaEmail" => 1
        );

        $idpreferencia = $managerPreferencia->insert($preferencia);
        if (!$idpreferencia) {
            $this->db->FailTrans();

            $this->setMsg(["msg" => "No se ha podido dar de alta el médico", "result" => false]);

            $this->db->CompleteTrans();
            return false;
        }


        $request["preferencia_idPreferencia"] = $idpreferencia;



        $idmedico = parent::insert($request);
        if (!$idmedico) {

            $this->setMsg(["msg" => "No se ha podido dar de alta el médico", "result" => false]);

            $this->db->FailTrans();
            $this->db->CompleteTrans();
            return false;
        }


        $rdo_msg = $this->sendSMSValidacion($idmedico);
        if (!$rdo_msg) {

            $this->setMsg(["msg" => "No se ha podido enviar el código de verifiación a su celular", "result" => false]);

            $this->db->FailTrans();
            $this->db->CompleteTrans();
            return false;
        }



        $this->setMsg(["msg" => "Ha sido dado de alta en el sistema", "result" => true, "idmedico" => $idmedico]);
        $this->db->CompleteTrans();
        return true;
    }

    /**
      /**
     * Realización de la registración del los datos del medico.
     * @param type $request
     * @return boolean
     */
    public function registracion_medico_step3($request) {


        if ($request["nombre"] == "" || $request["apellido"] == "") {
            $this->setMsg(["msg" => "Error. Verifique los campos obligatrios", "result" => false]);
            return false;
        }
        $request["nombre"] = ucwords(strtolower($request["nombre"]));
        $request["apellido"] = ucwords(strtolower($request["apellido"]));

//Apertura Transaccion
        $this->db->StartTrans();


//insertamos el titulo profesional DR/PROF

        $record["titulo_profesional_idtitulo_profesional"] = 1;

        $record["nombre"] = $request["nombre"];
        $record["apellido"] = $request["apellido"];
        $record["sexo"] = $request["sexo"] == 1 ? 1 : 0;
//Valido que no haya otro paciente con un email.

        $idmedico = parent::update($record, $request["idmedico"]);

//Valido que no haya otro paciente con un email.
        $medico = parent::get($idmedico);

        $managerUsuarioWeb = $this->getManager("ManagerUsuarioWeb");
        $idusuarioWeb = $managerUsuarioWeb->basic_update($record, $medico["usuarioweb_idusuarioweb"]);

//genero el idioma en español por defecto
        $ididioma = $this
                ->getManager("ManagerIdiomaMedico")
                ->insert(array(
            "medico_idmedico" => $idmedico,
            "idioma_ididioma" => 1
        ));

//Creo la cuenta del usuario
        $ManagerCuentaUsuario = $this->getManager("ManagerCuentaUsuario");
        $idcuenta_usuario = $ManagerCuentaUsuario->insert([
            "medico_idmedico" => $idmedico,
            "saldo" => 0
        ]);

        if (!$idmedico || !$idusuarioWeb || !$idcuenta_usuario || !$ididioma) {

            $this->setMsg(["msg" => "No se ha podido actualizar la informacion del médico", "result" => false]);

            $this->db->FailTrans();
            $this->db->CompleteTrans();
            return false;
        }


        $this->setMsg(["msg" => "Ha sido dado de alta en el sistema", "result" => true, "idmedico" => $idmedico]);

        $this->db->CompleteTrans();

        return true;
    }

    /**
      /**
     * Realización de la registración del los datos del médico.
     * Aceptación de terminos
     * @param type $request
     * @return boolean
     */
    public function registracion_medico_step4($request) {


        if ($request["idmedico"] == "") {

            $this->setMsg(["msg" => "Error. No se pudo recuperar el médico", "result" => false]);
            return false;
        }
        if ($request["pais_idpais"] == "") {

            $this->setMsg(["msg" => "Seleccione el país donde tiene establecido su consultorio físico", "result" => false]);
            return false;
        }



//validamos las opciones seleccionada;
        $upd = parent::update(["pais_idpais" => $request["pais_idpais"]], $request["idmedico"]);


        if (!$upd) {
            $this->setMsg(["msg" => "Ha ocurrido un error al registrar el médico", "result" => false]);
            return false;
        } else {
            $this->setMsg(["msg" => "Ha sido dado de alta en el sistema", "result" => true, "idmedico" => $request["idmedico"]]);
            return true;
        }
    }

    /**
      /**
     * Realización de la registración del los datos del médico.
     * Aceptación de terminos
     * @param type $request
     * @return boolean
     */
    public function registracion_medico_step5($request) {

        if ($request["idmedico"] == "") {

            $this->setMsg(["msg" => "Error. No se pudo recuperar el médico", "result" => false]);
            return false;
        }
        if ($request["especialidad_idespecialidad"] == "") {
            $this->setMsg(["msg" => "Error. Verifique los campos obligatrios", "result" => false]);
            return false;
        }


//Insertar la especialidad del médico
        $especialidad = array(
            "medico_idmedico" => $request["idmedico"],
            "especialidad_idespecialidad" => $request["especialidad_idespecialidad"]
        );

        $managerEspecialidadMedico = $this->getManager("ManagerEspecialidadMedico");
        $idespecialidadMedico = $managerEspecialidadMedico->insert($especialidad);
        if (!$idespecialidadMedico) {

            $this->db->FailTrans();
            $this->setMsg(["msg" => "No se ha podido dar de alta el médico", "result" => false]);

            $this->db->CompleteTrans();
            return false;
        }


        $medico = parent::get($request["idmedico"]);
        if ($medico["pais_idpais"] == 1) {
            $especialidad_seleccionada = $this->getManager("ManagerEspecialidades")->get($request["especialidad_idespecialidad"]);

            //verificamos el tipo de identificacion que requiere la especialidad seleccionada 0:RPPS - 1:ADELI

            if ($especialidad_seleccionada["tipo_identificacion"] == 0) {
                if ($request["numero_rpps"] != "") {
                    if (!$this->validarNumeroRPPS($request["numero_rpps"])) {
                        $this->setMsg(["msg" => "Error. Número RPPS no válido", "result" => false]);
                        return false;
                    }
                } else {
                    $this->setMsg(["msg" => "Error. Ingrese su número RPPS", "result" => false]);
                    return false;
                }
            } else if ($especialidad_seleccionada["tipo_identificacion"] == 1) {
                if ($request["numero_adeli"] != "") {
                    if (!$this->validarNumeroADELI($request["numero_adeli"])) {
                        $this->setMsg(["msg" => "Error. Número Adeli no válido", "result" => false]);
                        return false;
                    }
                } else {
                    $this->setMsg(["msg" => "Error. Ingrese su número Adeli", "result" => false]);
                    return false;
                }
            } else {
                if ($request["numero_identificacion"] == "") {

                    $this->setMsg(["msg" => "Error. Ingrese su número de identificación", "result" => false]);
                    return false;
                }
            }
        }



        //verificamos que se haya cargado las imagenes de identificacion
        foreach ($request["hash"] as $hash) {
            //DNI 
            if ($_SESSION[$hash]["name"] == "dni") {
                $dni_ext = $_SESSION[$hash]["ext"];
                $dni_path_temp = path_files("temp/" . $hash . "." . $dni_ext);
                $dni_path_file = path_entity_files("$this->imgContainer/{$request["idmedico"]}/dni.{$dni_ext}");
                $dni_exist = file_exists($dni_path_temp);
                $dni_is_file = is_file($dni_path_temp);

                if (!$dni_exist || !$dni_is_file) {
                    $this->setMsg(["msg" => "Error. Ingrese la foto de su DNI", "result" => false]);
                    return false;
                } else {
                    //copiamos el archivo a su ubicacion final
                    copy($dni_path_temp, $dni_path_file);
                    //comprobamos que se hayan movido
                    if (!file_exists($dni_path_file) || !is_file($dni_path_file)) {
                        $this->setMsg(["msg" => "Error. No se pudo subir ningun archivos, verifique sus formatos y tamaños", "result" => false]);
                        return false;
                    }
                }
            }
            //CPS si es frances
            if ($medico["pais_idpais"] == 1 && $_SESSION[$hash]["name"] == "cps") {
                $cps_ext = $_SESSION[$hash]["ext"];
                $cps_path_temp = path_files("temp/" . $hash . "." . $cps_ext);
                $cps_path_file = path_entity_files("$this->imgContainer/{$request["idmedico"]}/cps.{$cps_ext}");
                $cps_exist = file_exists($cps_path_temp);
                $cps_is_file = is_file($cps_path_temp);
                if (!$cps_exist || !$cps_is_file) {
                    if ($especialidad_seleccionada["tipo_identificacion"] == 2) {
                        $this->setMsg(["msg" => "Error. Ingrese la foto de su título", "result" => false]);
                    } else {
                        $this->setMsg(["msg" => "Error. Ingrese la foto de su tarjeta CPS", "result" => false]);
                    }

                    return false;
                } else {
                    //copiamos el archivo a su ubicacion final
                    copy($cps_path_temp, $cps_path_file);
                    //comprobamos que se hayan movido
                    if (!file_exists($cps_path_file) || !is_file($cps_path_file)) {
                        $this->setMsg(["msg" => "Error. No se pudo subir ningun archivos, verifique sus formatos y tamaños", "result" => false]);
                        return false;
                    }
                }
            }
        }
        //seteamos el titulo profesional del medico en base a la especialidad
        $ManagerEspecialidades = $this->getManager("ManagerEspecialidades");
        $esp = $ManagerEspecialidades->get($request["especialidad_idespecialidad"]);
        $request["titulo_profesional_idtitulo_profesional"] = $esp["tipo"] == 2 ? 2 : 1;
        $idmedico = parent::update($request, $request["idmedico"]);
        if (!$idmedico) {

            $this->setMsg(["msg" => "No se ha podido actualizar la informacion del médico", "result" => false]);

            $this->db->FailTrans();
            $this->db->CompleteTrans();
            return false;
        }

        /* Enivamos mail de confirmacion */
        $confirmar = $this->registracion_medico_confirmar($request);
        if (!$confirmar) {

            $this->db->FailTrans();
            $this->db->CompleteTrans();
            return false;
        }

        //eliminamos los archivos temporales subidos
        foreach ($request["hash"] as $hash) {
            unlink(path_files("temp/" . $hash . "." . $_SESSION[$hash]["ext"]));
            unset($_SESSION[$hash]);
        }


        $this->setMsg(["msg" => "Ha sido dado de alta en el sistema", "result" => true, "idmedico" => $idmedico]);

        $this->db->CompleteTrans();

        return true;
    }

    /**
      /**
     * Realización de la registración del los datos del médico.
     * Aceptación de terminos
     * @param type $request
     * @return boolean
     */
    public function registracion_medico_confirmar($request) {


        if ($request["idmedico"] == "") {

            $this->setMsg(["msg" => "Error. No se pudo recuperar el médico", "result" => false]);
            return false;
        }
        $managerUsuarioWeb = $this->getManager("ManagerUsuarioWeb");

//validamos las opciones seleccionada;
        $medico = parent::get($request["idmedico"]);
        $rdo_upd = $managerUsuarioWeb->basic_update(["registrado" => 1], $medico["usuarioweb_idusuarioweb"]);
        $rdo = $managerUsuarioWeb->sendEmailValidation($medico["usuarioweb_idusuarioweb"]);
        if (!$rdo || !$rdo_upd) {

            $this->setMsg(["msg" => "Ha ocurrido un error al registrar el médico", "result" => false]);
            return false;
        } else {
            $this->setMsg(["msg" => "Ha sido dado de alta en el sistema", "result" => true, "idmedico" => $request["idmedico"]]);

            $rdo_send = $this->sendEmailMedicoNuevo($request["idmedico"]);

// <------------------
// Fix 20191125 Enviamos SMS de creación de nueva cuenta
            $cuerpo = "WorknCare vous a envoyé un email pour confirmer votre compte. Si vous ne le voyez pas, il est peut-être dans les spams!";

            $ManagerLogSMS = $this->getManager("ManagerLogSMS");
            $sms = $ManagerLogSMS->insert([
                "dirigido" => 'M',
                //"paciente_idpaciente" => $evento["paciente_idpaciente"],
                "medico_idmedico" => $request["idmedico"],
                "contexto" => "SMS ALTA",
                "texto" => $cuerpo,
                "numero_cel" => $medico["numeroCelular"]
            ]);
// <------------------
// <-- LOG
            $log["data"] = "email, password, celular, surname, family name, gender, medical specialty, country of work, RPPS number, ID Card picture, CPS Card picture, terms & conditions approval";
            $log["page"] = "Create account";
            $log["usertype"] = "Professional";
            $log["action"] = "val"; //"vis" "del"
            $log["purpose"] = "Create account";
            $log["userid"] = $request["idmedico"];

            $ManagerLog = $this->getManager("ManagerLog");
            $ManagerLog->track($log);

// <--
            return true;
        }
    }

    /**
     * Envío del Email para el nuevo médico
     * @param type $idusuario
     * @return boolean
     */
    public function sendEmailMedicoNuevo($idusuario) {
        $usuario = $this->get($idusuario);

        $mEmail = $this->getManager("ManagerMail");
        $mEmail->setHTML(true);

//ojo solo arnet local
        $mEmail->setPort("587");

        $mEmail->setSubject("WorknCare | NOUVEAU PROFESSIONNEL INSCRIT ");


        $smarty = SmartySingleton::getInstance();

        $smarty->assign("usuario", $usuario);
        $smarty->assign("sistema", NOMBRE_SISTEMA);

        $mEmail->setBody($smarty->Fetch("email/nuevo_medico.tpl"));


        $mEmail->addTo("yannis.georgandelis@doctorplus.fr");

        $query = new AbstractSql();
        $query->setSelect("email");
        $query->setFrom("usuario");
        $query->setWhere("notificar_nuevo_medico=1");
        $list_usuarios = $this->getList($query);
        foreach ($list_usuarios as $admin) {
            $mEmail->addTo($admin["email"]);
        }



//$mEmail->addTo("yannisgeorgandelis@yahoo.com");
//header a todos los comentarios!
        if ($mEmail->send()) {

            return true;
        } else {
//$this->setMsg(["result" => false, "msg" => "No se pudo enviar el mensaje"]);
            return false;
        }
    }

    /**
     * Método que brinda los pacientes de un médico.
     * Método utilizado tambien para MI CUENTA
     * @param type $request
     * @param type $idpaginate
     * @return type
     */
    public function getMisPacientes($request, $idpaginate = NULL) {
        $this->resetPaginate($idpaginate);
        if (isset($request["do_reset"]) && $request["do_reset"] == 1) {
            $this->resetPaginate($idpaginate);
        }

        if (!is_null($idpaginate)) {
            $this->paginate($idpaginate, 10, true);
        }

        $query = new AbstractSql();

        $idmedico = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"];

        $query->setSelect("t.*");

        $query->setFrom("(
                            (   SELECT u.nombre, 
                                        u.apellido, 
                                        p.fechaNacimiento, 
                                        p.estado, 
                                        p.active, 
                                        IF(p.celularValido = 1, p.numeroCelular, ' - ' ) as numeroCelular, 
                                        p.caracteristicaCelular, 
                                        u.sexo, 
                                        mpi.medico_idmedico, 
                                        p.idpaciente,
                                        mpi.estado as estado_solicitud
                                FROM medico_paciente_invitacion mpi 
                                    INNER JOIN paciente p ON (mpi.paciente_idpaciente = p.idpaciente) 
                                    INNER JOIN usuarioweb u ON (p.usuarioweb_idusuarioweb = u.idusuarioweb) 
                                WHERE mpi.medico_idmedico = $idmedico
                                        AND p.active = 1
                            ) 
                        UNION 
                            (   SELECT mpi.nombre, 
                                        mpi.apellido, 
                                        mpi.fechaNacimiento, 
                                        '' as estado, 
                                        '' as active, 
                                        mpi.celular as numeroCelular, 
                                        '' as caracteristicaCelular, 
                                        '' as sexo, 
                                        mpi.medico_idmedico, 
                                        '' as idpaciente,
                                        mpi.estado as estado_solicitud
                                FROM medico_paciente_invitacion mpi 
                                WHERE mpi.medico_idmedico = $idmedico
                                    AND mpi.paciente_idpaciente IS NULL
                                ) 
                        UNION
                            (   SELECT u.nombre, 
                                        u.apellido, 
                                        p.fechaNacimiento, 
                                        p.estado, 
                                        p.active, 
                                        IF(p.celularValido = 1, p.numeroCelular, ' - ' ) as numeroCelular, 
                                        p.caracteristicaCelular, 
                                        u.sexo, 
                                        mmp.medico_idmedico, 
                                        p.idpaciente,
                                        '' as estado_solicitud
                                FROM medicomispacientes mmp 
                                    INNER JOIN paciente p ON (mmp.paciente_idpaciente = p.idpaciente) 
                                    INNER JOIN usuarioweb u ON (p.usuarioweb_idusuarioweb = u.idusuarioweb) 
                                WHERE mmp.medico_idmedico = $idmedico
                            )
                        UNION
                            ( SELECT pf.nombre, 
                                        pf.apellido, 
                                        p.fechaNacimiento, 
                                        p.estado, 
                                        p.active, 
                                        IF(p.celularValido = 1, p.numeroCelular, ' - ' ) as numeroCelular, 
                                        p.caracteristicaCelular, 
                                        pf.sexo, 
                                        mmp.medico_idmedico, 
                                        p.idpaciente,
                                        '' as estado_solicitud
                                FROM medicomispacientes mmp 
                                    INNER JOIN paciente p ON (mmp.paciente_idpaciente = p.idpaciente) 
                                    INNER JOIN pacientegrupofamiliar pf ON (p.idpaciente = pf.pacienteGrupo)  
                                WHERE mmp.medico_idmedico = $idmedico
                            ) 
                        ) AS t");

        if (isset($request["query_str"]) && $request["query_str"] != "") {
            $rdo = cleanQuery($request["query_str"]);
            $query->setWhere("(t.nombre LIKE '%$rdo%' OR t.apellido LIKE '%$rdo%')");
        }

//          $query->setGroupBy("t.idpaciente");

        $pacientes_list = $this->getList($query, false, $idpaginate);

//Por cada paciente, le agrego la imagen.
        if ($pacientes_list) {
            $ManagerPaciente = $this->getManager("ManagerPaciente");
            $pacientes_list = $ManagerPaciente->getPathImagesList($pacientes_list, "idpaciente");
        }

        return $pacientes_list;
    }

    /**
     * Método que retorna el paciente perteneciente al médico que se encuentra en SESSION, 
     * si el id del paciente que se ingresa como parámetro no pertenece al médico, retorna false...
     * @param type $idpaciente
     * @return boolean
     */
    public function getPacienteMedico($idpaciente) {

        $query = new AbstractSql();

        $idmedico = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"];

        $query->setSelect("t.*");

        $query->setFrom("(
                        SELECT
                                u.nombre,
                                u.apellido,
                                0 as animal,
                                p.*,
                                DATE_FORMAT(p.fechaNacimiento,'%d/%m/%Y') as fechaNacimiento_format,
                                u.sexo,
                                mmp.medico_idmedico,
                                '' AS estado_solicitud
                        FROM
                            medicomispacientes mmp
                        INNER JOIN paciente p ON ( mmp.paciente_idpaciente = p.idpaciente )
                        INNER JOIN usuarioweb u ON (p.usuarioweb_idusuarioweb = u.idusuarioweb )
                        WHERE mmp.medico_idmedico = $idmedico 
                         
                UNION
                        SELECT
                                pf.nombre,
                                pf.apellido,
                                pf.animal,
                                p.*,
                                DATE_FORMAT(p.fechaNacimiento,'%d/%m/%Y') as fechaNacimiento_format,
                                pf.sexo,
                                mmp.medico_idmedico,
                                '' AS estado_solicitud   
                        FROM
                            medicomispacientes mmp
                        INNER JOIN paciente p ON (mmp.paciente_idpaciente = p.idpaciente)
                        INNER JOIN pacientegrupofamiliar pf ON (p.idpaciente = pf.pacienteGrupo)
                        WHERE  mmp.medico_idmedico = $idmedico
                        
                ) AS t 
                ");

        $query->setWhere("t.medico_idmedico = $idmedico");

        $query->addAnd("t.idpaciente = $idpaciente");

        $query->setGroupBy("t.idpaciente");

        $execute = $this->db->Execute($query->getSql());

        if ($execute) {
            $rdo = $execute->FetchRow();

            if ($rdo) {
                $ManagerPaciente = $this->getManager("ManagerPaciente");

                $rdo["image"] = $ManagerPaciente->getImagenPaciente($idpaciente);
                $profesional_frecuente_cabecera = $this->getManager("ManagerProfesionalesFrecuentesPacientes")->getByFieldArray(["paciente_idpaciente", "medico_cabecera"], [$idpaciente, 1]);
                if ($profesional_frecuente_cabecera) {
                    $rdo["medico_cabecera"] = $this->getManager("ManagerMedico")->get($profesional_frecuente_cabecera["medico_idmedico"]);
                }
                $rdo["imagenes_tarjeta"] = $ManagerPaciente->getImagenesIdentificacion($idpaciente);

                return $rdo;
            } else {

                throw new ExceptionErrorPage("Information non accessible");
            }
        } else {

            throw new ExceptionErrorPage("Information non accessible");
        }
    }

    /**
     * Inicialización de los pacientes provenientes del médico..
     * @param type $idpaciente
     */
    public function inicializarPacienteFromMedico($idpaciente) {

//$paciente = $this->getPacienteMedico($idpaciente);
        $paciente = $this->getManager("ManagerPaciente")->isPacienteMedico($idpaciente);
        if ($paciente) {
            $_SESSION[URL_ROOT]["medico"]['logged_account']["paciente_session"] = $paciente;
            $this->setMsg(["msg" => "Éxito",
                "result" => true,
                "idpaciente" => str2seo($paciente["idpaciente"]),
                "nombre" => str2seo($paciente["nombre"]),
                "apellido" => str2seo($paciente["apellido"])
            ]);
            return true;
        } else {
            throw new ExceptionErrorPage("Information non accessible");
//              $this->setMsg(["msg" => "Error. No puede acceder a la información del paciente seleccionado",
//                    "result" => false
//              ]);
//              return false;
        }
    }

    /**
     *  Busqueda de profesionales Segun la agenda de la semana actual       
     *
     * */
    public function getMedicosList($request, $idpaginate = null) {

        if (isset($request["do_reset"]) && $request["do_reset"] == 1) {
            $this->resetPaginate($idpaginate);
        }

        if (!is_null($idpaginate)) {
            $this->paginate($idpaginate, 10, true);
        }

        $query = new AbstractSql();
        $query->setSelect("DISTINCT(m.idmedico),m.*, uw.*");
        $query->setFrom("$this->table m "
                . "INNER JOIN usuarioweb uw ON (m.usuarioweb_idusuarioweb = uw.idusuarioweb and uw.registrado=1)");
//$query->setWhere("");

        $medicos = $this->getList($query, false, $idpaginate);

        $ManagerConsultorio = $this->getManager("ManagerConsultorio");

        foreach ($medicos as $key => $medico) {

            $medicos[$key]["imagen"] = $this->tieneImagen($medico["idmedico"]);
            $medicos[$key]["agenda"] = $this->getAgendaSemanal($medico["idmedico"]);
            $medicos[$key]["consultorio"] = $ManagerConsultorio->getConsultorioPorDefecto($medico["idmedico"]);
        }


        return $medicos;
    }

    /**
     * Método que realiza el listado paginado de la búsqueda de consultorios de medicos
     * 
     * @param array $request
     * @param type $idpaginate
     * @return type
     */
    public function getMedicosListFromBusquedaPaginado($request, $idpaginate = null) {

        if (isset($request["do_reset"]) && $request["do_reset"] == 1) {
            $this->resetPaginate($idpaginate);
        }



        if (!is_null($idpaginate)) {
            $this->paginate($idpaginate, 20);
        }

        $header_paciente = $_SESSION[URL_ROOT]["paciente_p"]['logged_account']["paciente"]["header_paciente"];

//Si el filtro es distinto de "self" o de "all" va el filter selected,que es el id del paciente perteneciente al paciente
        $idpaciente = isset($header_paciente) && $header_paciente["filter_selected"] != "self" && $header_paciente["filter_selected"] != "all" ?
                $header_paciente["filter_selected"] :
                $_SESSION[URL_ROOT]["paciente_p"]['logged_account']["paciente"]["idpaciente"];


//Seteo el current page
        $request["current_page"] = $request["current_page"] != "" ? $request["current_page"] : 1;


        SmartyPaginate::setCurrentPage($request["current_page"], $idpaginate);

        $query = new AbstractSql();

        $query->setSelect("m.*,p.pais as pais_medico,sec.sector, uw.*, cons.*, tp.titulo_profesional,
                    IF(pfp.idprofesionalesFrecuentes_pacientes > 0, 1, 0) as is_profesional_frecuente,
                    IF(pf.idprofesionalFavorito > 0, 1, 0) as is_profesional_favorito,
                    IFNULL(getProximoTurnoVC(m.idmedico),'NO_TURNO')	as proximo_turno_vc,
                    pmr.idprograma_medico_referente,
                    pmc.idprograma_medico_complementario,
                    IF(pmr.idprograma_medico_referente IS NULL,0,1)	as medico_referente,
                    IF(pmc.idprograma_medico_complementario IS NULL,0,1)	as medico_complementario,
                    IF(pmr.idprograma_medico_referente IS NULL,999999999,pref.valorPinesVideoConsulta)	as tarifa_referente,
                    IF(pmc.idprograma_medico_complementario IS NULL,999999999,pref.valorPinesVideoConsulta)	as tarifa_complementario
                    
                ");
        //fix para join en el buscador programas de salud - no por especialidad
        $queryAnd1 = $queryAnd2 = "";
        if ((int) $request["idprograma_categoria"] > 0) {
            $queryAnd1 = "AND pmr.programa_categoria_idprograma_categoria = {$request["idprograma_categoria"]} ";
            $queryAnd2 = "AND pmc.programa_categoria_idprograma_categoria = {$request["idprograma_categoria"]} ";
        }
        $query->setFrom(" medico m
                            INNER JOIN pais p ON (p.idpais=m.pais_idpais)
                            LEFT JOIN sector sec ON (sec.idsector=m.sector_idsector)
                            LEFT JOIN  v_consultorio cons ON (cons.medico_idmedico = m.idmedico and cons.flag=1)  
                            INNER JOIN usuarioweb uw ON (m.usuarioweb_idusuarioweb = uw.idusuarioweb and uw.registrado=1)
                            LEFT JOIN profesionalesfrecuentes_pacientes pfp ON (m.idmedico = pfp.medico_idmedico AND pfp.paciente_idpaciente = {$idpaciente})
                            LEFT JOIN profesionalfavorito pf ON (m.idmedico = pf.medico_idmedico AND pf.paciente_idpaciente = {$idpaciente})
                            LEFT JOIN titulo_profesional tp ON (m.titulo_profesional_idtitulo_profesional = tp.idtitulo_profesional)
                            LEFT JOIN medico_prestador prst ON (prst.medico_idmedico = m.idmedico)      
                            LEFT JOIN preferencia pref ON (m.preferencia_idPreferencia = pref.idpreferencia) 
                            LEFT JOIN especialidadmedico em ON (em.medico_idmedico = m.idmedico)
                            LEFT JOIN obrasocialmedico osm ON (osm.medico_idmedico = m.idmedico)
                            LEFT JOIN configuracionagenda ca ON (ca.consultorio_idconsultorio = cons.idconsultorio) 
                            LEFT JOIN idiomamedico idm ON (idm.medico_idMedico = m.idmedico) 
                            LEFT JOIN programa_medico_referente pmr ON (pmr.medico_idMedico = m.idmedico  {$queryAnd1}) 
                            LEFT JOIN programa_medico_complementario pmc ON (pmc.medico_idmedico = m.idmedico  {$queryAnd2})
                            LEFT JOIN programa_categoria pc ON (pmc.programa_categoria_idprograma_categoria=pc.idprograma_categoria OR pmr.programa_categoria_idprograma_categoria=pc.idprograma_categoria)
                            ");




        $query->setWhere("(pref.valorPinesConsultaExpress is not null or (cons.idconsultorio is not null and cons.flag=1))");

        $query->addAnd("m.active=1");
        $query->addAnd("m.validado=1");
        $query->addAnd("uw.active=1");
        /**
         * Agrego los and, de los filtros de búsqueda que vengan
         */
        if ($request["nueva_consulta"] == 1) {


            $this->addFiltrosBusquedaConsultas($request, $query);
        } else {

            $this->addFiltrosBusquedaToQuery($request, $query);
        }

// $query->setGroupBy("cons.idconsultorio");
        $query->setGroupBy("m.idmedico");
//$query->setOrderBy("cons.is_virtual ASC,cons.idconsultorio ASC");
        // $query->setOrderBy("medico_cabecera DESC,proximo_turno_vc ASC");
        $query->setOrderBy("tarifa_referente ASC,tarifa_complementario ASC");

        $listado = $this->getListPaginado($query, $idpaginate);

        if ($listado && count($listado) > 0) {
            $ManagerEspecialidadMedico = $this->getManager("ManagerEspecialidadMedico");
            $ManagerConsultorio = $this->getManager("ManagerConsultorio");
            $ManagerMedicoMisPacientes = $this->getManager("ManagerMedicoMisPacientes");
            $ManagerProgramaSaludExcepcion = $this->getManager("ManagerProgramaSaludExcepcion");
            $ManagerMedicoVacaciones = $this->getManager("ManagerMedicoVacaciones");
            foreach ($listado["rows"] as $key => $value) {

//OPbtengo las especialidades del médico
                $listado["rows"][$key]["especialidad"] = $ManagerEspecialidadMedico->getEspecialidadesMedico($value["idmedico"]);

                if (count($listado["rows"][$key]["especialidad"]) > 0) {
//Agrego un string con las sub especialidades

                    $sub_especialidad_str = "";
                    foreach ($listado["rows"][$key]["especialidad"] as $key1 => $especialidad) {
                        if ($especialidad["subEspecialidad"] != "") {
                            $sub_especialidad_str .= ', ' . $especialidad["subEspecialidad"];
                        }
                    }
                    $listado["rows"][$key]["sub_especialidad_str"] = substr($sub_especialidad_str, 1);
                }


//Busco la cuenta del usuario y lo que cobra el médico la video consulta
                $preferencia = $this->getManager("ManagerPreferencia")->getPreferenciaMedico($value["idmedico"]);
                $listado["rows"][$key]["preferencia"] = $preferencia;

//si el profesional ofrece los servicios solo a sus paciente, verificamos si el paciente pertenece al listado de pacientes del medico
                if ($preferencia["pacientesConsultaExpress"] == 2 || $preferencia["pacientesVideoConsulta"] == 2) {
                    $is_paciente = $ManagerMedicoMisPacientes->getRelacion($value["idmedico"], $idpaciente);
                    if (!$is_paciente) {

                        if ($preferencia["pacientesConsultaExpress"] == 2) {
                            $listado["rows"][$key]["consultaexpress_solo_pacientes"] = 1;
                        }
                        if ($preferencia["pacientesVideoConsulta"] == 2) {
                            $listado["rows"][$key]["videoconsulta_solo_pacientes"] = 1;
                        }
                    }
                }


                $listado["rows"][$key]["imagen"] = $this->getImagenMedico($value["idmedico"]);
                $listado["rows"][$key]["paciente_sincargo"] = $ManagerMedicoMisPacientes->is_paciente_sin_cargo($idpaciente, $value["idmedico"]);

                $listado["rows"][$key]["agenda"] = $this->getAgendaSemanal($value["idmedico"], $value["idconsultorio"]);
                $listado["rows"][$key]["posee_consultorio_virtual"] = $this->poseeVideoConsulta($value["idmedico"]);
//Obtengo el listado de los otros consultorios que no tenga el médico
                $listado["rows"][$key]["list_consultorios"] = $ManagerConsultorio->getOtherConsultoriosMedico($value["idmedico"], $value["idconsultorio"]);

//verificamos si es medico de cabecera
                $prof_frecuente = $this->getManager("ManagerProfesionalesFrecuentesPacientes")->getByFieldArray(["paciente_idpaciente", "medico_idmedico"], [$idpaciente, $value["idmedico"]]);
                if ($prof_frecuente["medico_cabecera"] == 1) {
                    $listado["rows"][$key]["medico_cabecera"] = 1;
                } else {
                    $listado["rows"][$key]["medico_cabecera"] = 0;
                }

                //formateamos el proximo turno disponible
                if ($listado["rows"][$key]["proximo_turno_vc"] != "NO_TURNO") {
                    $listado["rows"][$key]["proximo_turno_format"] = $this->formatProximoTurnoVC($listado["rows"][$key]["proximo_turno_vc"], $value["idmedico"]);
                }

                //verificamos si el medico esta de vacaciones
                $listado["rows"][$key]["vacaciones"] = $ManagerMedicoVacaciones->getVacacionesMedico($value["idmedico"]);
            }
        }

        return $listado;
    }

    /**
     * Método que realiza el listado paginado de la búsqueda de consultorios de medicos
     * 
     * @param array $request
     * @param type $idpaginate
     * @return type
     */
    public function getMedicosListFromBusquedaExterna($request, $idpaginate = null) {
        if (isset($request["do_reset"]) && $request["do_reset"] == 1) {
            $this->resetPaginate($idpaginate);
        }



        if (!is_null($idpaginate)) {
            $this->paginate($idpaginate, 30);
        }




//Seteo el current page
        $request["current_page"] = $request["current_page"] != "" ? $request["current_page"] : 1;


        SmartyPaginate::setCurrentPage($request["current_page"], $idpaginate);

        $query = new AbstractSql();

        $query->setSelect("m.*,p.pais as pais_medico,
            sec.sector,
            uw.*,
            cons.*,
            tp.titulo_profesional,
            IFNULL(getProximoTurnoVC(m.idmedico),'NO_TURNO')	as proximo_turno_vc,
            pmr.idprograma_medico_referente,
            pmc.idprograma_medico_complementario,
            IF(pmr.idprograma_medico_referente IS NULL,0,1)	as medico_referente,
            IF(pmc.idprograma_medico_complementario IS NULL,0,1)	as medico_complementario,
            IF(pmr.idprograma_medico_referente IS NULL,999999999,pref.valorPinesVideoConsulta)	as tarifa_referente,
            IF(pmc.idprograma_medico_complementario IS NULL,999999999,pref.valorPinesVideoConsulta)	as tarifa_complementario
             ");


        $queryAnd1 = $queryAnd2 = "";
        if ((int) $request["idprograma_categoria"] > 0) {
            $queryAnd1 = "AND pmr.programa_categoria_idprograma_categoria = {$request["idprograma_categoria"]} ";
            $queryAnd2 = "AND pmc.programa_categoria_idprograma_categoria = {$request["idprograma_categoria"]} ";
        }
        $query->setFrom(" medico m
                            INNER JOIN pais p ON (p.idpais=m.pais_idpais)
                            LEFT JOIN sector sec ON (sec.idsector=m.sector_idsector)
                            LEFT JOIN  v_consultorio cons ON (cons.medico_idmedico = m.idmedico and cons.flag=1)  
                            INNER JOIN usuarioweb uw ON (m.usuarioweb_idusuarioweb = uw.idusuarioweb and uw.registrado=1)
                            LEFT JOIN titulo_profesional tp ON (m.titulo_profesional_idtitulo_profesional = tp.idtitulo_profesional)
                            LEFT JOIN medico_prestador prst ON (prst.medico_idmedico = m.idmedico)      
                            LEFT JOIN preferencia pref ON (m.preferencia_idPreferencia = pref.idpreferencia) 
                            LEFT JOIN especialidadmedico em ON (em.medico_idmedico = m.idmedico)
                            LEFT JOIN obrasocialmedico osm ON (osm.medico_idmedico = m.idmedico)
                            LEFT JOIN configuracionagenda ca ON (ca.consultorio_idconsultorio = cons.idconsultorio) 
                            LEFT JOIN idiomamedico idm ON (idm.medico_idMedico = m.idmedico) 
                            LEFT JOIN programa_medico_referente pmr ON (pmr.medico_idmedico = m.idmedico {$queryAnd1}) 
                            LEFT JOIN programa_medico_complementario pmc ON (pmc.medico_idmedico = m.idmedico  {$queryAnd2})
                        ");



        $query->setWhere("(pref.valorPinesConsultaExpress is not null or (cons.idconsultorio is not null and cons.flag=1))");

        $query->addAnd("m.active=1");
        $query->addAnd("m.validado=1");
        $query->addAnd("uw.active=1");
        /**
         * Agrego los and, de los filtros de búsqueda que vengan
         */
        $this->addFiltrosBusquedaToQuery($request, $query);
        if (isset($request["pais_idpais"]) && $request["pais_idpais"] == 1) {
            $query->addAnd("m.pais_idpais=1");
        } else if (isset($request["pais_idpais"]) && $request["pais_idpais"] == 2) {
            $query->addAnd("m.pais_idpais=2");
        } else {
            $query->addAnd("m.pais_idpais=1 OR m.pais_idpais=2");
        }

        // $query->setGroupBy("cons.idconsultorio");
        $query->setGroupBy("m.idmedico");
        //$query->setOrderBy("cons.is_virtual ASC,cons.idconsultorio ASC");
        //$query->setOrderBy("proximo_turno_vc ASC");
        $query->setOrderBy("tarifa_referente ASC,tarifa_complementario ASC");


        $listado = $this->getListPaginado($query, $idpaginate);

        if ($listado && count($listado) > 0) {
            $ManagerEspecialidadMedico = $this->getManager("ManagerEspecialidadMedico");
            $ManagerConsultorio = $this->getManager("ManagerConsultorio");
            $ManagerMedicoVacaciones = $this->getManager("ManagerMedicoVacaciones");
            foreach ($listado["rows"] as $key => $value) {

//OPbtengo las especialidades del médico
                $listado["rows"][$key]["especialidad"] = $ManagerEspecialidadMedico->getEspecialidadesMedico($value["idmedico"]);

                if (count($listado["rows"][$key]["especialidad"]) > 0) {
//Agrego un string con las sub especialidades

                    $sub_especialidad_str = "";
                    foreach ($listado["rows"][$key]["especialidad"] as $key1 => $especialidad) {
                        if ($especialidad["subEspecialidad"] != "") {
                            $sub_especialidad_str .= ', ' . $especialidad["subEspecialidad"];
                        }
                    }
                    $listado["rows"][$key]["sub_especialidad_str"] = substr($sub_especialidad_str, 1);
                }


//Busco la cuenta del usuario y lo que cobra el médico la video consulta
                $preferencia = $this->getManager("ManagerPreferencia")->getPreferenciaMedico($value["idmedico"]);
                $listado["rows"][$key]["preferencia"] = $preferencia;


                $listado["rows"][$key]["imagen"] = $this->getImagenMedico($value["idmedico"]);
                $listado["rows"][$key]["agenda"] = $this->getAgendaSemanal($value["idmedico"], $value["idconsultorio"]);
                $listado["rows"][$key]["posee_consultorio_virtual"] = $this->poseeVideoConsulta($value["idmedico"]);
//Obtengo el listado de los otros consultorios que no tenga el médico
                $listado["rows"][$key]["list_consultorios"] = $ManagerConsultorio->getOtherConsultoriosMedico($value["idmedico"], $value["idconsultorio"]);
//formateamos el proximo turno disponible
                if ($listado["rows"][$key]["proximo_turno_vc"] != "NO_TURNO") {
                    $listado["rows"][$key]["proximo_turno_format"] = $this->formatProximoTurnoVC($listado["rows"][$key]["proximo_turno_vc"]);
                }
                //verificamos si el medico esta de vacaciones
                $listado["rows"][$key]["vacaciones"] = $ManagerMedicoVacaciones->getVacacionesMedico($value["idmedico"]);
            }
        }



        return $listado;
    }

    /**
     * Método que realiza el listado paginado de la búsqueda de profesiones por el medico
     * 
     * @param array $request
     * @param type $idpaginate
     * @return type
     */
    public function getMedicosListFromBusquedaMedicoPaginado($request, $idpaginate = null) {

        if (isset($request["do_reset"]) && $request["do_reset"] == 1) {
            $this->resetPaginate($idpaginate);
        }

        if (!is_null($idpaginate)) {
            $this->paginate($idpaginate, 10);
        }
        $idmedico = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"];




//Seteo el current page
        $request["current_page"] = $request["current_page"] != "" ? $request["current_page"] : 1;


        SmartyPaginate::setCurrentPage($request["current_page"], $idpaginate);

        $query = new AbstractSql();

        $query->setSelect("m.*, uw.*, tp.titulo_profesional, cons.*");

        $query->setFrom(" medico m   
                            INNER JOIN usuarioweb uw ON (m.usuarioweb_idusuarioweb = uw.idusuarioweb and uw.registrado=1)
                            LEFT JOIN v_consultorio cons ON (cons.medico_idmedico=m.idmedico)
                            LEFT JOIN titulo_profesional tp ON (m.titulo_profesional_idtitulo_profesional = tp.idtitulo_profesional)
                            LEFT JOIN preferencia pref ON (m.preferencia_idPreferencia = pref.idpreferencia) 
                            LEFT JOIN especialidadmedico em ON (em.medico_idmedico = m.idmedico)
                            LEFT JOIN medico_prestador prst ON (prst.medico_idmedico = m.idmedico)                             
                            LEFT JOIN obrasocialmedico osm ON (osm.medico_idmedico = m.idmedico)
                            LEFT JOIN configuracionagenda ca ON (ca.consultorio_idconsultorio = cons.idconsultorio) 
                            LEFT JOIN idiomamedico idm ON (idm.medico_idMedico = m.idmedico) ");

        $query->setWhere("m.idmedico<>$idmedico");

        $query->addAnd("m.active=1");
        $query->addAnd("m.validado=1");
        $query->addAnd("uw.active=1");

        /**
         * Agrego los and, de los filtros de búsqueda que vengan
         */
        $this->addFiltrosBusquedaToQuery($request, $query);



        $query->setGroupBy("m.idmedico");

        $listado = $this->getListPaginado($query, $idpaginate);

        if ($listado && count($listado) > 0) {
            $ManagerEspecialidadMedico = $this->getManager("ManagerEspecialidadMedico");
            $ManagerConsultorio = $this->getManager("ManagerConsultorio");
            foreach ($listado["rows"] as $key => $value) {

//Obtengo las especialidades del médico
                $listado["rows"][$key]["especialidad"] = $ManagerEspecialidadMedico->getEspecialidadesMedico($value["idmedico"]);

                if (count($listado["rows"][$key]["especialidad"]) > 0) {
//Agrego un string con las sub especialidades
                    $sub_especialidad_str = "";
                    foreach ($listado["rows"][$key]["especialidad"] as $key1 => $especialidad) {
                        if ($especialidad["subEspecialidad"] != "") {
                            $sub_especialidad_str .= ', ' . $especialidad["subEspecialidad"];
                        }
                    }
                    $listado["rows"][$key]["sub_especialidad_str"] = substr($sub_especialidad_str, 1);
                }
                $listado["rows"][$key]["posee_consultorio_virtual"] = $this->poseeVideoConsulta($value["idmedico"]);
                $listado["rows"][$key]["imagen"] = $this->getImagenMedico($value["idmedico"]);

//Obtengo el listado de los  consultorios que no tenga el médico
                $listado["rows"][$key]["list_consultorios"] = $ManagerConsultorio->getListconsultorioMedico($value["idmedico"]);
            }
        }



        return $listado;
    }

    /**
     * Método que devueleve un string indicando cuando es el proximo turno disponible del médico
     */
    public function formatProximoTurnoVC($proximo_turno, $idmedico = null) {
        if ($idmedico != null) {
            $medico = $this->get($idmedico);
            $domicilio = $this->getManager("ManagerDireccion")->get($medico["direccion_iddireccion"]);
            //echo $domicilio;
            //echo $proximo_turno;
            if ($domicilio["localidad_idlocalidad"] == '2919') {
                date_default_timezone_set("Indian/Reunion");
                $time_actual = strtotime(date('m-d-Y h:i:s a', time()));
            } else {
                $time_actual = time();
            }
        } else {
            $time_actual = time();
        }

        $hoy = date("d-m-Y", strtotime($proximo_turno)) == date("d-m-Y");

        if ($hoy) {
            $time_prox_turno = strtotime($proximo_turno);

            $time_restante = $time_prox_turno - $time_actual;
            $min_restantes = round($time_restante / 60);
            // echo "mins:$min_restantes";
            //menos de 1 h restante
            if ($min_restantes < 60) {
                $tiempo_restante = ["min" => $min_restantes, 0];
            } else {
                $horas_restantes = floor($min_restantes / 60);
                $min_parciales = round($min_restantes - ($horas_restantes * 60));
                $tiempo_restante = ["hr" => $horas_restantes, "min" => $min_parciales];
            }

            //print_r($tiempo_restante);
        } else {
            $tiempo_restante = "";
        }
        date_default_timezone_set("Europe/Paris");
        return $tiempo_restante;
    }

    private function addFiltrosBusquedaConsultas($request, &$query) {
        //Categoria de programa de salud
        if ((int) $request["idprograma_categoria"] > 0) {
            $query->addAnd("pmr.programa_categoria_idprograma_categoria = {$request["idprograma_categoria"]} OR pmc.programa_categoria_idprograma_categoria = {$request["idprograma_categoria"]} ");
        }
        //Programa de salud
        if ((int) $request["idprograma_salud"] > 0) {
            $query->addAnd("pc.programa_salud_idprograma_salud = {$request["idprograma_salud"]}");
        }
//Si no hay especialidad, retorno falso, porque es obligatoria
        if ($request["especialidad_idespecialidad"] != "") {
            $query->addAnd("em.especialidad_idespecialidad = " . $request["especialidad_idespecialidad"]);
        }

        /**
         * Filtros de rangos
         */
        if ((int) $request["rango_minimo"] > 0) {
            if ($request["tipo"] == "videoconsulta") {
                $query->addAnd("pref.valorPinesVideoConsulta >= " . $request["rango_minimo"]);
            } else {
                $query->addAnd("pref.valorPinesConsultaExpress >= " . $request["rango_minimo"]);
            }
        }

        if ((int) $request["rango_maximo"] > 0) {
            if ($request["tipo"] == "videoconsulta") {
                $query->addAnd("pref.valorPinesVideoConsulta <= " . $request["rango_maximo"]);
            } else {
                $query->addAnd("pref.valorPinesConsultaExpress <= " . $request["rango_maximo"]);
            }
        }



        if ($request["obraSocial_idobraSocial"] != "") {
            $query->addAnd("osm.obraSocial_idobraSocial=" . $request["obraSocial_idobraSocial"]);
        }
        if (isset($request["idioma_ididioma"]) && $request["idioma_ididioma"] != "") {
            $query->addAnd("idioma_ididioma=" . $request["idioma_ididioma"]);
        }
        if (isset($request["localidad_idlocalidad"]) && $request["localidad_idlocalidad"] != "") {
            $query->addAnd("localidad_idlocalidad=" . $request["localidad_idlocalidad"]);
        }

        if (isset($request["sector_idsector"]) && $request["sector_idsector"] != "") {
            $query->addAnd("sector_idsector=" . $request["sector_idsector"]);
        }
        if (isset($request["pais_idpais"]) && $request["pais_idpais"] != "") {

            $query->addAnd("m.pais_idpais=" . $request["pais_idpais"] . "|| cons.pais_idpais=" . $request["pais_idpais"]);
        }
    }

    /**
     * Método utilizado para agregar los filtros a la query de la búsqueda de profesionales
     * @param type $request
     * @param type $query
     */
    private function addFiltrosBusquedaToQuery($request, &$query) {

        //Programa de salud
        if ((int) $request["idprograma_salud"] > 0) {
            $query->addAnd("pc.programa_salud_idprograma_salud = {$request["idprograma_salud"]}");
        }
        //categorias de programa de salud
        if ((int) $request["idprograma_categoria"] > 0) {
            $query->addAnd("pmr.programa_categoria_idprograma_categoria = {$request["idprograma_categoria"]} OR pmc.programa_categoria_idprograma_categoria = {$request["idprograma_categoria"]} ");
        }
//Especialidad
        if ((int) $request["especialidad_ti"] > 0) {
            $query->addAnd("em.especialidad_idespecialidad = {$request["especialidad_ti"]}");
        }

//Sub Especialidad
        if ((int) $request["subEspecialidad_ti"] > 0) {
            $query->addAnd("em.subEspecialidad_idsubEspecialidad = {$request["subEspecialidad_ti"]}");
        }

//Sector
        if ((int) $request["sector_idsector"] > 0) {
            $query->addAnd("m.sector_idsector = {$request["sector_idsector"]}");
        }

//Prestador
        if ((int) $request["prestador_ti"] > 0) {
            $query->addAnd("prst.prestador_idprestador = {$request["prestador_ti"]}");
        }
        if ($_SESSION[URL_ROOT]["paciente_p"]['logged_account']["paciente"]["prestador_idprestador"] != "") {
            $query->addAnd("prst.prestador_idprestador = {$_SESSION[URL_ROOT]["paciente_p"]['logged_account']["paciente"]["prestador_idprestador"]}");
        }


//Mañana
        if ((int) $request["maniana_ti"] == 1) {
            $maniana_inicio = "00:00:00";
            $maniana_fin = "12:00:00";
            $query->addAnd("ca.desde BETWEEN '$maniana_inicio' AND '$maniana_fin'");
        }

//Tarde
        if ((int) $request["tarde_ti"] == 1) {
            $tarde_inicio = "12:01:00";
            $tarde_fin = "23:59:00";
            $query->addAnd("ca.desde BETWEEN '$tarde_inicio' AND '$tarde_fin'");
        }

//Sábado
        if ((int) $request["sabado_ti"] == 1) {
            $id_dia_sabado = 6;
            $query->addAnd("ca.dia_iddia = {$id_dia_sabado}");
        }

//Idioma
        if ((int) $request["ididioma_ti"] > 0) {
            $query->addAnd("idm.idioma_ididioma = {$request["ididioma_ti"]}");
        }

//Nombre de médico
        if ($request["medico_ti"] != "") {
            $query->addAnd("(uw.nombre LIKE '%{$request["medico_ti"]}%' OR uw.apellido LIKE '%{$request["medico_ti"]}%' OR CONCAT(uw.nombre, ' ', uw.apellido) LIKE '%{$request["medico_ti"]}%' )");
        }

//Servicios que ofrece
        if ((int) $request["servicio_ofrece_ti"] > 0) {
            switch ((int) $request["servicio_ofrece_ti"]) {
                case 1:
//1: Consulta Express
                    $query->addAnd("pref.valorPinesConsultaExpress > 0");
                    break;
                case 2:
//2: Turnos en consultorio
//Que no tenga nula la configuración de agenda
                    $query->addAnd("ca.idconfiguracionAgenda IS NOT NULL");
                    break;
                case 3:
//3: Video Consulta
                    $query->addAnd("pref.valorPinesVideoConsulta > 0");
                    break;
                default:
                    break;
            }
        }

//Sexo
        if ((int) $request["sexo_ti"] > 0) {
            switch ((int) $request["sexo_ti"]) {
                case 1:
//1: Masculino
                    $query->addAnd("uw.sexo = 1");
                    break;
                case 2:
//2: Femenino
                    $query->addAnd("uw.sexo = 0");
                    break;
            }
        }


//Valoración
        $flag = false;
        $valoraciones = "";
        for ($i = 1; $i <= 5; $i++) {
            if (isset($request["valoracion_{$i}_ti"]) && (int) $request["valoracion_{$i}_ti"] == 1) {
                $valoraciones .= ", {$i}";
                $flag = true;
            }
        }

        if ($flag && $valoraciones != "") {
            $valoraciones = substr($valoraciones, 1);
            $query->addAnd("getEstrellasMedicos(m.idmedico) IN ($valoraciones)");
        }


//Distancia


        if ((int) $request["distancia_ti"] > 0) {
            $distancia = (int) $request["distancia_ti"] * 1000;

            if (!is_null($distancia)) {
//Me fijo si hay una provincia cargada en los filtros de búsqueda.

                if ($request["provincia_ti"] != "") {
                    $provincia = $this->getManager("ManagerProvincia")->get($request["provincia_ti"]);
                    $location .= ", {$provincia["provincia"]}";

                    if ((int) $request["localidad_ti"] > 0) {
                        $localidad = $this->getManager("ManagerLocalidad")->get($request["localidad_ti"]);
                        if ($localidad) {
                            $location .= ", {$localidad["localidad"]}";
                        }

                        $loc = geocoder::getLocation($location);
                        $p1lat = $loc["lat"];
                        $p1lng = $loc["lng"];

                        $query->addAnd("get_distance($p1lat, $p1lng, cons.lat, cons.lng) <= $distancia");
                    }
                }
            }
        }
//Localidad
        if ((int) $request["localidad_ti"] != "") {
            $query->addAnd("cons.localidad_idlocalidad = {$request["localidad_ti"]}");
        }
//Provincia
        if ((int) $request["pais_ti"] != "") {
            $query->addAnd("m.pais_idpais=" . $request["pais_ti"] . "|| cons.pais_idpais=" . $request["pais_ti"]);
        }
    }

    /**
     * Método que arma el array con los tags inputs
     * [
     *    "id" => id de la entidad
     *    "name" => nombre de la entidad
     *    "tipo" => nombre del campo con el que voy a referenciar en el $request
     * ]
     * @param type $request
     */
    public function getTagsInputBusquedaProfesional($request) {
        $tags_inputs = array();


//Especialidad
        /*
          if ((int) $request["especialidad_ti"] > 0) {
          $ManagerEspecialidades = $this->getManager("ManagerEspecialidades");
          $especialidad = $ManagerEspecialidades->get($request["especialidad_ti"]);
          if ($especialidad) {
          $tag = array("id" => $especialidad["idespecialidad"], "tipo" => "especialidad_ti", "name" => $especialidad["especialidad"]);
          $tags_inputs[] = $tag;
          }
          } */

//Subespecialidad
        if ((int) $request["subEspecialidad_ti"] > 0) {
            $ManagerSubEspecialidades = $this->getManager("ManagerSubEspecialidades");
            $subEspecialidad = $ManagerSubEspecialidades->get($request["subEspecialidad_ti"]);
            if ($subEspecialidad) {
                $tag = array("id" => "subEspecialidad_ti-{$subEspecialidad["idsubEspecialidad"]}", "tipo" => "subEspecialidad_ti", "name" => $subEspecialidad["subEspecialidad"]);
                $tags_inputs[] = $tag;
            }
        }

        if ((int) $request["prestador_ti"] > 0) {
            $ManagerPrestador = $this->getManager("ManagerPrestador");
            $prestador = $ManagerPrestador->get($request["prestador_ti"]);
            if ($prestador) {
                $tag = array("id" => "prestador_ti-{$prestador["idprestador"]}", "tipo" => "prestador_ti", "name" => $prestador["nombre"]);
                $tags_inputs[] = $tag;
            }
        }

//Obra social
        if ((int) $request["sector_idsector"] > 0) {
            $ManagerSector = $this->getManager("ManagerSector");
            $sector = $ManagerSector->get($request["sector_idsector"]);
            if ($sector) {
                $tag = array("id" => "sector_idsector-{$sector["idsector"]}", "tipo" => "sector_idsector", "name" => $sector["sector"]);
                $tags_inputs[] = $tag;
            }
        }

//Pais
        if ((int) $request["pais_ti"] > 0) {

            $pais = $this->getManager("ManagerPais")->get($request["pais_ti"]);
            if ($pais) {
                $tag = array("id" => "pais_ti-{$pais["idpais"]}", "tipo" => "pais_ti", "name" => $pais["pais"]);
                $tags_inputs[] = $tag;
            }
        }

//Pais
        if ((int) $request["pais_idpais"] > 0) {

            switch ($request["pais_idpais"]) {
                case 1:
                    $pais = "France";
                    break;
                case 2:
                    $pais = "Luxembourg";
                    break;
                case 3:
                    $pais = "Frontalier français";
                    break;
                case 4:
                    $pais = "Frontalier belge";
                    break;
                case 5:
                    $pais = "Autre";
                    break;
            }
            $tag = array("id" => "pais_ti-{$request["pais_idpais"]}", "tipo" => "pais_ti", "name" => $pais);

            $tags_inputs[] = $tag;
        }

        if ((int) $request["sector_ti"] > 0) {

            $pais = $this->getManager("ManagerPais")->get($request["pais_ti"]);
            if ($pais) {
                $tag = array("id" => "pais_ti-{$pais["idpais"]}", "tipo" => "pais_ti", "name" => $pais["pais"]);
                $tags_inputs[] = $tag;
            }
        }

//Localidad
        if ((int) $request["localidad_ti"] > 0) {
            $ManagerLocalidad = $this->getManager("ManagerLocalidad");
            $localidad = $ManagerLocalidad->get($request["localidad_ti"]);
            if ($localidad) {
                $tag = array("id" => "localidad_ti-{$localidad["idlocalidad"]}", "tipo" => "localidad_ti", "name" => $localidad["localidad"]);
                $tags_inputs[] = $tag;
            }
        }

//Mañana 
        if ((int) $request["maniana_ti"] == 1) {
            $tag = array("id" => "maniana_ti-1", "tipo" => "maniana_ti", "name" => "Demain");
            $tags_inputs[] = $tag;
        }

//Tarde
        if ((int) $request["tarde_ti"] == 1) {
            $tag = array("id" => "tarde_ti-1", "tipo" => "tarde_ti", "name" => "Après-midi");
            $tags_inputs[] = $tag;
        }

//Sábado
        if ((int) $request["sabado_ti"] == 1) {
            $tag = array("id" => "sabado_ti-1", "tipo" => "sabado_ti", "name" => "Samedi");
            $tags_inputs[] = $tag;
        }

//Idioma
        if ((int) $request["ididioma_ti"] > 0) {
            $ManagerIdiomas = $this->getManager("ManagerIdiomas");
            $idioma = $ManagerIdiomas->get($request["ididioma_ti"]);
            if ($idioma) {
                $tag = array("id" => "ididioma_ti-{$idioma["ididioma"]}", "tipo" => "ididioma_ti", "name" => $idioma["idioma"]);
                $tags_inputs[] = $tag;
            }
        }

//Servicio que ofrece
        if ((int) $request["servicio_ofrece_ti"] > 0) {
            switch ((int) $request["servicio_ofrece_ti"]) {
                case 1:
//1: Consulta Express
                    $tag = array("id" => "servicio_ofrece_ti-1", "tipo" => "servicio_ofrece_ti", "name" => "Conseil");
                    $tags_inputs[] = $tag;
                    break;
                case 2:
//2: Video Consulta
                    $tag = array("id" => "servicio_ofrece_ti-2", "tipo" => "servicio_ofrece_ti", "name" => "Vidéo Consultation");
                    $tags_inputs[] = $tag;
                    break;
                case 3:
//3: Turnos en consultorio
//Que no tenga nula la configuración de agenda
                    $tag = array("id" => "servicio_ofrece_ti-3", "tipo" => "servicio_ofrece_ti", "name" => "Rendez-vous");
                    $tags_inputs[] = $tag;
                    break;

                default:
                    break;
            }
        }

//Sexo
        if ((int) $request["sexo_ti"] > 0) {
            switch ((int) $request["sexo_ti"]) {
                case 1:
//1: Masculino
                    $tag = array("id" => "sexo_ti-1", "tipo" => "sexo_ti", "name" => "Mâle");
                    $tags_inputs[] = $tag;
                    break;
                case 2:
//2: Femenino
                    $tag = array("id" => "sexo_ti-2", "tipo" => "sexo_ti", "name" => "Femme");
                    $tags_inputs[] = $tag;
                    break;
            }
        }

//Valoración
        for ($i = 1; $i <= 5; $i++) {
            if ((int) $request["valoracion_{$i}_ti"] == 1) {
                $estrella = "Etoiles";
                if ($i == 1) {
                    $estrella = "Etoile";
                }
                $tag = array("id" => "valoracion_{$i}_ti-{$i}", "tipo" => "valoracion_{$i}_ti", "name" => "{$i} {$estrella}");
                $tags_inputs[] = $tag;
            }
        }

//Distancia
        if ((int) $request["distancia_ti"] > 0 && ((int) $request["provincia_ti"] > 0 || (int) $request["localidad_ti"] > 0)) {
            $tag = array("id" => "distancia_ti-1", "tipo" => "distancia_ti", "name" => "{$request["distancia_ti"]} Km.");
            $tags_inputs[] = $tag;
        }

//Nombre
        if ($request["medico_ti"] != "") {
            $tag = array("id" => "medico_ti-1", "tipo" => "medico_ti", "name" => $request["medico_ti"]);
            $tags_inputs[] = $tag;
        }


        return $tags_inputs;
    }

    /**
     * 
     * @param type $x
     * @return type
     */
    private function rad($x) {
        return $x * pi() / 180;
    }

    /**
     * Comparación de las distancias mediante dos puntos.
     * Si la distancia entre los dos puntos es mayor que el tercer parametro,
     * $distancia
     * @param type $p1
     * @param type $p2
     * @param type $distancia
     * @return boolean
     */
    private function compare_distancias($p1, $p2, $distancia) {

        switch ($distancia) {
            case 1:
                $distancia = 5 * 1000;
                break;
            case 2:
                $distancia = 10 * 1000;
                break;
            case 3:
                $distancia = 20 * 1000;
                break;
            case 4:
                $distancia = 50 * 1000;
                break;
        }


        $R = 6378137;
        $dLat = $this->rad($p2["lat"] - $p1["lat"]);
        $dLong = $this->rad($p2["lng"] - $p1["lng"]);

        $a = sin($dLat / 2) * sin($dLat / 2) +
                cos($this->rad($p1["lat"])) * cos($this->rad($p2["lat"])) *
                sin($dLong / 2) * sin($dLong / 2);

        $c = 2 * atan2(sqrt($a), sqrt(1 - $a));

        $d = $R * $c;

        if ($distancia > $d) {
            return false;
        }
        return true;
    }

    /**
     * Cambio del tipo de plan
     * @param type $request
     * @return boolean
     */
    public function changeTipoPlan($request) {

        $idmedico = is_null($request[$this->id]) ? $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"] : $request[$this->id];

        $medico = $this->get($idmedico);

        $planProfesional = (int) $medico["planProfesional"] == 1 ? 0 : 1;

        $cuenta = $planProfesional == 0 ? "gratuita" : "profesional";

        if ($medico) {
            $update = parent::update(array("planProfesional" => $planProfesional), $idmedico);
            if ($update) {
                $this->setMsg(["msg" => "Ha adquirido una cuenta [[" . $cuenta . "]]", "result" => true]);
                return $update;
            }
        }

        $this->setMsg(["msg" => "No ha podido adquirir la cuenta [[" . $cuenta . "]]", "result" => false]);
        return false;
    }

    /**
     * 
     * @param type $idmedico
     * @return boolean
     */
    public function getImagenMedico($idmedico = null) {
        if (is_null($idmedico)) {
            $idmedico = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"];
        }

        if (is_file(path_entity_files("medicos/$idmedico/$idmedico.jpg"))) {
            /* $medico = array(
              "perfil" => URL_ROOT . "xframework/files/entities/medicos/$idmedico/perfil_$idmedico.jpg",
              "crop" => URL_ROOT . "xframework/files/entities/medicos/$idmedico/perfil_crop_$idmedico.jpg",
              "thumb_list" => URL_ROOT . "xframework/files/entities/medicos/$idmedico/thumb_list.jpg",
              "thumb_logo" => URL_ROOT . "xframework/files/entities/medicos/$idmedico/thumb_logo.jpg"
              ); */

            $medico = array(
                "original" => URL_ROOT . "xframework/files/entities/medicos/$idmedico/{$idmedico}.jpg?t=" . mktime(),
                "perfil" => URL_ROOT . "xframework/files/entities/medicos/$idmedico/{$idmedico}_perfil.jpg?t=" . mktime(),
                "list" => URL_ROOT . "xframework/files/entities/medicos/$idmedico/{$idmedico}_list.jpg?t=" . mktime(),
                "usuario" => URL_ROOT . "xframework/files/entities/medicos/$idmedico/{$idmedico}_usuario.jpg?t=" . mktime()
            );

            return $medico;
        } else {

            return false;
        }
    }

    /**
     *  Averigua si un medico ha subido su imagen de perfil
     *
     * */
    public function tieneImagen($idmedico) {


        if (is_file(path_entity_files("medicos/$idmedico/{$idmedico}_list.jpg"))) {

            return path_entity_files("medicos/$idmedico/{$idmedico}_list.jpg");
        } else {

            return false;
        }
    }

    private function addTagsInputString($string, $nuevo) {
        if ($string == "") {
            return $nuevo;
        } else {
            return ",," . $nuevo;
        }
    }

    /**
     *
     *  Guarda alguna de las siguientes informaciones de medico:
     *    - Formación académica
     *    - Ares de competencia
     *    - Experiencia laboral                     
     *
     * */
    public function guardarInfoPersonal($request) {

        if (isset($_SESSION[URL_ROOT][CONTROLLER]['logged_account']) && $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["tipousuario"] == "medico") {

            if ($request["foto_perfil"] != 1) {
                $especialidad_medico = $this->getManager("ManagerEspecialidadMedico")->getEspecialidadesMedico($_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"])[0];

                if ($request["pais_idpais"] == 1 && $request["tipo_especialidad"] == 1 && $especialidad_medico["requiere_numero_am"] == 1) {

                    if ($request["numero_am"] != "") {
                        if (!$this->validarNumeroAM($request["numero_am"])) {
                            $this->setMsg(["msg" => "Error. Número AM no válido", "result" => false]);
                            return false;
                        }
                    } else {
                        $this->setMsg(["msg" => "Error. Ingrese su número AM", "result" => false]);
                        return false;
                    }
                }
            }


//verificamos que se guarden solo los campos habilitados
            $to_save = array("formacionAcademica", "experienciaProfesional", "sector_idsector", "facturacion_teleconsulta", "numero_am", "numero_rpps", "numero_adeli", "titulo_profesional_idtitulo_profesional", "hash", "vc_reintegro");
            $flag = 0;

            $myRequest = array();
            foreach ($request as $key => $value) {

                if (in_array($key, $to_save)) {
                    $myRequest[$key] = $value;
                } else {
                    unset($myRequest[$key]);
                }
            }

//atencion esto lo pongo por si  esta actualizando el perfil no actualiza datos de la db
            $myRequest[$this->id] = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"];

            $result = parent::update($myRequest, $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"]);
            //si esta cargando la foto de perfil y es PNG la convertimos a JPG
            if ($request["foto_perfil"] == 1) {
                $idmedico = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"];
                if (is_file(path_entity_files("medicos/$idmedico/$idmedico.png"))) {
                    $this->processImagePNG($idmedico);
                }
            }
//unificamos las tarifas del medico del sector 1 -> No posee 1 sola tarifa de VC
            if ($myRequest["sector_idsector"] == 1) {
                $ManagerPreferencia = $this->getManager("ManagerPreferencia");
                $preferencia = $ManagerPreferencia->getPreferenciaMedico($_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"]);
                $especialidad = $this->getManager("ManagerEspecialidadMedico")->getEspecialidadesMedico($_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"]);

                if ($preferencia && $especialidad[0]["max_vc_turno"] != "") {

                    $precio_videoconsulta = $especialidad[0]["max_vc_turno"];
                    $upd_preferencia = $ManagerPreferencia->update(["valorPinesVideoConsulta" => $precio_videoconsulta, "valorPinesVideoConsultaTurno" => $precio_videoconsulta], $preferencia["idpreferencia"]);
                    if (!$upd_preferencia) {
                        $this->setMsg(["result" => false, "msg" => "Error, no hemos podido guardar la información, intentelo nuevamente"]);
                        return false;
                    }
                }
            }
            if ($result) {

// Fix 18/06/2019: vamos a devolver si tiene o no que recargar la pagina para que se actualicen los contadores de info profesional.
// vamos a validar: {if $info_medico.medico.numero_am=="" || $info_medico.medico.sector_idsector=="" || $info_medico.medico.facturacion_teleconsulta==""}
                $medico = $this->get($_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"], true);
                if ($medico["pais_idpais"] == 1 && $medico["numero_am"] != "" && $medico["sector_idsector"] != "" && $medico["facturacion_teleconsulta"] != "") {
                    $reload_info_profesional = 1;
                } else {
                    $reload_info_profesional = 0;
                }

// <--
                $this->setMsg(["result" => true, "msg" => "Se ha actualizado con éxito la información",
                    "reload_info_profesional" => "$reload_info_profesional",
                    "imgs" => $this->getImagenMedico($_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"])
                ]);

// <-- LOG
                $log["data"] = "Modify data related to Professional";
                $log["page"] = "Professional information";
                $log["action"] = "val"; //"val" "vis" "del"
                $log["purpose"] = "Update professional info";

                $ManagerLog = $this->getManager("ManagerLog");
                $ManagerLog->track($log);
// 


                return true;
            } else {
                $this->setMsg(["result" => false, "msg" => "Error, no hemos podido guardar la información, intentelo nuevamente"]);
                return false;
            }
        } else {
            $this->setMsg(["result" => false, "msg" => "Error, acceso denegado"]);
            return false;
        }
    }

    /**
     *  Método que procesa las imagenes de perfil en formato PNG y las convierte a JPG 
     */
    public function processImagePNG($id) {
        //obtenemos todos los thumbs que se generaron
        $files[] = "{$id}";
        foreach ($this->thumbs_config as $thumb) {
            $files[] = "{$id}{$thumb["suffix"]}";
        }

        //converttimos todos los archivos y thumbs
        foreach ($files as $filename) {
            if (is_file(path_entity_files("medicos/$id/$filename.png"))) {
                $filenamePNG = path_entity_files("medicos/$id/$filename.png");
                $filenameJPG = path_entity_files("medicos/$id/$filename.jpg");
                $image = imagecreatefrompng($filenamePNG);
                $bg = imagecreatetruecolor(imagesx($image), imagesy($image));
                imagefill($bg, 0, 0, imagecolorallocate($bg, 255, 255, 255));
                imagealphablending($bg, TRUE);
                imagecopy($bg, $image, 0, 0, 0, 0, imagesx($image), imagesy($image));
                imagedestroy($image);
                $quality = 70;
                imagejpeg($bg, $filenameJPG, $quality);

                //borramos el png original
                imagedestroy($bg);
                unlink($filenamePNG);
            }
        }
    }

    /**
     *  Agenda semanal en base a la fecha pasada como parametro
     *
     *
     * */
    public function getAgendaSemanal($idmedico, $idconsultorio, $fecha = null) {

//si no pide fecha tomo la semana actual
        if (is_null($fecha)) {
            $fecha = date("d/m/Y");
            $dia_comp = $dia_hoy = date("d");
            $mes_comp = $mes_hoy = date("m");
            $anio_comp = $anio_hoy = date("Y");
            $semana_comp = date("W", mktime(0, 0, 0, $mes_comp, $dia_comp, $anio_comp));
        } else {

            list($mes_hoy, $dia_hoy, $anio_hoy) = preg_split("[/]", $fecha);
            $fecha = date("d/m/Y", mktime(0, 0, 0, $mes_hoy, $dia_hoy, $anio_hoy));
//Esto es para comparar la semana si es la actual o no lo es
            $dia_comp = date("d");
            $mes_comp = date("m");
            $anio_comp = date("Y");
            $semana_comp = date("W", mktime(0, 0, 0, $mes_comp, $dia_comp, $anio_comp));
        }

        $fecha_sql = $this->sqlDate($fecha, '-', true);

//busco la configuracion de horarios del medico
        $ManagerTurno = $this->getManager("ManagerTurno");

//$fecha_turnos = date("Y-m-d H:i:s");
        $turnoConfig = $ManagerTurno->getTodosHorariosSinTurnoMedico($idmedico, $idconsultorio, $fecha_sql);


        // busco los periodos de vacaciones, para luego setear la bandera vacaciones
        $vacaciones_medico = $this->getManager("ManagerMedicoVacaciones")->listado_vacaciones($idmedico);

        $agenda = array();

        $diaSemana = date("w", mktime(0, 0, 0, $mes_hoy, $dia_hoy, $anio_hoy));


        for ($dia = 1; $dia <= 7; $dia++) {
            $agenda[$dia]["fecha"] = date("Y-m-d", mktime(0, 0, 0, $mes_hoy, $dia_hoy + ($dia - $diaSemana), $anio_hoy));
            //echo  "$dia: ".$agenda[$dia]["fecha"]."<br />";
            foreach ($vacaciones_medico as $periodo_vacaciones) {
                // si la fecha esta dentro del periodo de vacaciones pongo el flag vacaciones en 1
                if ($periodo_vacaciones["desde"] <= $agenda[$dia]["fecha"] && $periodo_vacaciones["hasta"] >= $agenda[$dia]["fecha"]) {

                    $agenda[$dia]["vacaciones"] = '1';
                }
            }
        }


        if ($turnoConfig) {

            foreach ($turnoConfig as $key => $turno) {


                list($y, $m, $d) = preg_split("[-]", $turno["fecha"]);
                $dia = date("w", mktime(0, 0, 0, $m, $d, $y));


                list($h_d, $m_d, $s_d) = explode(":", $turno["horarioInicio"]);
                $desde = mktime($h_d, $m_d, $s_d);


                $turno_necesario = array(
                    "horario" => date("H:i", $desde),
                    "disponible" => true,
                    "idturno" => $turno["idturno"]
                );
                $agenda[$dia]["turnos"][] = $turno_necesario;
            }
        } else {

//Quiere decir que no hay horarios sin turnos
//Tengo que llevarlo a la semana del próximo turno disponible si es que hay
            $turno = $ManagerTurno->getNextTurnoDisponble($idmedico, $fecha, $idconsultorio);

            if ($turno) {
//Se necesita la cantidad de semanas que va a tener que avanzar para actualizar el módulo en caso
//de que haga Click en getNextTurnoDisponible del HTML
                list($anio, $mes, $dia) = preg_split("[-]", $turno["fecha"]);
                $semana_turno_disponible = date("W", mktime(0, 0, 0, $mes, $dia, $anio));
//Las diferencias de semanas serán las de $semana_turno_disponible - $semana de hoy
                $fecha = date("d/m/Y");
                $dia_comp = $dia_hoy = date("d");
                $mes_comp = $mes_hoy = date("m");
                $anio_comp = $anio_hoy = date("Y");
                $semana_comp = date("W", mktime(0, 0, 0, $mes_comp, $dia_comp, $anio_comp));

                $agenda["fecha"] = $turno["fecha"];
                $agenda["idturno"] = $turno["idturno"];
                $agenda["horarioInicio"] = $turno["horarioInicio"];
                $agenda["diferencia_semana"] = $semana_turno_disponible - $semana_comp;
                $agenda["hay_siguiente"] = "1";
            } else {
                $agenda["hay_siguiente"] = "2";
            }
        }




        return $agenda;
    }

    /*
     * jQuery Form Plugin; v20141005
     * Version : v2.5
     * http://www.itechflare.com/
     * Copyright (c) 2014 iTechFlare; Licensed: GPL
     * Developer: Abdulrhman Elbuni (mindsquare)
     * Description: This PHP source file is responsiple to process and store the uploaded images (GIF, PNG, JPG, JPEG).
     * And in contrast with other image uploading plugins, there is no contraints on width/height of the images, the script 
     * will intelligently resize the uploaded picture according to the canvas resolution defined, and according to the aspect 
     * ratio of the uploaded picture. The resizing process will happen before storage.
     * Using this script, the developers can also incorporate the uploaded image with any user using there own native techniques, and the places
     * where the developers should add thier custom database SQL script is annotated below along with full documentation.
     */

    public function insert_img($request) {


############ Edit settings ##############
        $imageURLFromClient = URL_ROOT . "xframework/files/entities/medicos/" . $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"] . "/"; // From client side, define the uploads folder url ?
        $ThumbSquareSize = 64; //Thumbnail will be 200x200
        $thumbnails = true; // Disable generating thumbnails
        $ThumbPrefix = "perfil_logo"; //Normal thumb Prefix
        $DestinationDirectory = path_entity_files("medicos/" . $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"] . "/");
        $Quality = 90; //jpeg quality
//---------------------- AGREGADO DE THUMB
        $send_time = false;

#########################################

        if (isset($request) && isset($request["w"]) && isset($request["h"]) && isset($request["id"]) && isset($request["ImageName"])) {
############ Dynamic settings ##############
            $imageQuality = $request['quality'];
            $imageName = $request["ImageName"];
            $container_width = $request["w"];
            $container_height = $request["h"];
            $dynamicStorage = isset($request["dynamicStorage"]) ? $request["dynamicStorage"] : false;
##########################################
// Create uploads folder if doesn't exist
            if (!file_exists($imageURLFromClient)) {
                mkdir($imageURLFromClient, 0777, true);
            }

// check $_FILES['ImageFile'] not empty
            if (!isset($_FILES[$imageName]) || !is_uploaded_file($_FILES[$imageName]['tmp_name'])) {
                $this->Report_Error('Error al subir el archivo!'); // output error when above checks fail.
            }


            $ImageName = str_replace(' ', '-', strtolower($_FILES[$imageName]['name'])); //get image name
            $ImageSize = $_FILES[$imageName]['size']; // get original image size
            $TempSrc = $_FILES[$imageName]['tmp_name']; // Temp name of image file stored in PHP tmp folder
            $ImageType = $_FILES[$imageName]['type']; //get file type, returns "image/png", image/jpeg, text/plain etc.
//Let's check allowed $ImageType, we use PHP SWITCH statement here
            switch (strtolower($ImageType)) {
                case 'image/png':
//Create a new image from file
                    $CreatedImage = imagecreatefrompng($_FILES[$imageName]['tmp_name']);
                    break;
                case 'image/gif':
                    $CreatedImage = imagecreatefromgif($_FILES[$imageName]['tmp_name']);
                    break;
                case 'image/jpeg':
                case 'image/pjpeg':
                    $CreatedImage = imagecreatefromjpeg($_FILES[$imageName]['tmp_name']);
                    break;
                default:
                    $this->Report_Error('Archivo no Soportado, debe ser jpg!'); //output error and exit
            }

//PHP getimagesize() function returns height/width from image file stored in PHP tmp folder.
//Get first two values from image, width and height. 
//list assign svalues to $CurWidth,$CurHeight
            list($CurWidth, $CurHeight) = getimagesize($TempSrc);

            $image_ratio = $CurWidth / $CurHeight;

            $src_width = $CurWidth;
            $src_height = $CurHeight;
// Resize image proportionally according to the size of container
            if ($CurWidth > $container_width) {
                $processed = true;
                $CurWidth = $container_width;
                $CurHeight = $CurWidth / $image_ratio;
            }
            if ($CurHeight > $container_height) {
                $CurHeight = $container_height;
                $CurWidth = $CurHeight * $image_ratio;
            }

            if ($CurWidth < $container_width) {
                $processed = true;
                $CurWidth = $container_width;
                $CurHeight = $CurWidth / $image_ratio;
            }
            if ($CurHeight < $container_height) {
                $CurHeight = $container_height;
                $CurWidth = $CurHeight * $image_ratio;
            }

            $supposedWidth = $CurWidth;
            $supposedHeight = $CurHeight;

            switch ($imageQuality) {
                case 2:
                    if ($container_width * 2 < $src_width && $container_height * 2 < $src_height) {
                        $CurHeight = $CurHeight * 2;
                        $CurWidth = $CurWidth * 2;
                    }
                    break;
                case 3:
                    if ($container_width * 3 < $src_width && $container_height * 3 < $src_height) {
                        $CurHeight = $CurHeight * 3;
                        $CurWidth = $CurWidth * 3;
                    }
                    break;
                default:
                    break;
            }

//Get file extension from Image name, this will be added after random name
            $ImageExt = substr($ImageName, strrpos($ImageName, '.'));
            $ImageExt = str_replace('.', '', $ImageExt);

//remove extension from filename
            $ImageName = preg_replace("/\\.[^.\\s]{3,4}$/", "", $ImageName);

//Construct a new name with random number and extension.

            $NewImageName = 'perfil_' . $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"] . '.' . $ImageExt;



//set the Destination Image
            $thumb_DestRandImageName = $DestinationDirectory . $ThumbPrefix . '.' . $ImageExt; //Thumbnail name with destination directory
            $DestRandImageName = $DestinationDirectory . $NewImageName; // Image with destination directory
//Me fijo si existe la imagen, porque si es así se mandará un ms con un time
            if (is_file($DestRandImageName)) {
                unlink($DestRandImageName);
                $send_time = true;
            }

//Resize image to Specified Size by calling resizeImage function.
            if ($this->resizeImage($CurWidth, $CurHeight, $DestRandImageName, $CreatedImage, $Quality, $ImageType, $src_width, $src_height)) {
                if ($thumbnails) {

                    /**
                     * Agregado de los thumbs
                     */
                    $manImg = new Images();

                    $this->delete_thumb();

                    if (count($this->thumbs_config) > 0) {
                        foreach ($this->thumbs_config as $key => $config) {

//evaluar anchos y si es un thumb proporcional					
                            $rdo = $manImg->resizeImgProportional($DestRandImageName, path_entity_files("medicos/" . $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"] . "/" . $config["suffix"] . ".jpg"), $config["w"]);
                        }
                    }

                    if ($send_time) {
                        $imgSrc = $imageURLFromClient . $NewImageName . "?ms=" . time();
                    } else {
                        $imgSrc = $imageURLFromClient . $NewImageName;
                    }

                    $json = array(
                        "imgSrc" => $imgSrc,
                        "thumbSrc" => $imageURLFromClient . 'thumb_logo.jpg',
                        "width" => $supposedWidth,
                        "height" => $supposedHeight
                    );

                    $_SESSION[URL_ROOT][CONTROLLER]['logged_account']['mi_logo'] = true;

                    echo json_encode($json);
                } else {
                    $json = array(
                        "imgSrc" => $imageURLFromClient . $NewImageName . "?ms=" . time(),
                        "thumbSrc" => $imageURLFromClient . 'thumb_logo.jpg',
                        "width" => $supposedWidth,
                        "height" => $supposedHeight
                    );

                    echo json_encode($json);
                }
            } else {
                $this->Report_Error('Resize Error');
            }
        }





// Handling position save command
        if (isset($request["top"]) || isset($request["left"])) { {


                if (!isset($request['hardTrim'])) {
                    $json = array(
                        "msg" => 'true'
                    );

                    echo json_encode($json);

                    return;
                }

                $TempSrc = $request['src'];
                $quality = $request['quality'];
                $pathInfo = pathinfo($TempSrc);
                $y = $request["top"];
                $x = $request["left"];
                $cWidth = $request["width"];
                $cHeight = $request["height"];

// Fixed ? character availablility
                if (strpos($pathInfo['basename'], '?') !== false) {
                    $positiona = strpos($pathInfo['basename'], '?');
                    $pathInfo['basename'] = substr($pathInfo['basename'], 0, $positiona);
                }
                if (strpos($pathInfo['extension'], '?') !== false) {
                    $positionb = strpos($pathInfo['extension'], '?');
                    $pathInfo['extension'] = substr($pathInfo['extension'], 0, $positionb);
                }

                list($CurWidth, $CurHeight) = getimagesize($DestinationDirectory . $pathInfo['basename']);

// The image has already been refined
                if ($quality == 2) {
// If image size greater than container's size
                    if (($CurWidth - 10) > $cWidth) {
                        $y = $y * 2;
                        $x = $x * 2;
                        $cWidth = $cWidth * 2;
                        $cHeight = $cHeight * 2;
                    }
                } elseif ($quality == 3) {
// If image size greater than container's size
                    if (($CurWidth - 10) > ($cWidth * 2)) {
                        $y = $y * 3;
                        $x = $x * 3;
                        $cWidth = $cWidth * 3;
                        $cHeight = $cHeight * 3;
                    }
                }

                if ($request['hardTrim'] == true) {
                    try {

                        $filename = $DestinationDirectory . $pathInfo['basename'];

                        list($width, $height) = getimagesize($filename);
                        $new_width = $width;
                        $new_height = $height;

// Resample
                        $image_p = imagecreatetruecolor($cWidth, $cHeight);

                        switch (strtolower($pathInfo['extension'])) {
                            case "gif" :
                                $image = imageCreateFromGif($filename);
                                break;
                            case "jpeg":
                            case "jpg":
                                $image = imageCreateFromJpeg($filename);
                                break;
                            case "png":
                                $image = imageCreateFromPng($filename);
                                break;
                            case "bmp":
                                $image = imageCreateFromBmp($filename);
                                break;
                        }
                        if (!imagecopyresampled($image_p, $image, 0, 0, abs($x), abs($y), $cWidth, $cHeight, $cWidth, $cHeight)) {
                            Report_Error('Image could not be processed! Only [png,jpg,gif] are allowed');
                        }

// Output
                        $imgTempName = "perfil_crop_" . $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"] . ".jpg";
                        if (is_file($DestinationDirectory . $imgTempName)) {
                            unlink($DestinationDirectory . $imgTempName);
                        }
                        if (!imagejpeg($image_p, $DestinationDirectory . $imgTempName, 100)) {
                            Report_Error('Image could not be processed! Only [png,jpg,gif] are allowed');
                        }

//Destroy image, frees memory	
                        if (is_resource($image)) {
                            imagedestroy($image);
                        }


                        /**
                         * Agregado de los thumbs
                         */
                        $manImg = new Images();


                        if (is_file($DestinationDirectory . $imgTempName)) {
                            $send_time = true;
                        }

                        $this->delete_thumb();

                        if (count($this->thumbs_config) > 0) {
                            foreach ($this->thumbs_config as $key => $config) {

//evaluar anchos y si es un thumb proporcional					
                                $rdo = $manImg->resizeImgProportional($DestinationDirectory . $imgTempName, path_entity_files("medicos/" . $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"] . "/" . $config["suffix"] . ".jpg"), $config["w"]);
                            }
                        }

                        if ($send_time) {
                            $imgSrc = $pathInfo['dirname'] . '/' . $imgTempName . "?ms=" . time();
                        } else {
                            $imgSrc = $pathInfo['dirname'] . '/' . $imgTempName;
                        }


                        $json = array(
                            "result" => true,
                            "msg" => 'true',
                            "height" => $request["height"],
                            "width" => $request["width"],
                            "imgSrc" => $imgSrc
                        );



                        echo json_encode($json);
                    } catch (Exception $e) {
                        Report_Error($e->getMessage());
                        return;
                    }
                }
            }
        }

// Handling image delete command
// POST
// command: delete
// id: The ID name of the specific image container that has been deleted
        if (isset($request["command"]) && isset($request["id"])) {
            $DestinationDirectory = path_entity_files("medicos/" . $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"] . "/");
            $ImageExt = '.jpg';
            $NewImageName = 'perfil_' . $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"] . $ImageExt;

            if (is_file($DestinationDirectory . 'perfil_crop_' . $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"] . $ImageExt)) {
                unlink($DestinationDirectory . 'perfil_crop_' . $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"] . $ImageExt);
            }

            if (is_file($DestinationDirectory . $NewImageName)) {
                unlink($DestinationDirectory . $NewImageName);
            }

            if (count($this->thumbs_config) > 0) {
                foreach ($this->thumbs_config as $key => $config) {


                    unlink($DestinationDirectory . $config["suffix"] . ".jpg");
                }
            }

            $_SESSION[URL_ROOT][CONTROLLER]['logged_account']['mi_logo'] = false;

            $json = array(
                "msg" => 'delete'
            );
            echo json_encode($json);
        }
    }

    /*
     * 
     * MÉTODOS AUXILIARES PARA UPLOAD DE LA IMAGEN
     */

    private function Report_Error($error) {
        $json = array(
            "msg" => 'false',
            "error" => $error
        );
        $_SESSION[URL_ROOT][CONTROLLER]['logged_account']['mi_logo'] = false;
        echo json_encode($json);
//die();
    }

//This function corps image to create exact square images, no matter what its original size!
    private function cropImage($CurWidth, $CurHeight, $iSize, $DestFolder, $SrcImage, $Quality, $ImageType) {
//Check Image size is not 0
        if ($CurWidth <= 0 || $CurHeight <= 0) {
            return false;
        }

//abeautifulsite.net has excellent article about "Cropping an Image to Make Square bit.ly/1gTwXW9
        if ($CurWidth > $CurHeight) {
            $y_offset = 0;
            $x_offset = ($CurWidth - $CurHeight) / 2;
            $square_size = $CurWidth - ($x_offset * 2);
        } else {
            $x_offset = 0;
            $y_offset = ($CurHeight - $CurWidth) / 2;
            $square_size = $CurHeight - ($y_offset * 2);
        }

        $NewCanves = imagecreatetruecolor($iSize, $iSize);
        if (imagecopyresampled($NewCanves, $SrcImage, 0, 0, $x_offset, $y_offset, $iSize, $iSize, $square_size, $square_size)) {
            switch (strtolower($ImageType)) {
                case 'image/png':
                    imagepng($NewCanves, $DestFolder);
                    break;
                case 'image/gif':
                    imagegif($NewCanves, $DestFolder);
                    break;
                case 'image/jpeg':
                case 'image/pjpeg':
                    imagejpeg($NewCanves, $DestFolder, $Quality);
                    break;
                default:
                    return false;
            }
//Destroy image, frees memory	
            if (is_resource($NewCanves)) {
                imagedestroy($NewCanves);
            }
            return true;
        }
    }

// This function will proportionally resize image 
    private function resizeImage($CurWidth, $CurHeight, $DestFolder, $SrcImage, $Quality, $ImageType, $src_width, $src_height) {
//Check Image size is not 0
        if ($CurWidth <= 0 || $CurHeight <= 0) {
            return false;
        }

        $NewWidth = ceil($CurWidth);
        $NewHeight = ceil($CurHeight);

//Construct a proportional size of new image
        $NewCanves = imagecreatetruecolor($NewWidth, $NewHeight);

// Resize Image
        if (imagecopyresized($NewCanves, $SrcImage, 0, 0, 0, 0, $NewWidth, $NewHeight, $src_width, $src_height)) {
            switch (strtolower($ImageType)) {
                case 'image/png':
                    imagepng($NewCanves, $DestFolder);
                    break;
                case 'image/gif':
                    imagegif($NewCanves, $DestFolder);
                    break;
                case 'image/jpeg':
                case 'image/pjpeg':
                    imagejpeg($NewCanves, $DestFolder, $Quality);
                    break;
                default:
                    return false;
            }
//Destroy image, frees memory	
            if (is_resource($NewCanves)) {
                imagedestroy($NewCanves);
            }
            return true;
        }
    }

    /**
     * Eliminación multiple de los medicos
     * También se van a eliminar los madicos. Esto quedará así ya que por el 
     * momento se toma como una relación de 1 a 1 entre usuario y medico
     * @param type $ids
     * @param type $force
     * @return boolean
     */
    public function deleteMultiple($ids, $force = false) {

//Obtengo los records para eliminar
        $records = explode(",", $ids);

        $managerUsuarioWeb = $this->getManager("ManagerUsuarioWeb");

        if (count($records) == 0) {

            $this->setMsg(["result" => false, "msg" => "No se han seleccionado médicos para desactivar"]);

            return false;
        } else {
            $result = true;
            foreach ($records as $id) {
                $entity = $this->get($id);

                $rdo1 = $managerUsuarioWeb->delete($entity["usuarioweb_idusuarioweb"], $force);

                $rdo2 = parent::update([$this->flag => 0], $id);
                if (!$rdo1 || !$rdo2) {
                    $result = false;
                }
            }
            if ($result) {
                if (count($records) == 1) {
                    $this->setMsg(["result" => true, "msg" => "Se ha desactivado la cuenta con éxito."]);
                } else {

                    $this->setMsg(["result" => true, "msg" => "Se han desactivado las cuentas con éxito."]);
                }




                return true;
            } else {
                if (count($records) == 1) {
                    $this->setMsg(["result" => false, "msg" => "Ha ocurrido un error al desactivar la cuenta."]);
                } else {
                    $this->setMsg(["result" => false, "msg" => "Ha ocurrido un error al desactivar las cuentas."]);
                }



                return false;
            }
        }
    }

    /*     * Metodo que realiza la activacion de los medicos
     * 
     * @param type $ids
     * @return boolean
     */

    public function activeMultiple($ids) {
//Obtengo los records para activar
        $records = explode(",", $ids);
        $managerUsuarioWeb = $this->getManager("ManagerUsuarioWeb");

        if (count($records) == 0) {

            $this->setMsg(["result" => false, "msg" => "No se han seleccionado médicos para activar"]);

            return false;
        } else {

            $result = true;
            foreach ($records as $id) {
                $medico = $this->get($id);
                $rdo1 = $managerUsuarioWeb->update(["active" => 1], $medico["usuarioweb_idusuarioweb"]);
                $rdo2 = $this->basic_update(["active" => 1], $id);
                if (!$rdo1 || !$rdo2) {
                    $result = false;
                }
            }
            if ($result) {
                if (count($records) == 1) {

                    $this->setMsg(["result" => true, "msg" => "Se ha activado la cuenta con éxito."]);
                } else {

                    $this->setMsg(["result" => true, "msg" => "Se han activado las cuentas con éxito."]);
                }


                return true;
            } else {
                if (count($records) == 1) {
                    $this->setMsg(["result" => false, "msg" => "Ha ocurrido un error al activar la cuenta."]);
                } else {

                    $this->setMsg(["result" => false, "msg" => "Ha ocurrido un error al activar las cuentas."]);
                }

                return false;
            }
        }
    }

    /**
     * Método que elimina los thumb si es que hay 
     */
    private function delete_thumb() {
        $DestinationDirectory = path_entity_files("medicos/" . $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"] . "/");
        if (count($this->thumbs_config) > 0) {
            foreach ($this->thumbs_config as $key => $config) {
                $file_name = $DestinationDirectory . $config["suffix"] . ".jpg";
                if (is_file($file_name)) {
                    unlink($file_name);
                }
            }
        }
    }

    /**
     * Método que se utiliza para enviar el código de verificación al médico
     * @return boolean
     */
    public function sendSMSValidacion($idmedico = null) {

        if (is_null($idmedico)) {
            $idmedico = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"];
        }
        $medico = parent::get($idmedico);


        $numero = /* $medico["caracteristicaCelular"] . */$medico["numeroCelular"];

        $caracteres = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890";
        $numerodeletras = 5;

        $codigo = "";
        for ($i = 0; $i < $numerodeletras; $i++) {
            $codigo .= substr($caracteres, rand(0, strlen($caracteres)), 1); /* Extraemos 1 caracter de los caracteres 
              entre el rango 0 a Numero de letras que tiene la cadena */
        }
        if (defined("SMS_TEST")) {
            $codigo = "12345";
        }


//Actualizo el código de validación de celular
        $id = parent::update(array("codigoValidacionCelular" => $codigo), $medico["idmedico"]);
        if (!$id) {
            $this->setMsg(["msg" => "Se produjo un error intente más tarde.", "result" => false]);
            return false;
        }

        $cuerpo = "Code de vérification WorknCare: " . $codigo;

        /**
         * Inserción del SMS en la lista de envio
         */
        $ManagerLogSMS = $this->getManager("ManagerLogSMS");
        $sms = $ManagerLogSMS->insert([
            "dirigido" => 'M',
            //"paciente_idpaciente" => $evento["paciente_idpaciente"],
            "medico_idmedico" => $idmedico,
            "contexto" => "SMS Validación",
            "texto" => $cuerpo,
            "numero_cel" => $numero
        ]);


        if ($sms) {
            $this->setMsg(["msg" => "Se ha enviado un SMS a su celular.", "result" => true]);
            return true;
        } else {
            $this->setMsg($ManagerLogSMS->getMsg());

            return false;
        }
    }

    /**
     * Chequeo del número que ingresó el médico para la validacion
     * @param type $request
     * @return boolean
     */
    public function checkValidacionCelular($request) {

        if ($request["idmedico"] == "") {
            $idmedico = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"];
        } else {
            $idmedico = $request["idmedico"];
        }
        $medico = parent::get($idmedico);
        $request["codigoValidacionCelular"] = strtoupper(trim($request["codigoValidacionCelular"]));
        //  fIX PARA PODER HACER LOGIN DESDE TEST
        if (defined("SMS_TEST") && $request["codigoValidacionCelular"] == 12345) {
            $medico["codigoValidacionCelular"] = 12345;
        }

        if (($request["codigoValidacionCelular"] == $medico["codigoValidacionCelular"]) && ($request["codigoValidacionCelular"] != "")) {

            $rdo = parent::update(array("celularValido" => 1), $idmedico);

            if ($rdo) {
                $this->setMsg(["msg" => "El celular ha sido validado", "result" => true]);
                return true;
            } else {
                $this->setMsg(["msg" => "El código de validación no es válido", "result" => false]);
                return false;
            }
        } else {
            $this->setMsg(["msg" => "El código de validación no es válido", "result" => false]);
            return false;
        }
    }

    /**
     * Chequeo del número que ingresó el médico para la validacion del nuevo mail
     * @param type $request
     * @return boolean
     */
    public function checkValidacionEmail($request) {
        $idmedico = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"];
        $medico = $this->get($idmedico);

        $request["codigoValidacionEmail"] = strtoupper(trim($request["codigoValidacionEmail"]));
        if (($request["codigoValidacionEmail"] == $medico["codigoValidacionEmail"]) && ($request["codigoValidacionEmail"] != "")) {
            $this->db->StartTrans();
            $rdo = $this->getManager("ManagerUsuarioWeb")->basic_update(["email" => $medico["cambioEmail"]], $medico["usuarioweb_idusuarioweb"]);
            $rdo1 = parent::update(array("codigoValidacionEmail" => "", "cambioEmail" => ""), $idmedico);

            if ($rdo && $rdo1) {
                $this->setMsg(["msg" => "El email ha sido validado", "result" => true]);
                $this->db->CompleteTrans();
                return true;
            } else {
                $this->setMsg(["msg" => "No se pudo validar el codigo", "result" => false]);
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                return false;
            }
        } else {
            $this->setMsg(["msg" => "El código de validación no es válido", "result" => false]);
            return false;
        }
    }

    /**
     * Método que retorna el listado de los médicos de acuerdo a los filtros de búsqueda presentados...
     * 
     * @param type $request
     * @return type
     */
    public function getMedicoCompartirList($request) {
        $idmedico = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"];
        $query = new AbstractSql();

        $query->setSelect("m.idmedico,                    
                            uw.nombre,
                            uw.apellido,
                            e.especialidad,
                            se.subEspecialidad,
                            tp.titulo_profesional
                    ");

        $query->setFrom("$this->table m 
                            INNER JOIN usuarioweb uw ON (m.usuarioweb_idusuarioweb=uw.idusuarioweb and uw.registrado=1)
                            LEFT JOIN especialidadmedico em ON (m.idmedico = em.medico_idmedico)
                            LEFT JOIN especialidad e ON(em.especialidad_idespecialidad = e.idespecialidad)
                            LEFT JOIN subespecialidad se ON(em.subEspecialidad_idsubEspecialidad = se.idsubEspecialidad)
                            LEFT JOIN titulo_profesional tp ON(m.titulo_profesional_idtitulo_profesional = tp.idtitulo_profesional)
                    ");
        $query->setWhere("m.idmedico<>$idmedico");
        if (isset($request["especialidad_idespecialidad"]) && $request["especialidad_idespecialidad"] != "") {
            $rdo = cleanQuery($request["especialidad_idespecialidad"]);
            $query->addAnd("em.especialidad_idespecialidad = $rdo");
        }

        if (isset($request["idsubespecialidad_medico"]) && $request["idsubespecialidad_medico"] != "") {
            $rdo = cleanQuery($request["idsubespecialidad_medico"]);
            $query->addAnd("em.subEspecialidad_idsubEspecialidad = $rdo");
        }

        if (isset($request["nombre_medico"]) && $request["nombre_medico"] != "") {
            $rdo = cleanQuery($request["nombre_medico"]);
            $query->addAnd("(uw.nombre LIKE '%$rdo%' || uw.apellido LIKE '%$rdo%')");
        }

        $query->setGroupBy("m.idmedico");

        $query->setLimit("0, 10");

        $listado = $this->getList($query);

        if ($listado && count($listado) > 0) {
            foreach ($listado as $key => $medico) {
//Obtengo el path de la imagen del medico
                $listado[$key]["images"] = $this->getImagenMedico($medico["idmedico"]);
            }
            return array("data" => $listado, "result" => true);
        } else {
            return array("result" => false);
        }
    }

    /**
     * Nétodo que retorna l ainformación utilizada para el menú del médico
     * @param type $idmedico
     * @return type
     */
    public function getInfoMenu($idmedico) {
        $array = array();
        $array["cantidad_notificaciones"] = 0;
        $pacientes = $this->getManager("ManagerMedicoMisPacientes")->getByField("medico_idmedico", $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"]);

        if ($pacientes) {
            $array["cantidad_pacientes"] = 1;
        } else {
            $array["cantidad_pacientes"] = 0;
        }

        $ManagerNotificacion = $this->getManager("ManagerNotificacion");
        $array["cantidad_notificaciones"] = $ManagerNotificacion->getCantidadNotificacionesMedico($_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"]);

        return $array;
    }

    /**
     *  Actualiza los datos de suscripcion premium de un médico a partir de una cuota
     *  @param int $idmedico el id del médico a actualizar
     *  @param int $idcuota el id de la cuota que se está procesando
     *  @return int el idmedico o false si falló
     */
    public function updateSuscripcionPremium($idmedico, $idcuota) {

        $cuota = $this->getManager("ManagerCuota")->get($idcuota);
        $updateRecord = [
            "suscripcion_premium_idsuscripcionactiva" => $cuota["suscripcion_premium_idsuscripcion_premium"],
            "fecha_vto_premium" => $cuota["fecha_vencimiento"], "planProfesional" => 1
        ];

        return parent::update($updateRecord, $idmedico);
    }

    /**
     * Método utilizado para guardar la imagen cortada por el usuario.
     * Utiliza la librería de jQuery "Cropper"
     * @param type $request
     * @return boolean
     */
    public function cropAndChangeImage($request) {

        $idmedico = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];

//Obtengo la imagen que voy a modificar.
        $image_to_copy = path_entity_files("medicos/$idmedico/{$idmedico}_copy.jpg");
        $image = path_entity_files("medicos/$idmedico/$idmedico.jpg");

        if (file_exists($image)) {
            $manImg = new Images();

            $grados = (float) $request["grado"] >= 0 ? (float) $request["grado"] : 360 + (float) $request["grado"];

            $grados = 360 - $grados;

            $rdo = $manImg->resizeCropImg($image, $image_to_copy, $request["width"], $request["height"], $request["left"], $request["top"], $grados, 100);

            if ($rdo) {



                $modify = $this->modifyImgResizeThumb($image_to_copy, $idmedico);

                rename($image_to_copy, $image);


                if ($modify) {

                    $this->setMsg(["msg" => "Se modificó la imagen", "result" => true, "imgs" => $this->getImagenMedico($idmedico)]);
                    return $idmedico;
                } else {
                    $this->setMsg(["msg" => "Error, no se pudieron actualizar las imágenes del médico", "result" => false]);
                    return false;
                }
            } else {
                $this->setMsg(["msg" => "Error, no se pudo procesar la imagen seleccionada", "result" => false]);
                return false;
            }
        } else {
            $this->setMsg(["msg" => "Error, no se encontró la imagen seleccionada", "result" => false]);
            return false;
        }
    }

    /*     * Metodo que envia un mensaje via email a un paciente
     * 
     * @param type $request
     */

    public function enviarMensajePaciente($request) {

//validamos la existencia del paciente  y su email
        if (CONTROLLER == "medico") {
            $request["medico_idmedico"] = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"];
        } else {
            $request["medico_idmedico"] = $request["idmedico"];
        }

        if (!isset($request["paciente_idpaciente"]) || $request["paciente_idpaciente"] == "") {
            $this->setMsg(["msg" => "Error. No se pudo recuperar el registro de paciente", "result" => false]);
            return false;
        }


        $ManagerPaciente = $this->getManager("ManagerPaciente");
        $paciente = $ManagerPaciente->get($request["paciente_idpaciente"]);
//Si el email es vació puede ser que sea un miembro del grupo familiar
        if ($paciente["email"] == "") {
            $paciente_titular = $ManagerPaciente->getPacienteTitular($request["paciente_idpaciente"]);
        }

        if ($paciente["email"] == "" && $paciente_titular["email"] == "") {
            $this->setMsg(["msg" => "Error al recuperar email del paciente ", "result" => false]);
            return false;
        }
//validamos que el mensaje no este vacio
        if (!isset($request["cuerpo"]) || $request["cuerpo"] == "") {
            $this->setMsg(["msg" => "Error. Mensaje vacío", "result" => false]);
            return false;
        }

//envio de la invitacion por mail
//$mEmail = $this->getManager("ManagerMail");
        $mEmail = $this->getManager("ManagerMail");

        $smarty = SmartySingleton::getInstance();
        $idmedico = $request["medico_idmedico"];
        $idpaciente = $paciente["idpaciente"];
        $medico = $this->get($request["medico_idmedico"], true);
        $medico["imagen"] = $this->getImagenMedico($idmedico);
        $smarty->assign("paciente", $paciente);
        $smarty->assign("medico", $medico);
        $smarty->assign("cuerpo", $request["cuerpo"]);

        //agregamos los archivos del mensaje
        $hash = $request["hash"];
        //Flag para verificar si ocurre algún error.
        $flag_file_true = false;
        $exist_files = false;

        if ($hash != "") {
            $datos_session = $_SESSION[$hash];

            $cantidad_file = $request["cantidad_image"];
            //creamos la estrucutra me mensajes
            if (!file_exists(path_entity_files("archivos_mensaje_paciente/$idmedico"))) {
                mkdir(path_entity_files("archivos_mensaje_paciente/$idmedico"), 0777, true);
            }
            if (!file_exists(path_entity_files("archivos_mensaje_paciente/$idmedico/$idpaciente"))) {
                mkdir(path_entity_files("archivos_mensaje_paciente/$idmedico/$idpaciente"), 0777, true);
            }
            $idnotificacion = $request["idnotificacion"];
            if (!file_exists(path_entity_files("archivos_mensaje_paciente/$idmedico/$idpaciente/$idnotificacion"))) {
                mkdir(path_entity_files("archivos_mensaje_paciente/$idmedico/$idpaciente/$idnotificacion"), 0777, true);
            }

            for ($i = 0; $i < $cantidad_file; $i++) {
                //Por cada cantidad tiene que haber un archivo insertado en la carpeta temporal "documentacion_medico"
                //Me fijo si existe el path
                if (isset($_SESSION[$hash][$i])) {
                    $exist_files = true;
                    $path = path_root("{$datos_session[$i]["path"]}");
                    //Si existe el path, se inserta el archvio
                    if (is_file($path)) {
                        $ext = $datos_session[$i]["ext"];
                        $nombre = $datos_session[$i]["filename"];
                        $request["nombre_archivo"] = $nombre;
                        $request["ext"] = $ext;
                        $filetypes = ["pdf", "png", "jpg", "jpeg"];
                        if (!in_array($request["ext"], $filetypes)) {
                            $this->setMsg(["msg" => "Error. No se pudo insertar el archivo [[{$request["nombre_archivo"] }]]", "result" => false]);
                            return false;
                        } else {
                            $flag_file_true = true;
                            $_SESSION[$hash] = $datos_session;
                            //Copio todos los archivos
                            copy(path_files("temp/archivos_mensaje_paciente/{$hash}/{$i}.{$request["ext"]}"), path_entity_files("archivos_mensaje_paciente/$idmedico/$idpaciente/$idnotificacion/{$request["nombre_archivo"]}.{$request["ext"]}"));

                            //Adjunto todos los archivos
                            $path_file = path_entity_files("archivos_mensaje_paciente/$idmedico/$idpaciente/$idnotificacion/{$request["nombre_archivo"]}.{$request["ext"]}");
                            $mEmail->AddAttachment($path_file, $request["nombre_archivo"]);
                        }
                    }
                }
            }
        }

        $mEmail->setHTML(true);

        //ojo solo arnet local
        $mEmail->setPort("587");

        $mEmail->setSubject(sprintf("WorknCare | Nouveau message du %s %s %s ", $medico["titulo_profesional"]["titulo_profesional"], $medico["nombre"], $medico["apellido"]));

        $mEmail->setBody($smarty->Fetch("email/medico_paciente_mensaje.tpl"));
        $email = $paciente["email"] == "" ? $paciente_titular["email"] : $paciente["email"];
        $mEmail->addTo($email);

        if ($mEmail->send()) {
            $this->setMsg(["msg" => "Mensaje enviado con éxito", "result" => true]);
            return true;
        } else {
            $this->setMsg(["msg" => "No se ha podido enviar el mensaje. Inténtelo más tarde", "result" => false]);
            return false;
        }
    }

    /**
     * 
     * @param type $request
     */
    public function enviarMailSolicitudModificacionDatosProfesionales($request) {
        $idmedico = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];
//validamos que el mensaje no este vacio
        if ($request["mensaje"] == "") {
            $this->setMsg(["msg" => "Ingrese el texto de la solicitud", "result" => false]);
            return false;
        }
        $medico = $this->get($idmedico);



        if ($medico["email"] == "") {
            $this->setMsg(["msg" => "Error al recuperar su email ", "result" => false]);
            return false;
        }



//envio de la solicitud por mail

        $smarty = SmartySingleton::getInstance();
        $smarty->assign("medico", $medico);
        $smarty->assign("mensaje", $request["mensaje"]);

        $mEmail = $this->getManager("ManagerMail");
        $mEmail->setHTML(true);

//ojo solo arnet local
        $mEmail->setPort("587");

        $mEmail->setSubject(sprintf("Demande de modification de données professionnelles "));

        $mEmail->setBody($smarty->Fetch("email/mensaje_solicitud_modificacion_datos.tpl"));


        $mEmail->addTo(DEFAULT_EMAIL_ADMIN);
        $mEmail->AddReplyTo($medico["email"], "{$medico["nombre"]}");



        if ($mEmail->send()) {
            $this->setMsg(["msg" => "Solicitud enviada con éxito. Nos contactaremos con Ud. a la brevedad", "result" => true]);
            return true;
        } else {
            $this->setMsg(["msg" => "No se ha podido enviar el mensaje. Inténtelo más tarde", "result" => false]);
            return false;
        }
    }

    /*     * Metodo que envia un mensaje via email a un medico
     * 
     * @param type $request
     */

    public function enviarMensajeMedico($request) {

//validamos la existencia del paciente  y su email

        if (!isset($request["medico_idmedico"]) || $request["medico_idmedico"] == "") {
            $this->setMsg(["msg" => "Error. No se pudo recuperar el registro de medico", "result" => false]);
            return false;
        }



        $medico_envia = $this->get($_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"], true);


        $medico_envia["imagen"] = $this->getImagenMedico($_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"]);

        $medico_recibe = $this->get($request["medico_idmedico"], true);



        if ($medico_recibe["email"] == "" || $medico_envia["email"] == "") {
            $this->setMsg(["msg" => "Error al recuperar email del medico", "result" => false]);
            return false;
        }


//validamos que el mensaje no este vacio
        if (!isset($request["cuerpo"]) || $request["cuerpo"] == "") {
            $this->setMsg(["msg" => "Error. Mensaje vacío", "result" => false]);
            return false;
        }

//envio de la invitacion por mail

        $smarty = SmartySingleton::getInstance();


        $smarty->assign("medico_envia", $medico_envia);
        $smarty->assign("medico_recibe", $medico_recibe);
        $smarty->assign("cuerpo", $request["cuerpo"]);




        $mEmail = $this->getManager("ManagerMail");
        $mEmail->setHTML(true);

//ojo solo arnet local
        $mEmail->setPort("587");

        $mEmail->setSubject(sprintf("WorknCare | Un collègue vous envoie un message"));

        $mEmail->setBody($smarty->Fetch("email/medico_medico_mensaje.tpl"));

        $email = $medico_recibe["email"];
        $mEmail->addTo($email);



        if ($mEmail->send()) {
            $this->setMsg(["msg" => "Mensaje enviado con éxito", "result" => true]);
            return true;
        } else {
            $this->setMsg(["msg" => "No se ha podido enviar el mensaje. Inténtelo más tarde", "result" => false]);
            return false;
        }
    }

    /*     * Metodo que envia un  email a una direccion alternativa de medico cuando se cambia el mail con el codigo de validacion
     * de la nueva direccion.
     * 
     * @param type $request
     */

    public function enviarMailCodigoValidacionEmail() {


        $idmedico = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"];


        $medico = $this->get($idmedico, true);



        if ($medico["cambioEmail"] == "") {
            $this->setMsg(["msg" => "Error al recuperar email del medico", "result" => false]);
            return false;
        }

        $caracteres = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890";
        $numerodeletras = 5;


        for ($i = 0; $i < $numerodeletras; $i++) {
            $cuerpo .= substr($caracteres, rand(0, strlen($caracteres)), 1); /* Extraemos 1 caracter de los caracteres 
              entre el rango 0 a Numero de letras que tiene la cadena */
        }

//Actualizo el código de validación de celular
        $id = parent::update(array("codigoValidacionEmail" => $cuerpo), $medico["idmedico"]);

        if ($id) {

//envio del codigo por mail

            $smarty = SmartySingleton::getInstance();

            $smarty->assign("medico", $medico);
            $smarty->assign("codigoValidacionEmail", $cuerpo);


            $mEmail = $this->getManager("ManagerMail");
            $mEmail->setHTML(true);

//ojo solo arnet local
            $mEmail->setPort("587");

            $mEmail->setSubject(sprintf("WorknCare | Code de validation "));

            $mEmail->setBody($smarty->Fetch("email/medico_cambio_email.tpl"));

            $email = $medico["cambioEmail"];
            $mEmail->addTo($email);



            if ($mEmail->send()) {
                $this->setMsg(["msg" => "Mensaje enviado con éxito", "result" => true]);
                return true;
            } else {
                $this->setMsg(["msg" => "No se ha podido enviar el mensaje. Inténtelo más tarde", "result" => false]);
                return false;
            }
        } else {
            return false;
        }
    }

    /**
     * Método utilizado para actualizar las cantidades de recomendaciones 
     * @param type $idmedico
     * @param type $valor : Puede ser 1 por defecto o menos uno si es que no lo recomienda -1 -> para cuando hace DELETE de profesional valoración
     * @return boolean
     */
    public function updateCantidadRecomendacion($idmedico) {

        $valoraciones = $this->db->getRow("select getEstrellasMedicos({$idmedico}) as cant_estrellas, getCantidadRecomendacionesMedicos({$idmedico}) as cant_recomendaciones");


        if ($valoraciones) {
//Actualizo la cantidad de recomendaciones y de estrellas 
            return parent::update(["cantidad_recomendaciones" => $valoraciones["cant_recomendaciones"], "cantidad_estrellas" => $valoraciones["cant_estrellas"]], $idmedico);
        }
        return false;
    }

    /*     * Metodo que retorna verdadero si el medico tiene habilitada la consulta presencial. Debe poseer un consultorio fisico
     * 
     * @param type $idmedico
     */

    public function poseeConsultaPresencial($idmedico) {
        $consultorios = $this->getManager("ManagerConsultorio")->getListconsultorioMedico($idmedico);
        $presencial = false;
        foreach ($consultorios as $cons) {
            if ($cons["is_virtual"] == "0") {
                $presencial = true;
                break;
            }
        }
        return $presencial;
    }

    /*     * Metodo que retorna verdadero si el medico tiene habilitada la videoconsulta. Debe poseer un consultorio virtual
     * 
     * @param type $idmedico
     */

    public function poseeVideoConsulta($idmedico) {
        $consultorios = $this->getManager("ManagerConsultorio")->getListconsultorioMedico($idmedico);
        $presencial = false;
        foreach ($consultorios as $cons) {
            if ($cons["is_virtual"] == "1") {
                $presencial = true;
                break;
            }
        }
        return $presencial;
    }

    /**
     * MEtodo que devuelve las imagenes de identificacion del medico
     * @param type $idpaciente
     */
    public function getImagenesIdentificacion($idmedico) {


        $listado_archivos = [];

        $path_dir = path_entity_files("medicos/$idmedico/");
        if (file_exists($path_dir)) {
            $archivos = scandir($path_dir);

            foreach ($archivos as $i => $archivo) {
                $tarjeta = [];
                if ($archivo == "." || $archivo == "..") {
                    unset($archivos[$i]);
                    continue;
                }
                //verificamos el nombre original del archivo encontrado -  no thumb
                if (strrpos($archivo, "cps.") !== false) {
                    $tarjeta["nombre"] = "cps";
                } else if (strrpos($archivo, "dni.") !== false) {
                    $tarjeta["nombre"] = "dni";
                } else {
                    unset($archivos[$i]);
                    continue;
                }
                $tarjeta["path"] = URL_ROOT . "xframework/files/entities/medicos/$idmedico/{$archivo}?t=" . mktime();
                $tarjeta["file"] = path_entity_files("medicos/$idmedico/{$archivo}");
                //obtenemos formato
                $tarjeta["ext"] = str_replace($tarjeta["nombre"], "", $archivo);
                $listado_archivos[$tarjeta["nombre"]] = $tarjeta;
            }
        }

        return $listado_archivos;
    }

    /**
     * Metodo que valida el numero RPPS ingresado
     * @param type $nro


     */
    private function validarNumeroRPPS($nro) {
        /**
          Cantidad de 11 numeros

          el nro empieza con 10
         */
        if (strlen($nro) != 11) {

            return false;
        }

        $primeros = substr($nro, 0, 2);

        if ($primeros != 10) {

            return false;
        }

        return true;
    }

    /**
     * Metodo que valida el numero ADELI ingresado
     * @param type $nro
     */
    private function validarNumeroADELI($nro) {

        if (strlen($nro) != 9) {

            return false;
        }


        return true;
    }

    /**
     * Metodo que valida el numero AM ingresado
     * cantidad 9 numeros, inicia con 14
     * @param type $nro
     */
    private function validarNumeroAM($nro) {
        if (strlen($nro) != 9) {

            return false;
        }

        $primeros = substr($nro, 0, 2);

        /* if ($primeros != 14) {

          return false;
          } */

        return true;
    }

    /**
     * Metodo que setea la preferencia del medico para usar consultorio con agenda o solo crear consultorio virtual para vc inmediata
     * @param type $request
     */
    public function setear_agenda_consultorio($request) {

        if ($request["agenda_consultorio"] == "") {

            $this->setMsg([
                "msg" => "  Seleccione

                una opcion", "result" => false]);
            return false;
        }

        $record["agenda_consultorio"] = $request["agenda_consultorio"] == 1 ? 1 : 0;
        $idmedico = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"];
        $rdo = parent::update($record, $idmedico);


        if ($rdo) {
            //mandamos a crear el consultorio virtual
            $ManagerConsultorio = $this->getManager("ManagerConsultorio");
            $rdo_virtual = $ManagerConsultorio->processVirtual($request);

            $this->setMsg($ManagerConsultorio->getMsg());
            return $rdo_virtual;
        } else {
            $this->setMsg(["msg" => "Error, no se pudo actualizar el registro", "result  " => false]);
            return false;
        }
    }

    /**
     * Método que elimina los archivos subidos en el registro del medico
     * @param type $idmedico
     * @param type $file
     */
    public function deleteFiles($idmedico, $file) {
        if (CONTROLLER != "xadmin") {
            return false;
        }
        $path_dir = path_entity_files("medicos/$idmedico/");
        $deleted = false;
        if (file_exists($path_dir)) {
            $archivos = scandir($path_dir);

            foreach ($archivos as $i => $archivo) {

                if ($archivo == "." || $archivo == "..") {
                    unset($archivos[$i]);
                    continue;
                }
                //verificamos el nombre original del archivo encontrado -  no thumb
                if (strrpos($archivo, "{$file}.") !== false) {
                    $path_file = $path_dir . $archivo;
                    if (file_exists($path_file) && is_file($path_file)) {
                        unlink($path_file);
                        $deleted = true;
                    }
                }
            }
        }
        if ($deleted) {
            $this->setMsg(["msg" => "Archivo eliminado con éxito", "result" => true]);
            return true;
        } else {
            $this->setMsg(["msg" => "Error. No se pudo eliminar los archivos", "result  " => false]);
            return false;
        }
    }

    /**
     * Método que elimina los archivos subidos en el registro del medico
     * @param type $idmedico
     * @param type $file
     */
    public function uploadFiles($request) {
        if (CONTROLLER != "xadmin") {
            return false;
        }
        $uploaded = false;
        $hash = $request["hash"];
        $name = $request["name"];
        //CPS si es frances
        if ($_SESSION[$hash]["name"] == $name && $request["idmedico"] != "") {
            //creamos el directorio si no existe
            if (!file_exists(path_entity_files($this->imgContainer . "/{$request["idmedico"]}"))) {
                $dir = new Dir(path_entity_files($this->imgContainer . "/{$request["idmedico"]}"));
                $dir->chmod(0777);
            }
            $file_ext = $_SESSION[$hash]["ext"];
            $file_path_temp = path_files("temp/" . $hash . "." . $file_ext);
            $path_file = path_entity_files("$this->imgContainer/{$request["idmedico"]}/$name.{$file_ext}");
            $file_exist = file_exists($file_path_temp);
            $is_file = is_file($file_path_temp);
            if (!$file_exist || !$is_file) {
                $this->setMsg(["msg" => "Error. No se pudo subir ningun archivos, verifique sus formatos y tamaños", "result" => false]);
                return false;
            } else {
                //copiamos el archivo a su ubicacion final
                copy($file_path_temp, $path_file);
                //comprobamos que se hayan movido
                if (!file_exists($path_file) || !is_file($path_file)) {
                    $this->setMsg(["msg" => "Error. No se pudo subir ningun archivos, verifique sus formatos y tamaños", "result" => false]);
                    return false;
                }
                $uploaded = true;
            }
        }
        if ($uploaded) {
            $this->setMsg(["msg" => "Archivo subido con éxito", "result" => true]);
            return true;
        } else {
            $this->setMsg(["msg" => "Error. No se pudo subir ningun archivos, verifique sus formatos y tamaños", "result  " => false]);
            return false;
        }
    }

    /**
     * Método que retorna el PDF con la factura de una consulta en particular
     * @param type $request
     */
    public function getResumenConsultaParticularPDF($request) {



        if (CONTROLLER == "medico") {
            $idmedico = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];
        } else {
            $idmedico = $request["medico_idmedico"];
        }

        //obtenemos la informacion para el PDF
        if ($request["tipo"] == "ce") {
            $consulta = $this->getManager("ManagerConsultaExpress")->get($request["id"]);
        } else if ($request["tipo"] == "vc") {
            $consulta = $this->getManager("ManagerVideoConsulta")->get($request["id"]);
        } else {
            return false;
        }
        $data_variables["consulta"] = $consulta;

        //verififcamos que la consulta sea del medico
        if ($consulta["medico_idmedico"] != $idmedico) {
            return false;
        }

        $data_variables["numero_factura"] = STR_PAD($request["id"], 9, "0", STR_PAD_LEFT);


        $medico = $this->getManager("ManagerMedico")->get($idmedico, true);
        $data_variables["medico"] = $medico;

        $paciente = $this->getManager("ManagerPaciente")->get($consulta["paciente_idpaciente"]);
        $data_variables["paciente"] = $paciente;

        $infofiscal = $this->getManager("ManagerInformacionComercialMedico")->getInformacionComercialMedico($idmedico);
        $data_variables["infofiscal"] = $infofiscal;
        $filtro["bandera"] = '1';
        $filtro["idconsulta"] = $request["id"];
        $filtro["filtro_inicio"] = '0';
        $filtro["filtro_fin"] = '0';
        $listado_consultas_beneficiarios = $this->getConsultasBeneficiario($filtro);
        $data_variables["listado_consultas_beneficiarios"] = $listado_consultas_beneficiarios;

        // $this->print_r($data_variables);
        //die();
        //instanciamos la clase que crea los pdf
        $PDFResumenConsulta = new PDFResumenConsulta();

        $PDFResumenConsulta->getPDF($data_variables);
    }

    /**
     * metodo que obtiene las consultas utilizadas por beneficiarios(video consultas y consultas express)
     */
    public function getConsultasBeneficiario($request) {

        $idmedico = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];

        if ($request["bandera"] == '1') {
            $idvideoconsulta = $request["idconsulta"];
            $whereVC = "vc.idvideoconsulta = '$idvideoconsulta'";
            $whereCE = "ce.idconsultaExpress = '$idvideoconsulta'";
        } else {
            $fechaInicio = $request["filtro_inicio"];
            $fechafin = $request["filtro_fin"];
            $whereVC = "vc.fecha_inicio BETWEEN '$fechaInicio' AND '$fechafin'";
            $whereCE = "ce.fecha_inicio BETWEEN '$fechaInicio' AND '$fechafin'";
        }

        $queryVC = new AbstractSql();
        $queryVC->setSelect("DATE_FORMAT(vc.fecha_inicio, '%d/%m/%Y') AS fechaInicio,
                        CONCAT(pac.nombre,' ',pac.apellido) AS nombrePaciente,
                        'Video Consultation' AS tipo_consulta,
			vc.numeroVideoConsulta AS numeroRegistrado,
			 CONCAT(vc.precio_tarifa,' EUR') AS precioTarifa");
        $queryVC->setFrom("videoconsulta vc
                            INNER JOIN v_pacientes pac ON (pac.idpaciente = vc.paciente_idpaciente)");
        $queryVC->setWhere($whereVC);

        $queryVC->addAnd("vc.medico_idmedico = $idmedico");
        $queryVC->addAnd("vc.estadoVideoConsulta_idestadoVideoConsulta = 4");
        if (!($request["bandera"] == '1')) {
            $queryVC->addAnd("vc.debito_plan_empresa = 1");
        }
        //obtenemos el detalle de consulta express del periodo
        $queryCE = new AbstractSql();
        $queryCE->setSelect(" DATE_FORMAT(ce.fecha_inicio, '%d/%m/%Y') AS fechaInicio,
                        CONCAT(pac.nombre,' ',pac.apellido) AS nombrePaciente,
                        'Conseils' AS tipo_consulta,
			ce.numeroConsultaExpress AS numeroRegistrado,
			 CONCAT(ce.precio_tarifa,' EUR') AS precioTarifa");
        $queryCE->setFrom("consultaexpress ce
                        INNER JOIN v_pacientes pac ON (pac.idpaciente = ce.paciente_idpaciente)");
        $queryCE->setWhere($whereCE);
        $queryCE->addAnd("ce.medico_idmedico = $idmedico");
        $queryCE->addAnd("ce.estadoConsultaExpress_idestadoConsultaExpress = 4");
        if (!($request["bandera"] == '1')) {
            $queryCE->addAnd("ce.debito_plan_empresa = 1");
        }

        //unimos los 2 resultados
        $query = new AbstractSql();
        $query->setSelect("*");
        $query->setFrom("((" . $queryVC->getSql() . ")UNION(" . $queryCE->getSql() . ")) as T");
        $query->setOrderBy("T.fechaInicio asc");

        $rdo = $this->getList($query);
        return $rdo;
    }

}

//END_class