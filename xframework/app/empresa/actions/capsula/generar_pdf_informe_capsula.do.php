<?php

//print($this->request["id"]);
$this->start();
$Manager = $this->getManager("ManagerCapsula");
$capsula = $Manager->get($this->request["id"]);

$Manager->getReportePDFcapsula($capsula);
