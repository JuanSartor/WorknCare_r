<?php

if (isset($this->request["idperiodoPago"]) && $this->request["idperiodoPago"] != "") {

    $this->assign("idperiodoPago", $this->request["idperiodoPago"]);
    $ManagerPeriodoPago = $this->getManager("ManagerPeriodoPago");
    $periodo_pago = $ManagerPeriodoPago->get($this->request["idperiodoPago"]);
    $this->assign("periodo_pago", $periodo_pago);

    //Obtener mes del periodo

    $nombre_mes = getNombreMes(date("n", mktime(0, 0, 0, $periodo_pago["mes"], 2, $periodo_pago["anio"])));

    $this->assign("nombre_mes", $nombre_mes);
    $medico = $this->getManager("ManagerMedico")->get($_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"]);

    $this->assign("medico", $medico);
    $especialidad = $this->getManager("ManagerEspecialidades")->get($_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idespecialidad"]);
    $this->assign("especialidad", $especialidad);
    if ($periodo_pago["status_solicitud_pago"] == 1) {
        //Datos del médico...
        $ManagerInformacionComercialMedico = $this->getManager("ManagerInformacionComercialMedico");
        $info = $ManagerInformacionComercialMedico->getInformacionComercialMedico($_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"]);

        if ($info) {
            $info["titular"] = $medico["nombre"] . " " . $medico["apellido"];
            $this->assign("info_comercial", $info);
        }



        //Me fijo si ya obtuvo la solicitud de pago el médico
        $ManagerSolicitudPagoMedico = $this->getManager("ManagerSolicitudPagoMedico");

        $solicitud_pago = $ManagerSolicitudPagoMedico->getByField("periodoPago_idperiodoPago", $this->request["idperiodoPago"]);

        if ($solicitud_pago) {
            if ($solicitud_pago["banco_idbanco"] != "") {
                $solicitud_pago["nombre_banco"] = $this->getManager("ManagerBanco")->get($solicitud_pago["banco_idbanco"])["nombre_banco"];
            }
            list($anio, $mes, $dia) = preg_split("[-]", $solicitud_pago["fechaSolicitudPago"]);
            $nombre_corto_mes = getNombreCortoMes($mes);
            $solicitud_pago["fecha_solicitud_format"] = "{$dia} {$nombre_corto_mes} {$anio}";
            $solicitud_pago["titular"] = $medico["nombre"] . " " . $medico["apellido"];
            $solicitud_pago["cuit"] = $medico["cuit"];
            $this->assign("solicitud_pago", $solicitud_pago);
        }
    }
}
$ManagerVideoConsulta = $this->getManager("ManagerVideoConsulta");
$idpaginate = "listado_videoconsultas_reintegro";


$this->assign("idpaginate", $idpaginate);
$this->request["do_reset"] = 1;


$cantidad = $ManagerVideoConsulta->get_cantidad_consultas_reintegro_pendiente();

$this->assign("cantidad", $cantidad);

$videoconsultas_reintegro = $ManagerVideoConsulta->get_listado_consultas_reintegro($this->request, $idpaginate);

$this->assign("videoconsultas_reintegro", $videoconsultas_reintegro);




