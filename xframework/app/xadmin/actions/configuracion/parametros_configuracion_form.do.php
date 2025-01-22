<?php

$file = path_config("init.config.php");

$parametros_configuracion = [
    "MONTO_CUOTA",
    "VIDEOCONSULTA_DURACION",
    "VIDEOCONSULTA_VENCIMIENTO_SALA",
    "VIDEOCONSULTA_HORAS_PENDIENTE_FINALIZACION",
    "VENCIMIENTO_VC_FRECUENTES",
    "VENCIMIENTO_VC_RED",
    "VIDEOCONSULTA_NOTIFICAR_MEDICO_DEMORADO",
    "VENCIMIENTO_CE_FRECUENTES",
    "VENCIMIENTO_CE_RED",
    "PRECIO_MINIMO_CE",
    "PRECIO_MINIMO_VC",
    "PRECIO_MINIMO_VC_TURNO",
    "PRECIO_MAXIMO_CE",
    "PRECIO_MAXIMO_VC",
    "PRECIO_MAXIMO_VC_TURNO",
    "COMISION_CE",
    "COMISION_VC",
];

//reemplazar el contenido con el nuevo valor
$result = false;
foreach ($parametros_configuracion as $param) {

    // Open the file to get existing content
    $content = file_get_contents($file);
    $valor = $this->request["{$param}"];
    if ($valor != "") {

        $modify_content = preg_replace("/\"{$param}\"\,.*[0-9]+\);/", "\"{$param}\",{$valor});", $content);
        $rdo = file_put_contents($file, $modify_content, LOCK_EX);
        if (!$rdo) {
            $result = false;
            $this->finish(["result" => false, "msg" => "Ha ocurrido un error"]);
            return false;
        } else {
            $result = true;
        }
    }
}
if ($result) {
    $this->finish(["result" => true, "msg" => "Registro actualizado con éxito"]);
} else {
    $this->finish(["result" => false, "msg" => "Ha ocurrido un error"]);
    return false;
} 




