<?php

/**
 * 	@autor Xinergia
 * 	@version 1.0	29/05/2014
 * 	Manager de Banco
 *
 */
class ManagerCompraCredito extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "compra_credito", "idcompra_credito");
    }

    /*     * Metodo que crea una nueva suscripcion de cuenta premium
     *  @param type $request
     */

    public function compra_credito($monto_compra, $codigo = "") {

        if ($monto_compra == "" || $monto_compra < 5) {
            $this->setMsg(["msg" => "Ingrese el monto de compra válido", "result" => false]);
            return false;
        }


        $idpaciente = $_SESSION[URL_ROOT]["paciente_p"]['logged_account']["paciente"]["idpaciente"];

        $this->db->StartTrans();

        $cuenta = $this->getManager("ManagerCuentaUsuario")->getCuentaPaciente($idpaciente);

        $arr["paciente_idpaciente"] = $idpaciente;
        $arr["fecha_compra"] = date("Y-m-d");
        $arr["monto_compra"] = $monto_compra;

        $arr["cuentausuario_idcuentausuario"] = $cuenta["idcuentaUsuario"];

        $idcompra = $this->insert($arr);


        if ($idcompra) {
            $this->db->CompleteTrans();
            $this->setMsg(["msg" => "Compra de credito realizada con exito", "result" => true, "id" => $idcompra, "monto_compra" => $monto_compra]);
            return true;
        } else {
            $this->db->FailTrans();
            $this->db->CompleteTrans();
            $this->setMsg(["msg" => "No se pudo crear la compra de credito", "result" => false]);
            return false;
        }
    }

    /**
     * Procesa el pago de la carga de credito
     * @param type $pago el pago obtenido del servidor de mercadopago
     * @return boolean
     */
    public function procesarPago($pago) {

        //obtengo registro de compra de credito
        $compra = $this->get($pago["order_id"]);

        //valido que el monto recibido sea la cantidad de credito cargada
        if ($pago["total_paid_amount"] < $compra["monto_compra"]) {
            return false;
        }

        $this->db->startTrans();
        //actualizo el registro de compra de credito
        $rdoCompra = $this->update(
                ["fecha_pago" => date("Y-m-d"), "acreditado" => 1], $compra["idcompra_credito"]
        );

        //inserto movimiento de cuenta
        if ($compra["monto_descuento"] != "" && $compra["monto_final"] != "") {
            //movimiento credito con descuento
            $movimiento = [
                "fecha" => date("Y-m-d H:i:s"),
                "monto" => $compra["monto_final"],
                "is_ingreso" => 1,
                "cuentaUsuario_idcuentaUsuario" => $compra["cuentausuario_idcuentausuario"],
                "detalleMovimientoCuenta_iddetalleMovimientoCuenta" => 3,
                "paciente_idpaciente" => $compra["paciente_idpaciente"]
            ];
            $rdoMovimiento = $this->getManager("ManagerMovimientoCuenta")->insert($movimiento);
            //movimiento credito de cuponstar
            $movimiento1 = [
                "fecha" => date("Y-m-d H:i:s"),
                "monto" => $compra["monto_descuento"],
                "is_ingreso" => 1,
                "cuentaUsuario_idcuentaUsuario" => $compra["cuentausuario_idcuentausuario"],
                "detalleMovimientoCuenta_iddetalleMovimientoCuenta" => 8,
                "paciente_idpaciente" => $compra["paciente_idpaciente"]
            ];
            $rdoMovimiento1 = $this->getManager("ManagerMovimientoCuenta")->insert($movimiento1);
        } else {
            $movimiento = [
                "fecha" => date("Y-m-d H:i:s"),
                "monto" => $compra["monto_compra"],
                "is_ingreso" => 1,
                "cuentaUsuario_idcuentaUsuario" => $compra["cuentausuario_idcuentausuario"],
                "detalleMovimientoCuenta_iddetalleMovimientoCuenta" => 3,
                "paciente_idpaciente" => $compra["paciente_idpaciente"]
            ];
            $rdoMovimiento = $this->getManager("ManagerMovimientoCuenta")->insert($movimiento);
        }

        //actualizo la cuenta del cliente
        $rdoCliente = $this->getManager("ManagerCuentaUsuario")->actualizarCuentaPaciente($compra["paciente_idpaciente"]);
        $this->db->completeTrans();

        if (!$rdoCompra || !$rdoCliente || !$rdoMovimiento) {
            return false;
        } else {
            return true;
        }
    }

    /**
     * Metodo que valida un cupon promocional de compra de credito con descuento
     * @param type $request
     * @return boolean
     */
    public function validar_cupon_promocional_credito($request) {
        $cuponstar = $this->getManager("ManagerCuponstar")->getByField("codigo", $request["codigo"]);
        if ($cuponstar) {

            $this->setMsg(["msg" => "Código ingresado  válido", "result" => true]);
            return true;
        } else {

            $this->setMsg(["msg" => "El código ingresado no es válido", "result" => false]);
            return false;
        }
        return true;
    }

}

//END_class
?>