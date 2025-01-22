<?php

/**
 * 	@autor Xinergia
 * 	@version 1.0	29/05/2014
 * 	Manager de Los pacientes
 *
 */
class ManagerCodigoValidacion extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "codigo_validacion", "idcodigo");


    }

    /**
     * Codigos genericos de celular para login y para SMS
     * @return boolean
     */
    public function sendSMSValidacion($request) {


        $numero = $request["numeroCelular"];                        
        $caracteres = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890";
        $numerodeletras = 5;

        $cuerpo = "";
        for ($i = 0; $i < $numerodeletras; $i++) {
            $cuerpo .= substr($caracteres, rand(0, strlen($caracteres)), 1); /* Extraemos 1 caracter de los caracteres 
              entre el rango 0 a Numero de letras que tiene la cadena */
        }
        
        //Actualizo el código de validación de celular
        
        
        $record["celular"] = $numero;
        $record["codigoValidacionCelular"] = $cuerpo;
        $record["fecha"] = date("Y-m-d H:i:s");
        $record["ip"] = $_SERVER["REMOTE_ADDR"];
        $record["contexto"] = $request["contexto"]; // "rp, rm, l
        switch ($record["contexto"]) {
            case "rp":  $txtcontexto = "SMS de validación registro paciente";
                        $dirigido = "p";
                        break;
            case "rp":  $txtcontexto = "SMS de validación registro medico";
                        $dirigido = "m";
                        break;
            case "l":   $txtcontexto = "SMS de validación Login";
                        $dirigido = "login";
                        break;
            default:
                $txtcontexto = "SMS de validación no definido";
            
        }
        
        // ToDO: Quitar esto en producción
        if (defined("SMS_TEST") ) {
            $record["codigoValidacionCelular"] = "12345";
            $record["NOENVIAR"] = true; // Flag para que no haga envío
        }
        $id = $this->insert($record);
        if (!$id) {
            $this->setMsg(["msg" => "Se produjo un error intente más tarde.", "result" => false]);
            return false;
        }

        $cuerpo = "Código de validación de celular WorknCare: " . $cuerpo;

        /**
         * Inserción del SMS en la lista de envio
         */
        $ManagerLogSMS = $this->getManager("ManagerLogSMS");
        $sms = $ManagerLogSMS->insert([
            "dirigido" => $dirigido,        
            "contexto" => $txtcontexto,
            "texto" => $cuerpo,
            "numero_cel" => $numero,
            "estado" => "1",
            "intentos" => "1"
        ]);
        

        if ($sms) {
            $this->setMsg(["msg" => "Se ha enviado un SMS a su celular.", "result" => true]);

            return true;
        } else {
            $this->setMsg($ManagerLogSMS->getMsg());

            return false;
        }
    }

}

//END_class