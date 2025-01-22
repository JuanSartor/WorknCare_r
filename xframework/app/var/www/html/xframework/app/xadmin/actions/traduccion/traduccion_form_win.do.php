<?php

$this->start();
$manager = $this->getManager("ManagerTraduccion");
$result = $manager->process($this->request);
$this->finish($manager->getMsg());
?>
