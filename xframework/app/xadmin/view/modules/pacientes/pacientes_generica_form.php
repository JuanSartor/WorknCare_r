<?php

/**
 *  Pacientes Form
 *
 * */
if (isset($this->request["id"]) && (int) $this->request["id"] > 0) {
    $manager = $this->getManager("ManagerPaciente");

    //con el flag active=0 obtenemos todos los pacientes activos e inactivos
    $record = $manager->get($this->request["id"], 0);



    $managerP = $this->getManager("ManagerPais");
    $this->assign("paises", $managerP->getCombo());
    $imagenes_tarjetas = $manager->getImagenesIdentificacion($this->request["id"]);

    $this->assign("imagenes_tarjetas", $imagenes_tarjetas);


    $this->assign("record", $record);

    $ManagerCuentaUsuario = $this->getManager("ManagerCuentaUsuario");

    $paginate = SmartyPaginate::getPaginate("listado_movimientos_" . $this->request["id"]);
    $this->assign("paginate", $paginate);
    $cuenta = $ManagerCuentaUsuario->getByField("paciente_idpaciente", $this->request["id"]);
    $this->assign("cuenta", $cuenta);


    $paciente_empresa = $this->getManager("ManagerPacienteEmpresa")->getByField("paciente_idpaciente", $cuenta["paciente_idpaciente"]);

    if ($paciente_empresa) {
        $plan_contratado = $this->getManager("ManagerProgramaSaludPlan")->get($paciente_empresa["plan_idplan"]);
        $empresa = $this->getManager("ManagerEmpresa")->get($paciente_empresa["empresa_idempresa"]);
        $this->assign("paciente_empresa", $paciente_empresa);
        $this->assign("empresa", $empresa);
        $this->assign("plan_contratado", $plan_contratado);
    }
}
?>