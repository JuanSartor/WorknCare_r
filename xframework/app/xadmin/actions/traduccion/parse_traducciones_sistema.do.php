<?php

$this->start();
$manager = $this->getManager("ManagerTraduccion");
$result = $manager->parse_traducciones_sistema();
$this->finish($manager->getMsg());
?>
