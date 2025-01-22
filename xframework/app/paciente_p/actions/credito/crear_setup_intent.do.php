<?php

$ManagerCustomerStripe = $this->getManager("ManagerCustomerStripe");
$ManagerCustomerStripe->crear_setup_intent($this->request["customerId"]);
$this->finish($ManagerCustomerStripe->getMsg());
