<?php

$ManagerCustomerStripe = $this->getManager("ManagerCustomerStripe");
$ManagerCustomerStripe->ver_ticket_payment_intent($this->request["payment_intent_id"]);
$this->finish($ManagerCustomerStripe->getMsg());
