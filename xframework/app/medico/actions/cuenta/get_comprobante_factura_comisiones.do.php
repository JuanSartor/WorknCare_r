<?php
// Vamos a mostrar un PDF

if($this->request["hash"]!=""){
   
    $id=  base64_decode($this->request["hash"]);
$solicitud=$this->getManager("ManagerSolicitudPagoMedico")->get($id);
  //verificamos que pertenezca al medico
$idmedico = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];
  $periodo=$this->getManager("ManagerPeriodoPago")->get($solicitud["periodoPago_idperiodoPago"]);
   if($periodo["medico_idmedico"]!=$idmedico){
      
       throw new ExceptionErrorPage("No se puede acceder a la información solicitada");
  }
header('Content-type: application/pdf');
$mes=  getNombreMes($periodo["mes"]);
// nombre del archivo
header('Content-Disposition: attachment; filename="Factura-Comision-DP-'.$mes.'-'.$periodo["anio"].'.pdf"');

// La fuente de PDF se encuentra en el path
readfile(path_entity_files("comisiones_solicitud_pago/$id/$id.pdf"));
}
