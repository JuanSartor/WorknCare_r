<?php

/* ini_set('display_errors', '1');
  error_reporting(6143);
  $manager = $this->getManager("ManagerSuscripcionPremium");
  $manager->debug();
  $manager->activarSuscripcionStripe(41);
  die("Que esta pasando???"); */


// Set your secret key: remember to change this to your live secret key in production
// See your keys here: https://dashboard.stripe.com/account/apikeys
require_once (path_libs_php("stripe-php-7.75.0/init.php"));

\Stripe\Stripe::setApiKey(STRIPE_APIKEY_SECRET);

// You can find your endpoint's secret in your webhook settings
$endpoint_secret = STRIPE_ENDPOINT_SECRET;

$payload = @file_get_contents('php://input');
$sig_header = $_SERVER['HTTP_STRIPE_SIGNATURE'];
$event = null;

//interno/////////////////////////////////////////
$myFile = path_files("ipn_log_stripe.txt");

$fh = fopen($myFile, 'a');
fwrite($fh, "-------" . PHP_EOL);
fwrite($fh, date("Y-m-d H:i:s") . PHP_EOL);
fwrite($fh, print_r($payload, true) . PHP_EOL);
fclose($fh);
//////////////////////////////////////////////////
try {
    $event = \Stripe\Webhook::constructEvent(
                    $payload, $sig_header, $endpoint_secret
    );
} catch (\UnexpectedValueException $e) {
    // Invalid payload
    http_response_code(400);
    exit();
} catch (\Stripe\Error\SignatureVerification $e) {
    // Invalid signature
    http_response_code(400);
    exit();
}

// Handle the checkout.session.completed event
if ($event->type == 'checkout.session.completed') {
    $session = $event->data->object;

    // Fulfill the purchase...
    //handle_checkout_session($session);

    $ManagerMetodoPago = $this->getManager("ManagerMetodoPago");
    $ManagerMetodoPago->debug();

    $resultadoProceso = $ManagerMetodoPago->handleCheckoutSessionStripe($session);
}

//fallo cobro suscripcion
if ($event->type == 'invoice.payment_failed') {
    $this->getManager("ManagerProgramaSaludSuscripcion")->handleSubscriptionFailStripe($event);
}
//exito cobro suscripcion
if ($event->type == 'invoice.payment_succeeded') {
    $this->getManager("ManagerProgramaSaludSuscripcion")->handleSubscriptionSucceedStripe($event);
}

http_response_code(200);
