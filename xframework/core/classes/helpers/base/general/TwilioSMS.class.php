<?php

require_once(path_libs("libs_php/Twilio/autoload.php"));

use Twilio\Rest\Client;
use Twilio\Exceptions\TwilioException;

/**
 * Manejo de SMS
 * Abstrae el comportamiento de TWILIO para el envio de SMS
 * @author Juan 4/01/2021
 */
class TwilioSMS {

    /**
     * Constructor
     */
    function __construct() {
        
    }

    /**
     *   Metodo para enviar SMS con TWILIO
     * 
     * @param type $numeroDestino
     * @param type $mensaje
     * 
     */
    public function send($numeroDestino, $mensaje) {

        $client = new Client(TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN);

        if ($_SERVER["HTTP_HOST"] != "localhost") {
            try {
                // miro si es para argentina o belgica porque no soportan el ID ALPHANUMERIC
                if (substr($numeroDestino, 0, 3) == '+54' || substr($numeroDestino, 0, 3) == '+32') {
                    $fromPara = TWILIO_NUMBER;
                } else {
                    $fromPara = "PASS";
                }
                $message = $client->messages->create(
                        // Where to send a text message (your cell phone?)
                        $numeroDestino, array(
                    'from' => $fromPara,
                    'body' => $mensaje
                        )
                );

                //      var_dump($result);
            } catch (TwilioException $e) {

                // output error message if fails
                error_log($e->getMessage());
                die($e->getMessage());
            }
        } else {
            
        }
    }

}
