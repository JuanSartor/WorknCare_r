<?php

 // <-- LOG
$log["data"] = "Payment NOT successful";                
$log["page"] = "Account settings";                
$log["action"] = "val";//"vis" "del"
$log["purpose"] = "Credit User account";

$ManagerLog = $this->getManager("ManagerLog");
$ManagerLog->track($log);

// <--
