<?php

/**
 *  Action para actualizar el iban del beneficiario
 */
$ManagerIban = $this->getManager("ManagerIbanBeneficiario");
$result = $ManagerIban->update(["iban" => $this->request["iban"]], $this->request["idIbanBeneficiario"]);

if ($result) {
    echo true;
} else {
    echo false;
}
