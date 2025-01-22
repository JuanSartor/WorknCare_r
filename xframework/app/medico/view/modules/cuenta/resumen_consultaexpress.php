<?php

$idpaginate = "listado_paginado_cuenta_consultasexpress_{$this->request["idperiodoPago"]}";
    $this->assign("idpaginate", $idpaginate);
    $this->assign("idperiodoPago",$this->request["idperiodoPago"]);
    $resumen_consultaexpress = $this->getManager("ManagerConsultaExpress")->getListadoPaginadoDetalleConsultasExpressXPeriodo($this->request, $idpaginate);
    //print_r($resumen_consultaexpress);
    $this->assign("resumen_consultaexpress",$resumen_consultaexpress);
    
    $periodo_pago = $this->getManager("ManagerPeriodoPago")->get($this->request["idperiodoPago"]);
    $this->assign("periodo_pago", $periodo_pago);

    //Obtener mes del periodo

    $nombre_mes = getNombreMes(date("n", mktime(0, 0, 0, $periodo_pago["mes"], 2, $periodo_pago["anio"])));

  $this->assign("nombre_mes", strtolower($nombre_mes));
    
    
