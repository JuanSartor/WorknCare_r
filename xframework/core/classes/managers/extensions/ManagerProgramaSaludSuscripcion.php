<?php

require_once (path_libs_php("stripe-php-7.75.0/init.php"));
/**
 * 	@autor Xinergia
 * 	@version 1.0	02/03/2021
 * 	Manager de Suscripciones al Programa de Salud.
 *
 */

/**
 * Description of ManagerProgramaSaludSuscripcion
 *
 * @author lucas
 */
class ManagerProgramaSaludSuscripcion extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

// Llamamos al constructor del a superclase
        parent::__construct($db, "programa_salud_suscripcion", "idprograma_salud_suscripcion");
//Stripe testing
        $this->apiKeyPublic_stripe = STRIPE_APIKEY_PUBLIC;
        $this->apiKeySecret_stripe = STRIPE_APIKEY_SECRET;
    }

    /**
     * Método que realiza la llamada a la API de Stripe para crear la sucripcion a un producto del Pass bien-être de un cliente empresa (customerID)
     * al contratar un pase de salud una empresa
     * @param type $request
     * @return type
     */
    public function crear_suscripcion($request) {
//chequeamos la existencia del usuario empresa - customerId
        $usuario_empresa = $this->getManager("ManagerUsuarioEmpresa")->getByField("stripe_customerid", $request["customerId"]);
        if ($usuario_empresa["idusuario_empresa"] == "") {
            $this->setMsg(["msg" => "Ha ocurrido un error. Intente nuevamente", "result" => false]);
            return false;
        }
//verificamos si no se generó la suscripcion ya
        $suscripcion_activa = $this->getByField("empresa_idempresa", $usuario_empresa["empresa_idempresa"]);
        if ($suscripcion_activa["idprograma_salud_suscripcion"] != "") {
            $this->setMsg(["msg" => "Su suscripción ya ha sido registrada exitosamente", "suscripcion" => true, "id" => $suscripcion_activa["subscriptionId"], "status" => "active", "result" => true]);
            return true;
        }

//Creamos el registro en la base de datos
        $this->db->StartTrans();
        $record["customerId"] = $request["customerId"];
        $record["client_secret"] = $usuario_empresa["stripe_client_secret"];
        $record["empresa_idempresa"] = $usuario_empresa["empresa_idempresa"];
        $record["priceId"] = $request["priceId"];
        $record["paymentMethodId"] = $request["paymentMethodId"];
        $record["creation_date"] = date("Y-m-d H:i:s");

        $id = parent::insert($record);
        if (!$id) {
            $this->db->FailTrans();
            $this->db->CompleteTrans();
            $this->setMsg(["msg" => "Ha ocurrido un error. Intente nuevamente", "result" => false]);
            return false;
        }

        $stripe = new \Stripe\StripeClient($this->apiKeySecret_stripe);

        $payment_method = $stripe->paymentMethods->retrieve($request["paymentMethodId"]);
        $payment_method->attach(['customer' => $request["customerId"],]);



// Set the default payment method on the customer
        $stripe->customers->update($request["customerId"], [
            'invoice_settings' => [
                'default_payment_method' => $request["paymentMethodId"]
            ]
        ]);
        $empresa = $this->getManager("ManagerEmpresa")->get($usuario_empresa["empresa_idempresa"]);
        try {
            //verificamos si tiene un cupon de descuento y lo asociamos
            if ($empresa["cupon_descuento"] != "") {
                $cupon_descuento = $this->getManager("ManagerProgramaSaludCupon")->getByField("codigo_cupon", $empresa["cupon_descuento"]);
            }
            // Create the subscription
            $subscription = $stripe->subscriptions->create([
                'customer' => $request["customerId"],
                'items' => [
                    [
                        'price' => $request["priceId"],
                    ],
                ],
                'coupon' => $cupon_descuento["stripe_cupon_id"],
                'expand' => ['latest_invoice.payment_intent'],
                    ], [
                'idempotency_key' => sha1("susc_" . $id)
            ]);
        } catch (\Stripe\Exception\ApiErrorException $e) {
            $this->db->FailTrans();
            $this->db->CompleteTrans();
            return $this->setMsg(["msg" => "Ha ocurrido un error. Intente nuevamente", "result" => false, "err" => $e->getMessage()]);
        } catch (\Stripe\Exception $e) {
            $this->db->FailTrans();
            $this->db->CompleteTrans();
            return $this->setMsg(["msg" => "Ha ocurrido un error. Intente nuevamente", "result" => false, "err" => $e->getMessage()]);
        }
        if ($subscription && $subscription["id"] != "" && $subscription["status"] == "active" && $subscription["items"]["data"][0]["object"] == "subscription_item" && $subscription["items"]["data"][0]["id"] !== "") {

            $record2["productId"] = $subscription["items"]["data"][0]["plan"]["product"];
            $record2["subscriptionId"] = $subscription["id"];
            $record2["subscription_item_id"] = $subscription["items"]["data"][0]["id"];
            $upd = parent::update($record2, $id);
        }

        if (!$upd) {
            $this->db->FailTrans();
            $this->db->CompleteTrans();
            $this->setMsg(["msg" => "Ha ocurrido un error. Intente nuevamente", "result" => false]);
            return false;
        }

        //chequeamos si la empresa es suscripcion particular, contamos el uso en la suscripcion de stripe
        if ($empresa["tipo_cuenta"] == 2) {
            $reporte_stripe = $this->reportar_beneficiarios($empresa["idempresa"]);
            if (!$reporte_stripe) {
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                $this->setMsg(["msg" => "Error, no se pudo actualizar el registro", "result" => false]);
                return false;
            }
        }

        $subscription["result"] = true;
        $this->db->CompleteTrans();
        $this->setMsg($subscription);
        return true;
    }

    /**
     * Método que registra la sucripcion a un pack del Pass bien-être de una obra social (customerID)
     * @param type $request
     * @return type
     */
    public function crear_suscripcion_pack($request) {

        //chequeamos la existencia del usuario empresa - customerId
        $usuario_empresa = $this->getManager("ManagerUsuarioEmpresa")->getByField("stripe_customerid", $request["customerId"]);
        if ($usuario_empresa["idusuario_empresa"] == "") {
            $this->setMsg(["msg" => "Ha ocurrido un error. Intente nuevamente", "result" => false]);
            return false;
        }
        //verificamos si no se generó la suscripcion ya
        $suscripcion_activa = $this->getByField("empresa_idempresa", $usuario_empresa["empresa_idempresa"]);
        if ($suscripcion_activa["idprograma_salud_suscripcion"] != "") {
            $this->setMsg(["msg" => "Su suscripción ya ha sido registrada exitosamente", "suscripcion" => true, "id" => $suscripcion_activa["idprograma_salud_suscripcion"], "result" => true]);
            return true;
        }
        //obtenemos el pack comprado
        $empresa = $this->getManager("ManagerEmpresa")->get($usuario_empresa["empresa_idempresa"]);
        // si es un plan free debo crear la suscripcion para el plan seleccionado
        if ($empresa["plan_idplan"] == '21' || $empresa["plan_idplan"] == '22' || $empresa["plan_idplan"] == '23') {
            $plan = $this->getManager("ManagerProgramaSaludPlan")->get($empresa["plan_idplan_siguiente"]);
        } else {
            $plan = $this->getManager("ManagerProgramaSaludPlan")->get($empresa["plan_idplan"]);
        }
        //verificamos si tiene un cupon de descuento y lo aplicamos al invoice
        if ($empresa["cupon_descuento"] != "") {
            $cupon_valido = $this->getManager("ManagerProgramaSaludCupon")->getByFieldArray(["codigo_cupon", "activo"], [$empresa["cupon_descuento"], 1]);
        }

        //Creamos el registro en la base de datos
        $this->db->StartTrans();
        $record["customerId"] = $usuario_empresa["stripe_customerid"];
        $record["empresa_idempresa"] = $usuario_empresa["empresa_idempresa"];
        $record["priceId"] = $plan["stripe_priceid"];
        $record["creation_date"] = date("Y-m-d H:i:s");
        $record["pack"] = 1;
        $record["pack_pago_pendiente"] = 1;

        $id = parent::insert($record);
        if (!$id) {
            $this->db->FailTrans();
            $this->db->CompleteTrans();
            $this->setMsg(["msg" => "Ha ocurrido un error. Intente nuevamente", "result" => false]);
            return false;
        }
        try {
            //creamos el invoice en stripe
            $stripe = new \Stripe\StripeClient($this->apiKeySecret_stripe);
            $invoice_item = $stripe->invoiceItems->create([
                'customer' => $usuario_empresa["stripe_customerid"],
                'price' => $plan["stripe_priceid"],
                'quantity' => (int) $empresa["cant_empleados"],
            ]);
            $invoice_item_id = $invoice_item->id;

            if (!$invoice_item_id) {
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                $this->setMsg(["msg" => "Ha ocurrido un error. Intente nuevamente", "result" => false]);
                return false;
            }
            $upd_invoice_item_id = parent::update(["invoiceItemId" => $invoice_item_id], $id);
            if (!$upd_invoice_item_id) {
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                $this->setMsg(["msg" => "Ha ocurrido un error. Intente nuevamente", "result" => false]);
                return false;
            }


            $record_invoice = [
                'customer' => $usuario_empresa["stripe_customerid"],
                'collection_method' => 'send_invoice',
                'due_date' => time() + (7 * 24 * 60 * 60),
                    //'discounts' => [["coupon" => $cupon_valido["stripe_cupon_id"]]]
            ];
            //asigamos el descuento al invoice si hay cupon
            if ($cupon_valido) {
                $record_invoice["discounts"] = [["coupon" => $cupon_valido["stripe_cupon_id"]]];
            }
            //creamos el invoice
            $invoice = $stripe->invoices->create($record_invoice);

            //enviamos el invoice por mail al usuario
            $invoice->sendInvoice($invoice->id);

            //recuperamos el client_secret del payment intent para crear el boton de pago
            $paymentIntent = $stripe->paymentIntents->retrieve($invoice->payment_intent);
            $client_secret = $paymentIntent->client_secret;

            if (!$client_secret) {
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                $this->setMsg(["msg" => "Ha ocurrido un error. Intente nuevamente", "result" => false]);
                return false;
            }
            $upd_client_secret = parent::update(["client_secret" => $client_secret, "invoiceId" => $invoice->id], $id);
            if (!$upd_client_secret) {
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                $this->setMsg(["msg" => "Ha ocurrido un error. Intente nuevamente", "result" => false]);
                return false;
            }


            $this->db->CompleteTrans();
            $this->setMsg(["msg" => "Su suscripción ya ha sido registrada exitosamente", "suscripcion" => true, "id" => $id, "result" => true]);
            return true;
        } catch (\Stripe\Exception\ApiErrorException $e) {
            $this->db->FailTrans();
            $this->db->CompleteTrans();
            $this->setMsg(["msg" => "Ha ocurrido un error. Intente nuevamente", "result" => false, "e" => $e]);
            return false;
        } catch (\Stripe\Exception $e) {
            $this->db->FailTrans();
            $this->db->CompleteTrans();
            $this->setMsg(["msg" => "Ha ocurrido un error. Intente nuevamente", "result" => false, "e" => $e]);
            return false;
        }
        $this->db->FailTrans();
        $this->db->CompleteTrans();
        $this->setMsg(["msg" => "Ha ocurrido un error. Intente nuevamente", "result" => false]);
        return false;
    }

    /**
     * Método que registra una nueva compra de un pack del Pass bien-être de una obra social (customerID)
     * al contratar un pase de salud
     * @param type $request
     * @return type
     */
    public function nueva_compra_suscripcion_pack($request) {

        if ((int) $request["cant_packs"] > 0) {
            $idempresa = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idempresa"];
            //verificamos si no se generó la recompra  ya
            $suscripcion_original = $this->getByField("empresa_idempresa", $idempresa);

            //verificamos si no se generó la recompra  ya
            $suscripcion_activa = $this->getByFieldArray(["empresa_idempresa", "recompra"], [$idempresa, 1]);
            if ($suscripcion_activa["idprograma_salud_suscripcion"] != "" && $suscripcion_activa["pack_pago_pendiente"] == 1) {
                $this->setMsg(["msg" => "Su suscripción ya ha sido registrada exitosamente", "suscripcion" => true, "id" => $suscripcion_activa["idprograma_salud_suscripcion"], "result" => true]);
                return true;
            }
            //obtenemos el pack comprado
            $empresa = $this->getManager("ManagerEmpresa")->get($idempresa);
            $plan = $this->getManager("ManagerProgramaSaludPlan")->get($empresa["plan_idplan"]);
            //verificamos si tiene un cupon de descuento y lo aplicamos al invoice
            if ($empresa["cupon_descuento"] != "") {
                $cupon_valido = $this->getManager("ManagerProgramaSaludCupon")->getByFieldArray(["codigo_cupon", "activo"], [$empresa["cupon_descuento"], 1]);
            }

            //Creamos el registro en la base de datos
            $this->db->StartTrans();
            $record["customerId"] = $suscripcion_original["customerId"];
            $record["empresa_idempresa"] = $idempresa;
            $record["priceId"] = $plan["stripe_priceid"];
            $record["creation_date"] = date("Y-m-d H:i:s");
            $record["pack"] = 1;
            $record["pack_pago_pendiente"] = 1;
            $record["recompra"] = 1;
            $record["pack_recompra"] = $request["cant_packs"];


            $id = parent::insert($record);
            if (!$id) {
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                $this->setMsg(["msg" => "Ha ocurrido un error. Intente nuevamente", "result" => false]);
                return false;
            }
            try {
                //creamos el invoice en stripe
                $stripe = new \Stripe\StripeClient($this->apiKeySecret_stripe);
                $invoice_item = $stripe->invoiceItems->create([
                    'customer' => $record["customerId"],
                    'price' => $plan["stripe_priceid"],
                    'quantity' => (int) $request["cant_packs"],
                ]);
                $invoice_item_id = $invoice_item->id;

                if (!$invoice_item_id) {
                    $this->db->FailTrans();
                    $this->db->CompleteTrans();
                    $this->setMsg(["msg" => "Ha ocurrido un error. Intente nuevamente", "result" => false]);
                    return false;
                }
                $upd_invoice_item_id = parent::update(["invoiceItemId" => $invoice_item_id], $id);
                if (!$upd_invoice_item_id) {
                    $this->db->FailTrans();
                    $this->db->CompleteTrans();
                    $this->setMsg(["msg" => "Ha ocurrido un error. Intente nuevamente", "result" => false]);
                    return false;
                }


                $record_invoice = [
                    'customer' => $record["customerId"],
                    'collection_method' => 'send_invoice',
                    'due_date' => time() + (7 * 24 * 60 * 60),
                        //'discounts' => [["coupon" => $cupon_valido["stripe_cupon_id"]]]
                ];
                //asigamos el descuento al invoice si hay cupon
                if ($cupon_valido) {
                    $record_invoice["discounts"] = [["coupon" => $cupon_valido["stripe_cupon_id"]]];
                }
                //creamos el invoice
                $invoice = $stripe->invoices->create($record_invoice);

                //enviamos el invoice por mail al usuario
                $invoice->sendInvoice($invoice->id);

                //recuperamos el client_secret del payment intent para crear el boton de pago
                $paymentIntent = $stripe->paymentIntents->retrieve($invoice->payment_intent);
                $client_secret = $paymentIntent->client_secret;

                if (!$client_secret) {
                    $this->db->FailTrans();
                    $this->db->CompleteTrans();
                    $this->setMsg(["msg" => "Ha ocurrido un error. Intente nuevamente", "result" => false]);
                    return false;
                }
                $upd_client_secret = parent::update(["client_secret" => $client_secret, "invoiceId" => $invoice->id], $id);
                if (!$upd_client_secret) {
                    $this->db->FailTrans();
                    $this->db->CompleteTrans();
                    $this->setMsg(["msg" => "Ha ocurrido un error. Intente nuevamente", "result" => false]);
                    return false;
                }


                $this->db->CompleteTrans();
                $this->setMsg(["msg" => "Su suscripción ya ha sido registrada exitosamente", "suscripcion" => true, "id" => $id, "result" => true]);
                return true;
            } catch (\Stripe\Exception\ApiErrorException $e) {
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                $this->setMsg(["msg" => "Ha ocurrido un error. Intente nuevamente", "result" => false, "e" => $e]);
                return false;
            } catch (\Stripe\Exception $e) {
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                $this->setMsg(["msg" => "Ha ocurrido un error. Intente nuevamente", "result" => false, "e" => $e]);
                return false;
            }
            $this->db->FailTrans();
            $this->db->CompleteTrans();
            $this->setMsg(["msg" => "Ha ocurrido un error. Intente nuevamente", "result" => false]);
            return false;
        } else {
            $this->setMsg(["msg" => "Ha ocurrido un error. Intente nuevamente", "result" => false]);
            return false;
        }
    }

    /**
     * Metodo que activa una recompra de nuevos packs de planes para obras sociales cuando se procesa el pago con exito
     * @param type $request
     */
    public function activar_nueva_compra_suscripcion_pack($request) {

        //verificamos que exista una suscripcion
        $suscripcion_pendiente = $this->get($request["idprograma_salud_suscripcion"]);
        if (!$suscripcion_pendiente) {
            $this->setMsg(["msg" => "Ha ocurrido un error. Intente nuevamente", "result" => false]);
            return false;
        }
        if (CONTROLLER == "empresa") {
            $idempresa = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idempresa"];
            if ($suscripcion_pendiente["empresa_idempresa"] != $idempresa) {
                $this->setMsg(["msg" => "Ha ocurrido un error. Intente nuevamente", "result" => false]);
                return false;
            }
        }
        //verificamos si ya se ha activado
        if ($suscripcion_pendiente["subscriptionId"] != "" && $suscripcion_pendiente["paymentMethodId"] != "" && $suscripcion_pendiente["pack_pago_pendiente"] == 2) {
            $this->setMsg(["msg" => "Su suscripción ya ha sido registrada exitosamente", "suscripcion" => true, "id" => $suscripcion_pendiente["idprograma_salud_suscripcion"], "result" => true]);
            return true;
        }

        //Creamos el registro en la base de datos
        $this->db->StartTrans();

        $record["paymentMethodId"] = $request["paymentMethodId"];
        $record["pack_pago_pendiente"] = 2;


        $id = parent::update($record, $suscripcion_pendiente["idprograma_salud_suscripcion"]);

        //actualizamos la cantidad de beneficiarios disponibles para la obra social
        $ManagerEmpresa = $this->getManager("ManagerEmpresa");
        $empresa = $ManagerEmpresa->get($suscripcion_pendiente["empresa_idempresa"]);
        //sumamos ca cantidad de la recompra de pack, mas los beneficiarios iniciales de la OS
        $record["cant_empleados"] = (int) $empresa["cant_empleados"] + (int) $suscripcion_pendiente["pack_recompra"];
        $upd = $ManagerEmpresa->update($record, $empresa["idempresa"]);
        if (!$id || !$upd) {
            $this->db->FailTrans();
            $this->db->CompleteTrans();
            $this->setMsg(["msg" => "Ha ocurrido un error. Intente nuevamente", "result" => false]);
            return false;
        }
        $this->db->CompleteTrans();
        $this->setMsg(["msg" => "Su suscripción ya ha sido registrada exitosamente", "suscripcion" => true, "id" => $id, "result" => true]);
        return true;
    }

    /**
     *  Metodo que activa el pago por factura de recompra de packs, se debe verificar del lado
     *  admin 
     * @param type $request
     */
    public function activar_compra_suscripcion_pack_factura($request) {

        if ((int) $request["id"] > 0) {
            $idempresa = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idempresa"];
            //verificamos que exista pendiente la compra de mas paquetes
            $suscripcion = parent::get($request["id"]);

            if ($suscripcion["pack_pago_pendiente"] != 1 || $suscripcion["empresa_idempresa"] != $idempresa || $suscripcion["invoiceId"] == "") {
                $this->setMsg(["msg" => "Ha ocurrido un error. Intente nuevamente", "result" => false]);
                return true;
            }

            //verificamos si ya se ha activado
            if ($suscripcion["subscriptionId"] != "" && $suscripcion["paymentMethodId"] != "" && $suscripcion["pack_pago_pendiente"] == 2) {
                $this->setMsg(["msg" => "Su suscripción ya ha sido registrada exitosamente", "suscripcion" => true, "id" => $suscripcion["idprograma_salud_suscripcion"], "result" => true]);
                return true;
            }


            //Creamos el registro en la base de datos
            $this->db->StartTrans();

            $record["paymentMethodId"] = $request["paymentMethodId"];
            $record["pack_pago_pendiente"] = "8";
            $record["fecha_envio_factura"] = date("Y-m-d");
// actualizo los datos en la bd 
            parent::update($record, $suscripcion["idprograma_salud_suscripcion"]);

            // genero la factura
            $stripe = new \Stripe\StripeClient($this->apiKeySecret_stripe);
            $facturas = $stripe->invoices->retrieve($suscripcion["invoiceId"]);

            $data_variables["empresa"] = $this->getManager("ManagerEmpresa")->get($idempresa);
            $data_variables["monto"] = $facturas["amount_due"] / 100;
            $data_variables["factura"] = $facturas;
            $data_variables["programaSaludSus"] = $suscripcion;
            $data_variables["plan"] = $this->getManager("ManagerProgramaSaludPlan")->getByField("stripe_priceid", $suscripcion["priceId"]);

            $contratante = $this->getManager("ManagerUsuarioEmpresa")->getByFieldArray(["contratante", "empresa_idempresa"], [1, $idempresa]);
            $data_variables["contratante"] = $contratante;
            if (!file_exists(path_entity_files("facturas_pagopackmanual_recompra/{$idempresa}"))) {
                mkdir(path_entity_files("facturas_pagopackmanual_recompra/{$idempresa}"), 0777, true);
            }
            $data_variables["file"] = path_files("entities/facturas_pagopackmanual_recompra/{$idempresa}/fac-pay-{$suscripcion["idprograma_salud_suscripcion"]}.pdf");

            $PDFFactura = new PDFFacturaTransferenciaPagoPack();
            $PDFFactura->getPDF($data_variables);



            // cancelo el pago por stripe 
            try {


                //cancelamos el invoice
                $invoice = $stripe->invoices->voidInvoice($suscripcion["invoiceId"]);
                if ($invoice->status != "void") {
                    $this->db->FailTrans();
                    $this->db->CompleteTrans();
                    $this->setMsg(["msg" => "Ha ocurrido un error. Intente nuevamente", "result" => false]);
                    return false;
                }

                $this->db->CompleteTrans();
                $this->setMsg(["msg" => "Su compra de paquetes ha sido solicitada correctamente", "result" => true]);
                return true;
            } catch (\Stripe\Exception\ApiErrorException $e) {
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                $this->setMsg(["msg" => "Ha ocurrido un error. Intente nuevamente", "result" => false, "e" => $e]);
                return false;
            } catch (\Stripe\Exception $e) {
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                $this->setMsg(["msg" => "Ha ocurrido un error. Intente nuevamente", "result" => false, "e" => $e]);
                return false;
            }
            $this->db->FailTrans();
            $this->db->CompleteTrans();
            $this->setMsg(["msg" => "Ha ocurrido un error. Intente nuevamente", "result" => false]);
            return false;
        } else {
            $this->setMsg(["msg" => "Ha ocurrido un error. Intente nuevamente", "result" => false]);
            return false;
        }
    }

    /**
     * Método que elimina la nueva compra de un pack del Pass bien-être de una obra social 
     * @param type $request
     * @return type
     */
    public function cancelar_compra_suscripcion_pack($request) {

        if ((int) $request["id"] > 0) {
            $idempresa = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idempresa"];
            //verificamos que exista pendiente la compra de mas paquetes
            $suscripcion = parent::get($request["id"]);

            if ($suscripcion["pack_pago_pendiente"] != 1 || $suscripcion["empresa_idempresa"] != $idempresa || $suscripcion["invoiceId"] == "") {
                $this->setMsg(["msg" => "Ha ocurrido un error. Intente nuevamente", "result" => false]);
                return true;
            }


            //Creamos el registro en la base de datos
            $this->db->StartTrans();

            $id = parent::delete($request["id"]);
            if (!$id) {
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                $this->setMsg(["msg" => "Ha ocurrido un error. Intente nuevamente", "result" => false]);
                return false;
            }
            try {

                $stripe = new \Stripe\StripeClient($this->apiKeySecret_stripe);
                //cancelamos el invoice
                $invoice = $stripe->invoices->voidInvoice($suscripcion["invoiceId"]);
                if ($invoice->status != "void") {
                    $this->db->FailTrans();
                    $this->db->CompleteTrans();
                    $this->setMsg(["msg" => "Ha ocurrido un error. Intente nuevamente", "result" => false]);
                    return false;
                }

                $this->db->CompleteTrans();
                $this->setMsg(["msg" => "Su compra de paquetes ha sido cancelada exitosamente", "result" => true]);
                return true;
            } catch (\Stripe\Exception\ApiErrorException $e) {
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                $this->setMsg(["msg" => "Ha ocurrido un error. Intente nuevamente", "result" => false, "e" => $e]);
                return false;
            } catch (\Stripe\Exception $e) {
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                $this->setMsg(["msg" => "Ha ocurrido un error. Intente nuevamente", "result" => false, "e" => $e]);
                return false;
            }
            $this->db->FailTrans();
            $this->db->CompleteTrans();
            $this->setMsg(["msg" => "Ha ocurrido un error. Intente nuevamente", "result" => false]);
            return false;
        } else {
            $this->setMsg(["msg" => "Ha ocurrido un error. Intente nuevamente", "result" => false]);
            return false;
        }
    }

    /**
     * Metodo que activa una suscripcion de el pack de planes para obras sociales cuando se procesa el pago con exito
     * @param type $request
     */
    public function activar_suscripcion_pack($request) {
        //chequeamos la existencia del usuario empresa - customerId
        $usuario_empresa = $this->getManager("ManagerUsuarioEmpresa")->getByField("stripe_customerid", $request["customerId"]);
        if ($usuario_empresa["idusuario_empresa"] == "") {
            $this->setMsg(["msg" => "Ha ocurrido un error. Intente nuevamente", "result" => false]);
            return false;
        }
        //verificamos que exista una suscripcion
        $suscripcion_activa = $this->getByField("empresa_idempresa", $usuario_empresa["empresa_idempresa"]);
        if ($suscripcion_activa["idprograma_salud_suscripcion"] == "") {
            $this->setMsg(["msg" => "Ha ocurrido un error. Intente nuevamente", "result" => false]);
            return false;
        }
        //verificamos si ya se ha activado
        if ($suscripcion_activa["subscriptionId"] != "" && $suscripcion_activa["paymentMethodId"] != "" && $suscripcion_activa["pack_pago_pendiente"] == 2) {
            $this->setMsg(["msg" => "Su suscripción ya ha sido registrada exitosamente", "suscripcion" => true, "id" => $suscripcion_activa["idprograma_salud_suscripcion"], "result" => true]);
            return true;
        }

        //Creamos el registro en la base de datos
        $this->db->StartTrans();

        $record["paymentMethodId"] = $request["paymentMethodId"];
        $record["pack_pago_pendiente"] = 2;

        $id = parent::update($record, $suscripcion_activa["idprograma_salud_suscripcion"]);
        if (!$id) {
            $this->db->FailTrans();
            $this->db->CompleteTrans();
            $this->setMsg(["msg" => "Ha ocurrido un error. Intente nuevamente", "result" => false]);
            return false;
        }
        $this->db->CompleteTrans();
        $this->setMsg(["msg" => "Su suscripción ya ha sido registrada exitosamente", "suscripcion" => true, "id" => $id, "result" => true]);
        return true;
    }

    /**
     * Método que realiza la llamada a la API de Stripe para crear un cliente empresa que va a contratar el Pass bien-être 
     * @param type $request
     * @return type array conteniendo customerID
     */
    public function crear_cliente($request) {


        $stripe = new \Stripe\StripeClient($this->apiKeySecret_stripe);
        try {
//chequeo si ya existe el cliente 
            $customers = $stripe->customers->all(['email' => $request["email"],
                'limit' => 1,
            ]);
//si existe lo devolvemos
            if ($customers["data"] && $customers["data"][0]["id"] != "") {
                $customer = $customers["data"][0];
            } else {
//sino creamos uno nuevo

                $customer = $stripe->customers->create([
                    'email' => $request["email"],
                    'name' => $request["name"],
                    'description' => "{$request["description"]}"
                        ], [
                    'idempotency_key' => $request["idempotency_key"]
                ]);
            }
        } catch (\Stripe\Exception\ApiErrorException $e) {
            $this->db->FailTrans();
            $this->db->CompleteTrans();
            //echo $e;
            $this->setMsg(["msg" => "Ha ocurrido un error. Intente nuevamente", "result" => false, "err" => $e->getMessage()]);
            return false;
        } catch (\Stripe\Exception $e) {
            //echo $e;
            $this->db->FailTrans();
            $this->db->CompleteTrans();
            $this->setMsg(["msg" => "Ha ocurrido un error. Intente nuevamente", "result" => false, "err" => $e->getMessage()]);
            return false;
        }
        //verificamos si ya tiene una suscripcion activa en stripe
        if ($this->verificar_suscripcion_activa($customer)) {
            return ["suscripcion_activa" => true, "result" => false];
        }
        $setup_intent = $this->crear_setup_intent($customer);
        //agregamos el campo client_secret al objeto cliente
        $customer["client_secret"] = $setup_intent->client_secret;

        return $customer;
    }

    /**
     * Método que realiza la llamada astripe para crear un objeto SetupIntent.
     * Este es un objeto que representa la intención de pago y rastrea los pasos para configurar el método de pago del cliente para pagos futuros. 
     * Esto incluye la recopilación del cliente y la verificación de la validez del IBAN.
     * @param type $customer
     * @return type array conteniendo customerID
     */
    public function crear_setup_intent($customer) {


        $stripe = new \Stripe\StripeClient($this->apiKeySecret_stripe);

        $setup_intent = $stripe->setupIntents->create([
            'payment_method_types' => ['sepa_debit'],
            'customer' => $customer["id"],
        ]);

        return $setup_intent;
    }

    /**
     * Método que realiza la llamada astripe para verificar si el usuario ya tiene una suscripcion activa.
     * @param type $customer
     * @return boolean false si hay suscripcion activa
     */
    public function verificar_suscripcion_activa($customer) {
        $suscripcion_exist = parent::getByField("customerId", $customer["id"]);
        if ($suscripcion_exist && $suscripcion_exist["subscriptionId"] != "" && $suscripcion_exist["pack"] == "0") {
            //verificamos si tiene un suscripcion activa el usuario
            try {
                $stripe = new \Stripe\StripeClient($this->apiKeySecret_stripe);
                $subscription = $stripe->subscriptions->retrieve(
                        $suscripcion_exist["subscriptionId"], []
                );
                if ($subscription["status"] == "active") {
                    return true;
                } else {
                    return false;
                }
            } catch (\Stripe\Exception\ApiErrorException $e) {
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                //echo $e;
                $this->setMsg(["msg" => "Ha ocurrido un error. Intente nuevamente", "result" => false, "err" => $e->getMessage()]);
                return false;
            } catch (\Stripe\Exception $e) {
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                //echo $e;
                $this->setMsg(["msg" => "Ha ocurrido un error. Intente nuevamente", "result" => false, "err" => $e->getMessage()]);
                return false;
            }
        }


        return false;
    }

    /**
     * Metodo encargado de enviar a la Stripe la cantidad de beneficiarios registrados a una suscripcion del plan empresa
     * @param type $idempresa
     */
    public function reportar_beneficiarios($idempresa) {
        $beneficiarios_registrados = $this->db->GetRow("SELECT COUNT(idpaciente_empresa) as cant FROM paciente_empresa WHERE facturar=1 AND empresa_idempresa={$idempresa}");

        $stripe = new \Stripe\StripeClient($this->apiKeySecret_stripe);

        $suscripcion = parent::getByField("empresa_idempresa", $idempresa);
        if (!$suscripcion) {
            $this->setMsg(["msg" => "Ha ocurrido un error. Intente nuevamente", "result" => false]);
            return false;
        }

        $subscription_item_id = $suscripcion["subscription_item_id"];

// cantidad de uso de la suscripcion  
        $usage_quantity = intval($beneficiarios_registrados["cant"]);
// La clave idempotency_key  permite volver a intentar esta llamada de registro de uso si falla.
        $idempotency_key = $suscripcion["idprograma_salud_suscripcion"] . "-" . date("Y-m-d_H:i:s");

        try {
            $usage_record = $stripe->subscriptionItems->createUsageRecord(
                    $subscription_item_id, [
                'quantity' => $usage_quantity,
                'action' => 'set',
                    ], [
                'idempotency_key' => $idempotency_key,
                    ]
            );

//            echo "<br>";
//            echo "Exito al informar reporte de uso de la suscripcion: $subscription_item_id con  idempotency_key $idempotency_key: $usage_record";
//            echo "_____________________________________________________________________________________________________________";
//            echo "<br>";
            return true;
        } catch (\Stripe\Exception\ApiErrorException $error) {
//            echo "<br>";
//            echo "Error al informar el resporte de uso de la suscripcion: $subscription_item_id con  idempotency_key $idempotency_key: $error";
//            echo "_____________________________________________________________________________________________________________";
//            echo "<br>";
            return false;
        }
    }

    /**
     * Método que deveulve el listado de facturas generadas por Stripe a cobrar la empresa por los beneficiarios registrados en el plan empresa
     * @param type $idempresa
     */
    public function get_facturas($idempresa, $bandAdmin = null) {
        $suscripcion = parent::getByField("empresa_idempresa", $idempresa);

        if ($suscripcion["customerId"] != "") {

            try {
                $stripe = new \Stripe\StripeClient($this->apiKeySecret_stripe);
                $facturas = $stripe->invoices->all(['customer' => $suscripcion["customerId"]]);
            } catch (\Stripe\Exception\ApiErrorException $e) {
                $this->setMsg(["msg" => "Ha ocurrido un error. Intente nuevamente", "result" => false, "err" => $e->getMessage()]);
                return false;
            } catch (\Stripe\Exception $e) {
                $this->setMsg(["msg" => "Ha ocurrido un error. Intente nuevamente", "result" => false, "err" => $e->getMessage()]);
                return false;
            }
        }

// query y logica para obtener las recompra de pack pagadas por transferencia
        // asi filtro y no muestro las facturas en estado anulado que genera stripe
        $query = new AbstractSql();
        $query->setSelect("invoiceId");
        $query->setFrom("programa_salud_suscripcion pss");
        $query->setWhere("pss.fecha_envio_factura!=''");
        $query->addAnd("pss.recompra = 1");
        $query->addAnd("pss.empresa_idempresa = $idempresa");
        $data = $this->getList($query);

        $arrayIdsExcluidos = Array();
        $k = 0;
        foreach ($data as $id) {
            $arrayIdsExcluidos[$k] = $id["invoiceId"];
            $k++;
        }


        foreach ($facturas as $factura) {

            // eso lo hago porque cuando es pago por transferencia, se genera una factura
            // en stripe pero figura como anulada entonces no tengo q mostrar esa
            // sino la q creamos nosotros

            if (in_array($factura["id"], $arrayIdsExcluidos)) {
                //  print($factura["id"]);
                $factura["visible"] = 0;
            }

            // esto tuve que agregar xq sino las facturas que son por transferencia siempre se ven
            // del lado empresa como pendientes, lo agrego Juan el 14-09-2022
            $factura["suscripcion"] = parent::getByField("invoiceId", $factura["id"]);
        }

        return $facturas;
    }

    /**
     * Método que deveulve el listado de metodos de pago cargados en Stripe a cobrar la empresa por los beneficiarios registrados en el plan empresa
     * @param type $idempresa
     */
    public function get_metodo_pago($idempresa) {
        $suscripcion = parent::getByField("empresa_idempresa", $idempresa);
        if ($suscripcion["paymentMethodId"] != "") {
            try {
                $stripe = new \Stripe\StripeClient($this->apiKeySecret_stripe);

                $metodo_pago = $stripe->paymentMethods->retrieve(
                        $suscripcion["paymentMethodId"], []
                );
                return $metodo_pago;
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
     * Método que actualiza en stripe la direccion de facturacion para una empresa
     * @param type $idempresa
     */
    public function actualizar_direccion_facturas($idempresa, $request) {
        $suscripcion = parent::getByField("empresa_idempresa", $idempresa);

        if ($suscripcion["customerId"] != "") {
            try {
                $stripe = new \Stripe\StripeClient($this->apiKeySecret_stripe);

//creamos el array de datos a actualizar en stripe
                $direccion["line1"] = $request["direccion"];
                $direccion["country"] = $request["pais_iso"];
                $direccion["city"] = $request["ciudad"];
                $direccion["postal_code"] = $request["codigo_postal"];
                if ($request["tipo_cuenta"] == 1) {
                    $nombre = "{$request["empresa"]} - SIREN/SIRET: {$request["siren"]}";
                } else {
                    $nombre = "{$request["nombre"]} {$request["apellido"]}";
                }

                $upd = $stripe->customers->update(
                        $suscripcion["customerId"], ["name" => $nombre, "description" => $nombre, 'address' => $direccion]);
                return $upd;
            } catch (\Stripe\Exception\ApiErrorException $e) {
                $this->db->FailTrans();
                $this->db->CompleteTrans();

                return $this->setMsg(["msg" => "Ha ocurrido un error. Intente nuevamente", "result" => false, "err" => $e->getMessage()]);
            } catch (\Stripe\Exception $e) {
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                return $this->setMsg(["msg" => "Ha ocurrido un error. Intente nuevamente", "result" => false, "err" => $e->getMessage()]);
            }
        }
        return false;
    }

    /**
     * Cron encargado de verificar las cancelaciones de renovacion de suscripciones al Pass bien-être y enviar la cancelaciona la api de stripe
     * @param type $idempresa
     */
    public function cron_actualizar_suscripcion() {
        $query = new AbstractSql();
        $query->setSelect("*");
        $query->setFrom("programa_salud_suscripcion pss inner join empresa e on (e.idempresa=pss.empresa_idempresa)");
        $query->setWhere("SYSDATE() > e.fecha_vencimiento AND cancelar_suscripcion<>2");

        $data = $this->getList($query);

        foreach ($data as $suscripcion) {
            if ($suscripcion["cancelar_suscripcion"] == 1 || $suscripcion["obra_social"] == 1) {
                $result = $this->cancelar_suscripcion($suscripcion);

                if ($result) {
                    // obtengo la lista de ids de idpaciente de beneficiarios de la empresa

                    $ids = $this->getManager("ManagerPacienteEmpresa")->getListIdsBeneficiarios($suscripcion['idempresa']);
                    $cadids = '';
                    foreach ($ids as $elemento) {
                        $cadids = $elemento["paciente_idpaciente"] . ',' . $cadids;
                    }
                    $idsbeneporempresa = substr($cadids, 0, -1);
                    // inserto la fila en historial para recordar los id de los exbeneficiarios
                    // los id son de la tabla paciente es decir idpaciente
                    if ($idsbeneporempresa != '') {
                        $requestInsertHistorial["ids_exbeneficiario"] = $idsbeneporempresa;
                        $requestInsertHistorial["empresa_idempresa"] = $suscripcion['idempresa'];
                        $requestInsertHistorial["hora_registrada"] = date("Y-m-d");
                        $this->getManager("ManagerHistorialExBeneficiarios")->insert($requestInsertHistorial);
                        $manaem = $this->getManager("ManagerPacienteEmpresa");
                        $rdo2 = $manaem->eliminarBeneficiarioEmpresa($suscripcion['idempresa']);
                    }
                }
            }
            if ($suscripcion["cancelar_suscripcion"] == 0) {
                $this->actualizar_suscripcion($suscripcion);
            }
        }
    }

    /**
     * Metodo que cancela una suscripcion de una empresa al Pass bien-être en la plataforma de de Stripe
     * @param type $suscripcion
     * @return boolean
     */
    public function cancelar_suscripcion($suscripcion) {
        // $this->debug();

        if ($suscripcion["subscriptionId"] != "") {

            try {
                $this->db->StartTrans();
                //marcamos la empresa como dada de baja en stripe : cancelar_suscripcion=2
                $manaem = $this->getManager("ManagerEmpresa");
                // $manaem->debug();  
                $upd = $manaem->basic_update(["cancelar_suscripcion" => 2, "plan_idplan" => 22], $suscripcion["empresa_idempresa"]);
                //     $enviar_mail = $this->getManager("ManagerEmpresa")->enviar_mail_cancelar_suscripcion($suscripcion["empresa_idempresa"]);
                //die();
                $enviar_mail = true;
                if ($upd && $enviar_mail) {

                    //si es empresa, no obra social, marcamos cancelada la suscripcion en stripe
                    if ($suscripcion["obra_social"] == 0) {
                        $stripe = new \Stripe\StripeClient($this->apiKeySecret_stripe);
                        $cancel = $stripe->subscriptions->cancel(
                                $suscripcion["subscriptionId"], []
                        );
                        // elimino la suscricion de la tabla programa_salud_suscripcion
                        // porque pasa a un gratuito y la suscripcion vieja ya fue cancelada
                        // sino no me crea otra suscripcion en strip
                        // esto solo para este tipo de plan para los pack no hace falta eliminarla
                        parent::delete($suscripcion["idprograma_salud_suscripcion"]);
                    }

                    $this->setMsg(["msg" => "Se ha cancelado la suscripcion:", "result" => true, "suscripcion" => $cancel]);
                    $this->db->CompleteTrans();
                    //echo $cancel
                    return $cancel;
                } else {
                    $this->db->FailTrans();
                    $this->db->CompleteTrans();
                    $this->setMsg(["msg" => "Ha ocurrido un error. Intente nuevamente", "result" => false]);
                    return false;
                }
            } catch (\Stripe\Exception\ApiErrorException $e) {
                //echo $e;
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                $this->setMsg(["msg" => "Ha ocurrido un error. Intente nuevamente", "result" => false, "err" => $e->getMessage()]);
                return false;
            } catch (\Stripe\Exception $e) {
                //echo $e;
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                $this->setMsg(["msg" => "Ha ocurrido un error. Intente nuevamente", "result" => false, "err" => $e->getMessage()]);
                return false;
            }
        } else {
            $manaem = $this->getManager("ManagerEmpresa");
            $upd = $manaem->basic_update(["cancelar_suscripcion" => 2, "plan_idplan" => 21], $suscripcion["empresa_idempresa"]);
            return $upd;
        }
        return false;
    }

    /**
     * * Metodo que permite al admin cancelar una suscripcion de una empresa al Pass bien-être en la plataforma de de Stripe de forma anticipada
     * @param type $idempresa
     * @return type
     */
    public function cancelar_suscripcion_from_admin($idempresa) {

        $suscripcion = $this->getByField("empresa_idempresa", $idempresa);
        $ManagerEmpresa = $this->getManager("ManagerEmpresa");
        $cancelacion = $this->cancelar_suscripcion($suscripcion);
        $ManagerEmpresa->basic_update(["cancelacion_admin" => 1, "fecha_vencimiento" => date("Y-m-d")], $idempresa);

        return $cancelacion;
    }

    /**
     * Metodo que actualiza el periodo de 12 meses de una suscripcion de una empresa al Pass bien-être 
     * @param type $suscripcion
     * @return boolean
     */
    public function actualizar_suscripcion($suscripcion) {

        if ($suscripcion["subscriptionId"] != "" && $suscripcion["fecha_vencimiento"]) {

            $this->db->StartTrans();
            //suamos 12 meses mas a la fecha de vencimiento
            $record["fecha_vencimiento"] = date("Y-m-d", strtotime('+12 month', strtotime($suscripcion["fecha_vencimiento"])));
            $record["fecha_adhesion"] = date("Y-m-d", strtotime('+12 month', strtotime($suscripcion["fecha_adhesion"])));

            $upd = $this->getManager("ManagerEmpresa")->basic_update($record, $suscripcion["empresa_idempresa"]);
            //renovamos la cantidad de consultas a los beneficiarios
            $upd_pacientes = $this->db->Execute("UPDATE paciente_empresa set cant_consultaexpress=0, cant_videoconsulta=0 where empresa_idempresa={$suscripcion["empresa_idempresa"]} and estado=1");

            if ($upd && $upd_pacientes) {
//                $this->getManager("ManagerEmpresa")->enviar_mail_renovacion_suscripcion($suscripcion["empresa_idempresa"]);
                $this->db->CompleteTrans();
                $this->setMsg(["msg" => "Se ha renovado la suscripcion al Pase de Salud", "result" => true]);
                return true;
            } else {
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                $this->setMsg(["msg" => "Ha ocurrido un error. Intente nuevamente", "result" => false]);
                return false;
            }
        }
        return false;
    }

    /**
     * Metodo que realiza un aumento en el plan contratado por la empresa actualizando a una suscipcion en Stripe con un precio superior
     * @param type $idplan cambio de plan   
     * @param type $idempresa empresa
     * @return type
     */
    public function cambiar_plan_suscripcion($idplan, $idempresa) {
        try {
            $plan = $this->getManager("ManagerProgramaSaludPlan")->get($idplan);
            $suscripcion = parent::getByField("empresa_idempresa", $idempresa);

            $this->db->StartTrans();

            $stripe = new \Stripe\StripeClient($this->apiKeySecret_stripe);
            $subscription = $stripe->subscriptions->retrieve($suscripcion["subscriptionId"]);
            $update_subscription = $stripe->subscriptions->update($suscripcion["subscriptionId"], [
                'cancel_at_period_end' => false,
                'proration_behavior' => 'create_prorations',
                'items' => [
                    [
                        'id' => $subscription->items->data[0]->id,
                        'price' => $plan["stripe_priceid"], //cambio de plan - priceId
                    ],
                ],
            ]);
            //echo $update_subscription;
            //guardamos los datos
            $record["productId"] = $subscription["items"]["data"][0]["plan"]["product"];
            $record["priceId"] = $plan["stripe_priceid"];
            $upd = parent::update($record, $suscripcion["idprograma_salud_suscripcion"]);
            if (!$upd) {
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                $this->setMsg(["msg" => "Ha ocurrido un error. Intente nuevamente", "result" => false]);
                return false;
            }
            $this->db->CompleteTrans();
            return true;
        } catch (\Stripe\Exception\ApiErrorException $e) {
            // echo $e;
            $this->db->FailTrans();
            $this->db->CompleteTrans();
            $this->setMsg(["msg" => "Ha ocurrido un error. Intente nuevamente", "result" => false, "err" => $e->getMessage()]);
            return false;
        } catch (\Stripe\Exception $e) {
            //echo $e;
            $this->db->FailTrans();
            $this->db->CompleteTrans();
            $this->setMsg(["msg" => "Ha ocurrido un error. Intente nuevamente", "result" => false, "err" => $e->getMessage()]);
            return false;
        }
    }

    /**
     * Metodo que realiza un cambio del metodo de pago de una suscipcion en Stripe 
     * @param type $paymentMethodId cambio de plan   
     * @return type
     */
    public function cambiar_metodo_pago_suscripcion($paymentMethodId) {
        try {
            $this->db->StartTrans();
            $idempresa = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idempresa"];
            $suscripcion = parent::getByField("empresa_idempresa", $idempresa);
            //verificamos que la suscripcion esté activa
            $empresa = parent::get($idempresa);
            if ($empresa["cancelar_suscripcion"] == 2) {
                $this->setMsg(["msg" => "Error. Su suscripción ha sido cancelada", "result" => false]);
                return false;
            }
            //actualizamos el metodo de pago en la BD local
            if ($paymentMethodId == "") {
                $this->setMsg(["msg" => "Ha ocurrido un error. Intente nuevamente", "result" => false]);
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                return false;
            }
            $record["paymentMethodId"] = $paymentMethodId;
            $update = parent::update($record, $suscripcion["idprograma_salud_suscripcion"]);

            if (!$update) {
                $this->setMsg(["msg" => "Ha ocurrido un error. Intente nuevamente", "result" => false]);
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                return false;
            }
            $stripe = new \Stripe\StripeClient($this->apiKeySecret_stripe);
            //agregamos el metodo de pago al cliente
            $stripe->paymentMethods->attach(
                    $paymentMethodId, ['customer' => $suscripcion['customerId']]
            );

            $stripe->customers->update(
                    $suscripcion['customerId'], ['invoice_settings' => ['default_payment_method' => $paymentMethodId]]
            );

            //seteamos el cambio en la suscripcion de stripe
            $subscription = $stripe->subscriptions->update(
                    $suscripcion["subscriptionId"], [
                'default_payment_method' => $paymentMethodId,
                    ]
            );
            //echo $subscription;
            $subscription["result"] = true;
            $this->db->CompleteTrans();
            $this->setMsg($subscription);
            return true;
        } catch (\Stripe\Exception\ApiErrorException $e) {
            //echo $e;
            $this->db->FailTrans();
            $this->db->CompleteTrans();
            $this->setMsg(["msg" => "Ha ocurrido un error. Intente nuevamente", "result" => false, "err" => $e->getMessage()]);
            return false;
        } catch (\Stripe\Exception $e) {
            //echo $e;
            $this->db->FailTrans();
            $this->db->CompleteTrans();
            $this->setMsg(["msg" => "Ha ocurrido un error. Intente nuevamente", "result" => false, "err" => $e->getMessage()]);
            return false;
        }
    }

    /**
     * Metodo que procesa el webhook proveniente de stripe con la informacion del fallo de pago del invoice cuando ocurre un error en el cobro de la sucripcion
     * @param type $session
     * @return type
     */
    public function handleSubscriptionFailStripe($session) {
        //valido lo que llego
        $customerId = $session->data->object->customer;
        //fix test
        //$customerId = "cus_J7u7F1xvYlf6At";
        $suscripcion = parent::getByField("customerId", $customerId);
        if ($suscripcion["empresa_idempresa"] != "") {
            $rdo = $this->getManager("ManagerEmpresa")->enviar_mail_error_cobro_suscripcion($suscripcion["empresa_idempresa"], $session);
            if ($rdo) {
                // <-- LOG
                $log["data"] = "Subscription invoice payment failed";
                $log["page"] = "Entreprise";
                $log["action"] = "val"; //"val" "vis" "del"
                $log["purpose"] = "Subscription";

                $ManagerLog = $this->getManager("ManagerLog");
                $ManagerLog->track($log);

                // <--
                $log = "Error Pago Suscripcion: email enviado a la empresa";
                echo $log;
            } else {
                echo "Error: el mail no pudo ser enviado a la empresa";
            }
        } else {
            echo "Customer ID not found";
        }


        $myFile = path_files("ipn_log_stripe_detailed_subscription.txt");
        $fh = fopen($myFile, 'a');
        fwrite($fh, "------" . date("Y-m-d H:i:s") . "-------" . PHP_EOL);
        fwrite($fh, $log . PHP_EOL);
        fwrite($fh, print_r($session, true) . PHP_EOL);
        fwrite($fh, "-------------------------" . PHP_EOL);
        fclose($fh);

        return $rdo;
    }

    /**
     * Metodo que procesa el webhook proveniente de stripe con la informacion del exito de pago del invoice cuando ocurre un error en el cobro de la sucripcion
     * @param type $session
     * @return type
     */
    public function handleSubscriptionSucceedStripe($session) {
        //valido lo que llego
        $customerId = $session->data->object->customer;
        //fix test
        //$customerId = "cus_J7u7F1xvYlf6At";
        $suscripcion = parent::getByField("customerId", $customerId);
        if ($suscripcion["empresa_idempresa"] != "") {
            if ($suscripcion["pack"] == 1 && $suscripcion["pack_pago_pendiente"] == 1 && $suscripcion["paymentMethodId"] == "") {
                $paymentMethodId = $session->data->object->customer;
                $request["paymentMethodId"] = $paymentMethodId;
                $rdo_activar = $this->activar_suscripcion_pack($request);
                if (!$rdo_activar) {
                    return false;
                }
            }
            $rdo = $this->getManager("ManagerEmpresa")->enviar_mail_exito_cobro_suscripcion($suscripcion["empresa_idempresa"], $session);
            if ($rdo) {
                // <-- LOG
                $log["data"] = "Subscription invoice payment succeed";
                $log["page"] = "Entreprise";
                $log["action"] = "val"; //"val" "vis" "del"
                $log["purpose"] = "Subscription";

                $ManagerLog = $this->getManager("ManagerLog");
                $ManagerLog->track($log);

                // <--
                $log = "Pago Suscripcion Exitoso: email enviado a la empresa";
                echo $log;
            } else {
                echo "Error Mail Pago Suscripcion: el mail no pudo ser enviado a la empresa";
            }
        } else {
            echo "Customer ID not found";
        }


        $myFile = path_files("ipn_log_stripe_detailed_subscription.txt");
        $fh = fopen($myFile, 'a');
        fwrite($fh, "------" . date("Y-m-d H:i:s") . "-------" . PHP_EOL);
        fwrite($fh, $log . PHP_EOL);
        fwrite($fh, print_r($session, true) . PHP_EOL);
        fwrite($fh, "-------------------------" . PHP_EOL);
        fclose($fh);

        return $rdo;
    }

    public function getPagoPendienteTransPack() {
        $idempresa = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idempresa"];
        $query = new AbstractSql();
        $query->setSelect("COUNT(*) as cantidad");
        $query->setFrom("programa_salud_suscripcion pss");
        $query->setWhere("pss.pack_pago_pendiente = 8");
        $query->addAnd("pss.empresa_idempresa = $idempresa");
        return $this->db->GetRow($query->getSql());
    }

}
