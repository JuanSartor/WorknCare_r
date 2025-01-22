<?php

$ManagerBanco=$this->getManager("ManagerBanco");
$banco=$ManagerBanco->getBancoXIBAN($this->request["iban"]);
echo json_encode($banco);
