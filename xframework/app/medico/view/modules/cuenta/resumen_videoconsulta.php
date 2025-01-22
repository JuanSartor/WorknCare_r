<?php

//obtnemos las videoconsultas realizadas en el periodo
    $idpaginate = "listado_paginado_cuenta_videoconsulta_{$this->request["idperiodoPago"]}";
    $this->assign("idpaginate", $idpaginate);
     $this->assign("idperiodoPago",$this->request["idperiodoPago"]);
    $resumen_videoconsulta = $this->getManager("ManagerVideoConsulta")->getListadoPaginadoDetalleVideoConsultaXPeriodo($this->request, $idpaginate);
    $this->assign("resumen_videoconsulta",$resumen_videoconsulta);
    
    $periodo_pago = $this->getManager("ManagerPeriodoPago")->get($this->request["idperiodoPago"]);
    $this->assign("periodo_pago", $periodo_pago);
    //Obtener mes del periodo

    $nombre_mes = getNombreMes(date("n", mktime(0, 0, 0, $periodo_pago["mes"], 2, $periodo_pago["anio"])));
    $this->assign("nombre_mes", strtolower($nombre_mes));