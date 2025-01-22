<?php

require_once(path_libs("libs_php/aws/aws-autoloader.php"));

use Aws\Sns\SnsClient;
use Aws\Exception\AwsException;

/**
 * Manejo de SMS
 * Abstrae el comportamiento de Amazon para el envio de SMS
 * @author lucas
 */
class AmazonSMS {

    private $phoneNumber = NULL;
    private $message = NULL;
    private $client = NULL;

    /**
     * Constructor
     */
    function __construct() {


        $this->client = SnsClient::factory(array(
                    'version' => 'latest',
                    'region' => 'us-east-1',
                    'credentials' => [
                        'key' => AWS_ACCESS_KEY_ID,
                        'secret' => AWS_SECRET_ACCESS_KEY
                    ]
        ));
    }

    /**
     * 
     * @param type $phoneNumber
     */
    public function setPhoneNumber($phoneNumber) {
        $this->phoneNumber = $phoneNumber;
    }

    /**
     * 
     * @param type $message
     */
    public function setMessage($message) {
        $this->message = $message;
    }

    public function send() {



        if ($_SERVER["HTTP_HOST"] != "localhost") {
            try {

                $result = $this->client->publish([
                    'Message' => $this->message,
                    'PhoneNumber' => $this->phoneNumber,
                ]);
                //      var_dump($result);
            } catch (AwsException $e) {

                // output error message if fails
                error_log($e->getMessage());
                die($e->getMessage());
            }
        }else{
            
        }
    }

}
