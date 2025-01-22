<?php

$this->start();
$manager = $this->getManager("ManagerTraduccion");
$result = $manager->get_traducciones_sistema();
$this->finish($manager->getMsg());
?>
