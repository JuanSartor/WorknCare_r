<?php

$file = @fopen(path_config("init.config.php"), "r");

if ($file) {
    while (($buffer = fgets($file)) !== false) {
        //recorremos todos los parametro
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

        foreach ($parametros_configuracion as $param) {
            if (strpos($buffer, "{$param}") > -1) {

                $valor = preg_replace("/[^\d]+/i", "", $buffer);

                $this->assign("{$param}", $valor);
            }
        }
    }
    if (!feof($file)) {
        $this->assign("valor", "Error: fallo inesperado");
    }
    fclose($file);
}    