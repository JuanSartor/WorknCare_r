<?php

require_once (path_libs_php("stripe-php-7.75.0/init.php"));
/**
 * 	@autor Xinergia
 * 	@version 1.0	02/03/2021
 * 	Manager de clientes en stripe
 *
 */

/**
 * Description of ManagerCustomerStripe
 *
 * @author lucas
 */
class ManagerCustomerStripe extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

// Llamamos al constructor del a superclase
        parent::__construct($db, "customer_stripe", "idcustomer_stripe");
//Stripe testing
        $this->apiKeyPublic_stripe = STRIPE_APIKEY_PUBLIC;
        $this->apiKeySecret_stripe = STRIPE_APIKEY_SECRET;
    }

    /**
     * Método que realiza la llamada a la API de Stripe para crear un cliente paciente que va a solcitar una consulta
     * @param type $idpaciente
     * @return type array conteniendo customerID
     */
    public function crear_cliente_paciente($idpaciente) {
        $paciente = $this->getManager("ManagerPaciente")->get($idpaciente);
        if ($paciente["email"] == "") {
            return false;
        }
        $stripe = new \Stripe\StripeClient($this->apiKeySecret_stripe);
        try {
//chequeo si ya existe el cliente 
            $customers = $stripe->customers->all(['email' => $paciente["email"],
                'limit' => 1,
            ]);

//si existe lo devolvemos
            if ($customers["data"][0]["id"] != "") {
                $customer = $customers["data"][0];
            } else {//sino creamos uno nuevo
                $customer = $stripe->customers->create([
                    'email' => $paciente["email"],
                    'name' => "{$paciente["nombre"]} {$paciente["apellido"]} ",
                ]);
            }
        } catch (\Stripe\Exception\ApiErrorException $e) {

            $this->setMsg(["msg" => "Ha ocurrido un error. Intente nuevamente", "result" => false, "err" => $e->getMessage()]);
            return false;
        } catch (\Stripe\Exception $e) {

            $this->setMsg(["msg" => "Ha ocurrido un error. Intente nuevamente", "result" => false, "err" => $e->getMessage()]);
            return false;
        }
//verificamos si obtuvimos la creacion del cliente en stripe
        if (!$customer["id"] != "") {
            return false;
        }



        $record["customerId"] = $customer["id"];

        $record["paciente_idpaciente"] = $paciente["idpaciente"];
        $id = parent::insert($record);


        $setup_intent = $this->crear_setup_intent($customer["id"]);
        if (!$setup_intent) {
            return false;
        }
        $cliente_stripe = parent::get($id);
        return $cliente_stripe;
    }

    /**
     * Método que devuelve los datos del usuario asociado en stripe para los pagos con tarjeta
     * se crea el registro la primeza vez si no existe
     * @param type $idpaciente
     * @return type array conteniendo customer
     */
    public function get_cliente_stripe($idpaciente) {

        $cliente_stripe = parent::getByField("paciente_idpaciente", $idpaciente);

        if (!$cliente_stripe) {
            $cliente_stripe = $this->crear_cliente_paciente($idpaciente);
        }
        return $cliente_stripe;
    }

    /**
     * Método que realiza la llamada astripe para crear un objeto SetupIntent.
     * Este es un objeto que representa la intención de pago y rastrea los pasos para configurar el método de pago del cliente para pagos futuros. 
     * Esto incluye la recopilación del cliente y la verificación de la validez del IBAN.
     * @param type $customerId


     * @return type array conteniendo customerID
     */
    public function crear_setup_intent($customerId) {
        try {
            $stripe = new \Stripe\StripeClient($this->apiKeySecret_stripe);

            $setup_intent = $stripe->setupIntents->create([
                'payment_method_types' => ['card'],
                'customer' => $customerId,
            ]);
        } catch (\Stripe\Exception\ApiErrorException $e) {
//echo $e;
            $this->setMsg(["msg" => "Ha ocurrido un error. Intente nuevamente", "result" => false, "err" => $e->getMessage()]);
            return false;
        } catch (\Stripe\Exception $e) {
// echo $e;
            $this->setMsg(["msg" => "Ha ocurrido un error. Intente nuevamente", "result" => false, "err" => $e->getMessage()]);
            return false;
        }

        $record["setupIntentId"] = $setup_intent->id;
        $record["client_secret"] = $setup_intent->client_secret;
        $customer_stripe = parent::getByField("customerId", $customerId);

        $rdo = parent::update($record, $customer_stripe["idcustomer_stripe"]);
        if ($rdo) {
            $this->setMsg(["result" => true, "client_secret" => $record["client_secret"]]);
            return true;
        } else {
            $this->setMsg(["msg" => "Ha ocurrido un error. Intente nuevamente", "result" => false]);
            return false;
        }
    }

    /**
     * Método que deveulve el listado de facturas generadas por Stripe a cobrar al usuario por las consultas realizadas
     * @param type $idpaciente


     */
    public function get_facturas($idpaciente) {
        $cliente_stripe = parent::getByField("paciente_idpaciente", $idpaciente);

        if ($cliente_stripe["customerId"] != "") {
            $stripe = new \Stripe\StripeClient($this->apiKeySecret_stripe);
            $facturas = $stripe->invoices->all(['customer' => $cliente_stripe["customerId"]]);
            return $facturas;
        }
    }

    /**
     * Método que deveulve el metodo de pago cargado para cobrar al usuario por las consultas
     * @param type $idpaciente


     */
    public function get_metodo_pago($idpaciente) {
        $cliente_stripe = parent::getByField("paciente_idpaciente", $idpaciente);
        if ($cliente_stripe["stripe_payment_method"] != "") {
            $stripe = new \Stripe\StripeClient($this->apiKeySecret_stripe);

            $metodo_pago = $stripe->paymentMethods->retrieve(
                    $cliente_stripe["stripe_payment_method"], []
            );
            return $metodo_pago;
        }
    }

    /**
     * Método que deveulve el listado de metodos de pago cargados al usuario para cobrar por las consultas
     * @param type $idpaciente


     */
    public function get_listado_metodos_pago($idpaciente) {
        $cliente_stripe = parent::getByField("paciente_idpaciente", $idpaciente);
        if ($cliente_stripe["customerId"] != "") {
            try {
                $stripe = new \Stripe\StripeClient($this->apiKeySecret_stripe);

                $metodos_pago_list = $stripe->paymentMethods->all([
                    'customer' => $cliente_stripe["customerId"],
                    'type' => 'card',
                ]);
                return $metodos_pago_list;
            } catch (\Stripe\Exception\ApiErrorException $e) {
//echo $e;
                return false;
            } catch (\Stripe\Exception $e) {
// echo $e;
                return false;
            }
        }
    }

    /**
     * Método que realiza el cobro a la tarjeta del paciente cuando se finaliza la consulta
     * Los datos del metodo de pago se almacenana en el movimiento de cuenta de la consulta
     * @param type $idpaciente


     */
    public function process_cobro_consulta($id, $idmovimiento, $tipo) {

        $ManagerMovimientoCuenta = $this->getManager("ManagerMovimientoCuenta");
        //recuperamos el movimiento de cuenta
        $movimiento = $ManagerMovimientoCuenta->get($idmovimiento);
        if ($tipo == "videoconsulta") {
            //recueperamos la consulta
            $consulta = $this->getManager("ManagerVideoConsulta")->get($id);
            $description = "Vidéo Consultation Nº{$consulta["numeroVideoConsulta"]}";
        } else if ($tipo == "consultaexpress") {
            //recueperamos la consulta
            $consulta = $this->getManager("ManagerConsultaExpress")->get($id);
            $description = "Conseil Nº{$consulta["numeroConsultaExpress"]}";
        } else if ($tipo == "turno") {
            //recueperamos la consulta
            $consulta = $this->getManager("ManagerTurno")->get($id);
            $description = "Vidéo Consultation sur RDV Nº{$consulta["idturno"]}";
        } else {
            return false;
        }

        if ($consulta && $movimiento) {

            //recuperamos el paciente titular de la cuenta
            $paciente_tit = $this->getManager("ManagerPaciente")->getPacienteTitular($consulta["paciente_idpaciente"]);

            $customerId = parent::getByField("paciente_idpaciente", $paciente_tit["idpaciente"])["customerId"];


            if ($movimiento["stripe_payment_method"] != "" && $customerId != "" && $movimiento["monto"] != "") {
                //registramos el cobro en la base de datos

                $error_stripe = false;
                $stripe = new \Stripe\StripeClient($this->apiKeySecret_stripe);
                try {
                    //cobro en stripe
                    //convertir a centavos
                    $monto = (float) $movimiento["monto"] * 100;
                    $payment_intent = $stripe->paymentIntents->create([
                        'amount' => $monto,
                        'currency' => 'eur',
                        'customer' => $customerId,
                        'payment_method' => $movimiento["stripe_payment_method"],
                        'payment_method_types' => ['card'],
                        "description" => $description,
                        'capture_method' => 'manual',
                        'off_session' => true,
                        'confirm' => true,
                            ]
                            , [
                        'idempotency_key' => "movimiento-cuenta-{$movimiento["idmovimientoCuenta"]}"
                    ]);
                } catch (\Stripe\Exception\CardException $e) {
                    // Error code will be authentication_required if authentication is needed
                    //echo 'Error code is:' . $e->getError()->code;
                    //$payment_intent = $stripe->paymentIntents->retrieve($payment_intent_id);
                    $error_stripe = true;
                    $error_msg = $e->getError()->message;
                    //$stripe_payment_detail = json_encode($e->getError()->payment_intent->charges->data[0]->payment_method_details);
                    //print_r($e->getError()->payment_intent->charges->data[0]->payment_method_details);
                } catch (\Stripe\Exception\ApiErrorException $e) {
                    //echo 'ApiErrorException is:' . $e;
                    $error_stripe = true;
                    $error_msg = $e->getError()->message;
                } catch (\Stripe\Exception $e) {
                    // echo 'Exception is:' . $e;
                    $error_stripe = true;
                    $error_msg = $e->getError()->message;
                }
                if ($error_stripe) {
                    switch ($error_msg) {
                        case "Your card has insufficient funds.":
                            $error_msg = "Votre carte ne dispose pas de fonds suffisants.";
                            break;
                    }
                    $this->setMsg(["msg" => "Error. No se pudo realizar el cobro de la consulta, intente nuevamente: [[$error_msg]]", "error_msg" => $error_msg, "result" => false]);
                    return false;
                } else {
                    //print_r($payment_intent);

                    $upd_movimiento = $ManagerMovimientoCuenta->update(["stripe_payment_intent_id" => $payment_intent->id], $movimiento["idmovimientoCuenta"]);
                    if (!$upd_movimiento) {
                        $this->setMsg(["msg" => "Error. No se pudo realizar el cobro de la consulta, intente nuevamente", "result" => false]);
                        return false;
                    }
                    //registramos los datos del pago en la consulta
                    if ($tipo == "videoconsulta") {
                        //recueperamos la consulta
                        $upd_consulta = $this->getManager("ManagerVideoConsulta")->update(["pago_stripe" => 1, "stripe_payment_method" => $movimiento["stripe_payment_method"], "stripe_payment_intent_id" => $payment_intent->id], $id);
                    } else if ($tipo == "consultaexpress") {
                        $upd_consulta = $this->getManager("ManagerConsultaExpress")->update(["pago_stripe" => 1, "stripe_payment_method" => $movimiento["stripe_payment_method"], "stripe_payment_intent_id" => $payment_intent->id], $id);
                    } else if ($tipo == "turno") {
                        $upd_consulta = $this->getManager("ManagerTurno")->update(["pago_stripe" => 1, "stripe_payment_method" => $movimiento["stripe_payment_method"], "stripe_payment_intent_id" => $payment_intent->id], $id);
                    }
                    if (!$upd_consulta) {
                        $this->setMsg(["msg" => "Error. No se pudo realizar el cobro de la consulta, intente nuevamente", "result" => false]);
                        return false;
                    }

                    $this->setMsg(["msg" => "Se ha registrado con éxito el cobro de la consulta en la tarjeta", "result" => true]);
                    return true;
                }
            } else {
                $this->setMsg(["msg" => "Error. No se pudo realizar el cobro de la consulta, intente nuevamente", "result" => false]);
                return false;
            }
        }
//Si se produjo un error, retorno falso
        $this->setMsg(["msg" => "Error. No se pudo realizar el cobro de la consulta, intente nuevamente", "result" => false]);
        return false;
    }

    /**
     * Método que realiza el cobro a la tarjeta del paciente cuando se finaliza la consulta
     * Los datos del metodo de pago se almacenana en el movimiento de cuenta de la consulta
     * @param type $idpaciente


     */
    public function confirmar_cobro_consulta($id, $tipo) {
        $ManagerMovimientoCuenta = $this->getManager("ManagerMovimientoCuenta");
        //recuperamos el movimiento de cobro en la cuenta

        if ($tipo == "videoconsulta") {
            //recueperamos la consulta
            $consulta = $this->getManager("ManagerVideoConsulta")->get($id);
            //recuperamos el paciente titular de la cuenta
            $paciente_tit = $this->getManager("ManagerPaciente")->getPacienteTitular($consulta["paciente_idpaciente"]);

            $movimiento = $ManagerMovimientoCuenta->getByFieldArray(["paciente_idpaciente", "is_ingreso", "videoconsulta_idvideoconsulta"], [$paciente_tit["idpaciente"], 0, $id]);
        } else if ($tipo == "consultaexpress") {
            //recueperamos la consulta
            $consulta = $this->getManager("ManagerConsultaExpress")->get($id);
            //recuperamos el paciente titular de la cuenta
            $paciente_tit = $this->getManager("ManagerPaciente")->getPacienteTitular($consulta["paciente_idpaciente"]);

            $movimiento = $ManagerMovimientoCuenta->getByFieldArray(["paciente_idpaciente", "is_ingreso", "consultaExpress_idconsultaExpress"], [$paciente_tit["idpaciente"], 0, $id]);
        } else if ($tipo == "turno") {
            //recueperamos la consulta

            $consulta = $this->getManager("ManagerTurno")->get($id);
            //recuperamos el paciente titular de la cuenta
            $paciente_tit = $this->getManager("ManagerPaciente")->getPacienteTitular($consulta["paciente_idpaciente"]);
            $query = new AbstractSql();
            $query->setSelect("*");
            $query->setFrom("movimientocuenta");
            $query->setWhere(" turno_idturno = $id   AND   paciente_idpaciente = {$paciente_tit['idpaciente']} AND is_ingreso=0");

            $query->setOrderBy("fecha desc");
            $query->setLimit("0,1");
            $movimiento = $this->getList($query)[0];
        } else {
            return false;
        }
        //buscamos el movimiento previo de reserva de fondos en stripe
        if ($consulta && $movimiento) {

            //recuperamos el paciente titular de la cuenta
            $paciente_tit = $this->getManager("ManagerPaciente")->getPacienteTitular($consulta["paciente_idpaciente"]);

            $customerId = parent::getByField("paciente_idpaciente", $paciente_tit["idpaciente"])["customerId"];


            if ($movimiento["stripe_payment_intent_id"] != "" && $customerId != "" && $movimiento["monto"] != "") {
                //registramos el cobro en la base de datos
                $this->db->StartTrans();
                $confirmar_movimiento = $ManagerMovimientoCuenta->update(["pendiente_stripe" => 2, "confirmado_stripe" => 1], $movimiento["idmovimientoCuenta"]);

                if (!$confirmar_movimiento) {
                    $this->db->FailTrans();
                    $this->db->CompleteTrans();
                    $this->setMsg(["msg" => "Error. No se pudo realizar el cobro de la consulta, intente nuevamente", "result" => false]);
                    return false;
                }
                $error_stripe = false;
                $stripe = new \Stripe\StripeClient($this->apiKeySecret_stripe);
                try {
                    //cobro en stripe
                    //convertir a centavos
                    if (($tipo == "consultaexpress" || $tipo == "videoconsulta") && $consulta["tipo_consulta"] == "0") {
                        $monto = (float) $consulta["precio_tarifa"] * 100;
                    } else {
                        $monto = (float) $movimiento["monto"] * 100;
                    }

                    $intent = $stripe->paymentIntents->retrieve($movimiento["stripe_payment_intent_id"]);
                    $intent->capture(['amount_to_capture' => $monto]);
                } catch (\Stripe\Exception\CardException $e) {
                    // Error code will be authentication_required if authentication is needed
                    //echo 'Error code is:' . $e->getError()->code;
                    //$payment_intent = $stripe->paymentIntents->retrieve($payment_intent_id);
                    $error_stripe = true;
                    $error_msg = "{$e->getError()->code} : {$e->getError()->message}";
                    $stripe_payment_detail = json_encode($e->getError()->payment_intent->charges->data[0]->payment_method_details);
                    //print_r($e->getError()->payment_intent->charges->data[0]->payment_method_details);
                } catch (\Stripe\Exception\ApiErrorException $e) {
                    //echo 'ApiErrorException is:' . $e;
                    $error_stripe = true;
                    $error_msg = "{$e->getError()->code} : {$e->getError()->message}";
                } catch (\Stripe\Exception $e) {
                    // echo 'Exception is:' . $e;
                    $error_stripe = true;
                    $error_msg = "{$e->getError()->code} : {$e->getError()->message}";
                }
                if ($confirmar_movimiento && !$error_stripe) {
                    //print_r($stripe_payment_detail);
                    $this->db->CompleteTrans();
                    $this->setMsg(["msg" => "Se ha registrado con éxito el cobro de la consulta en la tarjeta", "result" => true]);
                    return true;
                } else {

                    //$mail = $ManagerMovimientoCuenta->sendMailErrorProcesarPago($consulta, $movimiento, $tipo);
                    if ($error_msg) {
                        $this->db->CompleteTrans();
                        $this->setMsg(["msg" => "Error. No se pudo realizar el cobro de la consulta, intente nuevamente", "error_msg" => $error_msg, "result" => false]);
                        return false;
                    } else {
                        //enviar notificacion al paciente
                        $this->db->FailTrans();
                        $this->db->CompleteTrans();
                        $this->setMsg(["msg" => "Error. No se pudo realizar el cobro de la consulta, intente nuevamente", "result" => false]);
                        return false;
                    }
                }
            } else {
                $this->setMsg(["msg" => "Error. No se pudo realizar el cobro de la consulta, intente nuevamente", "result" => false]);
                return false;
            }
        }
//Si se produjo un error, retorno falso
        $this->setMsg(["msg" => "Error. No se pudo realizar el cobro de la consulta, intente nuevamente", "result" => false]);
        return false;
    }

    /**
     * Método que realiza el reembolso del cobro a la tarjeta del paciente cuando se vence o cancela la consulta
     * Los datos del metodo de pago se almacenana en el movimiento de cuenta de la consulta
     * @param type $idpaciente


     */
    public function reembolsar_cobro_consulta($id, $idmovimiento, $tipo) {

        $ManagerMovimientoCuenta = $this->getManager("ManagerMovimientoCuenta");
        //recuperamos el movimiento de cobro en la cuenta
        $movimiento = $ManagerMovimientoCuenta->get($idmovimiento);


        if ($tipo == "videoconsulta") {
            //recueperamos la consulta
            $consulta = $this->getManager("ManagerVideoConsulta")->get($id);
        } else if ($tipo == "consultaexpress") {
            //recueperamos la consulta
            $consulta = $this->getManager("ManagerConsultaExpress")->get($id);
        } else if ($tipo == "turno") {
            //recueperamos la consulta
            $consulta = $this->getManager("ManagerTurno")->get($id);
        } else {
            return false;
        }
        //si no pertenece a una consulta cobrada por stripe salimos del proceso
        if ($consulta["pago_stripe"] == 0) {
            return true;
        }


        //buscamos el movimiento previo de reserva de fondos en stripe
        if ($consulta && $movimiento) {

            if ($consulta["stripe_payment_intent_id"] != "" && $movimiento["monto"] != "") {
                //registramos el cobro en la base de datos
                $this->db->StartTrans();
                $confirmar_movimiento = $ManagerMovimientoCuenta->update(["pendiente_stripe" => 0, "confirmado_stripe" => 1], $movimiento["idmovimientoCuenta"]);

                if (!$confirmar_movimiento) {
                    $this->db->FailTrans();
                    $this->db->CompleteTrans();
                    $this->setMsg(["msg" => "Error. No se pudo realizar el cobro de la consulta, intente nuevamente", "result" => false]);
                    return false;
                }
                $error_stripe = false;
                $stripe = new \Stripe\StripeClient($this->apiKeySecret_stripe);
                try {
                    //cobro en stripe
                    //convertir a centavos


                    $intent = $stripe->paymentIntents->retrieve($consulta["stripe_payment_intent_id"]);

                    //si ya fue reintegrado en Stripe continuamos normalmente
                    if ($intent->charges->data[0]->refunded == 1 && $intent->charges->data[0]->amount == $intent->charges->data[0]->amount_refunded) {
                        $this->db->CompleteTrans();
                        $this->setMsg(["msg" => "Se ha registrado con éxito reembolso de la consulta en la tarjeta", "result" => true]);
                        return true;
                    }
                    //si ya fue capturado el monto (payment intent= succeded) realizamos un reintegro
                    if ($intent->status === "succeeded") {
                        $refund = $stripe->refunds->create(["payment_intent" => $consulta["stripe_payment_intent_id"]]);
                    } else {
                        //si no fue capturado el monto, cancelamos el intento (payment intent)
                        $intent->cancel();
                    }
                } catch (\Stripe\Exception\CardException $e) {
                    // Error code will be authentication_required if authentication is needed
                    //echo 'Error code is:' . $e->getError()->code;
                    //$payment_intent = $stripe->paymentIntents->retrieve($payment_intent_id);
                    $error_stripe = true;
                    $error_msg = "{$e->getError()->code} : {$e->getError()->message}";
                    $stripe_payment_detail = json_encode($e->getError()->payment_intent->charges->data[0]->payment_method_details);
                    //print_r($e->getError()->payment_intent->charges->data[0]->payment_method_details);
                } catch (\Stripe\Exception\ApiErrorException $e) {
                    //echo 'ApiErrorException is:' . $e;
                    $error_stripe = true;
                    $error_msg = "{$e->getError()->code} : {$e->getError()->message}";
                } catch (\Stripe\Exception $e) {
                    // echo 'Exception is:' . $e;
                    $error_stripe = true;
                    $error_msg = "{$e->getError()->code} : {$e->getError()->message}";
                }
                if ($confirmar_movimiento && !$error_stripe) {
                    $this->db->CompleteTrans();
                    $this->setMsg(["msg" => "Se ha registrado con éxito reembolso de la consulta en la tarjeta", "result" => true]);
                    return true;
                } else {

                    //$mail = $ManagerMovimientoCuenta->sendMailErrorProcesarPago($consulta, $movimiento, $tipo);
                    if ($error_msg) {
                        $this->db->FailTrans();
                        $this->db->CompleteTrans();
                        $this->setMsg(["msg" => "Error. No se pudo realizar el reembolso de la consulta, intente nuevamente", "error_msg" => $error_msg, "result" => false]);
                        return false;
                    } else {
                        //enviar notificacion al paciente
                        $this->db->FailTrans();
                        $this->db->CompleteTrans();
                        $this->setMsg(["msg" => "Error. No se pudo realizar el reembolso de la consulta, intente nuevamente", "result" => false]);
                        return false;
                    }
                }
            } else {
                $this->setMsg(["msg" => "Error. No se pudo realizar el reembolso de la consulta, intente nuevamente", "result" => false]);
                return false;
            }
        }
//Si se produjo un error, retorno falso
        $this->setMsg(["msg" => "Error. No se pudo realizar el reembolso de la consulta, intente nuevamente", "result" => false]);
        return false;
    }

    /**
     * Método que devuelve el objeto del payment intent para obtener la url del la factura por el movimiento
     * @param type $id


     */
    public function ver_ticket_payment_intent($id) {
        if ($id == "") {
            $this->setMsg(["msg" => "Error. No se pudo recuperar la información solicitada", "result" => false]);
            return false;
        }
        $stripe = new \Stripe\StripeClient($this->apiKeySecret_stripe);
        try {
            $intent = $stripe->paymentIntents->retrieve($id);
            //print_r($intent);
            $url = $intent->charges->data[0]->receipt_url;
            if ($url) {
                $this->setMsg(["url" => $url, "result" => true]);
                return true;
            } else {
                $this->setMsg(["msg" => "Error. No se pudo recuperar la información solicitada", "result" => false]);
                return false;
            }
        } catch (\Stripe\Exception\CardException $e) {
            // Error code will be authentication_required if authentication is needed
            //echo 'Error code is:' . $e->getError()->code;
            $this->setMsg(["msg" => "Error. No se pudo recuperar la información solicitada", "result" => false]);
            return false;
        } catch (\Stripe\Exception\ApiErrorException $e) {
            //echo 'ApiErrorException is:' . $e;
            $this->setMsg(["msg" => "Error. No se pudo recuperar la información solicitada", "result" => false]);
            return false;
        } catch (\Stripe\Exception $e) {
            $this->setMsg(["msg" => "Error. No se pudo recuperar la información solicitada", "result" => false]);
            return false;
        }
        $this->setMsg(["msg" => "Error. No se pudo recuperar la información solicitada", "result" => false]);
        return false;
    }

    public function getPacientesConSaldo() {
        $query = new AbstractSql();
        $query->setSelect("p.nombre,p.apellido,p.email,saldo");
        $query->setFrom("cuentausuario c inner join v_pacientes p on (c.paciente_idpaciente=p.idpaciente)");
        $query->setWhere("saldo>0");
        $listado_pacientes = $this->getList($query);

        $stripe = new \Stripe\StripeClient($this->apiKeySecret_stripe);
        foreach ($listado_pacientes as $paciente) {
            print_r($paciente);
            try {
//chequeo si ya existe el cliente 
                $customers = $stripe->customers->all(['email' => $paciente["email"],
                    'limit' => 1,
                ]);
                echo "<br> customer stripe <br>";

                print_r($customers);
            } catch (\Stripe\Exception\ApiErrorException $e) {

                $this->setMsg(["msg" => "Ha ocurrido un error. Intente nuevamente", "result" => false, "err" => $e->getMessage()]);
                return false;
            } catch (\Stripe\Exception $e) {

                $this->setMsg(["msg" => "Ha ocurrido un error. Intente nuevamente", "result" => false, "err" => $e->getMessage()]);
                return false;
            }
        }
    }

    /**
     * Metodo para eliminar tarjeta de credito ya asociada
     */
    public function eliminar_tarjeta_credito($request) {
        try {
            $stripe = new \Stripe\StripeClient($this->apiKeySecret_stripe);
            $stripe->paymentMethods->detach(
                    $request["idmetodopago"], []
            );
            $this->setMsg(["msg" => "Se ha eliminado la tarjeta con éxito", "result" => true]);
            return true;
        } catch (\Stripe\Exception\ApiErrorException $e) {
            $this->setMsg(["msg" => "Ha ocurrido un error. Intente nuevamente", "result" => false, "err" => $e->getMessage()]);
            return false;
        } catch (\Stripe\Exception $e) {
            $this->setMsg(["msg" => "Ha ocurrido un error. Intente nuevamente", "result" => false, "err" => $e->getMessage()]);
            return false;
        }
    }

    public function cancelarCuestionario($stripe_payment_intent_id) {

        $error_stripe = false;
        $stripe = new \Stripe\StripeClient($this->apiKeySecret_stripe);
        try {
            //cobro en stripe
            //convertir a centavos

            $intent = $stripe->paymentIntents->retrieve($stripe_payment_intent_id);

            //si ya fue reintegrado en Stripe continuamos normalmente
            if ($intent->charges->data[0]->refunded == 1 && $intent->charges->data[0]->amount == $intent->charges->data[0]->amount_refunded) {
                $this->db->CompleteTrans();
                $this->setMsg(["msg" => "Se ha registrado con éxito reembolso del cuestionario en la tarjeta", "result" => true]);
                return true;
            }
            //si ya fue capturado el monto (payment intent= succeded) realizamos un reintegro
            if ($intent->status === "succeeded") {
                $refund = $stripe->refunds->create(["payment_intent" => $stripe_payment_intent_id]);
            } else {
                //si no fue capturado el monto, cancelamos el intento (payment intent)
                $intent->cancel();
            }
        } catch (\Stripe\Exception\CardException $e) {
            // Error code will be authentication_required if authentication is needed
            //echo 'Error code is:' . $e->getError()->code;
            //$payment_intent = $stripe->paymentIntents->retrieve($payment_intent_id);
            $error_stripe = true;
            $error_msg = "{$e->getError()->code} : {$e->getError()->message}";
            $stripe_payment_detail = json_encode($e->getError()->payment_intent->charges->data[0]->payment_method_details);
            //print_r($e->getError()->payment_intent->charges->data[0]->payment_method_details);
        } catch (\Stripe\Exception\ApiErrorException $e) {
            //echo 'ApiErrorException is:' . $e;
            $error_stripe = true;
            $error_msg = "{$e->getError()->code} : {$e->getError()->message}";
        } catch (\Stripe\Exception $e) {
            // echo 'Exception is:' . $e;
            $error_stripe = true;
            $error_msg = "{$e->getError()->code} : {$e->getError()->message}";
        }
        if (!$error_stripe) {
            $this->db->CompleteTrans();
            $this->setMsg(["msg" => "Se ha registrado con éxito reembolso de la consulta en la tarjeta", "result" => true]);
            return true;
        } else {
            // print_r($error_msg);
            //$mail = $ManagerMovimientoCuenta->sendMailErrorProcesarPago($consulta, $movimiento, $tipo);
            if ($error_msg) {
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                $this->setMsg(["msg" => "Error. No se pudo realizar el reembolso de la consulta, intente nuevamente", "error_msg" => $error_msg, "result" => false]);
                return false;
            } else {
                //enviar notificacion al paciente
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                $this->setMsg(["msg" => "Error. No se pudo realizar el reembolso de la consulta, intente nuevamente", "result" => false]);
                return false;
            }
        }
    }

    /**
     * Método que realiza la llamada astripe para crear un objeto SetupIntent.
     * Este es un objeto que representa la intención de pago y rastrea los pasos para configurar el método de pago del cliente para pagos futuros. 
     * Esto incluye la recopilación del cliente y la verificación de la validez del IBAN.
     * @param type $customerId


     * @return type array conteniendo customerID
     */
    public function crear_setup_intent_cuestionario($customerId, $idPagoRecomensa) {
        // $this->debug();
        try {
            $stripe = new \Stripe\StripeClient($this->apiKeySecret_stripe);

            $setup_intent = $stripe->setupIntents->create([
                'payment_method_types' => ['card'],
                'customer' => $customerId,
            ]);
        } catch (\Stripe\Exception\ApiErrorException $e) {
//echo $e;
            $this->setMsg(["msg" => "Ha ocurrido un error. Intente nuevamente", "result" => false, "err" => $e->getMessage()]);
            return false;
        } catch (\Stripe\Exception $e) {
// echo $e;
            $this->setMsg(["msg" => "Ha ocurrido un error. Intente nuevamente", "result" => false, "err" => $e->getMessage()]);
            return false;
        }


        $record["setupIntentId"] = $setup_intent->id;
        $record["client_secret"] = $setup_intent->client_secret;

        $managerPago = $this->getManager("ManagerPagoRecompensaEncuesta");
        $managerPago->update(["client_secret" => $record["client_secret"]], $idPagoRecomensa);

        $this->setMsg(["result" => true, "client_secret" => $record["client_secret"], "setupIntentId" => $record["setupIntentId"]]);
        return true;
    }

    /**
     * Método que realiza el cobro a la tarjeta del paciente cuando se finaliza la consulta
     * Los datos del metodo de pago se almacenana en el movimiento de cuenta de la consulta
     * @param type $idpaciente
     */
    public function process_cobro_cuestionario($request) {
        //$this->debug();
        $managerCues = $this->getManager("ManagerCuestionario");
        $cuestionario = $managerCues->get($request["cuestionario_idcuestionario"]);
        if ($cuestionario["recompensa"] == '1') {
            $subtotal = 30 * $cuestionario["cantidad"];
        } else {
            $subtotal = 65 * $cuestionario["cantidad"];
        }

        $managerPago = $this->getManager("ManagerPagoRecompensaEncuesta");
        $pago = $managerPago->getByField("cuestionario_idcuestionario", $request["cuestionario_idcuestionario"]);


        $error_stripe = false;
        $stripe = new \Stripe\StripeClient($this->apiKeySecret_stripe);
        try {
            //cobro en stripe
            //convertir a centavos
//       
            $inv = $stripe->invoiceItems->create(
                    [
                        'customer' => $pago["customerId"],
                        'price' => $pago["priceId"],
                        'quantity' => $cuestionario["cantidad"],
                    ]
            );
            $in = $stripe->invoices->create(
                    [
                        'customer' => $pago["customerId"],
                        'footer' => 'Attention : tout retard de règlement donnera lieu de plein droit et sans qu’aucune mise en demeure ne soit nécessaire au paiement de pénalités de retard sur la base de 3 fois le taux d’intérêt légal et au paiement d’une indemnité forfaitaire pour frais de recouvrement d’un montant de 40 eur.            '
                        . '                                                                                                                                                                                                                                                                                     Note : paiement relatif à l’achat d’une prestation dans le cadre d’un sondage. La TVA est décomptée de la prestation le cas échéant. Validité de la prestation : 12 mois.',
            ]);

            $rdoInv = $stripe->invoices->finalizeInvoice($in["id"], []);
        } catch (\Stripe\Exception\CardException $e) {
            // Error code will be authentication_required if authentication is needed
            //echo 'Error code is:' . $e->getError()->code;
            //$payment_intent = $stripe->paymentIntents->retrieve($payment_intent_id);
            $error_stripe = true;
            $error_msg = $e->getError()->message;
            //$stripe_payment_detail = json_encode($e->getError()->payment_intent->charges->data[0]->payment_method_details);
            //print_r($e->getError()->payment_intent->charges->data[0]->payment_method_details);
        } catch (\Stripe\Exception\ApiErrorException $e) {
            //echo 'ApiErrorException is:' . $e;
            $error_stripe = true;
            $error_msg = $e->getError()->message;
        } catch (\Stripe\Exception $e) {
            // echo 'Exception is:' . $e;
            $error_stripe = true;
            $error_msg = $e->getError()->message;
        }
        if ($error_stripe) {
            // print_r($error_msg);
            switch ($error_msg) {
                case "Your card has insufficient funds.":
                    $error_msg = "Votre carte ne dispose pas de fonds suffisants.";
                    break;
            }
            $this->setMsg(["msg" => "Error. No se pudo realizar el cobro del cuestionario, intente nuevamente: [[$error_msg]]", "error_msg" => $error_msg, "result" => false]);
            return false;
        } else {

            $rupdate["invoiceId"] = $in["id"];
            $managerPago->update($rupdate, $pago["idpago_recompensa_encuesta"]);

            $this->setMsg(["msg" => "Se ha registrado con éxito el cobro del cuestionario en la tarjeta", "result" => true]);
            return true;
        }


//Si se produjo un error, retorno falso
        $this->setMsg(["msg" => "Error. No se pudo realizar el cobro de la consulta, intente nuevamente", "result" => false]);
        return false;
    }

    /**
     * Método que realiza el cobro a la tarjeta del paciente cuando se finaliza la consulta
     * Los datos del metodo de pago se almacenana en el movimiento de cuenta de la consulta
     * @param type $idpaciente


     */
    public function confirmar_cobro_cuestionario($idcuestionario) {


        $managerPago = $this->getManager("ManagerPagoRecompensaEncuesta");
        $pago = $managerPago->getByField("cuestionario_idcuestionario", $idcuestionario);
        $empre = $this->getManager("ManagerEmpresa")->get($pago["empresa_idempresa"]);

        $error_stripe = false;
        $stripe = new \Stripe\StripeClient($this->apiKeySecret_stripe);
        try {
            //cobro en stripe
///// lo que esta entre medio va si la empreaa es un pack es decir pago unico
            if ($empre["obra_social"] == '1') {
                $payment_method = $stripe->paymentMethods->retrieve($pago["stripe_payment_method"]);
                $payment_method->attach(['customer' => $pago["customerId"],]);

                $stripe->customers->update($pago["customerId"], [
                    'invoice_settings' => [
                        'default_payment_method' => $pago["stripe_payment_method"]
                    ]
                ]);
            }

            /////


            $rdoPay = $stripe->invoices->pay($pago["invoiceId"]);


            $request["invoice_pdf"] = $rdoPay["invoice_pdf"];
            $managerPago->update($request, $pago["idpago_recompensa_encuesta"]);
        } catch (\Stripe\Exception\CardException $e) {
            // Error code will be authentication_required if authentication is needed
            //echo 'Error code is:' . $e->getError()->code;
            //$payment_intent = $stripe->paymentIntents->retrieve($payment_intent_id);
            $error_stripe = true;
            $error_msg = "{$e->getError()->code} : {$e->getError()->message}";
            $stripe_payment_detail = json_encode($e->getError()->payment_intent->charges->data[0]->payment_method_details);
            //print_r($e->getError()->payment_intent->charges->data[0]->payment_method_details);
        } catch (\Stripe\Exception\ApiErrorException $e) {
            //echo 'ApiErrorException is:' . $e;
            $error_stripe = true;
            $error_msg = "{$e->getError()->code} : {$e->getError()->message}";
        } catch (\Stripe\Exception $e) {
            // echo 'Exception is:' . $e;
            $error_stripe = true;
            $error_msg = "{$e->getError()->code} : {$e->getError()->message}";
        }
        if (!$error_stripe) {
            //print_r($stripe_payment_detail);
            $this->db->CompleteTrans();
            $this->setMsg(["msg" => "Se ha registrado con éxito el cobro de la consulta en la tarjeta", "result" => true]);
            return true;
        } else {

            //$mail = $ManagerMovimientoCuenta->sendMailErrorProcesarPago($consulta, $movimiento, $tipo);
            if ($error_msg) {
                $this->db->CompleteTrans();
                $this->setMsg(["msg" => "Error. No se pudo realizar el cobro de la consulta, intente nuevamente", "error_msg" => $error_msg, "result" => false]);
                return false;
            } else {
                //enviar notificacion al paciente
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                $this->setMsg(["msg" => "Error. No se pudo realizar el cobro de la consulta, intente nuevamente", "result" => false]);
                return false;
            }
        }


//Si se produjo un error, retorno falso
        $this->setMsg(["msg" => "Error. No se pudo realizar el cobro de la consulta, intente nuevamente", "result" => false]);
        return false;
    }

}
