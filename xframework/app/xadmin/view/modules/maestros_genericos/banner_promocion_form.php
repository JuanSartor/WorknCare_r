<?php

/**
 *  banner de promocion
 *  
 * */
echo($this->request["idbanner_promocion"]);
if (isset($this->request["idbanner_promocion"]) && $this->request["idbanner_promocion"] > 0) {
    $manager = $this->getManager("ManagerBannerPromocion");
    $record = $manager->get($this->request["idbanner_promocion"]);
    $this->assign("record", $record);
}