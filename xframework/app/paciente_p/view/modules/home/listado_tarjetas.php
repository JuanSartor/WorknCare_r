<?php

//Paciente que se encuentra en el array de SESSION de header paciente
$ManagerPaciente = $this->getManager("ManagerPaciente");
$paciente = $ManagerPaciente->getPacienteXHeader();

//obtenemos la cuenta del paciente para verificar el saldo
$cuenta_paciente = $this->getManager("ManagerCuentaUsuario")->getCuentaPaciente($paciente["idpaciente"]);

//metodos de pago cargados en Stripe
$metodo_pago_list = $this->getManager("ManagerCustomerStripe")->get_listado_metodos_pago($cuenta_paciente["paciente_idpaciente"]);
$this->assign("metodo_pago_list", $metodo_pago_list["data"]);


// obtengo el iban asociado al usuario
$ibanBeneficiario = $this->getManager("ManagerIbanBeneficiario")->getByField("usuarioWeb_idusuarioweb", $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idusuarioweb"]);
$this->assign("iban_beneficiario", $ibanBeneficiario);
