<?php

/**
 *  Mailer
 * 	
 *  @author Sebastian Balestrini
 *  @author Emanuel del Barco
 *
 *  Manejo de emails. Abstrae el comportamiento de phpMailer
 *
 */
require_once(path_libs("libs_php/phpmailer/class.phpmailer.php"));
//require_once(path_libs("libs_php/PHPMailer-master/PHPMailerAutoload.php"));
require_once(path_libs("libs_php/sendgrid-php/sendgrid-php.php"));

class Mailer {

    var $phpMailer = NULL;
    var $to = array();
    var $cc = array();
    var $bcc = array();
    var $replyTo = null;
    var $replyToName = null;
    var $attachments = array();
    var $lastSendGridStatus = null;
    var $lastSendGridBody = null;

    /**
     * Constructor
     */
    function __construct() {

        $this->phpMailer = new phpmailer();
        $this->phpMailer->Mailer = "smtp";
        $this->setHTML(true);
        $this->setHost(DEFAULT_EMAIL_HOST);
        $this->setFrom(DEFAULT_EMAIL_FROM);
        $this->setFromName(DEFAULT_EMAIL_FROM_NAME);
        $this->setUserName(DEFAULT_EMAIL_USERNAME);
        $this->setPassword(DEFAULT_EMAIL_PASSWORD);


//		  $this->phpMailer->SMTPDebug  = 2;
        //chekar estoooo!
        $this->phpMailer->SMTPAuth = true;
        $this->phpMailer->SMTPKeepAlive = true;

        $this->phpMailer->SetLanguage('es', 'phpmailer/language/');
        $this->phpMailer->Priority = 1;  # Urgent = 1, Not Urgent = 5, Disable = 0
        $this->phpMailer->CharSet = "UTF-8";

        $this->phpMailer->AddCustomHeader('Auto-Submitted:auto-generated');
        $this->phpMailer->Timeout = 60;
        $this->phpMailer->IsHTML(true);
        $this->phpMailer->AddCustomHeader('X-Auto-Response-Suppress: All');

        $this->phpMailer->SMTPdebug = 2;
    }

// end constructor

    /**
     * setHost
     * Setea el host del email	 
     * @param string $newHost nuevo host
     */
    function setHost($newHost) {
        $this->phpMailer->Host = $newHost;
    }

    /**
     * setUserName
     * Setea el Username del servidor de mail	 
     * @param string $newUserName username
     */
    function setUserName($newUserName) {
        $this->phpMailer->Username = $newUserName;
    }

    /**
     * setPassword
     * Setea el password del email	 
     * @param string $newPassword nuevo host
     */
    function setPassword($newPassword) {
        $this->phpMailer->Password = $newPassword;
    }

    /**
     * setPassword
     * Setea puerto del email	 
     * @param string $newPassword nuevo host
     */
    function setPort($newPort) {
        $this->phpMailer->Port = $newPort;
    }

    /**
     * setSubject
     * Setea el subject del email	 
     * @param string $newSubject nuevo subject
     */
    function setSubject($newSubject) {
        $this->phpMailer->Subject = $newSubject;
    }

    /**
     * setFrom
     * Setea el from  del email	 
     * @param string $newFrom nuevo from
     */
    function setFrom($newFrom) {
        $this->phpMailer->From = $newFrom;
    }

    /**
     * setFromName
     * Setea el from name del email	 
     * @param string $newFromName nuevo from name
     */
    function setFromName($newFromName) {
        $this->phpMailer->FromName = $newFromName;
    }

    /**
     * addTo
     * Agrega una nueva direccion de email address 
     * @param string $newFromName nuevo from name
     */
    function addTo($email, $name = "") {
        // $this->fromName = $newFromName;
        $this->phpMailer->AddAddress($email);
        $this->to[] = $email;
    }

    /**
     * addCC
     * Agrega una nueva direccion a CC
     * @param string $email email a agregar
     */
    function addCC($email) {

        $this->phpMailer->AddCC($email);
        $this->cc[] = $email;
    }

    /**
     * addBCC
     * Agrega una nueva direccion a aBCC
     * @param string $email email a agregar
     */
    function addBCC($email) {

        $this->phpMailer->addBCC($email);
        $this->bcc[] = $email;
    }

    /**
     * addReplyTo
     * Agrega una nueva direccion a aBCC
     * @param string $email email a agregar
     */
    function addReplyTo($email) {

        $this->replyTo = $address;

        return $this->phpMailer->AddReplyTo($email);
    }

