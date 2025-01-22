<?php

require_once(path_libs("libs_php/aws/aws-autoloader.php"));

use Aws\Ses\SesClient;

/**
 * Description of MailerAmazonSES
 * Abstrae el comportamiento de AmazonSES para el envio de mails
 * @author lucas
 */
class MailerAmazonSES {

    private $client = NULL;
    private $To = [];
    private $From = NULL;
    private $FromName = NULL;
    private $BCC = [];
    private $CC = [];
    private $Body = NULL;
    private $Subject = NULL;
    private $Attachment = [];
    private $ReplyTo = NULL;
    private $ReplyToName = NULL;

    /**
     * Constructor
     */
    function __construct() {


        $this->client = SesClient::factory(array(
                    'version' => 'latest',
                    'region' => 'us-east-1',
                    'credentials' => [
                        'key' => AWS_ACCESS_KEY_ID,
                        'secret' => AWS_SECRET_ACCESS_KEY
                    ]
        ));
    }

    /* setSubject
     * Setea el subject del email	 
     * @param string $newSubject nuevo subject
     */

    public function setSubject($newSubject) {
        $this->Subject = $newSubject;
    }

    /**
     * setFrom
     * Setea el from  del email	 
     * @param string $newFrom nuevo from
     */
    public function setFrom($newFrom) {
        $this->From = $newFrom;
    }

    /**
     * setFromName
     * Setea el from name del email	 
     * @param string $newFromName nuevo from name
     */
    public function setFromName($newFromName) {
        $this->FromName = $newFromName;
    }

    /**
     * addTo
     * Agrega una nueva direccion de email address 
     * @param string $newFromName nuevo from name
     */
    public function addTo($email, $name = "") {
        // $this->fromName = $newFromName;
        $this->To[] = $email;
    }

    /**
     * replyTo
     * Agrega una nueva de respuesta de mail
     * @param string $address nuevo from name
     */
    public function AddReplyTo($address, $name = "") {

        $this->ReplyTo = $address;
        $this->ReplyToName = $name;
    }

    /**
     * addCC
     * Agrega una nueva direccion a CC
     * @param string $email email a agregar
     */
    public function addCC($email) {

        $this->CC[] = $email;
    }

    /**
     * addBCC
     * Agrega una nueva direccion a aBCC
     * @param string $email email a agregar
     */
    public function addBCC($email) {

        $this->BCC[] = $email;
    }

    /**
     * AddAttachment
     * Adjunta archivos al email
     * @param string $name nombre del archivo para atachar
     */
    public function AddAttachment($path, $name) {
        $arr = Array("path" => $path, "name" => $name);
        return array_push($this->Attachment, $arr);
    }

    /**
     * setBody
     * Setea el body del email	 
     * @param string $newBody nuevo bady
     */
    public function setBody($newBody) {
        $this->Body = $newBody;
    }

    public function send() {
                
        //campos de email para AMAZON SES
        /*
          $result = $client->sendEmail([
          'ConfigurationSetName' => '<string>',
          'Destination' => [ // REQUIRED
                'BccAddresses' => ['<string>', ...],
                'CcAddresses' => ['<string>', ...],
                'ToAddresses' => ['<string>', ...],
          ],
          'Message' => [ // REQUIRED
                 'Body' => [ // REQUIRED
                         'Html' => [
                             'Charset' => '<string>',
                            'Data' => '<string>', // REQUIRED
                                        ],
                          'Text' => [
                                    'Charset' => '<string>',
                                    'Data' => '<string>', // REQUIRED
                                     ],
                            ],
                'Subject' => [ // REQUIRED
                            'Charset' => '<string>',
                            'Data' => '<string>', // REQUIRED
                            ],
                          ],
          'ReplyToAddresses' => ['<string>', ...],
          'ReturnPath' => '<string>',
          'ReturnPathArn' => '<string>',
          'Source' => '<string>', // REQUIRED
          'SourceArn' => '<string>',
          'Tags' => [
                     [
                    'Name' => '<string>', // REQUIRED
                    'Value' => '<string>', // REQUIRED
                      ], ...
                    ],
          ]); */
        
   

        //intanciamos el php mailer para armar el mail 
        $mail = new PHPMailer();

        $mail->addAddress($this->To);
        $mail->setFrom($this->From, $this->FromName);
        $mail->Subject =  utf8_decode($this->Subject);
        $mail->CharSet = 'utf-8';
//$mail->AltBody = $text;
        $mail->Body = $this->Body;
        $mail->isHTML(true);
        if (count($this->Attachment) > 0) {
            foreach ($this->Attachment as $file) {
                $mail->addAttachment($file["path"], $file["name"]);
            }
        }
///$mail->addAttachment($attachment);

        $mail->preSend();
//obtenemos el mail en formato crudo (raw) para enviarlo mediante amazon SES
        print_r($this->BCC);
        print_r($this->CC);
        print_r($this->To);
        $args = [
            'Source' => $this->FromName . " <" . $this->From . ">",
               'Destinations' => [ // REQUIRED
                
                'ToAddresses' =>  Array("emanueldb@gmail.com")
                    
          ],
          
            'RawMessage' => [
                'Data' => $mail->getSentMIMEMessage()
            ]
        ];


        try {
            $this->client->sendRawEmail($args);
            // $messageId = $result->get('MessageId');
            // echo("Email sent! Message ID: $messageId" . "\n");

            return true;
        } catch (Exception $e) {
            echo("The email was not sent. Error message: ");
            echo($e->getMessage() . "\n");
            return false;
        }
    }

}
