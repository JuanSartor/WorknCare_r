<?php

/* * Clase encargada de gestionar el almacenamiento y obtencion de cookies encriptadas
 * 
 *
 * @author lucas
 */

class CookieEncrypt {

    private $key = "";

    public function __construct($key) {
        $this->key = $key;
    }

    /*     * metodo que setea una cookie encriptada por mcrypt de PHP extendiendo el metodo de PHP setcookie
     * 
     * @param type $name
     * @param type $value
     * @param type $expire
     * @param type $path
     * @param type $domain
     * @param type $secure
     * @param type $httponly
     */

    public function set_cookie($name, $value = null, $expire = 0, $path = null, $samesite = "Strict", $domain = null, $secure = true, $httponly = true) {

        $encrypted = $this->secured_encrypt($value);

        //llamamos al metodo de php para almacenar la cookie

        if (PHP_VERSION_ID < 70300) {
            return setcookie($name, $encrypted, $expire, "$path; samesite=$samesite", $domain, $secure, $httponly);
        } else {
            return setcookie($name, $encrypted, [
                'expires' => $expire,
                'path' => $path,
                'domain' => $domain,
                'samesite' => $samesite,
                'secure' => $secure,
                'httponly' => $httponly,
            ]);
        }
    }

    /*     * Metodo que obtiene la cookie pasada como parametro y la desencripta mediante mcrypt de PHP
     * 
     * @param type $name nombre de la cookie a obtener
     */

    public function get_cookie($name) {
        $decrypted = $this->secured_decrypt($_COOKIE[$name]);
        return $decrypted;
    }

    function secured_encrypt($data) {

        $first_key = base64_decode(FIRSTKEY);
        $second_key = base64_decode(SECONDKEY);

        $method = "aes-256-cbc";
        $iv_length = openssl_cipher_iv_length($method);
        $iv = openssl_random_pseudo_bytes($iv_length);

        $first_encrypted = openssl_encrypt($data, $method, $first_key, OPENSSL_RAW_DATA, $iv);
        $second_encrypted = hash_hmac('sha512', $first_encrypted, $second_key, TRUE);

        $output = base64_encode($iv . $second_encrypted . $first_encrypted);
        return $output;
    }

    function secured_decrypt($input) {
        $first_key = base64_decode(FIRSTKEY);
        $second_key = base64_decode(SECONDKEY);
        $mix = base64_decode($input);

        $method = "aes-256-cbc";
        $iv_length = openssl_cipher_iv_length($method);

        $iv = substr($mix, 0, $iv_length);
        $second_encrypted = substr($mix, $iv_length, 64);
        $first_encrypted = substr($mix, $iv_length + 64);

        $data = openssl_decrypt($first_encrypted, $method, $first_key, OPENSSL_RAW_DATA, $iv);
        $second_encrypted_new = hash_hmac('sha512', $first_encrypted, $second_key, TRUE);

        if (hash_equals($second_encrypted, $second_encrypted_new)) {
            return $data;
        }

        return false;
    }

}
