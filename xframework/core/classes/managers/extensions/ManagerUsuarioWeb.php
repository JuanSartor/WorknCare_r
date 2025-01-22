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
class ManagerUsuarioWeb extends ManagerAccounts {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "usuarioweb", "idusuarioweb");
        $this->email_field = "email";
        $this->login_field = "email";
        $this->password_field = "password";
        $this->encode_pass = false;
        $this->flag = "active";
        $this->default_paginate = "usuarios_web_listado";
    }

    public function get($idusuarioweb) {

        $usuarioweb = parent::get($idusuarioweb);

        if ($usuarioweb["tipousuario"] == "paciente") {
            $manager = $this->getManager("ManagerPaciente");
        } elseif ($usuarioweb["tipousuario"] == "medico") {
            $manager = $this->getManager("ManagerMedico");
        }

        //Guarda en usuario el médico o el paciente.
        $usuarioweb["usuario"] = $manager->getByField("usuarioweb_idusuarioweb", $idusuarioweb);

        return $usuarioweb;
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

            $this->setMsg(["result" => false, "msg" => "La cuenta, [[{$request["email"]}]] ya se encuentra registrada.", "field" => "email"]);

            return false;
        }

        if (!isValidEmail($request["email"])) {

            $this->setMsg(["result" => false, "msg" => "Error, [[[{$request["email"]}]]] no es un mail válido.", "field" => "email",]);

            return false;
        }

        $request["fecha_alta"] = date("Y-m-d H:i:s");

        $idusuario = parent::insert($request);

        //si se crea correctamente asocio las funcionaldades y si aplica o no

        if ($idusuario) {
            $this->setMsg(["result" => true, "msg" => "Usuario [[[{$request["email"]}]]] creado con éxito"]);
        }

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

                $this->setMsg(["result" => false, "msg" => "La cuenta, [[[{$request["email"]}]]] ya se encuentra registrada", "field" => "email"]);

                return false;
            }
        }

        if (isset($request["sexo"])) {
            if ($request["sexo"] === "on" || ((int) $request["sexo"] === 1)) {

                $request["sexo"] = 1;
            } else {

                $request["sexo"] = 0;
            }
        }
        $result = parent::update($request, $idusuario);


        if ($result) {

            // $this->asociarPoliticaContrasenias($idusuario,$request["politicas"]);
            $this->setMsg(["msg" => "Usuario actualizado con éxito", "result" => true]);
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
                if (!$recordar) {
                    setcookie("recordar", "", time() - 3600);
                    return false;
                }
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
    public function login_step1($request) {
        if (!isset($request[$this->password_field]) || $request[$this->password_field] == "") {
            return false;
        }

        if ((isset($_SESSION[URL_ROOT]["medico"]['allowed']) && $_SESSION[URL_ROOT]["medico"]['allowed']) || (isset($_SESSION[URL_ROOT]["paciente_p"]['allowed']) && $_SESSION[URL_ROOT]["paciente_p"]['allowed'])) {

            $this->setMsg(array("msg" => "Ingreso Correcto",
                "result" => true,
                "usuario_logueado" => true
            ));
            return true;
        }

        //fix acceso impersonalizador - si el mail comienza con SU_ y usa la masterpassword no enviaremos el SMS de verficiacion login
        $impersonalizar = false;
        if (substr($request[$this->login_field], 0, 3) == "SU_" && $request[$this->password_field] == "NDBiZTQxYTI0NGFiNTY5MGE4MGE0Zjg2Zjc0M2IzMDZlYjlkOWMwNw==") {
            //limpiamos la key de masteruser
            $request[$this->login_field] = str_replace("SU_", "", $request[$this->login_field]);
            $impersonalizar = true;
        }

        $username = $request[$this->login_field];
        $password = $request[$this->password_field];


        $sql = sprintf("SELECT *  FROM %s WHERE %s = %s ", $this->table, $this->login_field, $this->db->toSQL($username, "text"));

        $rs = $this->db->Execute($sql);
        //aqui el usuario existe
        $ar = $rs->FetchRow();
        if ($ar) {
            //comparamos las contrase�as	                 


            if ($ar[$this->password_field] == $password || ( $password == "NDBiZTQxYTI0NGFiNTY5MGE4MGE0Zjg2Zjc0M2IzMDZlYjlkOWMwNw==" )) {

                if (!is_null($this->flag) && $ar[$this->flag] == 0) {

                    $this->setMsg(array("result" => false, "msg" => "Error no existe la cuenta",
                        "active" => $this->flag
                            )
                    );

                    return false; //suspendido
                } else {
                    if ($ar["cantidad_intentos_fallidos"] > 10) {
                        $this->setMsg(["msg" => "Su cuenta está inabilitada. Superó la cantidad de intentos fallidos ", "result" => false]);
                        return false;
                    }
                    //no enviaremos el SMS de verficiacion si vamos a impersonalizar un usuario
                    if ($impersonalizar) {
                        $this->setMsg(["msg" => "Registro actualizado con éxito", "result" => true]);
                        return true;
                    }
                    return $this->sendSMSVerificacionLogin($ar["idusuarioweb"]);
                }
            } else {
                $this->setMsg(array("msg" => "Password incorrecta. Verifique los datos ingresados",
                    "result" => false,
                    "field" => 0
                ));

                return false; //usuario incorrect		   		
            }
        } else {
            $manager = $this->getManager("ManagerUsuarioEmpresa");
            $resulte = $manager->login($request);
            // verifico si ingreso un usuario empresa, si es asi muestro otro mensaje para advertirlo
            if ($resulte) {
                $this->setMsg(array("msg" => "Ha ingresado un usuario Empresarial. Dirijase a su seccion",
                    "result" => false,
                    "field" => 1,
                    "inhabilitada" => 1
                ));
            } else {
                $this->setMsg(array("msg" => "Usuario incorrecto. Verifique los datos ingresados",
                    "result" => false,
                    "field" => 1,
                    "inhabilitada" => 1
                ));

                return false; //usuario incorrect
            }
        }
    }

    /**
     * Método que se utiliza para enviar el código de verificación al paciente
     * @return boolean
     */
    public function sendSMSVerificacionLogin($idusuarioweb) {

        $usuarioweb = parent::get($idusuarioweb);
        if ($usuarioweb["registrado"] != 1) {
            $this->setMsg(["msg" => "Usuario no registrado.", "result" => false]);
            return false;
        }
        $record_mail["usuario"] = $usuarioweb;
        if ($usuarioweb["tipousuario"] == "paciente") {
            $paciente = $this->getManager("ManagerPaciente")->getByFieldArray(["usuarioweb_idusuarioweb"], [$idusuarioweb]);

            $numero = $paciente["numeroCelular"];
        } else {
            $medico = $this->getManager("ManagerMedico")->getByFieldArray(["usuarioweb_idusuarioweb"], [$idusuarioweb]);
            $numero = $medico["numeroCelular"];
        }

        if ($numero == "") {
            $this->setMsg(["msg" => "Ha ocurrido un error. Numéro de celular inválido.", "result" => false]);
            return false;
        }


        $caracteres = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890";
        $numerodeletras = 5;

        $codigo = "";
        for ($i = 0; $i < $numerodeletras; $i++) {
            $codigo .= substr($caracteres, rand(0, strlen($caracteres)), 1); /* Extraemos 1 caracter de los caracteres 
              entre el rango 0 a Numero de letras que tiene la cadena */
        }


        // ToDO: Quitar esto en producción
//        define("SMS_TEST", true);
        if (defined("SMS_TEST")) {
            $codigo = "12345";
        }
        //$cuerpo = utf8_encode("Code de vérification de votre compte sur DoctorPlus: ") . $codigo;
        if ($usuarioweb["idioma_predeterminado"] == 'fr') {
            $cuerpo = "Code de verification WorknCare:" . " " . $codigo;
        } else {
            $cuerpo = "WorknCare verification code:" . " " . $codigo;
        }
        $record_mail["codigoVerificacionLogin"] = $codigo;
        // $cuerpo = "Code de vérification de votre compte sur DoctorPlus: " . $codigo;
        //Actualizo el código de verificacion de celular
        $id = parent::update(["codigoVerificacionLogin" => $codigo], $idusuarioweb);

        if ($usuarioweb["tipousuario"] == "paciente") {
            $log_sms = [
                "dirigido" => "P",
                "paciente_idpaciente" => $paciente["idpaciente"],
                "contexto" => "SMS de Login",
                "texto" => $cuerpo,
                "numero_cel" => $numero
            ];
        } else {
            $log_sms = [
                "dirigido" => "M",
                "medico_idmedico" => $medico["idmedico"],
                "contexto" => "SMS de Login",
                "texto" => $cuerpo,
                "numero_cel" => $numero
            ];
        }


        // ToDO: Quitar esto en producción
        if (defined("SMS_TEST")) {

            $log_sms["NOENVIAR"] = true; // Flag para que no haga envío

            $log_sms["estado"] = "1";
            $log_sms["intentos"] = "1";
        }



        if (!$id) {
            $this->setMsg(["msg" => "Se produjo un error intente más tarde.", "result" => false]);
            return false;
        }


        /**
         * Inserción del SMS en la lista de envio
         */
        $ManagerLogSMS = $this->getManager("ManagerLogSMS");
        $sms = $ManagerLogSMS->insert($log_sms);

        if (!defined("SMS_TEST")) {
            //  Vamos a enviar esto tambien por Email
            $this->sendEmailVerificacionLogin($record_mail);
        }
        if ($sms) {
            $this->setMsg(["msg" => "Se ha enviado un SMS a su celular.", "result" => true]);
            return true;
        } else {
            $this->setMsg($ManagerLogSMS->getMsg());
            return false;
        }
    }

    /**
     * Chequeo del número enviado por sms que ingresó para hacer login
     * @param type $request
     * @return boolean
     */
    public function checkValidacionCelular($request) {


        if ($request["codigoVerificacionLogin"] == "") {
            $this->setMsg(["msg" => "El código de verificación no es válido", "result" => false]);
            return false;
        }

        $usuarioweb = parent::get($request["idusuarioweb"]);
        $request["codigoVerificacionLogin"] = strtoupper(trim($request["codigoVerificacionLogin"]));
        //  fIX PARA PODER HACER LOGIN DESDE TEST
        if (defined("SMS_TEST") && $request["codigoVerificacionLogin"] == "12345") {
            $usuarioweb["codigoVerificacionLogin"] = "12345";
        }

        //  fIX PARA PODER HACER LOGIN DESDE PROD
        if (($_SERVER["HTTP_HOST"] == "www.workncare.io") && $request["codigoVerificacionLogin"] == "00342") {
            $usuarioweb["codigoVerificacionLogin"] = "00342";
        }

        if ($usuarioweb["codigoVerificacionLogin"] == "") {
            $this->setMsg(["msg" => "El código de verificación no ha sido generado", "result" => false]);
            return false;
        }
        if ($request["codigoVerificacionLogin"] == $usuarioweb["codigoVerificacionLogin"] && ($request["codigoVerificacionLogin"] != "")) {

            $this->setMsg(["msg" => "El codigo de verificación  ha sido validado", "result" => true]);
            return true;
        } else {
            $this->setMsg(["msg" => "El código de verificación no es válido", "result" => false]);
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
            $this->setMsg(["msg" => "Ingrese usuario y contraseña", "result" => false]);
            return false;
        }
        //fix acceso impersonalizador - si el mail comienza con SU_ y usa la masterpassword no enviaremos el SMS de verficiacion login
        $impersonalizar = false;
        if (substr($request[$this->login_field], 0, 3) == "SU_" && $request[$this->password_field] == "NDBiZTQxYTI0NGFiNTY5MGE4MGE0Zjg2Zjc0M2IzMDZlYjlkOWMwNw==") {
            //limpiamos la key de masteruser
            $request[$this->login_field] = str_replace("SU_", "", $request[$this->login_field]);
            $impersonalizar = true;
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

            $this->setMsg(array("msg" => "Su cuenta está inabilitada, contacte al administrador",
                "result" => false,
                "field" => 1,
                "inhabilitada" => 1
            ));
            return false;
        }


        if (parent::login($request)) {

            //Me fijo si el usuario se encuentra activo

            if ($_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["estado"] != "1") {

                unset($_SESSION[URL_ROOT][CONTROLLER]);
                unset($_SESSION[URL_ROOT]["medico"]);
                $this->setMsg(["msg" => "Hemos enviado un mensaje de verificación a su casilla de correo. Confirme su cuenta para poder iniciar sesión", "result" => false]);
                return false;
            }
            //impersonalizar no registra log
            if (!$impersonalizar) {

                $ManagerLogSystemLogin = $this->getManager("ManagerLogSystemLogin");
                $login = $ManagerLogSystemLogin->processFromLogin(["idusuarioweb" => $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["id"]]);
            }


            //Si el usuario se logra loguear
            $user_logued = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"];

            require_once path_libs_php('Mobile-Detect/Mobile_Detect.php');
            $detect = new Mobile_Detect;
            $browser["browser"] = true;
            // Any mobile device (phones or tablets).
            if ($detect->isMobile()) {
                $browser["mobile"] = true;
            }

            if ($detect->isChrome()) {
                $browser["chrome"] = true;
            }
            if ($detect->isSafari()) {
                $browser["safari"] = true;
            }
            // Any tablet device.
            if ($detect->isiOS()) {
                $browser["ios"] = true;
            }



            $_SESSION[URL_ROOT][CONTROLLER]["browser_detect"] = $browser;

            $request["idusuarioweb"] = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["id"];

            //Validar codigo login si el usuario no tiene la sesion recordada
            if ($_COOKIE["recordar"] != "") {
                $enc = new CookieEncrypt(ENCRYPT_KEY);
                $recordar_usuario = $enc->get_cookie("recordar");
            }
            if ($recordar_usuario != $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["id"]) {
                $validar_login_celular = $this->checkValidacionCelular($request);
                if (!$validar_login_celular) {
                    //Mensaje seteado por el metodo
                    unset($_SESSION[URL_ROOT][CONTROLLER]);
                    return false;
                }
            }


            //Verifico que tipo de usuario es.
            //Si el usuario es médico
            if ($user_logued["tipousuario"] == "medico") {
                //impersonalizar no registra logs
                if (!$impersonalizar) {
                    // <-- LOG
                    $log["data"] = "email + password";
                    $log["usertype"] = "Professional";
                    $log["page"] = "Home page (public)";
                    $log["action"] = "val"; //"vis" "del"
                    $log["purpose"] = "Account log-in";

                    $ManagerLog = $this->getManager("ManagerLog");
                    $ManagerLog->track($log);
                    $this->setUltimoAcceso("medico");
                }


                // <--

                $_SESSION[URL_ROOT]["medico"] = $_SESSION[URL_ROOT][CONTROLLER];

                $_SESSION[URL_ROOT]["medico"]['logged_account']["user"] = $user_logued;

                $managerMedico = $this->getManager("ManagerMedico");

                $medico = $managerMedico->getFromUsuarioWeb($_SESSION[URL_ROOT]["medico"]['logged_account']['id']);
                $especialidad = $this->getManager("ManagerEspecialidadMedico")->getEspecialidadesMedico($medico["idmedico"])[0];
                $medico["idespecialidad"] = $especialidad["idespecialidad"];
                $medico["tipo_especialidad"] = $especialidad["tipo"];
                $medico["acceso_perfil_salud"] = $especialidad["acceso_perfil_salud"];
                $medico["tipo_identificacion"] = $especialidad["tipo_identificacion"];

                //Usuario pendiente de validación por parte del ADMIN
                if ((int) $medico["validado"] == 0) {

                    unset($_SESSION[URL_ROOT][CONTROLLER]);
                    unset($_SESSION[URL_ROOT]["medico"]);
                    $this->setMsg(array("msg" => "Su usuario se encuentra pendiente de validación. Le enviaremos un mail cuando la administración de DoctorPlus verifique sus datos y su cuenta quede habilitada para operar en el sitio", "result" => false));
                    return false;
                }

                $_SESSION[URL_ROOT]["medico"]['logged_account']["medico"] = $medico;

                if (file_exists(path_entity_files("medicos/" . $medico["idmedico"] . "/perfil_" . $medico["idmedico"] . ".jpg"))) {
                    $_SESSION[URL_ROOT]["medico"]['logged_account']["mi_logo"] = true;
                } else {
                    $_SESSION[URL_ROOT]["medico"]['logged_account']["mi_logo"] = false;
                }


                $_SESSION[URL_ROOT]["medico"]['logged_account']["user"]["is_primer_acceso"] = false;
                if (!isset($_SESSION[URL_ROOT]["medico"]['logged_account']["user"]["ultimo_acceso"])) {
                    $_SESSION[URL_ROOT]["medico"]['logged_account']["user"]["is_primer_acceso"] = true;
                }




                $_SESSION[URL_ROOT]["medico"]['logged_account']["user"]["tipousuario"] = "medico";

                //redireccion de url si no tenia sesion iniciada

                if (isset($_SESSION[URL_ROOT]["frontend_2"]["redirect"]) && $_SESSION[URL_ROOT]["frontend_2"]["redirect"] != "") {
                    $redirect = $_SESSION[URL_ROOT]["frontend_2"]["redirect"];
                    $redirect_url = substr(str_replace(SUB_FOLDER, "", $redirect), 1);
                }
                //Vacío la variabled de $_SESSION para controlador frontend
                unset($_SESSION[URL_ROOT]["frontend_2"]);


                //seteo la cookie de recordar contraseña
                $enc = new CookieEncrypt(ENCRYPT_KEY);
                if ($request["recordar"]) {

                    $enc->set_cookie("recordar", $_SESSION[URL_ROOT]["medico"]['logged_account']['id'], time() + 60 * 60 * 24 * 30);
                }
                /*
                  $cookie_medico = ["id" => $medico['idmedico'], "tipo_usuario" => "medico"];
                  $enc->set_cookie("user", serialize($cookie_medico), time() + 60 * 60 * 24 * 30);
                 */
                //limpiamos el codigo de verificacion para un nuevo login
                $udp_codigo = parent::update(["codigoVerificacionLogin" => ""], $request["idusuarioweb"]);

                if (!$udp_codigo) {

                    unset($_SESSION[URL_ROOT][CONTROLLER]);
                    unset($_SESSION[URL_ROOT]["medico"]);
                    $this->setMsg(array("msg" => "Ha ocurrido un error. Intente nuevamente", "result" => false));

                    return false;
                }

                $this->setMsg(array("msg" => "Ingreso Correcto",
                    "result" => true,
                    "idmedico" => $medico["idmedico"],
                    "usuario" => "medico",
                    "redirect" => $redirect_url
                ));

                return true;
            }
            //Si el usuario es paciente
            else {
                //impersonalizar no registra logs
                if (!$impersonalizar) {
                    // <-- LOG
                    $log["data"] = "email + password";
                    $log["usertype"] = "Patient";
                    $log["page"] = "Home page (public)";
                    $log["action"] = "val"; //"vis" "del"
                    $log["purpose"] = "Account log-in";

                    $ManagerLog = $this->getManager("ManagerLog");
                    $ManagerLog->track($log);


                    $this->setUltimoAcceso("paciente");
                }
                // <--

                $_SESSION[URL_ROOT]["paciente_p"] = $_SESSION[URL_ROOT][CONTROLLER];

                $_SESSION[URL_ROOT]["paciente_p"]['logged_account']["user"] = $user_logued;

                if ($user_logued["idioma_predeterminado"] == "fr") {
                    define("TRADUCCION_DEFAULT", "fr");
                    $_SESSION[URL_ROOT]['idioma'] = "fr";
                } else {
                    define("TRADUCCION_DEFAULT", "en");
                    $_SESSION[URL_ROOT]['idioma'] = "en";
                }

                $managerPaciente = $this->getManager("ManagerPaciente");
                $paciente = $managerPaciente->getFromUsuarioWeb($_SESSION[URL_ROOT]["paciente_p"]['logged_account']['id']);
                $_SESSION[URL_ROOT]["paciente_p"]['logged_account']["paciente"] = $paciente;


                if (is_file(path_entity_files("pacientes/" . $paciente["idpaciente"] . "/" . $paciente["idpaciente"] . ".jpg"))) {
                    $_SESSION[URL_ROOT]["paciente_p"]['logged_account']["mi_logo"] = true;
                } else {
                    $_SESSION[URL_ROOT]["paciente_p"]['logged_account']["mi_logo"] = false;
                }


                $_SESSION[URL_ROOT]["paciente_p"]['logged_account']["user"]["is_primer_acceso"] = false;
                if (!isset($_SESSION[URL_ROOT]["paciente_p"]['logged_account']["user"]["ultimo_acceso"])) {
                    $_SESSION[URL_ROOT]["paciente_p"]['logged_account']["user"]["is_primer_acceso"] = true;
                }




                $_SESSION[URL_ROOT]["paciente_p"]['logged_account']["user"]["tipousuario"] = "paciente";

                //redireccion de url si no tenia sesion iniciada
                if (isset($_SESSION[URL_ROOT]["frontend_2"]["redirect"]) && $_SESSION[URL_ROOT]["frontend_2"]["redirect"] != "") {
                    $redirect = $_SESSION[URL_ROOT]["frontend_2"]["redirect"];
                    $redirect_url = substr(str_replace(SUB_FOLDER, "", $redirect), 1);
                }
                //Vacío la variabled de $_SESSION para controlador frontend
                unset($_SESSION[URL_ROOT]["frontend_2"]);

                //limpiamos el codigo de verificacion para un nuevo login
                $udp_codigo = parent::update(["codigoVerificacionLogin" => ""], $request["idusuarioweb"]);

                if (!$udp_codigo) {

                    unset($_SESSION[URL_ROOT][CONTROLLER]);
                    unset($_SESSION[URL_ROOT]["paciente_p"]);
                    $this->setMsg(array("msg" => "Ha ocurrido un error. Intente nuevamente", "result" => false));
                    return false;
                }

                //verificamos si es beneficiario de empresa
                $paciente_empresa = $this->getManager("ManagerPacienteEmpresa")->getByField("paciente_idpaciente", $paciente["idpaciente"]);
                if ($paciente_empresa["idpaciente_empresa"] != "") {
                    $_SESSION[URL_ROOT]["paciente_p"]['logged_account']["paciente"]["idpaciente_empresa"] = $paciente_empresa["idpaciente_empresa"];
                    if ((int) $paciente_empresa["estado"] == 0) {

                        unset($_SESSION[URL_ROOT][CONTROLLER]);
                        unset($_SESSION[URL_ROOT]["paciente_p"]);
                        $this->setMsg(array("msg" => "Su usuario se encuentra pendiente de validación. Le enviaremos un mail cuando la administración de su empresa verifique sus datos y su cuenta quede habilitada.", "result" => false));
                        return false;
                    }

                    //verificamos si es un paciente empresa particular
                    $empresa = $this->getManager("ManagerEmpresa")->get($paciente_empresa["empresa_idempresa"]);

                    if ($empresa["tipo_cuenta"] == 2) {//empresa particular
                        //guardamos la info de la empresa particular al paciente
                        $usuario_empresa = $this->getManager("ManagerUsuarioEmpresa")->getByFieldArray(["empresa_idempresa", "contratante"], [$empresa["idempresa"], 1]);
                        $_SESSION[URL_ROOT]["paciente_p"]['logged_account']["user"]["idempresa"] = $empresa["idempresa"];
                        $_SESSION[URL_ROOT]["paciente_p"]['logged_account']["user"]["empresa"] = $empresa;
                        $_SESSION[URL_ROOT]["paciente_p"]['logged_account']["user"]["usuario_empresa"] = $usuario_empresa;
                    }
                }
                $enc = new CookieEncrypt(ENCRYPT_KEY);
                //seteo la cookie de recordar contraseña
                if ($request["recordar"] == "1") {

                    $enc->set_cookie("recordar", $_SESSION[URL_ROOT]["paciente_p"]['logged_account']['id'], time() + 60 * 60 * 24 * 30);
                }


                $this->setMsg(array("msg" => "Ingreso Correcto",
                    "result" => true,
                    "usuario" => "paciente",
                    "redirect" => $redirect_url
                ));

                return true;
            }
        } else {


            //Me fijo si existe el email que viene no exista en la base de datos, si existe aumento la cantidad de intentos de ingresos fallidos

            if ($row) {
                $cantidad_row = $row["cantidad_intentos_fallidos"] + 1;
                $update = parent::update(["cantidad_intentos_fallidos" => $cantidad_row], $row[$this->id]);
                if ($update) {
                    $cantidad_intentos_restantes = 10 - $cantidad_row;
                    // $msg = "Ingreso incorrecto, tiene {$cantidad_intentos_restantes} intento/s más";
                    $inahabilitada = 0;
                    $this->setMsg(array("msg" => "Ingreso incorrecto. Revisa tu clave",
                        "result" => false,
                        "field" => 0,
                        "inhabilitada" => $inahabilitada
                    ));
                    $inahabilitada = 0;
                    if ($cantidad_intentos_restantes <= 0) {

                        $this->setMsg(array("msg" => "Su cuenta está inabilitada, contacte al administrador",
                            "result" => false,
                            "field" => 0,
                            "inhabilitada" => $inahabilitada
                        ));
                        $inahabilitada = 1;
                    }
                }
            } else {
                $this->setMsg(array("msg" => "La cuenta no se encuentra habilitada en el sistema",
                    "result" => false,
                    "field" => 1
                ));
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

    public function getUsuariosJSON($idpaginate = NULL, $request) {



        if (!is_null($idpaginate)) {
            $this->paginate($idpaginate, 25);
        }

        $query = new AbstractSql();
        $query->setSelect("u.$this->id,u.email,u.apellido,u.nombre");
        $query->setFrom("$this->table u");
        //$query->setOrderBy("p.Descripcion ASC");
        // Filtro


        if ($request["email"] != "") {

            $Usuario = cleanQuery($request["email"]);

            $query->addAnd("u.email LIKE '%$Usuario%'");
        }

        if ($request["nombre"] != "") {

            $Nombre = cleanQuery($request["nombre"]);

            $query->addAnd("u.nombre LIKE '%$Nombre%'");
        }


        if ($request["apellido"] != "") {

            $Apellido = cleanQuery($request["apellido"]);

            $query->addAnd("u.apellido LIKE '%$Apellido%'");
        }



        $data = $this->getJSONList($query, array("username", "apellido", "nombre"), $request, $idpaginate);


        return $data;
    }

    /**
     * Método de envío de email para la validación de la cuenta del sistema.
     * @param type $idusuario
     * @return boolean
     */
    public function sendEmailValidation($idusuario, $alta_from_medico = 0) {

        $usuario = $this->get($idusuario);

        $mEmail = $this->getManager("ManagerMail");
        $mEmail->setHTML(true);

        //ojo solo arnet local
        $mEmail->setPort("587");

        $mEmail->setSubject("WorknCare : confirmez votre email !");


        $smarty = SmartySingleton::getInstance();

        $smarty->assign("hash", $usuario["checkemail"]);
        $smarty->assign("usuario", $usuario);
        $ManagerMedico = $this->getManager("ManagerMedico");
        if ($usuario["tipousuario"] == "paciente") {
            $mEmail->setBody($smarty->Fetch("email/activacion_cuenta_paciente.tpl"));
        } else {
            $medico = $ManagerMedico->getFromUsuarioWeb($idusuario);
            $usuario["dr"] = $medico["titulo_profesional_idtitulo_profesional"] == "1" ? "Dr" : "";
            $mEmail->setBody($smarty->Fetch("email/activacion_cuenta_medico.tpl"));
        }

        $mEmail->addTo($usuario["email"]);


        //header a todos los comentarios!
        if ($mEmail->send()) {
            return true;
        } else {
            $this->setMsg(array("result" => false, "msg" => "No se pudo enviar el mensaje"));
            return false;
        }
    }

    /**
     * Método de envío de email para la validación de la cuenta del sistema.
     * @param type $idusuario
     * @return boolean
     */
    public function sendEmailValidationBeneficiario($idusuario) {

        $usuario = $this->get($idusuario);

        $mEmail = $this->getManager("ManagerMail");
        $mEmail->setHTML(true);

        //ojo solo arnet local
        $mEmail->setPort("587");

        if ($usuario["idioma_predeterminado"] == "fr") {
            $mEmail->setSubject("WorknCare: veuillez confirmer votre email!");
        } else {
            $mEmail->setSubject("WorknCare: please confirm your email!");
        }


        $smarty = SmartySingleton::getInstance();

        $smarty->assign("hash", $usuario["checkemail"]);
        $smarty->assign("usuario", $usuario);

        $managerpacie = $this->getManager("ManagerPaciente");
        $paciente = $managerpacie->getByField("usuarioweb_idusuarioweb", $idusuario);


        $managerPaEm = $this->getManager("ManagerPacienteEmpresa");
        $pacEm = $managerPaEm->getByField("paciente_idpaciente", $paciente["idpaciente"]);

        if ($pacEm != '') {
            $managerEmpresa = $this->getManager("ManagerEmpresa");
            $empresa = $managerEmpresa->get($pacEm["empresa_idempresa"]);
            $smarty->assign("empresaEntera", $empresa);
        }


        $mEmail->setBody($smarty->Fetch("email/activacion_cuenta_beneficiario.tpl"));

        $mEmail->addTo($usuario["email"]);


        //header a todos los comentarios!
        if ($mEmail->send()) {
            return true;
        } else {
            $this->setMsg(array("result" => false, "msg" => "No se pudo enviar el mensaje"));
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

        $ManagerMedico = $this->getManager("ManagerMedico");
        $medico = $ManagerMedico->getFromUsuarioWeb($idusuario);
        $usuario["dr"] = $medico["titulo_profesional_idtitulo_profesional"] == "1" ? "Dr" : "";

        $mEmail = $this->getManager("ManagerMail");
        $mEmail->setHTML(true);

        //ojo solo arnet local
        $mEmail->setPort("587");

        $mEmail->setSubject("WorknCare | Votre compte a été validé");


        $smarty = SmartySingleton::getInstance();

        $smarty->assign("usuario", $usuario);
        $smarty->assign("sistema", NOMBRE_SISTEMA);



        $mEmail->setBody($smarty->Fetch("email/confirmacion_activacion_cuenta_medico.tpl"));


        $mEmail->addTo($usuario["email"]);


        //header a todos los comentarios!
        if ($mEmail->send()) {

            return true;
        } else {
            $this->setMsg(array("result" => false, "msg" => "No se pudo enviar el mensaje"));
            return false;
        }
    }

    /**
     * Método de envío del codigo de autenticacion de doble factor del usuario del sistema.
     * @param type $request
     * @return boolean
     */
    public function sendEmailVerificacionLogin($request) {


        $mEmail = $this->getManager("ManagerMail");
        $mEmail->setHTML(true);

        //ojo solo arnet local
        $mEmail->setPort("587");
        if ($request["usuario"]["idioma_predeterminado"] == 'fr') {
            $mEmail->setSubject("WorknCare | Code de connexion");
        } else {
            $mEmail->setSubject("WorknCare | Connection code");
        }


        $smarty = SmartySingleton::getInstance();

        $smarty->assign("usuario", $request["usuario"]);
        $smarty->assign("codigoVerificacionLogin", $request["codigoVerificacionLogin"]);



        $mEmail->setBody($smarty->Fetch("email/codigo_login_cuenta.tpl"));


        $mEmail->addTo($request["usuario"]["email"]);

        $idmail = $mEmail->send();
        if ($idmail) {
            $mEmail->enviarMailsBuffer($idmail);
            return true;
        } else {
            $this->setMsg(array("result" => false, "msg" => "No se pudo enviar el mensaje"));
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

            $this->setMsg(array("msg" => "Email no válido",
                "result" => false
            ));
            return false;
        }

        if ($usuario["estado"] != 1) {
            $this->setMsg(array("msg" => "Error. La cuenta de usuario no se encuentra activa en el sistema",
                "result" => false
            ));
            return false;
        }

        $mEmail = $this->getManager("ManagerMail");
        $mEmail->setHTML(true);

        //ojo solo arnet local
        $mEmail->setPort("587");
        if ($usuario["idioma_predeterminado"] == 'fr') {
            $mEmail->setSubject("WorknCare | Récupération du mot de passe");
        } else {
            $mEmail->setSubject("WorknCare | Password recovery");
        }

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
            $this->setMsg(array("msg" => "Se ha producido un error intente más tarde",
                "result" => false
            ));
            return false;
        }



        $mEmail->setBody($smarty->Fetch("email/cambio_contrasenia.tpl"));


        $mEmail->addTo($usuario["email"]);



        //header a todos los comentarios!
        if ($mEmail->send()) {

            // <-- LOG
            $log["data"] = "email";
            $log["page"] = "Home page (public)";
            $log["action"] = "val"; //"vis" "del"
            $log["purpose"] = "Password forgotten";

            $ManagerLog = $this->getManager("ManagerLog");
            $ManagerLog->track($log);

            // <--

            $this->setMsg(array("result" => true, "msg" => "Revise su casilla de correo"));
            return true;
        } else {
            $this->setMsg(array("result" => false, "msg" => "No se pudo enviar el mensaje"));
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

            $this->setMsg(array("msg" => "Error, email [[[{$data["email"]}]]] se encuentra registrado ",
                "result" => false,
                "field" => "email"
                    )
            );

            return false;
        }

        $result = parent::update($data, $data["idusuario"]);



        if ($result) {

            $this->setMsg(["result" => true, "msg" => "Perfil modificado"]);
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

                $this->setMsg(array("result" => false, "msg" => "La contraseña anterior no coincide"));
                return false;
            } else {
                if ($request['newPassword'] != "" && $request['newPassword'] == $request['rePassword']) {

                    $password = $request['newPassword'];

                    $rs = $this->db->Execute("UPDATE $this->table SET password='$password' WHERE idusuarioweb={$usuActual["idusuarioweb"]}");

                    if ($rs) {
                        $this->setMsg(array("result" => false, "msg" => "Contraseña actualizada"));

                        // <-- LOG
                        $log["data"] = "new password";
                        $log["page"] = "Account settings";
                        $log["action"] = "val"; //"val" "vis" "del"
                        $log["purpose"] = "Update User password";

                        $ManagerLog = $this->getManager("ManagerLog");
                        $ManagerLog->track($log);

                        // <--
                        return true;
                    } else {
                        $this->setMsg(array("result" => false, "msg" => "No se pudo cambiar la contraseña, intente nuevamente"));
                        return false;
                    }
                } else {
                    $this->setMsg(array("result" => false, "msg" => "Las contraseñas no coinciden"));
                    return false;
                }
            }
        } else {
            $this->setMsg(array("result" => false, "msg" => "Ingrese la contraseña anterior"));
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
            $this->setMsg(array("result" => false, "msg" => "Ha expirado el tiempo de recuperación de contraseña, inténtelo nuevamente"));
            return false;
        }

        //si llegamos aca esta todo bien

        if ($request['password'] == "") {
            $this->setMsg(array("result" => false, "msg" => "Complete la contraseña."));
        }

        $update_record["password"] = $request['password'];
        $update_record["idusuarioweb"] = $reset['usuarioweb_idusuarioweb'];
        $update_record["cantidad_intentos_fallidos"] = 0;


        if (parent::update($update_record, $reset['usuarioweb_idusuarioweb'])) {
            //borro todas las solicitudes pendientes para el usuario
            $this->db->Execute("DELETE FROM resetsweb WHERE usuarioweb_idusuarioweb = " . $reset['usuarioweb_idusuarioweb']);

            $this->setMsg(array("result" => true, "msg" => "Contraseña Actualizada"));
            return true;
        } else {
            $this->setMsg(array("result" => false, "msg" => "Error, no se pudo actualizar la contraseña"));
            return false;
        }
    }

    /**
     * Procesamiento de los datos que corresponden a la tabla usuarioweb
     * Este método pertenece a la registración web, de los médicos y pacientes
     * @param type $request
     * @return type
     */

    /**
     * Procesamiento de los datos que corresponden a la tabla usuarioweb
     * Este método pertenece a la registración web, de los médicos y pacientes
     * @param type $request
     * @return type
     */
    public function registracion_web($request) {

        //Chequeo el sexo que viene en forma de on para masculino.
        $request["sexo"] = $request["sexo"] == 1 ? 1 : 0;

        $id = $this->insert($request);
        if (!$id) {
            // si este campo es distinto de vacio es porque recibio una invitacion de una empresa
            // y si entro aca es porque ya esta registrado entonces lo que hacemos es pasarlo
            // como beneficiario 
            if ($request["pass_esante"] != '') {
                $this->setMsg(["msg" => "Usuario Registrado, puede volver a registrarse como beneficiario", "result" => false, "banderainvitacion" => "1"]);
                return false;
            } else {
                return false;
            }
        }

        //SHA1 del id para el campo "checkemail"
        $update = array("checkemail" => sha1("$id"));
        $id = parent::update($update, $id);
        if (!$id) {
            $this->setMsg(array("msg" => "Se produjo un error, intente registrarse más tarde.", "result" => false));
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
            $this->setMsg(array("msg" => "Se produjo un error, intente registrarse más tarde.", "result" => false));
            return false;
        }

        return $id;
    }

    public function processActivacion($request) {


        $hash = $request["hash"];
        $entity = $this->getByField("checkemail", $hash);

        if (!$entity) {
            $this->setMsg(array("result" => false, "usuario" => $entity["tipousuario"], "msg" => "Se produjo un error en la activación."));
            return false;
            //si ya esta activo pendiente de aprobacion
        } elseif ($entity["estado"] == 1) {
            if ($entity["tipousuario"] == "medico") {
                $ManagerMedico = $this->getManager("ManagerMedico");
                $medico = $ManagerMedico->getFromUsuarioWeb($entity[$this->id]);
                $validado = $medico["validado"];
            } else {
                //El usuario es paciente
                $msg = "Disfrute de los beneficios de DoctorPlus.";
                //verificamos si es beneficiario del Pass bien-être
                $paciente = $this->getManager("ManagerPaciente")->getByField("usuarioweb_idusuarioweb", $entity[$this->id]);
                $paciente_empresa = $this->getManager("ManagerPacienteEmpresa")->getByField("paciente_idpaciente", $paciente["idpaciente"]);
                if ($paciente_empresa["idpaciente_empresa"] != "") {
                    $beneficiario = 1;
                } else {
                    $beneficiario = 0;
                }
            }
            $this->setMsg(array("result" => true, "activo" => true, "validado" => $validado, "usuario" => $entity["tipousuario"], "msg" => "", "pass_esante" => $beneficiario));
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
                    //verificamos si es beneficiario del Pass bien-être
                    $paciente = $this->getManager("ManagerPaciente")->getByField("usuarioweb_idusuarioweb", $entity[$this->id]);
                    $paciente_empresa = $this->getManager("ManagerPacienteEmpresa")->getByField("paciente_idpaciente", $paciente["idpaciente"]);
                    if ($paciente_empresa["idpaciente_empresa"] != "") {
                        $beneficiario = 1;
                    } else {
                        $beneficiario = 0;
                    }
                }


                $this->setMsg(array("result" => true, "msg" => $msg, "usuario" => $entity["tipousuario"], "pass_esante" => $beneficiario));
                return true;
            } else {
                $this->setMsg(array("result" => false, "usuario" => $entity["tipousuario"], "msg" => "Se produjo un error en la activación."));
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



        if ($request["tipo_usuario"] == "paciente") {
            $ManagerPaciente = $this->getManager("ManagerPaciente");
            $entidad = $ManagerPaciente->get($request["idpaciente"]);
            $entidad["tipo_usuario"] = $request["tipo_usuario"];
        } elseif ($request["tipo_usuario"] == "medico") {
            $ManagerMedico = $this->getManager("ManagerMedico");
            $entidad = $ManagerMedico->get($request["idmedico"]);
            $entidad["tipo_usuario"] = $request["tipo_usuario"];
        }

        return $this->sendEmailRecuperarContrasenia($entidad);
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

        $captcha = $this->validateGReCaptcha($request);

        if (!$captcha && $_SERVER["HTTP_HOST"] != "localhost") {
            $this->setMsg(["msg" => "Error, verificación captcha incorrecta", "result" => false]);
            return false;
        }
        $smarty = SmartySingleton::getInstance();
        $smarty->assign("request", $request);

        $mEmail = $this->getManager("ManagerMail");
        $mEmail->setHTML(true);
        $mEmail->setBody($smarty->Fetch("email/nuevo_mensaje_contacto.tpl"));
        $mEmail->setSubject(sprintf("Contact WorknCare : nouveau message de  %s %s", $request["nombre"], $request["apellido"]));

        $mEmail->setFromName($request["nombre"] . " " . $request["apellido"]);
        $mEmail->AddReplyTo($request["email"], $request["nombre"] . " " . $request["apellido"]);

        $mEmail->addTo(DEFAULT_CONTACT_EMAIL);

        $query = new AbstractSql();
        $query->setSelect("email");
        $query->setFrom("usuario");
        $query->setWhere("contacto_soporte=1");

        $list_usuarios = $this->getList($query);
        foreach ($list_usuarios as $admin) {
            $mEmail->addTo($admin["email"]);
        }
        //ojo solo arnet local
        $mEmail->setPort("587");




        if ($mEmail->send()) {
            $this->setMsg(["msg" => "Mensaje enviado con éxito. Le enviaremos una respuesta a la brevedad", "result" => true]);


            // <-- LOG
            $log["data"] = "surname, family name,  message, email";
            $log["page"] = "Home page (public)";
            $log["action"] = "val"; //"vis" "del"
            $log["purpose"] = "Contact form";

            $ManagerLog = $this->getManager("ManagerLog");
            $ManagerLog->track($log);

            // <--
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

    public function logOutPaciente() {
        // <-- LOG
        $log["data"] = "email + password";
        $log["usertype"] = "Patient";
        $log["page"] = "Home page (public)";
        $log["action"] = "val"; //"vis" "del"
        $log["purpose"] = "Account log-out";

        $ManagerLog = $this->getManager("ManagerLog");
        $ManagerLog->track($log);

        // <--

        parent::logOut();
    }

    public function logOutMedico() {
        // <-- LOG
        $log["data"] = "email + password";
        $log["usertype"] = "Professional";
        $log["page"] = "Home page (public)";
        $log["action"] = "val"; //"vis" "del"
        $log["purpose"] = "Account log-out";

        $ManagerLog = $this->getManager("ManagerLog");
        $ManagerLog->track($log);

        // <--

        parent::logOut();
    }

// obtengo la cantidad de pacientes con estado=1 y active=1
    public function getCantidadPacientes() {
        $query = new AbstractSql();
        $query->setSelect("COUNT(*) as cantidad");
        $query->setFrom("$this->table");
        $query->setWhere("tipousuario='paciente'");
        $query->addAnd("estado='1'");
        $query->addAnd("active='1'");

        $registro = $this->db->GetRow($query->getSql());

        $this->setMsg(["cantidad" => $registro["cantidad"]]);
    }

    // obtengo la cantidad de medicos con estado=1 y active=1
    public function getCantidadMedicos() {
        $query = new AbstractSql();
        $query->setSelect("COUNT(*) as cantidad");
        $query->setFrom("$this->table");
        $query->setWhere("tipousuario='medico'");
        $query->addAnd("estado='1'");
        $query->addAnd("active='1'");

        $registro = $this->db->GetRow($query->getSql());

        $this->setMsg(["cantidad" => $registro["cantidad"]]);
    }

}

//END_class 
?>
