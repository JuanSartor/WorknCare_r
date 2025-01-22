<?php

/**
 * 	@autor Xinergia
 * 	@version 1.0	2020-01-20
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
 * Encapsula el manejo de los Usuarios del sistema
 */
class ManagerUsuarioEmpresa extends ManagerAccounts {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

// Llamamos al constructor del a superclase
        parent::__construct($db, "usuario_empresa", "idusuario_empresa");
        $this->email_field = "email";
        $this->login_field = "email";
        $this->encode_pass = false;
        $this->password_field = "password";
        $this->flag = "activo";
        $this->default_paginate = "usuario_empresa_listado";
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

        // esto es para el idioma predeterminado
        if ($request["idioma_pre"] == "1") {
            $request["idioma_predeterminado"] = "fr";
        } else {
            $request["idioma_predeterminado"] = "en";
        }

        $required_fields = ["email", "password", "nombre", "apellido"];
        foreach ($required_fields as $value) {
            if ($request[$value] == $value) {
                $this->setMsg(["msg" => "Error. Verifique los campos obligatrios", "result" => false]);
                return false;
            }
        }
        if ($request["terminos_condiciones"] == "") {
            $this->setMsg(["msg" => "Debe aceptar los Términos y condiciones de uso del sistema.", "result" => false]);
            return false;
        }

        $captcha = parent::validateGReCaptcha($request);

        if (!$captcha && $_SERVER["HTTP_HOST"] != "localhost") {
            $this->setMsg(["msg" => "Error, verificación captcha incorrecta", "result" => false]);
            return false;
        }

//valido descripcion unica
        if (!$this->validateUnique("email", $request["email"])) {

            $this->setMsg(
                    array(
                        "result" => false,
                        "msg" => "La cuenta, [[{$request["email"]}]] ya se encuentra registrada",
                        "spry_msg" => array(
                            "field" => "email",
                            "msg" => "La cuenta, [[{$request["email"]}]] ya se encuentra registrada")
                    )
            );

            return false;
        }

        $this->db->StartTrans();
        $request["nombre"] = ucwords(strtolower($request["nombre"]));
        $request["apellido"] = ucwords(strtolower($request["apellido"]));
        $request["fecha_alta"] = date("Y-m-d H:i:s");

        if ($request["particular"] == "1") {
            $request["empresa"] = "Particulier";
            $request["tipo_cuenta"] = "2";
            $request["fecha_adhesion"] = date("d/m/Y");
            $request["cant_empleados"] = 1;
        }
        if ($request["cupon_descuento"] != "") {
            $request["cupon_descuento"] = strtoupper(trim($request["cupon_descuento"]));
            $cupon_valido = $this->getManager("ManagerProgramaSaludCupon")->getByFieldArray(["codigo_cupon", "activo"], [$request["cupon_descuento"], 1]);
            if (!$cupon_valido) {
                $this->setMsg(["msg" => "El cupón de descuento ingresado no es válido o no se encuentra activo", "result" => false]);
                return false;
            }
        }
        $ManagerEmpresa = $this->getManager("ManagerEmpresa");
        $idempresa = $ManagerEmpresa->insert($request);

        if (!$idempresa) {
            $this->setMsg($ManagerEmpresa->getMsg());
            $this->db->FailTrans();
            $this->db->CompleteTrans();
            return false;
        }
        $request["empresa_idempresa"] = $idempresa;
        $request["contratante"] = 1;
        $idusuario = parent::insert($request);
//mandamos a crear el cliente en stripe
        $cliente_record["email"] = $request["email"];
        $cliente_record["idempotency_key"] = sha1("$idusuario");
        if ($request["tipo_cuenta"] == 1) {
//empresa
            $cliente_record["name"] = $request["empresa"];
            $cliente_record["description"] = "{$request["nombre"]} {$request["apellido"]}";
        } else {
//particular - creamos el beneficiarios del usuario registrado
            $cliente_record["name"] = "{$request["nombre"]} {$request["apellido"]}";
            $cliente_record["description"] = "Particulier";
            $request["empresa_idempresa"] = $idempresa;

            $ManagerPaciente = $this->getManager("ManagerPaciente");
            $idbeneficiario_particular = $ManagerPaciente->registracionBeneficiarioParticular($request);
            if (!$idbeneficiario_particular) {
                $this->setMsg($ManagerPaciente->getMsg());
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                return false;
            }
        }



        $cliente_stripe = $this->getManager("ManagerProgramaSaludSuscripcion")->crear_cliente($cliente_record);

//verificamos si ya tiene una suscripcion activa en stripe
        if ($cliente_stripe["suscripcion_activa"] == true) {

            $this->db->FailTrans();
            $this->db->CompleteTrans();
            $this->setMsg(["msg" => "Error. Usted ya posee una suscripcion activa actualmente. Contacate a nuestro soporte para continuar.", "result" => false]);
            return false;
        }
        if (!$cliente_stripe["id"] || $cliente_stripe["id"] == "" || !$cliente_stripe["client_secret"] || $cliente_stripe["client_secret"] == "") {

            $this->db->FailTrans();
            $this->db->CompleteTrans();
            $this->setMsg(["msg" => "Ha ocurrido un error. Intente nuevamente", "result" => false]);
            return false;
        }



