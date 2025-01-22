<?php

/**
 * 	@autor Xinergia
 * 	@version 1.0	29/05/2014
 * 	Manager de Los temas utilizados para los eventos
 *
 */
class ManagerEventoPaciente extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "eventopaciente", "ideventopaciente");
    }

    public function get($id) {
        $record = parent::get($id);

        if ($record) {
            $managerTemaEvento = $this->getManager("ManagerTemaEvento");
            $record["temaevento"] = $managerTemaEvento->get($record["temaevento_idtemaevento"]);
        }

        return $record;
    }

    /*
     * 	@author Xinergia <info@e-xinergia.com>
     *   @version 1.0
     */

    public function process($request) {

        if ($request["recordatorio"] == "1") {
            $request["horarioRecordatorio"] = "";
            $request["intervaloTiempo"] = "";
        } elseif ($request["horarioRecordatorio"] == "" || $request["intervaloTiempo"] == "") {
            $this->setMsg([ "msg" => "Debe cargar el horario y el intervalo de tiempo del recordatorio", "result" => false]);
            return false;
        }

        $fecha = $request["fecha"];
        if (!isset($fecha) && $fecha == "") {
            $this->setMsg(["msg" => "Debe cargar la fecha del recordatorio", "result" => false]);

            return false;
        }

        $rdo = $this->compararFechas($fecha, date("d/m/Y"));

        if (!$rdo || $rdo < 0) {
            $this->setMsg([ "msg" => "La fecha cargada ya ha pasado", "result" => false]);
            return false;
        }

        $request["fecha"] = $this->sqlDate($fecha);

        //die();
        $id = parent::process($request);
        if (!$id) {
            $this->setMsg([ "msg" => "Ha ocurrido un error al ingresar el evento.", "result" => false]);
            return false;
        } else {
            $this->setMsg([ "msg" => "Se ha agendado el evento", "result" => true]);
        }

        return $id;
    }

    public function getListadoJSON($idpaginate = NULL, $request) {

        if (!is_null($idpaginate)) {
            $this->paginate($idpaginate, 50);
        }

        $query = new AbstractSql();
        $query->setSelect("*");

        $query->setFrom("
                $this->table
            ");

        // Filtro
        if ($request["temaevento"] != "") {

            $nombre = cleanQuery($request["temaevento"]);

            $query->addAnd("temaevento LIKE '%$nombre%'");
        }


        $query->setOrderBy("temaevento ASC");

        $data = $this->getJSONList($query, array("temaevento"), $request, $idpaginate);

        return $data;
    }

    /**
     * Compara fechas separadas por "/"
     * @param type $primera
     * @param type $segunda
     * @return int
     */
    private function compararFechas($primera, $segunda) {
        $valoresPrimera = explode("/", $primera);
        $valoresSegunda = explode("/", $segunda);

        $diaPrimera = $valoresPrimera[0];
        $mesPrimera = $valoresPrimera[1];
        $anyoPrimera = $valoresPrimera[2];

        $diaSegunda = $valoresSegunda[0];
        $mesSegunda = $valoresSegunda[1];
        $anyoSegunda = $valoresSegunda[2];

        $diasPrimeraJuliano = gregoriantojd($mesPrimera, $diaPrimera, $anyoPrimera);
        $diasSegundaJuliano = gregoriantojd($mesSegunda, $diaSegunda, $anyoSegunda);

        if (!checkdate($mesPrimera, $diaPrimera, $anyoPrimera)) {
            // "La fecha ".$primera." no es válida";
            return false;
        } elseif (!checkdate($mesSegunda, $diaSegunda, $anyoSegunda)) {
            // "La fecha ".$segunda." no es válida";
            return false;
        } else {
            return $diasPrimeraJuliano - $diasSegundaJuliano;
        }
    }

    /**
     * Mpetodo que envía los recordatorios de los eventos a los pacientes que así lo tengan configurado
     * @return boolean
     */
    public function cronSendRecordatorioEventoPaciente() {

        $fecha = date("Y-m-d");

        $fecha_his = date("Y-m-d H:i:s");

        $query = new AbstractSql();

        $query->setSelect("ep.*, p.*");

        $query->setFrom("
               eventopaciente ep
                    INNER JOIN paciente p ON (ep.paciente_idpaciente = p.idpaciente)
            ");

        $query->setWhere("(p.recepcionNotificacionesEmail = 1 OR (p.recepcionNotificacionesSMS = 1 AND p.celularValido = 1))");

        //Los que no se enviaron
        $query->addAnd("ep.isEnvioRecordatorio = 0");

        //Los que tengan horario
        $query->addAnd("ep.sinHorario = 0");

        $query->addAnd("ep.fecha >= '$fecha'");


        $listado = $this->getList($query);

        if ($listado && count($listado) > 0) {
            foreach ($listado as $key => $evento) {

                $envio = false;
                $result_envio = false;
                $fecha_his_evento = $evento["fecha"] . " " . $evento["horaEvento"];
                //Debo controlar que el horario de envío sea el correcto...
                if ((int) $evento["recordatorio"] == 0) {
                    //Recordatorio a un tiempo determinado
                    $envio = $this->isEnviarRecordatorio($fecha_his, $fecha_his_evento, $evento["recordatorio"], $evento["horarioRecordatorio"]);
                } elseif ((int) $evento["recordatorio"] == 1) {
                    //Recordatorio a la hora
                    $envio = $this->isEnviarRecordatorio($fecha_his, $fecha_his_evento, 2, 1);
                }


                //Si se debe envíar el recordatorio
                if ($envio) {
                    if ((int) $evento["recepcionNotificacionesEmail"] == 1) {
                        $result_envio = $this->sendEventoPacienteEmail($evento);
                    }
                    if ((int) $evento["recepcionNotificacionesSMS"] == 1) {
                        $result_envio = $this->sendEventoPacienteSMS($evento);
                    }

                    if ($result_envio) {
                        //Tengo que actualizar el registro de la base de datos para marcar que ya se enviaron los recordatorios
                        $rdo = parent::update(array("isEnvioRecordatorio" => 1), $evento[$this->id]);
                    }
                }
            }
        } else {
            return false;
        }
    }

    /**
     * Método que compara en base a la fecha en la que se corre el cron, se determina si el tiempo es mayor igual 
     * 
     * @param type $fecha1
     * @param type $intervalo_tiempo
     * @param type $horario_recordatorio
     * @return boolean
     */
    private function isEnviarRecordatorio($fecha_now, $fecha_evento, $intervalo_tiempo, $horario_recordatorio) {
        //Array, con la fecha de ahora
        $array_fecha_now = explode(" ", $fecha_now);

        list($Y1, $m1, $d1) = preg_split("[-]", $array_fecha_now[0]);
        list($H1, $i1, $s1) = preg_split("[:]", $array_fecha_now[1]);

        //Fecha del evento
        $array_fecha_evento = explode(" ", $fecha_evento);

        list($Y2, $m2, $d2) = preg_split("[-]", $array_fecha_evento[0]);
        list($H2, $i2, $s2) = preg_split("[:]", $array_fecha_evento[1]);

        //mkTime de la fecha original
        $mktime_evento = mktime($H2, $i2, $s2, $m2, $d2, $Y2);

        //Sumo la cantidad de tiempo, si se pasa a la hora del evento, se debe enviar el mensaje
        switch ($intervalo_tiempo) {
            case (int) 1:
                //Minutos
                $mktime2 = mktime($H1, $i1 + $horario_recordatorio, $s1, $m1, $d1, $Y1);
                break;
            case (int) 2:
                //Hora
                $mktime2 = mktime($H1 + $horario_recordatorio, $i1, $s1, $m1, $d1, $Y1);
                break;
            case (int) 3:
                //Dias
                $mktime2 = mktime($H1, $i1, $s1, $m1, $d1 + $horario_recordatorio, $Y1);
                break;
            case (int) 4:
                //Semanas
                $mktime2 = mktime($H1, $i1, $s1, $m1, $d1 + $horario_recordatorio * 7, $Y1);
                break;
            default:
                return false;
                break;
        }

        if ($mktime_evento <= $mktime2) {
            return true;
        } else {
            return false;
        }
    }

    /**
     * Método utilizado para enviar un evento en caso de que el paciente tenga configurado para recibir las notificaciones vía SMS
     * @param type $evento
     * @return boolean
     */
    private function sendEventoPacienteSMS($evento) {
        $cuerpo = "Evento WorknCare: " . $evento["comentario"];

        $numero = $evento["numeroCelular"];

        /**
         * Inserción del SMS en la lista de envio
         */
        $ManagerLogSMS = $this->getManager("ManagerLogSMS");
        $sms = $ManagerLogSMS->insert([
            "dirigido" => 'P',
            "paciente_idpaciente" => $evento["paciente_idpaciente"],
            "contexto" => "Evento Paciente",
            "texto" => $cuerpo,
            "numero_cel" => $numero
        ]);


        if ($sms) {
            $this->setMsg([ "msg" => "Se ha enviado un SMS a su celular.", "result" => true]);

            return true;
        } else {
            $this->setMsg($ManagerLogSMS->getMsg());

            return false;
        }
    }

    /**
     * Mpétodo utilizado para el envio de eventos a los pacientes que se encuentran en el sistema
     * @param type $evento
     * @return boolean
     */
    private function sendEventoPacienteEmail($evento) {
        $mEmail = $this->getManager("ManagerMail");
        $mEmail->setHTML(true);

        //ojo solo arnet local
        $mEmail->setPort("587");

        $mEmail->setSubject("Event WorknCare");

        $smarty = SmartySingleton::getInstance();


        $usuario = $this->getManager("ManagerUsuarioWeb")->get($evento["paciente_idpaciente"]);

        if (!$usuario) {
            return false;
        }


        $smarty->assign("usuario", $usuario);
        $smarty->assign("evento", $evento);
        $smarty->assign("sistema", NOMBRE_SISTEMA);



        $mEmail->setBody($smarty->Fetch("email/evento_paciente.tpl"));


        $mEmail->addTo($usuario["email"]);


        //header a todos los comentarios!
        if ($mEmail->send()) {

            return true;
        } else {
            $this->setMsg(["result" => false, "msg" => "No se pudo enviar el mensaje"]);
            return false;
        }
    }

}

//END_class
?>