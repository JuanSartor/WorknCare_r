<?php

/**
 * 	@autor Xinergia
 * 	@version 1.0	2008-04-14
 * 	Manager de usuarios
 *
 */
// Incluimos la superclase Gestor
require_once(path_managers("base/users/ManagerAccounts.php"));

/**
 * @autor Xinergia
 * @version 1.0
 * Class ManagerUsuarios
 * 	
 * Emcapsula el manejo de los Usuarios del sistema
 */
class ManagerUsuarioPrestador extends ManagerAccounts {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "usuario_prestador", "idusuario_prestador");
        $this->email_field = "email";
        $this->login_field = "username";
        $this->password_field = "password";
        $this->encode_pass = false;
        $this->flag = "active";
        $this->default_paginate = "usuarios_presador_listado";
    }

    public function process($request) {
        //verifiamos si es un admin de prestador o el admin de DP el que crea los usuarios
        if ($_SESSION[URL_ROOT][CONTROLLER]['logged_account']['user']['idusuario_prestador'] != "") {
            $usuario = $this->get($_SESSION[URL_ROOT][CONTROLLER]['logged_account']['user']['idusuario_prestador']);
            if ($usuario['tipousuario'] == 0 || $usuario['active'] == 0) {
                $this->setMsg(["result" => false, "msg" => "Error. No tiene permisos para realizar esta acción"]);
                return false;
            }
            $request["prestador_idprestador"] = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']['user']['prestador_idprestador'];
        }

        return parent::process($request);
    }

    /*
     * 	@author Xinergia <info@e-xinergia.com>
     *   @version 1.0
     *   Inserta un nuevo usuario generando un status para el xadmin
     *   
     *           
     *   
     *   @param array $request datos enviados por el usuario
     *   @return int|boolean id del usuario creado o false en caso de error
     *
     */

    public function insert($request) {

        $this->encode_pass = false;

        //valido descripcion unica Email
        if (!$this->validateUnique("email", $request["email"])) {
            $this->setMsg(["result" => false, "msg" => "La cuenta,[[{$request["email"]}]] ya se encuentra registrada", "field" => "email"]);
            return false;
        }
        //valido descripcion unica user
        if (!$this->validateUnique("username", $request["username"])) {
            $this->setMsg(["result" => false, "msg" => "El usuario, [[{$request["username"]}]] ya se encuentra registrado ", "field" => "username"]);
            return false;
        }

        if (!isValidEmail($request["email"])) {
            $this->setMsg(["result" => false, "msg" => "Error, [[{$request["email"]}]]  no es un mail válido ", "field" => "email"]);
            return false;
        }

        $request["fecha_alta"] = date("Y-m-d H:i:s");
        $this->db->StartTrans();
        $idusuario = parent::insert($request);

        //si se crea correctamente asocio las funcionaldades y si aplica o no

        if ($idusuario) {

            $mail = $this->sendEmailActivacion($idusuario);
            if (!$mail) {

                $this->setMsg(["msg" => "Error. No se pudo enviar el email al usuario", "result" => false]);
                $this->db->FailTrans();
                $this->db->CompleteTrans();

                return false;
            }

            //$this->setPassAleatoria($idusuario);
            $this->setMsg(["result" => true, "msg" => "Usuario [[{$request['username']} -{$request['email']}]] creado con éxito"]);
        }
        $this->db->CompleteTrans();
        return $idusuario;
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
     *   Acutaliza un usuario
     *   
     *   @param array $request datos enviados por el usuario
     *   @param $iduser id del usuario
     *           		
     *   @return int|boolean id del usuario creado o false en caso de error
     *
     */

    public function update($request, $idusuario) {

        //valido descripcion unica
        if (isset($request["email"]) && $request["email"] != "") {
            if (!$this->validateUnique("email", $request["email"], $idusuario)) {
                $this->setMsg(["result" => false, "msg" => "La cuenta, [[{$request["email"]}]] ya se encuentra registrada.", "field" => "email"]);
                return false;
            }
        }

        //valido descripcion unica
        if (isset($request["username"]) && $request["username"] != "") {
            if (!$this->validateUnique("username", $request["username"], $idusuario)) {
                $this->setMsg(["result" => false, "msg" => "El usuario, [[{$request["username"]}]] ya se encuentra registrado.", "field" => "username"]);
                return false;
            }
        }


        $result = parent::update($request, $idusuario);


        if ($result) {

            $this->setMsg(["msg" => "Usuario [[{$request["username"]} - {$request["email"]}]] actualizado con éxito", "result" => true]);
        }


        return $result;
    }

    /*     * Metodo que realiza el autologueo si se tiene seteada la cookie de recordar usuario en le login y no esta iniciada la sesion aun
     * 
     */

    public function autologin() {

        if ($_COOKIE["recordar"] != "") {
            $enc = new CookieEncrypt(ENCRYPT_KEY);
            $recordar = $enc->get_cookie("recordar");

            if ((isset($_SESSION[URL_ROOT]["medico"]['allowed']) && $_SESSION[URL_ROOT]["medico"]['allowed']) || (isset($_SESSION[URL_ROOT]["paciente_p"]['allowed']) && $_SESSION[URL_ROOT]["paciente_p"]['allowed'])) {
                return true;
            } else {
                $usuario = $this->get($recordar);
                $record["email"] = $usuario["email"];
                $record["password"] = $usuario["password"];

                $rdo = $this->login($record);
                if ($rdo) {
                    return true;
                } else {
                    setcookie("recordar", "", time() - 3600);
                    return false;
                }
            }
        } else {

            return false;
        }
    }

    /**
     * @author Sebastian Balestrini
     * @version 1.0
     * Redefine el metodo login, busca la configuracion de interfaz de xadmin
     * @param array $request donde se encuntran los datos de login
     * @return bool exito del login  
     * 		
     */
    public function login($request) {

        if (!isset($request[$this->password_field]) || $request[$this->password_field] == "") {
            return false;
        }

        $query = new AbstractSql();

        $query->setSelect("*");
        $query->setFrom("$this->table");
        $query->setWhere("$this->login_field = '{$request[$this->login_field]}'");

        $row = $this->db->GetRow($query->getSql());
        if (!$row) {

            $this->setMsg(array("msg" => "Usuario incorrecto. Verifique los datos ingresados",
                "result" => false,
                "field" => 1,
                "inhabilitada" => 1
            ));
            return false;
        }
        if ($row["cantidad_intentos_fallidos"] > 10) {
            $this->setMsg(["msg" => "Su cuenta está inabilitada. Superó la cantidad de intentos fallidos ", "result" => false]);
            return false;
        }

        if ($row["active"] == 0) {
            $this->setMsg(["msg" => "Su cuenta está inabilitada ", "result" => false]);
            return false;
        }




        if (parent::login($request)) {
            //Me fijo si el usuario se encuentra activo




            $ManagerLogSystemLogin = $this->getManager("ManagerLogSystemLogin");
            $login = $ManagerLogSystemLogin->processFromLogin(["idusuario_prestador" => $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["id"]]);
            $controller = CONTROLLER;

            $this->setMsg(["result" => true, "msg" => "Login Exitoso", "controller" => "{$controller}.php"]);


            return true;
        } else {


            //Me fijo si existe el email que viene no exista en la base de datos, si existe aumento la cantidad de intentos de ingresos fallidos

            if ($row) {
                $cantidad_row = $row["cantidad_intentos_fallidos"] + 1;
                $update = parent::update(["cantidad_intentos_fallidos" => $cantidad_row], $row[$this->id]);
                if ($update) {
                    $cantidad_intentos_restantes = 10 - $cantidad_row;
                    // $msg = "Ingreso incorrecto, tiene {$cantidad_intentos_restantes} intento/s más";

                    $this->setMsg(["msg" => "Ingreso incorrecto. Revisa tu clave", "result" => false, "field" => 0]);

                    $inahabilitada = 0;
                    if ($cantidad_intentos_restantes <= 0) {

                        $this->setMsg(["msg" => "Su cuenta está inabilitada, contacte al administrador", "result" => false, "field" => 0, "inhabilitada" => $inahabilitada]);

                        $inahabilitada = 1;
                    }
                }
            } else {
                $this->setMsg(["msg" => "La cuenta no se encuentra habilitada en el sistema", "result" => false, "field" => 1]);
            }


            return false;
        }
    }

    /**
     * Seteo del último acceso del usuario en la base de datos.
     * Modficación del campo "ultimo_acceso"
     * @param type $fecha
     * @return boolean
     */
    public function setUltimoAcceso($controller, $fecha = null) {
        $user_logued = $_SESSION[URL_ROOT][CONTROLLER]['logged_account'];

        if (is_null($fecha)) {
            $fecha = date('Y-m-d H:i:s');
        }

        $id = parent::update(array("ultimo_acceso" => $fecha, "cantidad_intentos_fallidos" => 0), $user_logued["id"]);
        if (!$id) {
            return false;
        } else {
            $_SESSION[URL_ROOT][$controller]['logged_account']['user']['ultimo_acceso'] = $fecha;
            return $id;
        }
    }

    /*
     * 	@author Xinergia <info@e-xinergia.com>
     *
     *   Usuarios 
     */

    public function getUsuariosJSON($request, $idpaginate = NULL) {


        if ($_SESSION[URL_ROOT][CONTROLLER]['logged_account']['user']['idusuario_prestador'] != "") {
            $idprestador = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']['user']['prestador_idprestador'];
        } else {
            $idprestador = $request["idprestador"];
        }
        if (!is_null($idpaginate)) {
            $this->paginate($idpaginate, 25);
        }

        $query = new AbstractSql();
        $query->setSelect("u.$this->id,
                u.email,
                u.apellido,
                u.nombre,
                u.username,
                CASE u.tipousuario 
                WHEN 0 THEN 'Secretario/a'
                WHEN 1 THEN 'Administrador'
                WHEN 2 THEN 'Operador'
                END as tipo,
                IF(u.active=1,'Activo','Inactivo') as estado");
        $query->setFrom("$this->table u");

        $query->setWhere("u.prestador_idprestador={$idprestador}");
        // Filtro

        if ($_SESSION[URL_ROOT][CONTROLLER]['logged_account']['user']['idusuario_prestador'] != "") {
            $query->addAnd("u.idusuario_prestador<>{$_SESSION[URL_ROOT][CONTROLLER]['logged_account']['user']['idusuario_prestador']}");
        }
        if ($request["busqueda"] != "") {

            $busqueda = cleanQuery($request["busqueda"]);

            $query->addAnd("(u.email LIKE '%$busqueda%' OR u.nombre LIKE '%$busqueda%' OR u.apellido LIKE '%$busqueda%')");
        }
        if ($request["nombre"] != "") {

            $nombre = cleanQuery($request["nombre"]);

            $query->addAnd("u.nombre LIKE '%$nombre%'");
        }
        if ($request["apellido"] != "") {

            $apellido = cleanQuery($request["apellido"]);

            $query->addAnd("u.apellido LIKE '%$apellido%'");
        }
        if ($request["email"] != "") {

            $email = cleanQuery($request["email"]);

            $query->addAnd("u.email LIKE '%$email%'");
        }

        if ($request["username"] != "") {

            $username = cleanQuery($request["username"]);

            $query->addAnd("u.username LIKE '%$username%'");
        }

        if ($request["active"] != "") {

            $active = cleanQuery($request["active"]);

            $query->addAnd("u.active=$active");
        }

        if ($request["tipousuario"] != "") {

            $tipousuario = cleanQuery($request["tipousuario"]);

            $query->addAnd("u.tipousuario=$tipousuario");
        }

        $data = $this->getJSONList($query, array("nombre", "apellido", "username", "email", "tipo", "estado"), $request, $idpaginate);


        return $data;
    }

    /**
     * Método de envío de email para la validación de la cuenta del sistema.
     * @param type $idusuario
     * @return boolean
     */
    public function sendEmailValidation($idusuario) {
        $usuario = $this->get($idusuario);

        $mEmail = $this->getManager("ManagerMail");
        $mEmail->setHTML(true);

        //ojo solo arnet local
        $mEmail->setPort("587");

        $mEmail->setSubject("Merci de vous être inscrit sur WorknCare!");


        $smarty = SmartySingleton::getInstance();

        $smarty->assign("hash", $usuario["checkemail"]);
        $smarty->assign("usuario", $usuario);



        if ($usuario["tipousuario"] == "paciente") {
            $mEmail->setBody($smarty->Fetch("email/activacion_cuenta_paciente.tpl"));
        } else {
            $mEmail->setBody($smarty->Fetch("email/activacion_cuenta_medico.tpl"));
        }

        $mEmail->addTo($usuario["email"]);


        //header a todos los comentarios!
        if ($mEmail->send()) {

            return true;
        } else {
            $this->setMsg(["result" => false, "msg" => "No se pudo enviar el mensaje"]);
            return false;
        }
    }

    /**
     * Método de envío de email para la validación de la cuenta del sistema.
     * @param type $idusuario
     * @return boolean
     */
    public function sendEmailActivacion($idusuario) {
        $usuario = $this->get($idusuario);

        $mEmail = $this->getManager("ManagerMail");
        $mEmail->setHTML(true);

        //ojo solo arnet local
        $mEmail->setPort("587");

        $mEmail->setSubject("WorknCare - Extranet | Votre compte a été activé");


        $smarty = SmartySingleton::getInstance();
        if ($usuario["password"] == "") {
            $password = $this->getRandomEasyPass(8);
        } else {
            $password = $usuario["password"];
        }

        $randomPass_secure = sha1($password);
        $randomPass_secure = base64_encode($randomPass_secure);
        $upd = parent::update(array("password" => $randomPass_secure), $idusuario);
        if ($upd) {
            $smarty->assign("usuario", $usuario);
            $smarty->assign("sistema", NOMBRE_SISTEMA);
            $smarty->assign("password", $password);



            $mEmail->setBody($smarty->Fetch("email/confirmacion_activacion_cuenta_prestador.tpl"));


            $mEmail->addTo($usuario["email"]);


            //header a todos los comentarios!
            if ($mEmail->send()) {

                return true;
            } else {
                $this->setMsg(["result" => false, "msg" => "No se pudo enviar el mensaje"]);
                return false;
            }
        } else {
            return false;
        }
    }

    /**
     * Método de envío de email para la recuperación de la cuenta del sistema.
     * @param type $idusuario
     * @return boolean
     */
    public function sendEmailRecuperarContrasenia($request) {

        $usuario = $this->getByField("email", $request["email"]);
        if (!$usuario) {

            $this->setMsg(["result" => false, "msg" => "Email no válido"]);
            return false;
        }

        if ($usuario["estado"] != 1) {
            $this->setMsg(["result" => false, "msg" => "Error. La cuenta de usuario no se encuentra activa en el sistema"]);
            return false;
        }

        $mEmail = $this->getManager("ManagerMail");
        $mEmail->setHTML(true);

        //ojo solo arnet local
        $mEmail->setPort("587");

        $mEmail->setSubject("WorknCare | Récupération du mot de passe");


        $smarty = SmartySingleton::getInstance();

        $hash = time() * (int) $usuario["idusuarioweb"];
        $hash = sha1("$hash");

        $smarty->assign("hash", $hash);
        $smarty->assign("usuario", $usuario);
        $smarty->assign("sistema", NOMBRE_SISTEMA);

        $managerResetsWeb = $this->getManager("ManagerResetsWeb");
        $insert_reset = array(
            "usuarioweb_idusuarioweb" => $usuario["idusuarioweb"],
            "hash" => $hash
        );
        $idreset = $managerResetsWeb->insert($insert_reset);
        if (!$idreset) {
            $this->setMsg(["result" => false, "msg" => "Se ha producido un error intente más tarde"]);
            return false;
        }



        $mEmail->setBody($smarty->Fetch("email/cambio_contrasenia.tpl"));


        $mEmail->addTo($usuario["email"]);


        //header a todos los comentarios!
        if ($mEmail->send()) {
            $this->setMsg(["result" => true, "msg" => "Revise su casilla de correo"]);
            return true;
        } else {
            $this->setMsg(["result" => false, "msg" => "No se pudo enviar el mensaje"]);
            return false;
        }
    }

    /**
     *  Actualiza el perfil de un usuario
     *
     *
     * */
    public function guardarPerfil($request) {

        $data["nombre"] = $request["nombre"];
        $data["apellido"] = $request["apellido"];
        $data["email"] = $request["email"];
        $data["idusuario"] = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["id"];

        //valido descripcion unica
        if (!$this->validateUnique("email", $data["email"], $data["idusuario"])) {

            $this->setMsg(["result" => false, "msg" => "Error, email [[{$data["email"]}]] ya se encuentra registrado", "field" => "email"]);

            return false;
        }

        $result = parent::update($data, $data["idusuario"]);

        if ($result) {
            $this->setMsg(["result" => true, "result" => "Perfil modificado"]);
        }

        return $result;
    }

    /*
     * @author Emanuel del Barco
     * @version 1.0
     * Devuelve un combo de usuarios activos
     *
     *
     * @return array combo de Perfiles
     */

    public function getCombo() {

        $query = new AbstractSql();
        $query->setSelect("u.idusuario,u.username");
        $query->setFrom("usuario u");
        $query->setWhere("u.activo = 1");

        return $this->getComboBox($query, false);
    }

    /**
     * @author Emanuel del Barco
     * @version 1.0
     * Devuelve un listado de Perfiles en forma de combo
     *
     *
     * @return array combo de Perfiles
     */
    public function getComboPerfilesActivos() {

        $query = new AbstractSql();
        $query->setSelect("p.idperfil,p.descripcion");
        $query->setFrom("perfil p");
        $query->setWhere("p.activo = 1");

        return $this->getComboBox($query, false);
    }

    /**
     * @author Emanuel del Barco
     * @version 1.0
     *
     * Intenta cambiar el password del user logueado
     * @params array $request datos enviados por el usuario
     * @return bool resultado de laoperacion
     */
    public function changePassword($request) {

        if (isset($request['oldPassword'])) {
            if (CONTROLLER == "medico") {
                $idmedico = (int) $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"];
                $medico = $this->getManager("ManagerMedico")->get($idmedico);
                $usuActual = $this->get($medico["usuarioweb_idusuarioweb"]);
            }
            if (CONTROLLER == "paciente_p") {
                $idpaciente = (int) $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["paciente"]["idpaciente"];
                $paciente = $this->getManager("ManagerPaciente")->get($idpaciente);
                $usuActual = $this->get($paciente["usuarioweb_idusuarioweb"]);
            }


            if ($request['oldPassword'] != $usuActual['password']) {

                $this->setMsg(["result" => false, "msg" => "La contraseña anterior no coincide"]);
                return false;
            } else {
                if ($request['newPassword'] != "" && $request['newPassword'] == $request['rePassword']) {

                    $password = $request['newPassword'];

                    $rs = $this->db->Execute("UPDATE $this->table SET password='$password' WHERE idusuarioweb={$usuActual["idusuarioweb"]}");

                    if ($rs) {
                        $this->setMsg(["result" => false, "msg" => "Contraseña actualizada"]);
                        return true;
                    } else {
                        $this->setMsg(["result" => false, "msg" => "No se pudo cambiar la contraseña, intente nuevamente"]);
                        return false;
                    }
                } else {
                    $this->setMsg(["result" => false, "msg" => "Las contraseñas no coinciden"]);
                    return false;
                }
            }
        } else {
            $this->setMsg(["result" => false, "msg" => "Ingrese la contraseña anterior"]);

            return false;
        }
    }

    /**
     *  Resetea el password de un usuario q lo ha olvidado
     *  y solocito resetearlo mediante un email         
     *
     * */
    public function resetPass($request) {


        //email puede ser email o loguin
        $hash = addslashes($request['hash']);

        //buscamos el hash
        $consulta = new AbstractSql();
        $consulta->setSelect(" r.usuarioweb_idusuarioweb,(r.validez > NOW())as valido,r.hash");
        $consulta->setFrom(" resetsweb r");
        $consulta->setWhere(" r.hash = '$hash' ");

        $res = $this->getList($consulta);

        $reset = $res[0];

        if ((int) $reset['usuarioweb_idusuarioweb'] <= 0 && (int) $reset['valido'] == 0) {
            $this->setMsg(["result" => false, "msg" => "Ha expirado el tiempo de recuperación de contraseña, inténtelo nuevamente"]);
            return false;
        }

        //si llegamos aca esta todo bien

        if ($request['password'] == "") {
            $this->setMsg(["result" => false, "msg" => "Empty password"]);
        }

        $update_record["password"] = $request['password'];
        $update_record["idusuarioweb"] = $reset['usuarioweb_idusuarioweb'];
        $update_record["cantidad_intentos_fallidos"] = 0;


        if (parent::update($update_record, $reset['usuarioweb_idusuarioweb'])) {
            //borro todas las solicitudes pendientes para el usuario
            $this->db->Execute("DELETE FROM resetsweb WHERE usuarioweb_idusuarioweb = " . $reset['usuarioweb_idusuarioweb']);

            $this->setMsg(["result" => true, "msg" => "Contraseña Actualizada"]);
            return true;
        } else {
            $this->setMsg(["result" => false, "msg" => "Error, no se pudo actualizar la contraseña"]);
            return false;
        }
    }

    /**
     * Procesamiento de los datos que corresponden a la tabla usuarioweb
     * Este método pertenece a la registración web, de los médicos y pacientes
     * @param type $request
     * @return type
     */
    public function registracion_web($request) {

        //Chequeo el sexo que viene en forma de on para masculino.
        if (isset($request["sexo"]) && $request["sexo"] == "on") {
            $request["sexo"] = 1;
        } else {
            $request["sexo"] = 0;
        }

        $id = $this->insert($request);
        if (!$id) {
            return false;
        }

        //SHA1 del id para el campo "checkemail"
        $update = array("checkemail" => sha1("$id"));
        $id = parent::update($update, $id);
        if (!$id) {
            $this->setMsg(["msg" => "Se produjo un error, intente registrarse más tarde.", "result" => false]);
            return false;
        }

        return $id;
    }

    /**
     * Procesamiento de los datos que corresponden a la tabla usuarioweb
     * Este método pertenece a la registración desde admin
     * @param type $request
     * @return type
     */
    public function registracion_admin($request) {



        $id = $this->insert($request);
        if (!$id) {
            return false;
        }

        //SHA1 del id para el campo "checkemail"
        $update = array("checkemail" => sha1("$id"));
        $id = parent::update($update, $id);
        if (!$id) {
            $this->setMsg(["msg" => "Se produjo un error, intente registrarse más tarde.", "result" => false]);
            return false;
        }

        return $id;
    }

    public function processActivacion($request) {


        $hash = $request["hash"];
        $entity = $this->getByField("checkemail", $hash);

        if (!$entity) {
            $this->setMsg(["result" => false, "usuario" => $entity["tipousuario"], "msg" => "Se produjo un error en la activación."]);
            return false;
            //si ya esta activo pendiente de aprobacion
        } elseif ($entity["estado"] == 1) {
            if ($entity["tipousuario"] == "medico") {
                $ManagerMedico = $this->getManager("ManagerMedico");
                $medico = $ManagerMedico->getFromUsuarioWeb($entity[$this->id]);
                $validado = $medico["validado"];
            }
            $this->setMsg(["result" => true, "activo" => true, "validado" => $validado, "usuario" => $entity["tipousuario"], "msg" => ""]);
            return false;
        } else {
            $id = parent::update(array("estado" => 1), $entity["idusuarioweb"]);
            if ($id > 0) {

                if ($entity["tipousuario"] == "medico") {
                    $ManagerMedico = $this->getManager("ManagerMedico");
                    $medico = $ManagerMedico->getFromUsuarioWeb($entity[$this->id]);
                    if ((int) $medico["validado"] == 1) {
                        $msg = "Puede ingresar al sistema.";
                    } else {
                        $msg = "Se le enviará un mail cuando la administración de DoctorPlus apruebe su cuenta.";
                    }
                } else {
                    //El usuario es paciente
                    $msg = "Disfrute de los beneficios de DoctorPlus.";
                }


                $this->setMsg(["result" => true, "msg" => $msg, "usuario" => $entity["tipousuario"]]);
                return true;
            } else {
                $this->setMsg(["result" => false, "usuario" => $entity["tipousuario"], "msg" => "Se produjo un error en la activación."]);
                return false;
            }
        }
    }

    /**
     * Método que realiza la generacion de una nueva password por parte del admin y envia la nueva al usuario
     * @param type $request
     * @return boolean
     */
    public function changePasswordAdmin($request) {



        $usuario = $this->get($request["idusuario_prestador"]);
        //verifiamos si es un admin de prestador o el admin de DP el que crea los usuarios
        if ($_SESSION[URL_ROOT][CONTROLLER]['logged_account']['user']['idusuario_prestador'] != "") {
            if ($usuario['prestador_idprestador'] != $_SESSION[URL_ROOT][CONTROLLER]['logged_account']['user']['prestador_idprestador']) {
                $this->setMsg(["result" => false, "msg" => "Error. No tiene permisos para realizar esta acción"]);

                return false;
            }
        }
        if ($request["password"] == "") {
            $this->setMsg(["result" => false, "msg" => "Error. No tiene permisos para realizar esta acción"]);

            return false;
        }

        $this->db->StartTrans();
        $randomPass = $request["password"];
        $randomPass_secure = sha1($randomPass);
        $randomPass_secure = base64_encode($randomPass_secure);

        $upd = parent::update(array("password" => $randomPass_secure, "cantidad_intentos_fallidos" => 0), $request["idusuario_prestador"]);

        if ($upd) {
            $mEmail = $this->getManager("ManagerMail");
            $mEmail->setHTML(true);

            //ojo solo arnet local
            $mEmail->setPort("587");

            $mEmail->setSubject("WorknCare - Extranet| Votre mot de passe a été réinitialisé");

            if ($upd) {

                $smarty = SmartySingleton::getInstance();

                $smarty->assign("usuario", $usuario);

                $smarty->assign("password", $randomPass);



                $mEmail->setBody($smarty->Fetch("email/mail_nueva_password_prestador.tpl"));
                $mEmail->addTo($usuario["email"]);


                //header a todos los comentarios!
                if ($mEmail->send()) {
                    $this->db->CompleteTrans();
                    $this->setMsg(["result" => true, "msg" => "Se modificó la contraseña"]);
                    return true;
                }
            }
        }


        $this->db->FailTrans();
        $this->db->CompleteTrans();
        $this->setMsg(["result" => false, "msg" => "Se produjo un error en el cambio de contraseña."]);
        return false;
    }

    /**
     * Método utilizado para actualizar la session del paciente
     * @param type $id
     */
    public function actualiceSessionPaciente($id) {
        $actualice = parent::actualiceSession($id);

        if ($actualice) {
            $ManagerPaciente = $this->getManager("ManagerPaciente");
            $paciente = $ManagerPaciente->getFromUsuarioWeb($id);
            $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["paciente"] = $paciente;

            if (file_exists(path_entity_files("pacientes/" . $paciente["idpaciente"] . "/" . $paciente["idpaciente"] . ".jpg"))) {
                $_SESSION[URL_ROOT]["paciente_p"]['logged_account']["mi_logo"] = true;
            } else {
                $_SESSION[URL_ROOT]["paciente_p"]['logged_account']["mi_logo"] = false;
            }

            $ManagerPaciente->inicializarPaciente();
        }
    }

    /*     * Metodo para enviar una consulta a soporte@gmail.com via mail desde el frontend
     * 
     * * */

    public function enviarMailContacto($request) {


        //envio de la invitacion por mail+
        $array = Array("nombre", "apellido", "email", "mensaje");

        foreach ($array as $key) {
            if ($request[$key] == "") {
                $this->setMsg(["msg" => "Ingrese un $key valido", "result" => false]);
                return false;
            }
        }

        $smarty = SmartySingleton::getInstance();
        $smarty->assign("request", $request);

        $mEmail = $this->getManager("ManagerMail");
        $mEmail->setHTML(true);
        $mEmail->setBody($smarty->Fetch("email/nuevo_mensaje_contacto.tpl"));
        $mEmail->setSubject(sprintf("Contact WorknCare | Nouveau message de %s %s", $request["nombre"], $request["apellido"]));

        $mEmail->setFromName($request["nombre"] . " " . $request["apellido"]);
        $mEmail->AddReplyTo($request["email"], $request["nombre"] . " " . $request["apellido"]);

        $mEmail->addTo(DEFAULT_CONTACT_EMAIL);
        //ojo solo arnet local
        $mEmail->setPort("587");




        if ($mEmail->send()) {
            $this->setMsg(["msg" => "Mensaje enviado con éxito. Le enviaremos una respuesta a la brevedad", "result" => true]);
            return true;
        } else {
            $this->setMsg(["msg" => "No se ha podido enviar el mensaje. Inténtelo más tarde", "result" => false]);
            return false;
        }
    }

    /**
     * Método utilizado para resetear la cantidad de intentos fallidos de un usuario web
     * @param type $idusuarioweb
     * @return type
     */
    public function reset_intentos_fallidos($idusuarioweb) {
        return parent::update(["cantidad_intentos_fallidos" => 0], $idusuarioweb);
    }

}

//END_class 
?>