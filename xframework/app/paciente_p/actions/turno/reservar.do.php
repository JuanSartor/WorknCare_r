<?php


    /**
     * Rereservar un turno
     *
     **/  
    $this->start();
    $ManagerTurno = $this->getManager("ManagerTurno");
//$ManagerTurno->debug();
    $ManagerTurno->reservarTurno($this->request);
    $this->finish($ManagerTurno->getMsg());
?>
