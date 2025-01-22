<?php

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Description of ManagerPreregistro
 *
 * @author lucas
 */
class ManagerPreregistro extends Manager {

    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "preregistro", "idpreregistro");



        $this->default_paginate = "preregistro_list";
    }

    /**
     * Método que retorna el listado JSON de los médicos registrados desde el frontend y que no han completado el registro
     * @param type $request
     * @param type $idpaginate
     * @return type
     */
    public function getListadoPreregistroJSON($request, $idpaginate = NULL) {

        if (!is_null($idpaginate)) {
            $this->paginate($idpaginate, 50);
        }

        $query = new AbstractSql();
        $query->setSelect("p.*,
                IF(uw.idusuarioweb is NULL,'-',CONCAT(uw.apellido,', ', uw.nombre)) as nombre,
                IF(uw.idusuarioweb is NULL,'NO','SI') as completado,
                DATE_FORMAT(p.fecha, '%d/%m/%Y %H:%i') as fecha_format,
                if(teaser=1,'Si','No') as teaser
               
                
            ");
        $query->setFrom("
                $this->table p
                    LEFT JOIN usuarioweb uw ON (p.email = uw.email AND uw.registrado=1)
            ");


          if ($request["completado"] != "") {

              if ($request["completado"] == 0) {
                  $query->addAnd("uw.idusuarioweb is NULL");
              }else{
                   $query->addAnd("uw.idusuarioweb is NOT NULL");
              }

            
        }
           if ($request["teaser"] != "") {

              if ($request["teaser"] == 1) {
                  $query->addAnd("teaser=1");
              }else{
                   $query->addAnd("teaser=0");
              }

            
        }

        // Filtro
        if ($request["nombre"] != "") {

            $rdo = cleanQuery($request["nombre"]);

            $query->addAnd("((uw.nombre LIKE '%$rdo%') OR (uw.apellido LIKE '%$rdo%'))");
        }

        if ($request["email"] != "") {

            $rdo = cleanQuery($request["email"]);

            $query->addAnd("(p.email LIKE '%$rdo%') ");
        }

        $data = $this->getJSONList($query, array("fecha_format", "email", "completado","teaser", "nombre"), $request, $idpaginate);

        return $data;
    }

    /** 
     * Generacion de listado CSV von los médicos registrados desde el frontend y que no han completado el registro
     * 
     * @param type $request
     * 
     */
  
    public function ExportarCSV($request) {
   
        //obtenemos los registros
        $query = new AbstractSql();
        $query->setSelect("p.email,
                IF(uw.idusuarioweb is NULL,'-',CONCAT(uw.apellido,', ', uw.nombre)) as nombre,
                DATE_FORMAT(p.fecha, '%d/%m/%Y %H:%i') as fecha_format
               
                
            ");
        $query->setFrom("
                $this->table p
                    LEFT JOIN usuarioweb uw ON (p.email = uw.email)
            ");


        if ($request["completado"] != "") {

              if ($request["completado"] == 0) {
                  $query->addAnd("uw.idusuarioweb is NULL");
              }else{
                   $query->addAnd("uw.idusuarioweb is NOT NULL");
              }

            
        }

        // Filtro
        if ($request["nombre"] != "") {

            $rdo = cleanQuery($request["nombre"]);

            $query->addAnd("((uw.nombre LIKE '%$rdo%') OR (uw.apellido LIKE '%$rdo%'))");
        }

        if ($request["email"] != "") {

            $rdo = cleanQuery($request["email"]);

            $query->addAnd("(p.email LIKE '%$rdo%') ");
        }

        $data = $this->getList($query);





        $fecha_actual = date("Y-m-d");
        header('Content-Type: text/csv');
        header('Content-Disposition: attachment;filename=preregistro-' . $fecha_actual . ".csv");


        $out = fopen('php://output', 'w');

        foreach ($data as $registro) {
            fputcsv($out, $registro,";");
        }

        fclose($out);
    }

    /*     * Metodo que crea un nuevo registro
     * 
     * @param array $request
     * @return type
     */

    public function insert($request) {
        $request["fecha"] = date("Y-m-d H:i:s");
        return parent::insert($request);
    }

}
