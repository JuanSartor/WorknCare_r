<?php

/**
 *  estos son lo q representa cada valor de la columna pago_pendiente en la tabla pago_recompensa_encuesta
 * 0 pediente - 1 pagado - 2 factura enviada - 3 cancelado - 4 es gratuito sin prestacion
 */
if ($this->request["banderaPrestacion"] == 'true') {

    $managerPago = $this->getManager("ManagerPagoRecompensaEncuesta");
//print_r($this->request);
    // $managerPago->debug();
    $managerPago->nuevo_pago_recompensa_encuesta($this->request);

    $manager = $this->getManager("ManagerCuestionario");
    $manager->update($this->request, $this->request["idcuestionario"]);
    $this->finish($manager->getMsg());
} else {

    $managerEmprea = $this->getManager("ManagerEmpresa");


    $managerPago = $this->getManager("ManagerPagoRecompensaEncuesta");

    $requestPagoGratuito["cuestionario_idcuestionario"] = $this->request["idcuestionario"];
    $requestPagoGratuito["pago_pendiente"] = '6';
    $requestPagoGratuito["empresa_idempresa"] = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idempresa"];
    $requestPagoGratuito["creation_date"] = date("Y-m-d H:i:s");
    $managerPago->insert($requestPagoGratuito);
    $manager = $this->getManager("ManagerCuestionario");
    $this->request["estado"] = '1';
    $this->request["recompensa"] = '0';
    $this->request["programasalud_idprogramasalud"] = '0';
    $this->request["cantidad"] = '0';
    $manager->update($this->request, $this->request["idcuestionario"]);
    $managerEmprea->generar_hash_invitacion_cuestionario($this->request["idcuestionario"]);
    $this->finish($managerEmprea->getMsg());
}
