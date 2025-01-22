<?php

class ManagerCapsulaRegistroVisitas extends Manager {

    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "registro_visitas_capsula", "idregistrovisitas");

        $this->default_paginate = "registro_visitas_capsula";
    }

    public function getListadoVisitasCantidad($request) {
        $query = new AbstractSql();

        $query->setSelect("DATE(fecha_realizada) as fecha_realizada,count(capsula_idcapsula) as cantidad");

        $query->setFrom("$this->table t");

        $query->setWhere("capsula_idcapsula = $request");
        $query->setGroupBy("DATE(fecha_realizada)");

        return$this->getList($query);
    }

}

//END_class
?>