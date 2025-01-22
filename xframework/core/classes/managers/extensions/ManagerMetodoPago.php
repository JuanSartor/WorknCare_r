<?php

    require_once (path_libs_php("mercadopago/mercadopago.php"));
    require_once (path_libs_php("stripe-php-7.75.0/init.php"));

    /**x
     * 	@autor Xinergia
     * 	Manager de los tipos de familiar
     *
     */
    class ManagerMetodoPago extends Manager {
        private $mp; //mercadopago
        private $apiKey_payu; //payu
        private $apiLogin_payu; //payu
        private $merchantId_payu; //payu
        private $accountId_payu; //payu
        private $url_submit_payu; //payu


        /** constructor
         * 	@param $db instancia de adodb
         */
        function __construct($db) {
            // Llamamos al constructor del a superclase
            parent::__construct($db, "metodopago", "idmetodoPago");
            //$this->mp = new MP('2205200664718042', 'JhSiNmJWaKufPtih1P6t4CsO9NhS1e0Q');//credenciales usuario testing
            //$this->mp = new MP('6041146799695898', '8FzLXleVWcVd0n3GlIKQd5HkqAVY9hGR');
            $this->mp = new MP('5504390177603377', 'makCL5APLfsdJxfefmxTwtlVyH7N0ZLe');//credenciales 

            //payu testing
            $this->apiKey_payu = "4Vj8eK4rloUd272L48hsrarnUA";
            $this->apiLogin_payu = "pRRXKOl8ikMmt9u";
            $this->merchantId_payu = "508029";
            $this->accountId_payu = "512322";
            $this->url_submit_payu = "https://sandbox.checkout.payulatam.com/ppp-web-gateway-payu";

            //payu produccion
            
            //Stripe testing
            $this->apiKeyPublic_stripe = STRIPE_APIKEY_PUBLIC;
            $this->apiKeySecret_stripe = STRIPE_APIKEY_SECRET;
            
        }

        /**
         * Obtiene un combo de los métodos de pago disponibles
         * @return type
         */
        public function getCombo() {

            $query = new AbstractSql();
            $query->setSelect("$this->id,metodopago");
            $query->setFrom("$this->table");
            $query->setWhere("activo=1");
            if(CONTROLLER!="paciente_p"){
                $query->addAnd("{$this->id} <> 3");
            }

            return $this->getComboBox($query, false);
        }

        /**
         * Método utlizado para la creación del enlace para pagar por mercado pago
         * Esto se utiliza para un solo pago individual
         * @param type $request
         * @return type
         */
        public function getEnlaceMP($request) {

            //$this->mp->sandbox_mode(TRUE);//sandbox

            //creacion de la preferencia de pago para pago con tarjetas
            $preference_data = array(
                "items" => array(
                    array(
                        "id" => $request["idcompra_credito"],
                        "title" => "Pago compra de crédito (DoctorPlus)",
                        "quantity" => 1,
                        "currency_id" => "ARS",
                        //"unit_price" => 4.6 //precio minimo para testing
                        "unit_price" => $request["monto"]
                    )
                ),
                "back_urls" => array(
                    "failure" => URL_ROOT."panel-paciente/",
                    "pending" => URL_ROOT."panel-paciente/",
                    "success" => URL_ROOT."panel-paciente/"
                ),
                "auto_return" => "approved",
                "payment_methods" => array(
                    "excluded_payment_types" => array(
                        array("id" => "ticket"),
                        array("id" => "bank_transfer"),
                        array("id" => "atm"),
                        array("id" => "debit_card"),
                        array("id" => "credit_card")
                    )
                ),
                "external_reference" => "c=" . $request["idcompra_credito"]
            );

            $preference = $this->mp->create_preference($preference_data);
            $this->setMsg(["result"=>true, "link"=>$preference['response']['init_point']]);
            return $preference['response']['init_point'];
        }//END_getEnlaceMP

        /**
         *
         */
        public function getEnlacePagoRecurrenteMP($request){
            $fechas = fechaMP($request["cuotas"]);
            if(CONTROLLER=="medico"){
                $back_url=URL_ROOT."panel-medico/pagos-vencimientos/";
            }

            $preapproval_data = array(
                "payer_email" => $request["email"],
                "back_url" => $back_url,
                "reason" => "Pago adquisición de cuenta Profesional (DoctorPlus)",
                "external_reference" => "d=" . $request["idsuscripcion"],
                "auto_recurring" => array(
                        "frequency" => 1,
                        "frequency_type" => "months",
                        "transaction_amount" => $request["monto"], /* * 1.045,*/
                        //"transaction_amount" => 1, //testing
                        "currency_id" => "ARS",
                        //"start_date" => "",//no mandamos fecha, asi se genera el preapproval con la fecha de hoy
                        "end_date" => $fechas["fechaFin"]
                )
            );
            $preference = $this->mp->create_preapproval_payment($preapproval_data);

            $this->setMsg(["result"=>true, "msg"=>"Preferencia de pago creada con éxito", "enlace"=>$preference['response']['init_point']]);
            return $preference['response']['init_point'];

        }//END_getEnlacePagoRecurrenteMP

        /**
         *  Procesa una notificacion
         */
        public function processNotificationMP($id) {
        
            //obtengo el pago completo de mercadopago
            $payment = $this->mp->get_payment($id);

            $myFile = path_files("ipn_log_mp_1.txt");

            $fh = fopen($myFile, 'a');
            fwrite($fh, print_r($payment, true));
          
            fclose($fh);

            //si el estado del pago es 200 (ok)
            if ($payment["status"] == 200) {
            
                //obtengo la info específica del pago
                $pago = $payment["response"]["collection"];

                //valido el estado del pago
                if ($pago["status"] != "approved") {
                    return false;
                }

                $orderId = explode("=", $pago["order_id"]);
                $fecha_pago = explode("T", $pago["date_approved"]);
                $pago["order_id"] = $orderId[1];
                $pago["fecha_pago"] = $fecha_pago[0];
              
                //proceso el pago    
                switch ($orderId[0]) {
                    case "d"://pago recurrente
                        $ManagerCuota = $this->getManager("ManagerCuota");
                        $rdo = $ManagerCuota->procesarPago($pago);
                        break;
                    case "c"://compra de credito
                        $ManagerCompraCredito = $this->getManager("ManagerCompraCredito");
                        $rdo = $ManagerCompraCredito->procesarPago($pago);
                        break;
                }

                return $rdo;
                //return true;
            }
        }

        /**
         * Obtiene los datos para completar el formulario de payu
         * @param  [type] $request [description]
         * @return [type]          [description]
         */
        public function getDatosPagoPayU($request){

            $result = [];
            $result["action"] = $this->url_submit_payu;
            $result["merchantId"] = $this->merchantId_payu;
            $result["accountId"] = $this->accountId_payu;
            
            $result["referenceCode"] = $signature["referenceCode"] = "c={$request["idcompra_credito"]}";
            $result["description"] = "Compra de crédito DoctorPlus";
            $result["amount"] = $signature["amount"] = $request["monto"];

            $result["currency"] = $signature["currency"] = "ARS";
            $result["tax"] = 0;
            $result["taxReturnBase"] = 0;

            $result["signature"] = $this->getSignature($signature);            

            $result["buyerEmail"] = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']['user']["email"];
            $result["buyerFullName"] = "{$_SESSION[URL_ROOT][CONTROLLER]['logged_account']['user']["nombre"]} {$_SESSION[URL_ROOT][CONTROLLER]['logged_account']['user']["apellido"]}";

            $result["test"] = 1; //testing
            $result["responseUrl"] = URL_ROOT."panel-paciente/";
            $result["confirmationUrl"] = URL_ROOT. "ipn_payu.php";

            return $result;

        }

        /**
         *  Genera una firma para enviar pago a payu encriptando con md5 el string: apiKey~merchantId~referenceCode~amount~currency
         *  @param array $request
         *  @return string
         */
        public function getSignature($request){

            $amount = round($request["amount"], 2);

            $signature = "{$this->apiKey_payu}~{$this->merchantId_payu}~{$request["referenceCode"]}~{$request["amount"]}~{$request["currency"]}";

            return md5($signature);

        }

        /**
         *  Valida la firma que llega al IPN
         *  @param array $request
         *  @return boolean
         */
        public function validateSignature($request){
          
            //arreglamos el parametro value para compatibilizar
            //$new_value = rtrim($request["value"], "0");
            //substr("abcdef", -1);    // devuelve "f"
            //substr("abcdef", 0, -1);  // devuelve "abcde"

            $last = substr($request["value"], -1);
            if($last == 0){//borrar
                $new_value = substr($request["value"], 0, -1);
            }else{
                $new_value = $request["value"];
            }

            //armamos una signature
            $signature = md5("{$this->apiKey_payu}~{$request["merchant_id"]}~{$request["reference_sale"]}~{$new_value}~{$request["currency"]}~{$request["state_pol"]}");
            
            //comparamos nuestra signature con la sign recibida
            if($request["sign"] == $signature){
                $rdo = 1;
            } else{
                $rdo = 0;
            }
                
            return $rdo;

        }

        public function processNotificationPayU($request){
            
            //valido lo que llego
            $valido = $this->validateSignature($request);
            
            if(!$valido){
                $myFile = path_files("ipn_log_payu_detailed.txt");
                $fh = fopen($myFile, 'a');
                fwrite($fh, "------- CANCELADO ------- \n");
                fwrite($fh, date("Y-m-d H:i:s") . "\n");
                fwrite($fh, print_r($this->request, true));
                fwrite($fh, "------------------------- \n");
                fclose($fh);

                return false;
            }

            //obtengo la operación que me está notificando
            $orderId = explode("=", $request["reference_sale"]);
            $pago["order_id"] = $orderId[1];
            $pago["total_paid_amount"] = $request["value"];
          
            //si state_pol = 4 la operación está aprobada
            if($request["state_pol"] == 4){
                //proceso el pago    
                switch ($orderId[0]){
                    case "c": 
                        $ManagerCompraCredito = $this->getManager("ManagerCompraCredito");
                        $rdo = $ManagerCompraCredito->procesarPago($pago);
                        break;
                }                
                            
                return true;
            }else{
                return false;
            }
        }

        /**
         * [createOneTimePayment description]
         * @param  [type] $request [description]
         * @return [type]          [description]
         */
        public function createOneTimePaymentStripe($request){
            // Set your secret key: remember to change this to your live secret key in production
            // See your keys here: https://dashboard.stripe.com/account/apikeys
            \Stripe\Stripe::setApiKey($this->apiKeySecret_stripe);

            $data = [
                "payment_method_types" => ["card"],
                "customer_email" => $request["email"],
                "client_reference_id" => "c={$request["idcompra_credito"]}",
                "line_items" => [[
                    "name" => "Achat de crédit",
                    "description" => "Achat de crédit au DoctorPlus",
                    "images" => [URL_ROOT."mails/logo.jpg"],
                    "amount" => $request["monto"] * 100,
                    "currency" => "eur",
                    "quantity" => 1,
                ]],
                "locale" => "fr",
                "success_url" => URL_ROOT."panel-paciente/purchase-ok.html",
                "cancel_url" => URL_ROOT."panel-paciente/purchase-ko.html",
            ];

            //$this->print_r($data);

            $session = \Stripe\Checkout\Session::create($data);
            return $session["id"];
        }

        /**
         * [handleCheckoutSessionStripe description]
         * @param  [type] $session [description]
         * @return [type]          [description]
         */
        public function handleCheckoutSessionStripe($session){
            //valido lo que llego
            $valido = true;
            
            if(empty($valido)){
                $myFile = path_files("ipn_log_stripe_detailed.txt");
                $fh = fopen($myFile, 'a');
                fwrite($fh, "------- CANCELADO ------- \n");
                fwrite($fh, date("Y-m-d H:i:s") . "\n");
                fwrite($fh, print_r($session, true));
                fwrite($fh, "------------------------- \n");
                fclose($fh);

                return false;
            }

            //obtengo la operación que me está notificando
            $orderId = explode("=", $session->client_reference_id);
                      
            //proceso el pago    
            switch ($orderId[0]){
                case "c": 
                    //inicializo el pago
                    $pago["order_id"] = $orderId[1];
                    $pago["total_paid_amount"] = $session->display_items[0]->amount/100;
                    
                    //proceso el pago
                    $ManagerCompraCredito = $this->getManager("ManagerCompraCredito");
                    $rdo = $ManagerCompraCredito->procesarPago($pago);
                    
                    $log = "Compra de credito cliente -> [{$rdo}]";
                    break;
                case "d":
                    //inicializo la suscripcion
                    $reqSub = [
                        "idsuscripcion"=> $orderId[1],
                        "idsuscripcion_stripe"=>$session->subscription
                    ];

                    $ManagerSuscripcionPremium = $this->getManager("ManagerSuscripcionPremium");
                    $rdo = $ManagerSuscripcionPremium->activarSuscripcionStripe($reqSub);
                    
                    // <-- LOG
                    $log["data"] = "confirmation choice subscription";
                    $log["page"] = "Account detail";          
                    $log["action"] = "val"; //"val" "vis" "del"
                    $log["purpose"] = "Subscription";

                    $ManagerLog = $this->getManager("ManagerLog");
                    $ManagerLog->track($log);

                    // <--
                    $log = "Suscripcion premium profesional -> [{$rdo}]";
                    break;
            }

            $myFile = path_files("ipn_log_stripe_detailed.txt");
            $fh = fopen($myFile, 'a');
            fwrite($fh, "------" . date("Y-m-d H:i:s") . "-------" . PHP_EOL);
            fwrite($fh, $log . PHP_EOL);
            fwrite($fh, print_r($session, true) . PHP_EOL);
            fwrite($fh, "-------------------------" . PHP_EOL);
            fclose($fh); 

            return $rdo;
        }

        /**
         * [createOneTimePayment description]
         * @param  [type] $request [description]
         * @return [type]          [description]
         */
        public function createSubscriptionPaymentStripe($request){
            // Set your secret key: remember to change this to your live secret key in production
            // See your keys here: https://dashboard.stripe.com/account/apikeys
            \Stripe\Stripe::setApiKey($this->apiKeySecret_stripe);

            $data = [
                "payment_method_types" => ["card"],
                "customer_email" => $request["email"],
                "client_reference_id" => "d={$request["idsuscripcion"]}",
                "subscription_data" => [
                    "items" => [[
                        "plan" => STRIPE_IDPLAN,
                    ]],
                ],
                "locale" => "fr",
                "success_url" => URL_ROOT."panel-medico/purchase-ok.html",
                "cancel_url" => URL_ROOT."panel-medico/purchase-ko.html",
            ];
            
            //$this->print_r($data);

            $session = \Stripe\Checkout\Session::create($data);
            return $session["id"];
        }

        /**
         * Cancela una suscripcion de stripe
         * @param  string $idsubscription el id de la suscripción EN STRIPE OJO!!!
         * @return [type]
         */
        public function cancelSubscriptionStripe($idsubscription){
            \Stripe\Stripe::setApiKey($this->apiKeySecret_stripe);

            $sub = \Stripe\Subscription::retrieve($idsubscription);
            $rdo = $sub->cancel();
            
            //validación del resultado
            if($rdo->status == "canceled"){//cancelada->OK
                return true;
            }else{//algo fallo
                return false;
            }
        }

    }//END_class