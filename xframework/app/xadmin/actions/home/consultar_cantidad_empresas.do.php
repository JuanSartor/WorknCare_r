<?php

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Description of cargar_dashboard
 *
 * @author juan
 */
$this->start();
$manager = $this->getManager("ManagerEmpresa");
//$manager->debug();
$result = $manager->getCantidadEmpresa();
$this->finish($manager->getMsg());