        $record["stripe_customerid"] = $cliente_stripe["id"];
        $record["stripe_client_secret"] = $cliente_stripe["client_secret"];
        $record["checkemail"] = sha1("$idusuario");
//si se crea correctamente asocio las funcionaldades y si aplica o no
        $upd = parent::update($record, $idusuario);
        if (!$upd) {
            $this->db->FailTrans();
            $this->db->CompleteTrans();
            $this->setMsg(["msg" => "Ha ocurrido un error. Intente nuevamente", "result" => false]);
            return false;
        }
//si es un paquete de planes para obra social creamos el invoice para el pago inmediato (No  suscripcion)     
        $empresa = $this->getManager("ManagerEmpresa")->get($idempresa);
        if ($request["plan_idplan"] != '21' && $request["plan_idplan"] != '22' && $request["plan_idplan"] != '23') {
            if ($empresa["obra_social"] == 1) {
                $ManagerProgramaSaludSuscripcion = $this->getManager("ManagerProgramaSaludSuscripcion");
                $crear_compra_pack = $ManagerProgramaSaludSuscripcion->crear_suscripcion_pack(["customerId" => $cliente_stripe["id"]]);
                if (!$crear_compra_pack) {
                    $this->db->FailTrans();
                    $this->db->CompleteTrans();
                    $this->setMsg(["msg" => $ManagerProgramaSaludSuscripcion->getMsg(), "result" => false]);
                    return false;
                }
            }
        }

//enviamos mail de validacion de correo al usuario
        $email = $this->sendEmailValidation($idusuario);
        if ($idusuario && $email) {
//notitificamos al admin de DoctorPlus que hay una empresa nueva registrada
            if ($request["tipo_cuenta"] == 1) {
                $this->sendEmailEmpresaNueva($idusuario);
            } else {
                $this->sendEmailBeneficiarioParticularNuevo($idusuario);
            }

            $this->db->CompleteTrans();
            $this->setMsg(["msg" => "Usuario [[{$request["email"]}]] creado con éxito", "result" => true, "hash" => $empresa["hash"], "idbeneficiario_particular" => $idbeneficiario_particular]);
        } else {
            $this->db->FailTrans();
            $this->db->CompleteTrans();
        }

        return $idusuario;
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
        $result = parent::update($request, $idusuario);

        if ($result) {
            $this->setMsg(["msg" => "Usuario [[{$request["email"]}]] actualizado con éxito", "result" => true]);
        }

        return $result;
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

    public function basic_update($request, $idusuario) {
        return parent::update($request, $idusuario);
    }

    /**
     * Metodo que devuelve un registro de usuario con los datos de la empresa a la que pertenece
     * @param type $idusuario
     * @return type
     */
    public function get($idusuario) {
        $usuario = parent::get($idusuario);
        $empresa = $this->getManager("ManagerEmpresa")->get($usuario["empresa_idempresa"]);
        return array_merge($empresa, $usuario);
    }

