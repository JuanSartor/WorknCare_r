<?php

/**
 * 	@autor Xinergia
 * 	@version 1.0	29/05/2014
 * 	Manager de Banco
 *
 */
class ManagerCuota extends ManagerMedia {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "cuota", "idcuota");
        $this->default_paginate = "listado_cuota";
        $this->setImgContainer("cuotas");
    }

    /**
     *  Procesa el pago de una cuota cuando ingresa el IPN de mercadopago
     *  @param array $pago un array con los datos del pago
     *  @return boolean true si se proceso correctamente, false en caso contrario
     */
    public function procesarPago($pago) {

        //obtengo la suscripcion asociada
        $ManagerSuscripcion = $this->getManager("ManagerSuscripcionPremium");
        $suscripcion = $ManagerSuscripcion->get($pago["order_id"]);

        $this->db->startTrans();
        $last_cuota = $this->getLastCuota($pago["order_id"]);
        if ($last_cuota["numero"] == "") {
            $numero = 1;
        } else {
            $numero = (int) $last_cuota["numero"] + 1;
        }


        //inserto el registro
        $idcuota = $this->insert([
            "suscripcion_premium_idsuscripcion_premium" => $pago["order_id"], "numero" => $numero, "fecha_pago" => $pago["fecha_pago"],
            "fecha_vencimiento" => date("Y-m-d", mktime(0, 0, 0, date("m") + $pago["fecha_pago"], date("d"), date("Y")))
        ]);
        //ponemos la suscripcion como activa
        $susc = $ManagerSuscripcion->update(["activa" => 1], $suscripcion["idsuscripcion_premium"]);

        //modifico los datos en el medico
        $ManagerMedico = $this->getManager("ManagerMedico");
        $rdo = $ManagerMedico->updateSuscripcionPremium($suscripcion["medico_idmedico"], $idcuota);

        if ($idcuota && $rdo && $susc) {
            $this->db->completeTrans();
            return true;
        } else {
            return false;
        }
    }

    /* Metodo que inserta un pago / factura que carga el administrador cuando crea el comprobante de cobro de la cuota
     * 
     */

    public function process($request) {


        $id = parent::process($request);
        if ($id) {


            //si se subieron ficheros
            if (isset($request["hash"]) && is_array($request["hash"])) {


                foreach ($request["hash"] as $k => $hash) {

                    $file = $_SESSION[$hash];

                    $path_tmp = path_files("temp/" . $file["name"]);

                    $path = path_entity_files("cuotas/$id/");


                    if (!is_dir($path)) {
                        $Dir = new Dir($path);
                        $Dir->chmod(0777);
                    }

                    $new_path = path_entity_files("cuotas/{$id}/{$id}.pdf");
                    if (file_exists($new_path) && file_exists($path_tmp)) {
                        unlink($new_path);
                    }

                    if (file_exists($path_tmp)) {


                        rename($path_tmp, $new_path);
                        parent::update(["posee_file" => 1], $id);
                        unlink($path_tmp);
                    }
                }
            }
        }

        return $id;
    }

    /*     * Metodo que retorna los pagos y sus estados correspondiente a una suscripcion premium
     * 
     * @param type $idsuscripcion
     * @return type
     */

    public function getPagosList($idsuscripcion, $fecha_inicio) {
        $pagos_list = [];
        list($Y, $m, $d) = preg_split("[-]", $fecha_inicio);

        for ($i = 0; $i < 6; $i++) {

            $pago["fecha"] = date("Y-m-d", mktime(0, 0, 0, $m + $i, $d, $Y));
            $pago["posee_file"] = 0;
            $pago["estado"] = "PENDIENTE";
            $pago["monto_cuota"] = MONTO_CUOTA;
            $pagos_list[] = $pago;
        }






        $query = new AbstractSql();
        $query->setSelect("*");
        $query->setFrom("$this->table");
        $query->setWhere("suscripcion_premium_idsuscripcion_premium=$idsuscripcion");

        $cuotas_pagadas = $this->getList($query);

        //seteamos que pagos fueron realizados
        foreach ($cuotas_pagadas as $cuota) {
            $pagos_list[$cuota["numero"] - 1]["estado"] = "PAGADA";
            $pagos_list[$cuota["numero"] - 1]["idcuota"] = $cuota["idcuota"];
            $pagos_list[$cuota["numero"] - 1]["hash"] = base64_encode($cuota["idcuota"]);

            $pagos_list[$cuota["numero"] - 1]["posee_file"] = $cuota["posee_file"];
        }
        return $pagos_list;
    }

    /*     * Metodo que obtiene el numero de la cuota correspondiente al pago que ingresa
     * 
     * @param type $idsuscripcion
     */

    public function getLastCuota($idsuscripcion) {
        $query = new AbstractSql();
        $query->setSelect("*");
        $query->setFrom("$this->table");
        $query->setWhere("suscripcion_premium_idsuscripcion_premium=$idsuscripcion");
        $query->setOrderBy("fecha_vencimiento DESC, idcuota DESC");
        return $this->db->getRow($query->getSql());
    }

    /*     * Metodo que obtiene un array en formato JSON con el listado de cuotas de las suscripciones profesionales de medicos 
     * y los comprobantes asociados del pago por MercadoPago cargados por el administrador 
     * 
     * @param type $request
     * @param type $idpaginate
     * @return type
     */

    public function getListadoComprobantesCuotaJSON($request, $idpaginate = NULL) {
        if (!is_null($idpaginate)) {
            $this->paginate($idpaginate, 50);
        }

        $query = new AbstractSql();
        $query->setSelect("c.idcuota,CONCAT(uw.nombre,  ' ', uw.apellido) as  nombre_medico,
              m.cuit,
              s.idsuscripcion_premium,
              s.fecha_inicio as inicio_suscripcion, 
              s.fecha_fin as fin_suscripcion, 
              c.numero as cuota,
              c.fecha_pago,
              DATE_FORMAT(s.fecha_inicio, '%d/%m/%Y') as inicio_suscripcion_format,
              DATE_FORMAT(s.fecha_fin, '%d/%m/%Y') as fin_suscripcion_format,
              DATE_FORMAT(c.fecha_pago, '%d/%m/%Y') as fecha_pago_format,
              c.posee_file,
                        CASE c.facturada
                         WHEN 1 THEN 'Facturada' 
                        ELSE 'Pendiente' 
                         END  as estado");

        $query->setFrom("
                {$this->table}  c
                INNER JOIN suscripcion_premium s ON (
                c.suscripcion_premium_idsuscripcion_premium = s.idsuscripcion_premium)
                INNER JOIN medico m on (s.medico_idmedico=m.idmedico)
                INNER JOIN usuarioweb uw on (m.usuarioweb_idusuarioweb=uw.idusuarioweb)
            ");

        // Filtro
        if ($request["fecha_desde"] != "") {

            $rdo = $this->sqlDate($request["fecha_desde"], "-", true);
            $query->addAnd("c.fecha_pago >= '$rdo'");
        }
        if ($request["fecha_hasta"] != "") {
            $rdo = $this->sqlDate($request["fecha_hasta"], "-", true);
            $query->addAnd("c.fecha_pago >= '$rdo'");
        }

        if ($request["nombre_medico"] != "") {
            $rdo = cleanQuery($request["nombre_medico"]);
            $query->addAnd("CONCAT(uw.nombre,  ' ', uw.apellido) LIKE '%$rdo%'");
        }

        if ($request["estado"] != "") {
            $query->addAnd("c.facturada={$request["estado"]}");
        }

        $data = $this->getJSONList($query, array("nombre_medico", "cuit", "inicio_suscripcion_format", "fin_suscripcion_format", "cuota", "fecha_pago_format", "estado", "posee_file"), $request, $idpaginate);

        return $data;
    }

}

//END_class
?>