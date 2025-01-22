<?php

require_once (path_libs_php("stripe-php-7.75.0/init.php"));
/**
 * 	@autor Xinergia
 * 	@version 1.0	02/03/2021
 * 	Manager de Suscripciones al Programa de Salud.
 *
 */

/**
 * Description of ManagerProgramaSaludSuscripcion
 *
 * @author lucas
 */
class ManagerPagoRecompensaEncuesta extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

// Llamamos al constructor del a superclase
        parent::__construct($db, "pago_recompensa_encuesta", "idpago_recompensa_encuesta");
//Stripe testing
        $this->apiKeyPublic_stripe = STRIPE_APIKEY_PUBLIC;
        $this->apiKeySecret_stripe = STRIPE_APIKEY_SECRET;
    }

    public function nuevo_pago_recompensa_encuesta($request) {

        //chequeamos la existencia del usuario empresa - customerId
        $usuario_empresa = $this->getManager("ManagerUsuarioEmpresa")->getByField("empresa_idempresa", $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idempresa"]);
        if ($usuario_empresa["idusuario_empresa"] == "") {
            $this->setMsg(["msg" => "Ha ocurrido un error. Intente nuevamente", "result" => false]);
            return false;
        }

        //obtenemos la recompensa seleccionada
        $recompensa = $this->getManager("ManagerRecompensa")->get($request["recompensa"]);


        //Creamos el registro en la base de datos
        $this->db->StartTrans();
        $record["customerId"] = $usuario_empresa["stripe_customerid"];
        $record["empresa_idempresa"] = $usuario_empresa["empresa_idempresa"];
        $record["priceId"] = $recompensa["stripe_priceid"];
        $record["creation_date"] = date("Y-m-d H:i:s");
        $record["cuestionario_idcuestionario"] = $request["idcuestionario"];

        $id = parent::insert($record);

        if (!$id) {
            $this->db->FailTrans();
            $this->db->CompleteTrans();
            $this->setMsg(["msg" => "Ha ocurrido un error. Intente nuevamente", "result" => false]);
            return false;
        } else {
            $this->db->CompleteTrans();
            $this->setMsg(["msg" => "Su suscripción ya ha sido registrada exitosamente", "suscripcion" => true, "id" => $id, "result" => true]);
            return true;
        }
    }

    public function getListCuestionListosEmpresa() {

        $query = new AbstractSql();
        $query->setSelect("COUNT(*) as cantidad");
        $query->setFrom("$this->table p, cuestionarios c");
        $query->setWhere("(p.pago_pendiente = 1 or (p.pago_pendiente = 2 and c.estado=1))");
        $query->addAnd("p.empresa_idempresa={$_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idempresa"]}");
        $query->addAnd("p.cuestionario_idcuestionario=c.idcuestionario");
        return $this->db->GetRow($query->getSql());
    }

    public function getCuestionListoEmpresa() {

        $query = new AbstractSql();
        $query->setSelect("c.*");
        $query->setFrom("$this->table t, cuestionarios c");
        $query->setWhere("(pago_pendiente = 1 or pago_pendiente = 2 or pago_pendiente = 4 or pago_pendiente = 5 or pago_pendiente = 6 )");
        $query->addAnd("t.empresa_idempresa={$_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idempresa"]}");
        $query->addAnd("c.empresa_idempresa={$_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idempresa"]}");
        $query->addAnd("t.cuestionario_idcuestionario=c.idcuestionario");
        $query->addAnd("c.estado=1");

        return $this->db->GetRow($query->getSql());
    }

    public function getPagoPendienteFactura() {
        $usuario_empresa = $this->getManager("ManagerUsuarioEmpresa")->get($_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idusuario_empresa"]);

        $query = new AbstractSql();
        $query->setSelect("t.*");
        $query->setFrom("$this->table t, cuestionarios c");
        $query->setWhere(" pago_pendiente = 2");
        $query->addAnd("t.empresa_idempresa={$_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idempresa"]}");
        $query->addAnd("c.empresa_idempresa={$_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idempresa"]}");
        $query->addAnd("t.cuestionario_idcuestionario=c.idcuestionario");
        if ($usuario_empresa["tipo_usuario"] == '5') {
            $query->addAnd("c.usuarioempresa_idusuarioempresa=" . $usuario_empresa["idusuario_empresa"]);
        }

        return $this->db->GetRow($query->getSql());
    }

    public function eliminarCuestionarioYPago($idcuestionario) {
        // pongo estado en 3 significa que fue eliminado el cuestionario
        // hago una eliminacion logica no fisica
        $rdo = $this->db->Execute("update pago_recompensa_encuesta set pago_pendiente=3 where cuestionario_idcuestionario=" . $idcuestionario);

        if ($rdo) {
            $managerCues = $this->getManager("ManagerCuestionario");
            $rdoPago = $managerCues->db->Execute("update cuestionarios set estado=3 where idcuestionario=" . $idcuestionario);
            $pago = $this->getByField("cuestionario_idcuestionario", $idcuestionario);
            if ($pago["pago_pendiente"] == '1') {
                if ($rdoPago) {
                    $pago = $this->getByField("cuestionario_idcuestionario", $idcuestionario);
                    $ManagerCustomerStripe = $this->getManager("ManagerCustomerStripe");
                    $rdoCustomer = $ManagerCustomerStripe->cancelarCuestionario($pago["stripe_payment_intent_id"]);
                    if ($rdoCustomer) {
                        $this->setMsg(["msg" => "Se ha eliminado correctamente el cuestionario", "result" => true]);
                        return true;
                    } else {
                        $this->setMsg(["msg" => "Ha ocurrido un error. No se pudo cancelar el pago en stripe correctamente", "result" => false]);
                        return false;
                    }
                } else {
                    $this->setMsg(["msg" => "Ha ocurrido un error. No se cancelar el pago correctamente", "result" => false]);
                    return false;
                }
            } else {
                $this->setMsg(["msg" => "Se ha eliminado correctamente el cuestionario", "result" => true]);
                return true;
            }
        } else {
            $this->setMsg(["msg" => "Ha ocurrido un error. No se pudo eliminar el cuestionario", "result" => false]);
            return false;
        }
    }

    public function confirmarPagoCuestionario($idcuestionario) {

        $ManagerCustomerStripe = $this->getManager("ManagerCustomerStripe");
        $rdo = $ManagerCustomerStripe->confirmar_cobro_cuestionario($idcuestionario);
        if ($rdo) {
            $rdoU = $this->db->Execute("update pago_recompensa_encuesta set pago_pendiente=4 where cuestionario_idcuestionario=" . $idcuestionario);
            if ($rdoU) {
                $this->setMsg(["msg" => "Pago actualizado correctamente", "result" => true]);
                return true;
            } else {
                $this->setMsg(["msg" => "Ha ocurrido un error. No se actualizar el estado del pago", "result" => false]);
                return false;
            }
        } else {
            $this->setMsg(["msg" => "Ha ocurrido un error. No se concretar el pago en stripe", "result" => false]);
            return false;
        }
    }

}
