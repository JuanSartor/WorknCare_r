<?php

require_once (path_libs_php("mercadopago/mercadopago.php"));

/**
 * Class ManagerMercadoPago
 * Transacciones de Mercado Pago
 */
class ManagerMercadoPago extends Manager {
    
    private $mp;

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Constructor
        $this->db = $db;
        //$this->mp = new MP('6041146799695898', '8FzLXleVWcVd0n3GlIKQd5HkqAVY9hGR');
        $this->mp = new MP('5504390177603377', 'makCL5APLfsdJxfefmxTwtlVyH7N0ZLe');
        
        
        //activar sandbox
        //$this->mp->sandbox_mode(TRUE);
    }

    /**
     *  Procesa una notificacion
     */
    public function processNotification($id) {

        
        //obtengo el pago completo de mercadopago
        $payment = $this->mp->get_payment($id);
        print_r($payment);
        //si el estado del pago es 200 (ok)
        if ($payment["status"] == 200){
            
            //obtengo la info específica del pago
            $pago = $payment["response"]["collection"];

            //valido el estado del pago
            if($pago["status"] != "approved"){
                return false;
            }

            $orderId = explode("=", $pago["order_id"]);
                        
            $fecha_pago = explode("T", $pago["date_approved"]);
           // $pago["fecha_pago"] = $fecha_pago[0];
            $pago["fecha_pago"]=date("Y-m-d");
            $pago["order_id"] = $orderId[1];
            

            //proceso el pago    
            switch ($orderId[0]) {
                case "i":
                    $rdo = $this->processInscripcion($pago);
                    break;
                case "r":
                    $rdo = $this->processRenovacion($pago);
                    break;
                case "d":
                    $rdo = $this->processInscripcion($pago);
                    //si la inscripcion se proceso exitosamente
                    if($rdo){
                        //enviar mail
                      
                       
                    }
                    break;
            }

            $logPago = path_files("ipn_process_log_mp.txt");
            $fh = fopen($logPago, 'a');
            fwrite($fh, "-------");
            fwrite($fh, date("Y-m-d H:i:s"));
            fwrite($fh, print_r($pago, true));
            fclose($fh);
                       
            return $rdo;
        }
    }//END_processNotification

    /**
     * Procesa el pago correspondiente a una inscripcion
     * @param type $pago
     */
    public function processInscripcion($pago) {
        //ordeno los datos
        $data = array(
            "fecha_pago" => $pago["fecha_pago"],
            "detalle_pago" => $pago["id"],
            "tipo_pago" => "MercadoPago",
            "order_id" => $pago["order_id"],
            "transaction_amount" => $pago["transaction_amount"]
        );

        //registro el pago
        $ManagerInscripcionWeb = $this->getManager("ManagerInscripcionWeb");
        $rdo = $ManagerInscripcionWeb->pagarInscripcion($data);
        return $rdo;
    }//END_processInscripcion

    /**
     * Procesa el pago correspondiente a una renovacion
     * @param type $pago
     */
    public function processRenovacion($pago) {
        //ordeno los datos
        $data = array(
            "fecha_pago" => $pago["fecha_pago"],
            "detalle_pago" => $pago["id"],
            "tipo_pago" => "MercadoPago",
            "order_id" => $pago["order_id"],
            "transaction_amount" => $pago["transaction_amount"]
        );

        //registro el pago
        $ManagerEstudianteCursoCuota = $this->getManager("ManagerEstudianteCursoCuota");
        $rdo = $ManagerEstudianteCursoCuota->pagarCuota($data);
        return $rdo;
       
    }//END_processRenovacion
    
}//END_class 
?>
