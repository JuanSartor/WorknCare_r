<?php

/**
 *  envio de mail a soporte sobre reembolso
 */
$ManagerReembolso = $this->getManager("ManagerReembolso");
$result = $ManagerReembolso->enviarMailASoporte($this->request);
$this->finish($ManagerReembolso->getMsg());

