<?php

require_once(path_libs("libs_php/ElephantIO/Client.php"));
require_once(path_libs("libs_php/ElephantIO/Engine/SocketIO/Version1X.php"));

use ElephantIO\Client as ElephantClient;
use ElephantIO\Engine\SocketIO\Version1X;

/**
 * Clase que implementa las funcionalidades de ElphantIO permitiendo emitir un un evento al servidor node
 * sin tener que realizar la inicializacion y cierre en cada llamada de esta clase
 *
 * @author lucas
 */
class XSocketClient {

    private $client;

    /** Consturctor de la clase
     * 
     */
    public function __construct() {
        if (SERVER_URL == "localhost") {
            $protocol = "http://";
            $this->client = new ElephantClient(new Version1X($protocol . SERVER_URL . ":" . SERVER_NODE_PORT));
        } else {
            $protocol = "https://";
            $this->client = new ElephantClient(new Version1X($protocol . SERVER_URL  . ":" . SERVER_NODE_PORT, ['context' => ['ssl' => ['verify_peer_name' => false, 'verify_peer' => false]]]));
        }
     
    }

    /** Emitir un un evento al servidor node
     * 
     * @param type $event nombre del evento que se emite
     * @param type $array_data aray clave=>valor que contiene los datos transmitidos en el mensaje
     * @return boolean
     */
    public function emit($event, $array_data) {
        $debug = 0;
        try {
            $this->client->initialize();
            $this->client->emit($event, $array_data);
            $this->client->close();

            return true;
        } catch (ElephantIO\Exception\MalformedUrlException $e) {
            if ($debug) {
                echo $e;
            }

            return false;
        } catch (ElephantIO\Exception\ServerConnectionFailureException $e) {
            if ($debug) {
                echo $e;
            }
            return false;
        } catch (ElephantIO\Exception\SocketException $e) {
            if ($debug) {
                echo $e;
            }
            return false;
        } catch (ElephantIO\Exception\UnsupportedActionException $e) {
            if ($debug) {
                echo $e;
            }
            return false;
        } catch (ElephantIO\Exception\UnsupportedTransportException $e) {
            if ($debug) {
                echo $e;
            }
            return false;
        }
    }

}
