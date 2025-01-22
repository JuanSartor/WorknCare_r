<?php

/* Manager encargado de la gestion de la cola de mail,
 * al enviarse un mail se ingresa un registro en la tabla mail con los campos requeridos
 * un cron recorre la tabla enviado los mail pendientes
 * 
 */

/**
 * Description of ManagerMail
 *
 * @author lucas
 */
class ManagerMail extends Manager {

    //put your code here
    private $Subject = '';
    private $From = '';
    private $FromName = '';
    private $To = [];
    private $ReplyTo = '';
    private $ReplyToName = '';
    private $CC = [];
    private $BCC = [];
    private $Port = '';
    private $Attachment = '';
    private $Body = '';
    private $IsHTML = '';

    /**  /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {


        // Constructor
        parent::__construct($db, "mail", "idmail");
        $this->default_paginate = "listado_log_mail";
    }

    /**
     * setPassword
     * Setea puerto del email	 
     * @param string $newPort nuevo puerto
     */
    public function setPort($newPort) {
        $this->Port = $newPort;
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
     * setHTML
     * Setea si el body del email tiene formato html	 
     * @param bool $state nuevo estdo para el flag htmlFormat
     */
    public function setHTML($state) {
        $this->IsHTML = $state;
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
        return $this->Attachment = $this->Attachment . $path . "?" . $name . "|";
    }

    /**
     * setBody
     * Setea el body del email	 
     * @param string $newBody nuevo bady
     */
    public function setBody($newBody) {
        $this->Body = $newBody;
    }

    /** Obtiene las variables del mail e inserta un registro en la base de datos en la cola de mails
     * 
     * @param bool $state 
     */
    public function send($debug = false) {

        //put your code here
        //subject
        $Subject = $this->Subject;
        if ($Subject != "") {
            $mail["mail_subject"] = $Subject;
        } else {

            $this->setMsg(["result" => false, "msg" => "Error. Subject incorrecto"]);
            if ($debug) {
                print_r($this->getMsg());
            }
            return false;
        }


        //from
        $From = $this->From;
        if ($From != "") {
            $mail["mail_from"] = $From;
        } else {
            $mail["mail_from"] = DEFAULT_EMAIL_FROM;
        }
        //from name
        $FromName = $this->FromName;
        if ($FromName != "") {
            $mail["mail_from_name"] = $FromName;
        } else {
            $mail["mail_from_name"] = DEFAULT_EMAIL_FROM_NAME;
        }

        //detinatario
        $To = $this->To;

        if (COUNT($To) > 0) {


            $mail["mail_to"] = implode(";", $To);
        } else {

            $this->setMsg(["result" => false, "msg" => "Error. Destinarario incorrecto"]);
            if ($debug) {
                print_r($this->getMsg());
            }
            return false;
        }

        //CC
        $CC = $this->CC;
        if (COUNT($CC) > 0) {


            $mail["cc"] = implode(";", $CC);
        }

        //BCC
        $BCC = $this->BCC;
        if (COUNT($BCC) > 0) {


            $mail["bcc"] = implode(";", $BCC);
        }

        //cuerpo del mail
        $Body = $this->Body;
        if ($Body != "") {
            $mail["body"] = $Body;
        } else {

            $this->setMsg(["result" => false, "msg" => "Error. Cuerpo de mail incorrecto"]);
            if ($debug) {
                print_r($this->getMsg());
            }
            return false;
        }
        $Attachment = $this->Attachment;
        if ($Attachment != "") {
            $mail["attachment"] = $Attachment;
        }
        $mail["fecha"] = date("Y-m-d H:i:s");
        $rdo = parent::insert($mail);

        if ($rdo) {
            $this->setMsg(["result" => false, "msg" => "Mail insterado correctamente en la cola de envío"]);
            return $rdo;
        } else {
            $this->setMsg(["result" => false, "msg" => "Error. No se pudo insertar el registro en la cola de envío"]);
            if ($debug) {
                print_r($this->getMsg());
            }
            return false;
        }
    }

    /*     * Metodo que recorre la tabla de mail y envia cada uno que este pendiente, luego actualiza su estado
     * 
     */

    public function enviarMailsBuffer($idmail = null) {

        $buffer = CANTIDAD_ENVIO_MAIL_SIMULTANEOS;
        if ($buffer == "") {
            $buffer = 50;
        }

        $query = new AbstractSql();
        $query->setSelect("*");
        $query->setFrom("$this->table t");
        $query->setWhere("t.estado=0 and t.intentos<=5");
        //si viene un id particular de mail para enviar filtramos el listado solo a este
        if (!is_null($idmail)) {
            $query->addAnd("$this->id=$idmail");
        }
        $query->setOrderBy("fecha ASC");
        $query->setLimit("0,$buffer");

        $cola_mails = $this->getList($query);
        if (COUNT($cola_mails) > 0) {

            $exito = true;
            $cant_enviados = 0;
            $cant_error = 0;
            foreach ($cola_mails as $mail) {
                if ($_SERVER["HTTP_HOST"] != "localhost") {

                    // $mEmail = new MailerAmazonSES();
                    $mEmail = new Mailer("sendgrid");
                    $mEmail->setPort("587");
                } else {

                    $mEmail = new Mailer("phpmailer");
                    $mEmail->setPort("587");
                }

                // $mEmail->setHTML(true);



                $mEmail->setSubject(utf8_decode($mail["mail_subject"]));
                $mEmail->setBody(utf8_decode($mail["body"]));
                $To_list = explode(";", $mail["mail_to"]);

                //echo "To: {$To_list}";
                foreach ($To_list as $To) {
                    $mEmail->addTo($To);
                }

                if ($mail["reply_to"] != "") {
                    $mEmail->AddReplyTo($mail["reply_to"], $mail["reply_to_name"]);
                }
                $mEmail->setFrom(utf8_decode($mail["mail_from"]));
                $mEmail->setFromName(utf8_decode($mail["mail_from_name"]));

                $CC_list = explode(";", $mail["cc"]);
                foreach ($CC_list as $CC) {
                    if ($CC != "") {
                        $mEmail->addCC($CC);
                    }
                }


                $BCC_list = explode(";", $mail["bcc"]);
                foreach ($BCC_list as $BCC) {
                    if ($BCC != "") {
                        $mEmail->addBCC($BCC);
                    }
                }

                if ($mail["attachment"] != "") {
                    //archivo|archivo|archivo
                    $adjuntos = explode("|", $mail["attachment"]);

                    foreach ($adjuntos as $archivo) {
                        //path?nombre|path?nombre
                        $file = explode("?", $archivo);
                        $path = $file[0];
                        $nombre = $file[1];
                        if (file_exists($path)) {
                            $mEmail->AddAttachment($path, $nombre);
                        }
                    }
                }



                //actualizamos los datos del registro del mail
                $record["ultimo_envio"] = date("Y-m-d H:i:s");

                $record["intentos"] = (int) $mail["intentos"] + 1;

                // FIX 20191220 para preferencias de usuario. Solo vamos a mandar si la preferencia de usuario está configurada en "recibir notificaciones por email"
                // Obtengo el médico de la notificación si corresponde
                $ManagerUsuarioWeb = $this->getManager("ManagerUsuarioWeb");
                $usuario_web = $ManagerUsuarioWeb->getByField("email", $mail["mail_to"]);

                $enviar = true;
                if ($usuario_web["tipousuario"] == 'medico') {
                    $ManagerMedico = $this->getManager("ManagerMedico");
                    $ManagerPreferencia = $this->getManager("ManagerPreferencia");

                    // Obtengo las preferencias
                    $medico = $ManagerMedico->getByField("usuarioweb_idusuarioweb", $usuario_web["idusuarioweb"]);
                    $preferencia = $ManagerPreferencia->get($medico["idmedico"]);

                    // se cambia Pass Bien-etre por DoctorPlus en la condicion el dia 10-02-2022
                    if ($preferencia["recibirNotificacionSistemaEmail"] != 1 && $mail["mail_subject"] != "WorknCare | Récupération du mot de passe") {
                        $enviar = false;
                    }
                }



                //enviamos el mail
                if ($enviar) {
                    $rdo = $mEmail->send();
                    if (!$rdo) {
                        $record["estado"] = 0;
                        $cant_error++;
                        $exito = false;
                    } else {
                        $record["estado"] = 1;
                        $cant_enviados++;
                    }
                    parent::update($record, $mail["idmail"]);
                } else {

                    $record["estado"] = 99;

                    parent::update($record, $mail["idmail"]);
                }
            }

            if ($exito) {
                //echo "Se han enviado $cant_enviados mails en cola";
                return true;
            } else {

                //echo "Ha ocurrido un error al enviar $cant_error mails";
                return false;
            }
        } else {
            //echo "No hay mails en cola para ser enviados";
            return false;
        }
    }

    /**
     * Listado de registros de mail
     * @param type $request
     * @param type $idpaginate
     * @return type
     */
    public function getListadoJSON($request, $idpaginate = NULL) {

        if (!is_null($idpaginate)) {
            $this->paginate($idpaginate, $request["rows"]);
        }

        $query = new AbstractSql();
        $query->setSelect("idmail,
                            CONCAT(mail_from_name,': ',mail_from) as mail_from,
                            mail_to,
                            mail_subject,
                            CASE estado
                                WHEN '1' THEN 'Enviado'
                                WHEN '0' THEN 'Pendiente' 
                                WHEN '99' THEN 'NO enviar' 
                            END as estado,
                            fecha,
                            ultimo_envio
                 ");
        $query->setFrom("$this->table  ");

        // Filtro

        if ($request["mail"] != "") {
            $busqueda = cleanQuery($request["mail"]);
            $query->addAnd("mail_to LIKE '%$busqueda%'");
        }

        if ($request["asunto"] != "") {
            $busqueda = cleanQuery($request["asunto"]);
            $query->addAnd("mail_subject LIKE '%$busqueda%'");
        }

        if ($request["estado"] != "") {
            $busqueda = cleanQuery($request["estado"]);
            $query->addAnd("estado='$busqueda'");
        }

        if ($request["fecha"] != "") {
            $fecha = $this->sqlDate($request["fecha"]);
            $query->addAnd("fecha >= '{$fecha} 00:00:00' AND fecha <= '{$fecha} 23:59:59'");
        }

        $data = $this->getJSONList($query, array("mail_from", "mail_to", "mail_subject", "estado", "fecha", "ultimo_envio"), $request, $idpaginate);

        return $data;
    }

}
