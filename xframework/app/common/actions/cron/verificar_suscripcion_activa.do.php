<?php
/**Cron que se ejecuta a las 00:00hs encargado de vencer las suscripciones premium que han pasado 2 dias de vencimiento sin pagarse la cuota
     * 
     */
$ManagerSuscripcionPremium = $this->getManager("ManagerSuscripcionPremium");
$ManagerSuscripcionPremium->debug();
$ManagerSuscripcionPremium->cronVerificarSuscripcionActiva();