    /**
     * Metodo que devuelve un registro de usuario con los datos de la empresa a la que pertenece mediante el hash de la empresa
     * @param type $hash
     * @return type
     */
    public function getByHash($hash) {
        $empresa = $this->getManager("ManagerEmpresa")->getByField("hash", $hash);
        if (!$empresa) {
            $empresa_invitacion = $this->getManager("ManagerEmpresaInvitacion")->getByField("hash", $hash);
            $empresa = $this->getManager("ManagerEmpresa")->get($empresa_invitacion["empresa_idempresa"]);
        }

        $usuario = parent::getByFieldArray(["contratante", "empresa_idempresa"], [1, $empresa["idempresa"]]);
        return array_merge($empresa, $usuario);
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
        if (parent::login($request)) {

            if ($_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["estado"] != "1") {

                unset($_SESSION[URL_ROOT][CONTROLLER]);
                unset($_SESSION[URL_ROOT]["empresa"]);
                $this->setMsg(["msg" => "Hemos enviado un mensaje de verificación a su casilla de correo. Confirme su cuenta para poder iniciar sesión", "result" => false]);
                return false;
            }

            $_SESSION[URL_ROOT]["empresa"] = $_SESSION[URL_ROOT][CONTROLLER];

            $usuario = $this->get($_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idusuario_empresa"]);
            $_SESSION[URL_ROOT]["empresa"]['logged_account']["user"] = $usuario;



            if ($usuario["idioma_predeterminado"] == "fr") {
                define("TRADUCCION_DEFAULT", "fr");
                $_SESSION[URL_ROOT]['idioma'] = "fr";
            } else {
                define("TRADUCCION_DEFAULT", "en");
                $_SESSION[URL_ROOT]['idioma'] = "en";
            }

//verificamos si se finalizo el proceo de contratacion 
            $empresa = $this->getManager("ManagerEmpresa")->get($usuario["empresa_idempresa"]);
            if ($empresa["plan_idplan"] != 21 && $empresa["plan_idplan"] != 22 && $empresa["plan_idplan"] != 23) {


                /**
                 * esto que esta debajo agrego juan el 27-04-2022 
                 * para verificar si es una empres Particulier mostrar mensaje
                 * de que no es una cuenta empresa
                 */
                if ($empresa["empresa"] == "Particulier") {
                    unset($_SESSION[URL_ROOT][CONTROLLER]);
                    unset($_SESSION[URL_ROOT]["empresa"]);
                    $this->setMsg(array("msg" => "Atencion! Su cuenta no es Empresarial",
                        "result" => false,
                        "field" => 0
                    ));
                    return false;
                }


                $suscripcion = $this->getManager("ManagerProgramaSaludSuscripcion")->getByField("empresa_idempresa", $usuario["empresa_idempresa"]);

                if (!$suscripcion || ($suscripcion["subscriptionId"] == "" && $suscripcion["pack_pago_pendiente"] != "2")) {
                    unset($_SESSION[URL_ROOT][CONTROLLER]);
                    unset($_SESSION[URL_ROOT]["empresa"]);
                    $this->setMsg(array("msg" => "Atencion! Su contratacion del Pase de Bienestar se encuentra pendiente. Debe finalizar el proceso para poder continuar",
                        "result" => false,
                        "suscripcion_pendiente" => 1,
                        "hash" => $empresa["hash"],
                        "obra_social" => $empresa["obra_social"],
                        "contratacion_manual" => (int) $empresa["contratacion_manual"],
                    ));
                    return false;
                }
            }
//Mensaje seteado por el metodo
            unset($_SESSION[URL_ROOT][CONTROLLER]);

            $this->setMsg(array("msg" => "Ingreso Correcto",
                "result" => true,
                "id" => $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idusuario_empresa"],
                "usuario" => "empresa"
            ));
            return true;
        } else {
            $this->setMsg(array("msg" => "Ingreso incorrecto. Revisa tu clave",
                "result" => false,
                "field" => 0
            ));
            return false;
        }
    }

    /*
     * 	@author Xinergia <info@e-xinergia.com>
     *
     *   Usuarios 
     */

    public function getUsuariosJSON($request, $idpaginate = NULL) {
        if (!is_null($idpaginate)) {
            $this->paginate($idpaginate, 25);
        }

        $query = new AbstractSql();
        $query->setSelect("u.idusuario_empresa,
                            u.nombre,
                            u.apellido,
                            u.email,
                            u.fecha_alta, 
                            CASE u.tipo_usuario
                                WHEN 1 THEN 'Todo'
                                WHEN 2 THEN 'Facturas'
                                WHEN 3 THEN 'Beneficiarios'
                                WHEN 4 THEN 'Beneficiarios y Facturas'
                            END as tipo_usuario_format,
                            IF(u.activo = 1,'Activo','Inactivo') AS activo,
                            IF(u.estado = 1,'SI','NO') AS email_confirmado");
        $query->setFrom("usuario_empresa u");
        $query->setWhere("u.empresa_idempresa={$request["idempresa"]}");



        $listado = $this->getJSONList($query, array("nombre", "apellido", "email", "fecha_alta", "tipo_usuario_format", "activo", "email_confirmado"), $request, $idpaginate);

        return $listado;
    }

    /**
     * Método que llama a setear contraseña cuando se olvida
     * @param type $request
     * @return boolean
     */
    public function forgotPass($request) {
//Viene el email
        $usuario = $this->getByField("email", cleanQuery($request["email"]));
        if ($usuario && (int) $usuario["activo"] == 1) {
            return $this->setPassAleatoria($usuario[$this->id]);
        } else {
            $this->setMsg(["result" => false, "msg" => "Error. El usuario solicitado es inexistente"]);
            return false;
        }
    }

    /**
     * Establece una pass aleatoria para un usuario, la envia x email y establece el cambio cambiar_pass a uno
     *
     * */
    public function setPassAleatoria($idusuario) {

        $usuario = $this->get($idusuario);

//solo si esta activo
        if ($usuario["activo"] == 1) {

            $mEmail = $this->getManager("ManagerMail");
            $mEmail->setHTML(true);

//ojo solo arnet local
            $mEmail->setPort("587");

            $mEmail->setSubject("DoctorPlus | Les mots de passe");

            $randomPass = $this->getRandomEasyPass(6);

//              $pass_enc = base64_encode(sha1($randomPass));$randomPass

            if (parent::update(array("password" => $randomPass), $idusuario)) {

                $smarty = SmartySingleton::getInstance();

                $smarty->assign("usuario", $usuario);
                $smarty->assign("password", $randomPass);
                $smarty->assign("sistema", NOMBRE_SISTEMA);


                $mEmail->setBody($smarty->Fetch("mails/mail_recuperar_pass.tpl"));
                $mEmail->addTo($usuario["email"]);


//header a todos los comentarios!
                if ($mEmail->send()) {
                    $this->setMsg(array("result" => true, "msg" => "Contraseña restablecida"));
                    return true;
                } else {
                    $this->setMsg(array("result" => false, "msg" => "Contraseña restablecida, ATENCION: No se pudo enviar el email"));
                    return -2;
                }
            } else {
                $this->setMsg(array("result" => true, "msg" => "No se pudo actualizar la contraseña"));
                return -1;
            }
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

            $this->setMsg(array("msg" => "Error, el email [[{$data["email"]}]] ya se encuentra registrado.",
                "result" => false,
                "spry_msg" => array(
                    "field" => "email",
                    "msg" => "Error, el email [[{$data["email"]}]] ya se encuentra registrado.")
                    )
            );

            return false;
        }

        $result = parent::update($data, $data["idusuario"]);

        $msg = $this->getMsg();

        if ($result) {

            $this->setMsg(["msg" => "Perfil actualizado", "result" => true]);
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
        $query->setSelect("u.idusuario,u.email");
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
            $usuActual = $this->get($_SESSION[URL_ROOT][CONTROLLER]['logged_account']["id"]);

            if ($request['oldPassword'] != $usuActual['password']) {

                $this->setMsg(array("result" => false, "msg" => "La contraseá anterior no coincide"));
                return false;
            } else {
                if ($request['newPassword'] != "") {

                    $password = $request['newPassword'];

                    $rs = $this->db->Execute("UPDATE usuario_empresa SET password='$password' WHERE idusuario_empresa = " . $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["id"]);

                    if ($rs) {
                        $this->setMsg(array("result" => false, "msg" => "Contraseña actualizada"
                                )
                        );
                        return true;
                    } else {
                        $this->setMsg(array("result" => false, "msg" => "No se pudo actualizar la contraseña"
                                )
                        );
                        return false;
                    }
                } else {
                    $this->setMsg(array("result" => false, "msg" => "No se pudo actualizar la contraseña"
                            )
                    );
                    return false;
                }
            }
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
        $consulta->setSelect(" r.idresetsempresa,(r.validez > NOW())as valido,r.hash,r.usuario_empresa_idusuario_empresa");
        $consulta->setFrom(" resetsempresa r");
        $consulta->setWhere(" r.hash = '$hash' ");

        $res = $this->getList($consulta);

        $reset = $res[0];
//si llegamos aca esta todo bien

        if ($request['password'] == "") {
            $this->setMsg(array("result" => false, "msg" => "Complete la contraseña"));
        }

        $update_record = array();
        $update_record["password"] = trim($request['password']);

//echo  "UPDATE REcord:<br>" . print_r($update_record); echo "<hr>";
        if (parent::update($update_record, $reset['usuario_empresa_idusuario_empresa'])) {
//borro todas las solicitudes pendientes para el usuario
            $this->db->Execute("DELETE FROM resetsempresa WHERE usuario_empresa_idusuario_empresa = " . $reset['usuario_empresa_idusuario_empresa']);
            unset($_SESSION['resetAutorizado']);
            $this->setMsg(array("result" => true, "msg" => "Contraseña actualizada con éxito"));
            return true;
        } else {
            $this->setMsg(array("result" => false, "spry_msg" => array("msg" => "Error no se pudo resetear la contraseña")));
            return false;
        }
    }

    /**
     *  Resetea el password de un usuario q lo ha olvidado
     *  y solocito resetearlo mediante un email         
     *
     * */
    public function setear_contrasenia_usuario_empresa($request) {

        if ($request['password'] == "") {
            $this->setMsg(array("result" => false, "msg" => "Complete la contraseña"));
        }

//verifricamos si existe  usuario
        $usuario_secundario = $this->getByFieldArray(["checkemail", "contratante", "estado"], [$request["hash"], 0, 0]);
        if ($usuario_secundario["idusuario_empresa"] == "") {
            $this->setMsg(array("result" => false, "spry_msg" => array("msg" => "Error no se pudo activar la cuenta")));
            return false;
        }
        $update_record = array();
        $update_record["password"] = trim($request['password']);
        $update_record["estado"] = 1;
        $upd = parent::update($update_record, $usuario_secundario["idusuario_empresa"]);
        if ($upd) {

            $this->setMsg(array("result" => true, "msg" => "Su cuenta [[" . $usuario_secundario["email"] . "]] ha sido activada con éxito."));
            return $upd;
        } else {
            $this->setMsg(array("result" => false, "spry_msg" => array("msg" => "Error no se pudo activar la cuenta")));
            return false;
        }
    }

    /**
     * Método que realiza la generacion de una nueva password por parte del admin y envia la nueva al usuario
     * @param type $request
     * @return boolean
     */
    public function changePasswordAdmin($request) {


        $usuario = parent::get($request["idusuario_empresa"]);

        return $this->sendEmailRecuperarContrasenia($usuario);
    }

    /**
     * Método de envío de email para la recuperación de la cuenta del sistema.
     * @param type $request
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
        $mEmail->setFromName("WorknCare");
        if ($usuario["idioma_predeterminado"] == 'fr') {
            $mEmail->setSubject("WorknCare : Récupération du mot de passe");
        } else {
            $mEmail->setSubject("WorknCare : Password recovery");
        }


        $smarty = SmartySingleton::getInstance();

        $hash = time() * (int) $usuario["idusuario_empresa"];
        $hash = sha1("$hash");

        $smarty->assign("hash", $hash);
        $smarty->assign("usuario", $usuario);
        $smarty->assign("sistema", NOMBRE_SISTEMA);

        $ManagerResetsEmpresa = $this->getManager("ManagerResetsEmpresa");
        $insert_reset = array(
            "usuario_empresa_idusuario_empresa" => $usuario["idusuario_empresa"],
            "hash" => $hash
        );
        $idreset = $ManagerResetsEmpresa->insert($insert_reset);
        if (!$idreset) {
            $this->setMsg(array("msg" => "Se ha producido un error intente más tarde",
                "result" => false
            ));
            return false;
        }



        $mEmail->setBody($smarty->Fetch("email/cambio_contrasenia_empresa.tpl"));


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
        $mEmail->setFromName("Notifications WorknCare");
        if ($usuario["idioma_predeterminado"] == "fr") {
            $mEmail->setSubject("WorknCare : confirmer votre email!");
        } else {
            $mEmail->setSubject("WorknCare : confirm your email!");
        }


        $smarty = SmartySingleton::getInstance();

        $smarty->assign("hash", $usuario["checkemail"]);
        $smarty->assign("usuario", $usuario);

        $mEmail->setBody($smarty->Fetch("email/activacion_cuenta_empresa.tpl"));

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
     * Envío del Email para el nuevo médico
     * @param type $idusuario
     * @return boolean
     */
    public function sendEmailBeneficiarioParticularNuevo($idusuario) {
        $usuario = $this->get($idusuario);
        $plan_contratado = $this->getManager("ManagerProgramaSaludPlan")->getByUser($idusuario);
        $mEmail = $this->getManager("ManagerMail");
        $mEmail->setHTML(true);

//ojo solo arnet local
        $mEmail->setPort("587");
        $mEmail->setFromName("Notifications WorknCare");
        $mEmail->setSubject("WorknCaree: Nouvelle création de compte particulier.");


        $smarty = SmartySingleton::getInstance();

        $smarty->assign("usuario", $usuario);
        $smarty->assign("plan_contratado", $plan_contratado);
        $smarty->assign("sistema", NOMBRE_SISTEMA);

        $mEmail->setBody($smarty->Fetch("email/nueva_contratacion_pass_esante_particular.tpl"));

        $mEmail->addTo("yannis.georgandelis@doctorplus.fr");

        $query = new AbstractSql();
        $query->setSelect("email");
        $query->setFrom("usuario");
        $query->setWhere("notificar_nuevo_medico=1");
        $list_usuarios = $this->getList($query);
        foreach ($list_usuarios as $admin) {
            $mEmail->addTo($admin["email"]);
        }




//header a todos los comentarios!
        if ($mEmail->send()) {

            return true;
        } else {
//$this->setMsg(["result" => false, "msg" => "No se pudo enviar el mensaje"]);
            return false;
        }
    }

    /**
     * Envío del Email para el nuevo médico
     * @param type $idusuario
     * @return boolean
     */
    public function sendEmailEmpresaNueva($idusuario) {
        $usuario = $this->get($idusuario);
        $plan_contratado = $this->getManager("ManagerProgramaSaludPlan")->getByUser($idusuario);
        $mEmail = $this->getManager("ManagerMail");
        $mEmail->setHTML(true);

//ojo solo arnet local
        $mEmail->setPort("587");
        $mEmail->setFromName("Notifications WorknCare");
        $mEmail->setSubject("WorknCare : nouvel utilisateur entreprise !");


        $smarty = SmartySingleton::getInstance();

        $smarty->assign("usuario", $usuario);
        $smarty->assign("plan_contratado", $plan_contratado);
        $smarty->assign("sistema", NOMBRE_SISTEMA);

        $mEmail->setBody($smarty->Fetch("email/nueva_contratacion_pass_esante.tpl"));

        $mEmail->addTo("yannis.georgandelis@doctorplus.fr");

        $query = new AbstractSql();
        $query->setSelect("email");
        $query->setFrom("usuario");
        $query->setWhere("notificar_nuevo_medico=1");
        $list_usuarios = $this->getList($query);
        foreach ($list_usuarios as $admin) {
            $mEmail->addTo($admin["email"]);
        }




//header a todos los comentarios!
        if ($mEmail->send()) {

            return true;
        } else {
//$this->setMsg(["result" => false, "msg" => "No se pudo enviar el mensaje"]);
            return false;
        }
    }

    /**
     * Metodo que procesa la activacion de cuenta mediante verificacion del mail del usuario empresa que contrata el plan
     * @param type $request
     * @return boolean
     */
    public function processActivacion($request) {


        $hash = $request["hash"];
        $entity = $this->getByField("checkemail", $hash);

        if (!$entity) {
            $this->setMsg(array("result" => false, "usuario" => $entity["tipousuario"], "msg" => "Se produjo un error en la activación."));
            return false;
            //si ya esta activo pendiente de aprobacion
        } else {
            $id = parent::update(["estado" => 1], $entity["idusuario_empresa"]);
            $empresa = $this->getManager("ManagerEmpresa")->get($entity["empresa_idempresa"]);
            //si es cuenta Particular activamos el usuario web paciente tambien
            if ($empresa["tipo_cuenta"] == 2) {
                $ManagerUsuarioWeb = $this->getManager("ManagerUsuarioWeb");
                $usuarioweb = $ManagerUsuarioWeb->getByField("email", $entity["email"]);
                $upd_usuarioweb = $ManagerUsuarioWeb->basic_update(["estado" => 1], $usuarioweb["idusuarioweb"]);
                if (!$upd_usuarioweb) {
                    $this->setMsg(array("result" => false, "msg" => "Se produjo un error en la activación."));
                    return false;
                }
            }
        }
        if ($id > 0) {
            $this->setMsg(array("result" => true, "msg" => "Disfrute de los beneficios de DoctorPlus.", "usuario" => $entity["tipousuario"]));
            return true;
        } else {
            $this->setMsg(array("result" => false, "msg" => "Se produjo un error en la activación."));
            return false;
        }
    }

    /**
     *  Metodo que realiza la actualizacion de los campos de email en la configuracion de administracion de la empresa
     * 	@author Xinergia <info@e-xinergia.com>
     *   @version 1.0
     */
    public function updateEmail($request, $idusuario_empresa) {

        if ((int) $idusuario_empresa != (int) $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idusuario_empresa"] && CONTROLLER == "empresa") {
            $this->setMsg(["msg" => "Se produjo un error", "result" => false]);
            return false;
        }

        $usuario = $this->get($idusuario_empresa);


//Verificamos si cambio el mail

        $EmailValidado = 1;
        if ($request["email"] != "" && $request["email"] != $usuario["email"]) {

//valido descripcion unica Email
            if (!$this->validateUnique("email", $request["email"])) {

                $this->setMsg(["result" => false, "msg" => "La cuenta, [[" . $request["email"] . "]] ya se encuentra registrada", "field" => "email"]);
                return false;
            }

            $this->db->StartTrans();

            $result = parent::update(["cambioEmail" => $request["email"]], $idusuario_empresa);
            $mail = $this->enviarMailCodigoValidacionEmail();
            $EmailValidado = 0;
        }

//si se crea correctamente asocio las funcionaldades y si aplica o no
        if ($result && $mail) {

            $log["data"] = "Entreprise email / password / tel";
            $log["action"] = "val"; //"val" "vis" "del"
            $log["page"] = "Account settings";
            $log["purpose"] = "User ID";

            $ManagerLog = $this->getManager("ManagerLog");
            $ManagerLog->track($log);

            $this->setMsg(["result" => true, "msg" => "Se modificaron sus datos con éxito", "emailValido" => $EmailValidado]);

            $this->db->CompleteTrans();
            return $result;
        } else {
            $this->setMsg(["result" => false, "msg" => "Se produjo un error al modificar sus datos"]);

            $this->db->FailTrans();
            $this->db->CompleteTrans();
            return false;
        }
    }

    /**
     * Metodo que envia un  email a una direccion alternativa de usuarios cuando se cambia el mail con el codigo de validacion
     * de la nueva direccion.
     * 
     * @param type $request
     */
    public function enviarMailCodigoValidacionEmail() {


        $idusuario_empresa = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idusuario_empresa"];


        $usuario = $this->get($idusuario_empresa);



        if ($usuario["cambioEmail"] == "") {
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
        $id = parent::update(array("codigoValidacionEmail" => $cuerpo), $idusuario_empresa);

        if ($id) {

//envio del codigo por mail

            $smarty = SmartySingleton::getInstance();

            $smarty->assign("usuario", $usuario);
            $smarty->assign("codigoValidacionEmail", $cuerpo);


            $mEmail = $this->getManager("ManagerMail");
            $mEmail->setHTML(true);

//ojo solo arnet local
            $mEmail->setPort("587");
            $mEmail->setFromName("Notifications WorknCare");
            $mEmail->setSubject(sprintf("WorknCare | Code de validation de compte de messagerie"));

            $mEmail->setBody($smarty->Fetch("email/usuario_cambio_email.tpl"));

            $email = $usuario["cambioEmail"];
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
     * Chequeo del número que ingresó el usuario de empresa para la validacion del nuevo mail
     * @param type $request
     * @return boolean
     */
    public function checkValidacionEmail($request) {
        $idusuario_empresa = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idusuario_empresa"];
        $usuario = $this->get($idusuario_empresa);

        $request["codigoValidacionEmail"] = strtoupper(trim($request["codigoValidacionEmail"]));
        if (($request["codigoValidacionEmail"] == $usuario["codigoValidacionEmail"]) && ($request["codigoValidacionEmail"] != "")) {
            $this->db->StartTrans();
            $rdo = parent::update(["email" => $usuario["cambioEmail"], "codigoValidacionEmail" => "", "cambioEmail" => ""], $idusuario_empresa);

            if ($rdo) {
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
     * Metodo que actualiza los datos de la cuenta del usuario de empresa
     * @param type $request
     * @return boolean
     */
    public function saveDatosCuenta($request) {

        $idusuario_empresa = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idusuario_empresa"];
        $usuario = parent::get($idusuario_empresa);
        $required_fields = ["tipo_cuenta_empresa", "nombre", "apellido"];
        foreach ($required_fields as $value) {
            if ($request[$value] == $value) {
                $this->setMsg(["msg" => "Error. Verifique los campos obligatrios", "result" => false]);
                return false;
            }
        }

        if ($request["empresa"] == "") {
            $request["empresa"] = "Particulier";
        }
        $record["nombre"] = $request["nombre"];
        $record["apellido"] = $request["apellido"];

        $rdo1 = parent::update($record, $idusuario_empresa);

        $record2["tipo_cuenta_empresa"] = $request["tipo_cuenta_empresa"];
        $record2["empresa"] = $request["empresa"];
        $record2["dominio_email"] = $request["dominio_email"];
        $rdo2 = $this->getManager("ManagerEmpresa")->basic_update($record2, $usuario["empresa_idempresa"]);
        if ($rdo1 && $rdo2) {
            $usuario = $this->get($_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idusuario_empresa"]);
            $_SESSION[URL_ROOT]["empresa"]['logged_account']["user"] = $usuario;
        }
        return $rdo2;
    }

    /**
     * Métodos que devuelve el listado de usuarios secundarios de administracion de una empresa
     * @param type $requesr
     */
    public function getListadoUsuariosSecundarios($request, $idpaginate = null) {
//verificamos si el medico tiene habilitada la videocosulta

        if (isset($request["do_reset"]) && $request["do_reset"] == 1) {
            $this->resetPaginate($idpaginate);
        }

        if (!is_null($idpaginate)) {
            $this->paginate($idpaginate, 10);
        }

//Seteo el current page
        $request["current_page"] = $request["current_page"] != "" ? $request["current_page"] : 1;
        SmartyPaginate::setCurrentPage($request["current_page"], $idpaginate);

        $query = new AbstractSql();

        $query->setSelect("u.*");

        $query->setFrom("usuario_empresa u");

        $query->setWhere("u.empresa_idempresa = {$_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idempresa"]}");
        $query->addAnd("u.idusuario_empresa<> {$_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idusuario_empresa"]}");

        if ($request["check"] != '0' && $request["check"] != '') {
            $query->addAnd("u.tipo_usuario= {$request["check"]}");
        }
        $query->setOrderBy("u.fecha_alta DESC");

//añadimos los filtros de fecha

        if ($request["filtro_busqueda"] != "") {

            $filtro_busqueda = cleanQuery($request["filtro_busqueda"]);
            $query->addAnd("u.nombre LIKE '%{$filtro_busqueda}%' OR u.apellido LIKE '%{$filtro_busqueda}%' OR u.email LIKE '%{$filtro_busqueda}%'");
        }

        $query->setGroupBy("u.idusuario_empresa");

        $listado = $this->getListPaginado($query, $idpaginate);



        if ($listado["rows"] && count($listado["rows"]) > 0) {

            foreach ($listado["rows"] as $key => $value) {
//Tengo que formatear la fecha d.
                if ($value["fecha_alta"] != "") {
                    $listado["rows"][$key]["fecha_alta_format"] = fechaToString($value["fecha_alta"], 1);
                }
            }
            return $listado;
        }
    }

    /**
     * Metodo que agrega un usuario secundario para el acceso a la cuenta de administracion de empresa
     * @param type $request
     */
    public function agregarUsuarioSecundario($request) {

        $required_fields = ["email", "tipo_usuario", "nombre", "apellido"];
        foreach ($required_fields as $value) {
            if ($request[$value] == $value) {
                $this->setMsg(["msg" => "Error. Verifique los campos obligatrios", "result" => false]);
                return false;
            }
        }


//valido descripcion unica
        if (!$this->validateUnique("email", $request["email"])) {

            $this->setMsg(
                    array(
                        "result" => false,
                        "msg" => "La cuenta, [[{$request["email"]}]] ya se encuentra registrada",
                        "spry_msg" => array(
                            "field" => "email",
                            "msg" => "La cuenta, [[{$request["email"]}]] ya se encuentra registrada")
                    )
            );

            return false;
        }
        $this->db->StartTrans();
        $record["nombre"] = $request["nombre"];
        $record["apellido"] = $request["apellido"];
        $record["email"] = $request["email"];
        $record["tipo_usuario"] = $request["tipo_usuario"];
        $record["fecha_alta"] = date("Y-m-d H:i:s");
        $record["empresa_idempresa"] = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idempresa"];
        $record["contratante"] = 0;
        $randomPass = $this->getRandomEasyPass(6);
        $pass_enc = base64_encode(sha1($randomPass));
        $record["password"] = $pass_enc;

        $idusuario = parent::insert($record);
//si se crea correctamente asocio las funcionaldades y si aplica o no
        $upd = parent::update(["checkemail" => sha1("$idusuario")], $idusuario);
        $email = $this->sendEmailValidation($idusuario);
        if ($idusuario && $email && $upd) {
            $this->db->CompleteTrans();
            $this->setMsg(["msg" => "Usuario [[{$request["email"]}]] creado con éxito", "result" => true]);
        } else {
            $this->db->FailTrans();
            $this->db->CompleteTrans();
        }
        return $idusuario;
    }

    /**
     * Metodo que eliminar un usuario secundario del el acceso a la cuenta de administracion de empresa
     * @param type $request
     */
    public function eliminarUsuarioSecundario($request) {
        $usuario = $this->get($request["id"]);
//verifico que sea de la misma empresa
        if ($usuario["empresa_idempresa"] != $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idempresa"]) {
            $this->setMsg(["msg" => "Error, no se pudo eliminar el usuario", "result" => false]);
            return false;
        }
//verifico que no sea el que contrata
        if ($usuario["contratante"] == 1) {
            $this->setMsg(["msg" => "Error, no se pudo eliminar el usuario", "result" => false]);
            return false;
        }
//verifico que no sea yo
        if ($request["id"] == $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idusuario_empresa"]) {
            $this->setMsg(["msg" => "Error, no se pudo eliminar el usuario", "result" => false]);
            return false;
        }

//verifico que tengo permisos para hacerlo
        $usuario_actual = $this->get($_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idusuario_empresa"]);
        if ($usuario_actual["tipo_usuario"] != 1) {
            $this->setMsg(["msg" => "Error, no se pudo eliminar el usuario", "result" => false]);
            return false;
        }



        $delete = parent::delete($request["id"], true);

        if ($delete) {
            $this->setMsg(["msg" => "Usuario eliminado con éxito", "result" => true]);
        } else {
            $this->setMsg(["msg" => "Error, no se pudo eliminar el usuario", "result" => false]);
        }
        return $delete;
    }

    /**
     * Metodo que actualiza los permisos de acceso de un usuario secundario de empresa
     * @param type $request
     */
    public function cambiarPermisosUsuarioSecundario($request) {
        $usuario = $this->get($request["id"]);
//verifico que sea de la misma empresa
        if ($usuario["empresa_idempresa"] != $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idempresa"]) {
            $this->setMsg(["msg" => "Error, no se pudo actualizar el usuario", "result" => false]);
            return false;
        }
//verifico que no sea el que contrata
        if ($usuario["contratante"] == 1) {
            $this->setMsg(["msg" => "Error, no se pudo actualizar el usuario", "result" => false]);
            return false;
        }
//verifico que no sea yo
        if ($request["id"] == $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idusuario_empresa"]) {
            $this->setMsg(["msg" => "Error, no se pudo actualizar el usuario", "result" => false]);
            return false;
        }

//verifico que tengo permisos para hacerlo
        $usuario_actual = $this->get($_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idusuario_empresa"]);
        if ($usuario_actual["tipo_usuario"] != 1) {
            $this->setMsg(["msg" => "Error, no se pudo actualizar el usuario", "result" => false]);
            return false;
        }

//verifico los permisos
        if ((int) $request["tipo_usuario"] < 1 && (int) $request["tipo_usuario"] > 4) {
            $this->setMsg(["msg" => "Error, no se pudo actualizar el usuario", "result" => false]);
            return false;
        }


        $upd = parent::update(["tipo_usuario" => $request["tipo_usuario"]], $request["id"]);

        if ($upd) {
            $this->setMsg(["msg" => "Usuario actualizado con éxito", "result" => true]);
        } else {
            $this->setMsg(["msg" => "Error, no se pudo actualizar el usuario", "result" => false]);
        }
        return $delete;
    }

    /**
     * Método que cambia el estado del email del usuario
     * @param type $request
     * @return boolean
     */
    public function changeConditionEmail($request) {


        $accion_a_realizar = $request["accion"];



        if ($accion_a_realizar == 'Activar') {

            parent::update(["estado" => 1], $request["idusuario_empresa"]);
            return true;
        } else {
            parent::update(["estado" => 0], $request["idusuario_empresa"]);
            return true;
        }
    }

    /**
     * Envío del Email para la nueva empresa/mutual que contrato de manera manual
     * @param type $idusuario
     * @return boolean
     */
    public function sendEmailEmpresaNuevaManual($idusuario, $recordatorioCron = '0') {
        $usuario = $this->get($idusuario);
        $plan_contratado = $this->getManager("ManagerProgramaSaludPlan")->getByUser($idusuario);
        $mEmail = $this->getManager("ManagerMail");
        $mEmail->setHTML(true);

//ojo solo arnet local
        $mEmail->setPort("587");
        $mEmail->setFromName("Notifications WorknCare");
        if ($recordatorioCron == '0') {
            $mEmail->setSubject("WorknCare | Prochaine étape: paiement du Pass ");
        } else {
            $mEmail->setSubject("WorknCare | Rappel: paiement du Pass ");
        }

        $smarty = SmartySingleton::getInstance();

        $smarty->assign("usuario", $usuario);
        $smarty->assign("plan_contratado", $plan_contratado);
        $smarty->assign("sistema", NOMBRE_SISTEMA);

        $mEmail->setBody($smarty->Fetch("email/nueva_contratacion_pass_esante_manual.tpl"));

        $mEmail->addTo($usuario["email"]);

//header a todos los comentarios!
        if ($mEmail->send()) {
            $this->getManager("ManagerEmpresa")->update(["fecha_mail_transferencia_manual" => date("Y-m-d H:i:s")], $usuario["empresa_idempresa"]);
            return true;
        } else {
//$this->setMsg(["result" => false, "msg" => "No se pudo enviar el mensaje"]);
            return false;
        }
    }

    /**
     * Envío del Email de confirmacion de pago suscripcion manual de empresa/ obra social
     * @param type $idusuario
     * @return boolean
     */
    public function sendEmailConfirmacionPagoSuscripcionManual($idusuario) {
        $usuario = $this->get($idusuario);
        $plan_contratado = $this->getManager("ManagerProgramaSaludPlan")->getByUser($idusuario);
        $mEmail = $this->getManager("ManagerMail");
        $mEmail->setHTML(true);

//ojo solo arnet local
        $mEmail->setPort("587");
        $mEmail->setFromName("Notifications WorknCare");
        $mEmail->setSubject("WorknCare : Paiement reçu !");


        $smarty = SmartySingleton::getInstance();

        $smarty->assign("usuario", $usuario);
        $smarty->assign("plan_contratado", $plan_contratado);
        $smarty->assign("sistema", NOMBRE_SISTEMA);

        $mEmail->setBody($smarty->Fetch("email/confirmacion_pago_contratacion_pass_manual.tpl"));

        $mEmail->addTo($usuario["email"]);

//header a todos los comentarios!
        if ($mEmail->send()) {

            return true;
        } else {
//$this->setMsg(["result" => false, "msg" => "No se pudo enviar el mensaje"]);
            return false;
        }
    }

    public function cronRecordatorioTransferenciaPendiente() {
        $query = new AbstractSql();

        $query->setSelect("ue.idusuario_empresa");
        $query->setFrom("empresa e
                 INNER JOIN usuario_empresa ue ON (e.idempresa=ue.empresa_idempresa and ue.contratante=1)
                 INNER JOIN programa_salud_suscripcion psp ON (psp.empresa_idempresa=e.idempresa and psp.pack_pago_pendiente<>2)");
        $query->setWhere("e.contratacion_manual=1  and SYSDATE()> DATE_ADD(e.fecha_mail_transferencia_manual,INTERVAL 7 DAY)");

        $listado = $this->getList($query);

        foreach ($listado as $usuario_empresa) {
            $this->sendEmailEmpresaNuevaManual($usuario_empresa["idusuario_empresa"], "1");
        }
    }

    public function getUsuarioContratante($idempresa) {
        $query = new AbstractSql();

        $query->setSelect("u.*");
        $query->setFrom("$this->table u");
        $query->setWhere("u.empresa_idempresa = $idempresa");
        $query->addAnd("u.contratante=1");
        return $this->db->GetRow($query->getSql());
    }

    /**
     * exporto los usuarios empresa en excel para ocupar en MailChimp
     */
    public function exportarUsuarioEmpresa() {
        require_once(path_libs_php("PHPExcel/Classes/PHPExcel.php"));
        require_once(path_libs_php("PHPExcel/Classes/PHPExcel/IOFactory.php"));

        $query = new AbstractSql();
        $query->setSelect("e.idempresa,
                u.nombre,
                u.apellido,
                u.email,
                e.empresa,
                pse.programa_salud_excepcion,
                psp.nombre as nombre_plan,
                CONCAT (DATE_FORMAT(e.fecha_adhesion,'%d/%m/%Y'),' - ',DATE_FORMAT(e.fecha_vencimiento,'%d/%m/%Y')) as fecha_adhesion,
                IF(e.cancelar_suscripcion=0,
                    IF(CONCAT(e.fecha_adhesion,' ','00:00:00') > SYSDATE(),'Pendiente de inicio','Activa'),
                    IF(e.cancelar_suscripcion=1,'Cancelacion pendiente','Cancelada')
                ) as estado_suscripcion,
                u.fecha_alta,
                IF(u.activo = 1,'Activo','Inactivo') AS activo,
                IF(u.estado = 1,'SI','NO') AS email_confirmado,
                IF(pssus.pack_pago_pendiente = 1,'Pendiente','Verificado') AS pagopendiente,
                IF(e.empresa_test = 0,'Cliente','Test') AS cuenta_empresa");
        $query->setFrom("usuario_empresa u 
                INNER JOIN empresa e ON (e.idempresa=u.empresa_idempresa)
                INNER JOIN programa_salud_plan psp ON (psp.idprograma_salud_plan=e.plan_idplan)
                LEFT  JOIN programa_salud_suscripcion pssus ON (pssus.empresa_idempresa=e.idempresa)
                LEFT JOIN programa_salud_excepcion pse ON ( e.idempresa = pse.empresa_idempresa )");
        $query->setWhere("u.contratante=1");

        $data = $this->getList($query);



        $programas = $this->getManager("ManagerProgramaSalud")->getListadoProgramas();

        $valArray = 0;
        foreach ($data as $elem) {
            $ArrayEle = array_map('intval', explode(",", $elem["programa_salud_excepcion"]));

            $cad = '';
            foreach ($programas as $programa) {
                if (!in_array(intval($programa["idprograma_salud"]), $ArrayEle)) {

                    $cad = $programa["programa_salud"] . ', ' . $cad;
                }
            }
            $data[$valArray]["programas-asociados"] = substr($cad, 0, -2);
            $valArray++;
        }

        //template
        $inputFileName = path_root() . "xframework/app/xadmin/view/templates/excel/listado_usuarios_empresa.xlsx";
        $inputFileType = PHPExcel_IOFactory::identify($inputFileName);
        $objReader = PHPExcel_IOFactory::createReader($inputFileType);
        $objPHPExcel = $objReader->load($inputFileName);


        $i = 0;
        $r_start = 4;
        $objPHPExcel->setActiveSheetIndex($i);
        $active_sheet = $objPHPExcel->getActiveSheet();
        // inserto las preguntas, es decir los titulos de cada columna
        foreach ($data as $beneficiario) {

            $active_sheet->setCellValue('a' . $r_start, $beneficiario["nombre"] . ' ' . $beneficiario["apellido"]);
            $active_sheet->setCellValue('b' . $r_start, $beneficiario["email"]);
            $active_sheet->setCellValue('c' . $r_start, $beneficiario["empresa"]);
            $active_sheet->setCellValue('d' . $r_start, $beneficiario["programas-asociados"]);

            $r_start++;
        }

        $active_sheet->setTitle("UserEntreprise");
        //configuracion de hoja

        $active_sheet->getPageSetup()->setOrientation(PHPExcel_Worksheet_PageSetup::ORIENTATION_PORTRAIT);
        $active_sheet->getPageSetup()->setPaperSize(PHPExcel_Worksheet_PageSetup::PAPERSIZE_A4);
        $active_sheet->getPageSetup()->setFitToPage(true);
        $active_sheet->getPageSetup()->setFitToWidth(1);
        $active_sheet->getPageSetup()->setFitToHeight(0);

        $objPHPExcel->setActiveSheetIndex(0);

        // Write out as the new file
        $outputFileType = $inputFileType;
        $objWriter = PHPExcel_IOFactory::createWriter($objPHPExcel, $outputFileType);

        $fecha_actual = date("Y-m-d");

        //header('Content-Type: application/vnd.ms-excel');
        header('Content-Type: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
        header('Content-Disposition: attachment;filename="' . "user_entreprise_" . "_" . $fecha_actual . '.xlsx"');
        header('Cache-Control: max-age=0');
        ob_end_clean();
        $objWriter->save('php://output');
    }

}

//END_class 
?>