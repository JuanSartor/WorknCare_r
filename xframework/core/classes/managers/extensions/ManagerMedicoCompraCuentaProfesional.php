<?php

  /**
   * 	@autor Xinergia
   * 	@version 1.0	29/05/2014
   * 	Manager de Los pacientes que pertenecen a un grupo familiar
   *    No son usuarios web.
   *
   */
  class ManagerMedicoCompraCuentaProfesional extends Manager {

      /** constructor
       * 	@param $db instancia de adodb
       */
      function __construct($db) {

          // Llamamos al constructor del a superclase
          parent::__construct($db, "medicocompracuentaprofesional", "idmedicoCompraCuentaProfesional");

      }

      
      public function processFromCuentaProfesionalMP($pago) {
          
          $myFile = path_files("ipn_log_mp_1.txt");

          $fh = fopen($myFile, 'a');

          fwrite($fh, $this->print_r($pago));
          
          $data = array(
                "fecha_pago" => $pago["fecha_pago"],
                "detalle_pago" => $pago["id"],
                "tipo_pago" => "MercadoPago",
                "order_id" => $pago["order_id"],
                "transaction_amount" => $pago["transaction_amount"],
                "medico_idmedico" => $pago["order_id"],
                "metodoPago_idmetodoPago" => 2 //Método de pago mercado pago
          );
          
          $rdo = $this->process($data);
          if($rdo){
              //Cambio el estado del médico
              $ManagerMedico = $this->getManager("ManagerMedico");
              $rdo = $ManagerMedico->update(array("planProfesional" => 1) , $pago["order_id"]);
              
              return true;
          }else{
              return false;
          }
          
          
          
      }

  }
  