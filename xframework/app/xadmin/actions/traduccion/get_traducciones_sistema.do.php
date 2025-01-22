<?php

$this->start();
$manager = $this->getManager("ManagerTraduccion");
$result = $manager->get_traducciones_sistema($this->request);
$this->finish($manager->getMsg());
?>
