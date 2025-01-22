<?php

$ManagerCompraCredito=$this->getManager("ManagerCompraCredito");
$result=$ManagerCompraCredito->validar_cupon_promocional_credito($this->request);
$this->finish($ManagerCompraCredito->getMsg());

