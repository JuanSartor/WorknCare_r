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
class ManagerUsuarios extends ManagerAccounts {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "usuario", "idusuario");
        $this->email_field = "email";
        $this->password_field = "password";
        $this->flag = "activo";
        $this->default_paginate = "usuarios_listado";
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

        //valido descripcion unica
        if (!$this->validateUnique("username", $request["username"])) {

            $this->setMsg(array("msg" => "La cuenta, [[{$request["username"]}]] ya se encuentra registrada",
                "result" => false,
                "spry_msg" => array(
                    "field" => "username",
                    "msg" => "La cuenta, [[{$request["username"]}]] ya se encuentra registrada")
                    )
            );

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

        $idusuario = parent::insert($request);

        //si se crea correctamente asocio las funcionaldades y si aplica o no

        if ($idusuario) {

            $this->setMsg(["msg" => "Usuario [[{$request["username"]}]] creado con éxito", "result" => true]);
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

        //valido descripcion unica
        if (!$this->validateUnique("username", $request["username"], $idusuario)) {

            $this->setMsg(array("msg" => "La cuenta, [[{$request["username"]}]] ya se encuentra registrada",
                "result" => false,
                "spry_msg" => array(
                    "field" => "username",
                    "msg" => "La cuenta, [[{$request["username"]}]] ya se encuentra registrada")
                    )
            );

            return false;
        }


        //valido descripcion unica
        if (!$this->validateUnique("email", $request["email"], $idusuario)) {

            $this->setMsg(array("msg" => "La cuenta, [[{$request["email"]}]] ya se encuentra registrada.",
                "result" => false,
                "spry_msg" => array(
                    "field" => "email",
                    "msg" => "La cuenta, [[{$request["email"]}]] ya se encuentra registrada.")
                    )
            );

            return false;
        }

        $result = parent::update($request, $idusuario);


        if ($result) {

            $this->setMsg(["msg" => "Usuario [[{$request["username"]}]] actualizado con éxito", "result" => true]);
        }


        return $result;
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
            return true;
        } else {
            return false;
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
        $query->setSelect("u.idusuario,u.username,u.apellido,u.email,u.nombre, IF(u.activo = 1,'Activo','Inactivo') AS activo");
        $query->setFrom("usuario u");

        // Filtro


        if ($request["username"] != "") {

            $Usuario = cleanQuery($request["username"]);

            $query->addAnd("u.username LIKE '%$Usuario%'");
        }

        if ($request["nombre"] != "") {

            $Nombre = cleanQuery($request["nombre"]);

            $query->addAnd("u.nombre LIKE '%$Nombre%'");
        }


        if ($request["apellido"] != "") {

            $Apellido = cleanQuery($request["apellido"]);

            $query->addAnd("u.apellido LIKE '%$Apellido%'");
        }



        if (isset($request["activo"]) && (int) $request["activo"] >= 0) {

            $Activo = (int) ($request["activo"]);

            $query->addAnd("u.activo = $Activo");
        }

        $data = $this->getJSONList($query, array("username", "email", "nombre", "apellido", "activo"), $request, $idpaginate);


        return $data;
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
            $usuActual = $this->get($_SESSION[URL_ROOT][CONTROLLER]['logged_account']["id"]);

            if ($request['oldPassword'] != $usuActual['password']) {

                $this->setMsg(array("result" => false, "msg" => "La contraseá anterior no coincide"));
                return false;
            } else {
                if ($request['newPassword'] != "") {

                    $password = $request['newPassword'];

                    $rs = $this->db->Execute("UPDATE usuario SET password='$password' WHERE idusuario = " . $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["id"]);

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
        $consulta->setSelect(" r.idusuario,(r.validez > NOW())as valido,r.hash");
        $consulta->setFrom(" resets r");
        $consulta->setWhere(" r.hash = '$hash' ");

        $res = $this->getList($consulta);

        $reset = $res[0];



        //si llegamos aca esta todo bien

        if ($request['password'] == "") {
            $this->setMsg(array("result" => false, "spry_msg" => array("msg" => "Complete la contraseña"
                )
                    )
            );
        }

        //echo  "RESET:<br>" . print_r($reset); echo "<hr>";
        //echo  "REQUEST:<br>" . print_r($request);
        $update_record = array();
        $update_record["original_password"] = $request['password'];
        $update_record["password"] = trim($request['password']);
        $update_record["idusuario"] = $reset['idusuario'];

        //echo  "UPDATE REcord:<br>" . print_r($update_record); echo "<hr>";
        if ($this->update($update_record, $reset['idusuario'])) {
            //borro todas las solicitudes pendientes para el usuario
            $this->db->Execute("DELETE FROM resets WHERE idusuario = " . $reset['idusuario']);
            unset($_SESSION['resetAutorizado']);
            $this->setMsg(array("result" => true, "msg" => "Contraseña actualizada con éxito"));
            return true;
        } else {
            $this->setMsg(array("result" => false, "spry_msg" => array("msg" => "Error no se pudo resetear la contraseña")));
            return false;
        }
    }

}

//END_class 
?>