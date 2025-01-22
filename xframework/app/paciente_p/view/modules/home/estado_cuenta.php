<?php

$ManagerMovimientoCuenta = $this->getManager("ManagerMovimientoCuenta");
//  $ManagerMovimientoCuenta->debug();


$ultima_carga = $ManagerMovimientoCuenta->getUltimoMovimientoCarga();
if ($ultima_carga) {
    $this->assign("ultima_carga", $ultima_carga);
}

$cuenta_usuario = $this->getManager("ManagerCuentaUsuario")->getCuentaPaciente($_SESSION[URL_ROOT]["paciente_p"]['logged_account']["paciente"]["idpaciente"]);

if ($cuenta_usuario) {
    $this->assign("cuenta_usuario", $cuenta_usuario);
}

$paciente_empresa = $this->getManager("ManagerPacienteEmpresa")->getByField("paciente_idpaciente", $cuenta_usuario["paciente_idpaciente"]);

if ($paciente_empresa) {
    $plan_contratado = $this->getManager("ManagerProgramaSaludPlan")->get($paciente_empresa["plan_idplan"]);
    $this->assign("paciente_empresa", $paciente_empresa);

    $this->assign("plan_contratado", $plan_contratado);
    $empresa = $this->getManager("ManagerEmpresa")->get($paciente_empresa["empresa_idempresa"]);
    $this->assign("empresa", $empresa);

}