<?php
// Vamos a mostrar un PDF
if($this->request["hash"]!=""){
    $id=  base64_decode($this->request["hash"]);
$cuota=$this->getManager("ManagerCuota")->get($id);
header('Content-type: application/pdf');

// nombre del archivo
header('Content-Disposition: attachment; filename="Comprobante-Cuota'.$cuota["numero"].'-'.$cuota["fecha_pago"].'.pdf"');

// La fuente de PDF se encuentra en el path
readfile(path_entity_files("cuotas/$id/$id.pdf"));
}