    /**
     * clearReplyTo
     * Agrega una nueva direccion a aBCC
     * @param string $email email a agregar
     */
    function clearReplyTo() {

        $this->phpMailer->ClearReplyTos();
    }

    /**
     * AddAttachment
     * Adjunta archivos al email
     * @param string $name nombre del archivo para atachar
     */
    function AddAttachment($name) {
        $this->attachments[] = $name;
        return $this->phpMailer->AddAttachment($name);
    }

    /**
     * setBody
     * Setea el body del email	 
     * @param string $newBody nuevo bady
     */
    function setBody($newBody) {
        $this->phpMailer->Body = $newBody;
        $this->phpMailer->AltBody = strip_tags($newBody);
    }

    /**
     * setHTML
     * Setea si el body del email tiene formato html	 
     * @param bool $state nuevo estdo para el flag htmlFormat
     */
    function setHTML($state) {
        $this->phpMailer->IsHTML($state);
    }

    /**
     * send
     * Envia el mail con todos los parametros ya configurados 
     * @param string $method método para enviar (phpmailer, sendgrid)
     * @return void
     * 
     */
    function send($method = "sendgrid") {



        if ($method == "sendgrid") {



            $from = new SendGrid\Email(utf8_encode($this->phpMailer->FromName), $this->phpMailer->From);

            $to = new SendGrid\Email(null, $this->to[0]);


            $content = new SendGrid\Content("text/html", utf8_encode($this->phpMailer->Body));

            $mail = new SendGrid\Mail($from, utf8_encode($this->phpMailer->Subject), $to, $content);
            $sg = new \SendGrid(SEND_MAIL_API_KEY);

            if (count($this->to) > 0) {

                for ($i = 1; $i < count($this->to); $i++) {

                    $to = new SendGrid\Email(null, $this->to[$i]);
                    $mail->personalization[0]->addTo($to);
                }
            }


            if (count($this->cc) > 0) {

                for ($i = 0; $i < count($this->cc); $i++) {

                    $cc = new SendGrid\Email(null, $this->cc[$i]);
                    $mail->personalization[0]->addCc($cc);
                }
            }

            if (count($this->bcc) > 0) {

                for ($i = 0; $i < count($this->bcc); $i++) {


                    $bcc = new SendGrid\Email(null, $this->bcc[$i]);
                    $mail->personalization[0]->addBcc($bcc);
                }
            }



            if (!is_null($this->replyTo)) {

                $reply_to = new SendGrid\ReplyTo($this->replyTo, $this->replyToName);
                $mail->setReplyTo($reply_to);
            }


            //attachments
            if (count($this->attachments) > 0) {

                for ($i = 0; $i < count($this->attachments); $i++) {

                    $file_encoded = base64_encode(file_get_contents($this->attachments[$i]));

                    $attachment = new SendGrid\Attachment();

                    $attachment->setContent($file_encoded);
                    //$attachment->setType("application/text");
                    $attachment->setDisposition("attachment");

                    $attachment->setFilename(pathinfo($this->attachments[$i], PATHINFO_BASENAME));

                    $mail->addAttachment($attachment);
                }
            }


            $response = $sg->client->mail()->send()->post($mail);

            //$this->phpMailer->ClearAttachments();
            //$this->phpMailer->ClearAddresses();
            // <-- INICIO DEBUG

            /* echo $response->statusCode();
              echo $response->headers();
              echo $response->body();
             */
            // <-- FIN DEBUG
            //limpio las direcciones y los attachments
            $this->attachments = $this->bcc = $this->cc = $this->to = [];

            $this->replyTo = $this->replyToName = null;


            $this->lastSendGridStatus = $response->statusCode();
            $this->lastSendGridBody = $response->headers() . $response->body();

            return (int) $response->statusCode() == 200 || (int) $response->statusCode() == 202;
        } else {


            $result = $this->phpMailer->send();
            $this->phpMailer->ClearAttachments();
            $this->phpMailer->ClearAddresses();
            $this->phpMailer->SmtpClose();
            return $result;
        }
    }

    /**
     * getLastError
     * devuelve el ultimo error producido	 
     * @return string ultimo error.
     */
    function getLastError() {

        $this->phpMailer->ErrorInfo;
    }

    function getLastSendGridStatus() {

        return $this->lastSendGridStatus;
    }

    function getLastSendGridSBody() {

        return $this->lastSendGridBody;
    }

}
