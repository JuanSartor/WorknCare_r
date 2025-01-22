<?php

echo "entre";
$ManagerMetodoPago = $this->getManager("ManagerMetodoPago");

//$ManagerMetodoPago->processNotificationMP(1888373281);

print_r(date("Y-m-d", mktime(0, 0, 0, date("m")+$pago["fecha_pago"], date("d"), date("Y"))));

