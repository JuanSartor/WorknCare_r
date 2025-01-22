<?php

/**
 * 	Manager de Localidad
 *
 * 	@author UTN
 * 	@version 1.0
 * 	@package managers\extensions
 */
class ManagerLocalidad extends ManagerMaestros {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Constructor
        parent::__construct($db, "localidad", "idlocalidad");
        $this->default_paginate = "paginate_localidad";
    }

    /**
     * Método que retorna el combo box de localidad por pais
     * @param type $idpais, id de la pais
     * @return type
     */
    public function getCombo($idpais) {

        $query = new AbstractSql();

        $query->setSelect("l.$this->id,l.$this->table");
        $query->setFrom("$this->table l");
        $query->setWhere("l.pais_idpais = $idpais");
        $query->setOrderBy("l.localidad");

        return $this->getComboBox($query, false);
    }

    /**
     * Listado JSON de las localidades
     * @param type $request
     * @param type $idpaginate
     * @return type
     */
    public function getListadoJSON($request, $idpaginate = null) {
        if (!is_null($idpaginate)) {
            $this->paginate($idpaginate, 25);
        }

        $query = new AbstractSql();
        $query->setSelect("$this->id,localidad,cpa,pais");
        $query->setFrom("$this->table loc inner join pais p on (p.idpais=loc.pais_idpais)");

        // Filtro
        if ($request["pais_idpais"] > 0) {

            $pais_idpais = (int) ($request["pais_idpais"]);

            $query->addAnd("loc.pais_idpais = $pais_idpais");
        }


        if ($request["cpa"] != "") {

            $cpa = cleanQuery($request["cpa"]);

            $query->addAnd("cpa = '$cpa'");
        }

        if ($request["localidad"] != "") {

            $localidad = cleanQuery($request["localidad"]);

            $query->addAnd("localidad LIKE '%$localidad%'");
        }


        $data = $this->getJSONList($query, array("localidad", "cpa", "pais"), $request, $idpaginate);


        return $data;
    }

    /**
     *   Combo de localidades que pertenecen a un pais
     * 		
     * 	@author UTN
     * 	@version 1.0
     *
     * 	@param int $pais_idpais ID del pais
     * 	@return array Listado de registros
     */
    public function getComboLocalidadDePartido($pais_idpais) {

        $query = new AbstractSql();
        $query->setSelect("$this->id,$this->table");
        $query->setFrom("$this->table ");
        $query->setWhere("pais_idpais = $pais_idpais");

        return $this->getComboBox($query, false);
    }

    /**
     *   Combo de localidades que pertenecen a un pais con información de código postal
     * 		
     * 	@author UTN
     * 	@version 1.0
     *
     * 	@param int $pais_idpais ID del pais
     * 	@return array Listado de registros
     */
    public function getComboLocalidadcpaDePartido($pais_idpais) {

        $query = new AbstractSql();
        $query->setSelect("$this->id,IFNULL(CONCAT($this->table,' (',cpa,')'),$this->table)");
        $query->setFrom("$this->table ");
        $query->setWhere("pais_idpais = $pais_idpais");

        return $this->getComboBox($query, false);
    }

    /**
     *   Listado de Localidades con filtro de busqueda para autosugeridor
     * 		
     * 	@author Xinergia
     * 	@version 1.0
     *
     * 	@param int $request con parametros para la busqueda
     * 	@return array Listado de registros
     */
    public function getAutosuggest($request) {

        $queryStr = cleanQuery($request["query"]);
        $pais_idpais = $request["pais_idpais"];

        if ($pais_idpais == "") {
            $data = array(
                "query" => $request["query"],
                "suggestions" => array()
            );
        } else {

            $query = new AbstractSql();

            $query->setSelect("$this->id  AS data ,
                                    CONCAT($this->table,' (',cpa,')') AS value,
                                    loc.*");
            $query->setFrom("$this->table loc 
                                    INNER JOIN pais par ON (loc.pais_idpais = par.idpais)");

            // Filtro


            $query->setWhere("loc.pais_idpais = $pais_idpais AND loc.localidad LIKE '%$queryStr%'");


            $data = array(
                "query" => $request["query"],
                "suggestions" => $this->getList($query, false)
            );
        }

        return json_encode($data);
    }

    /*
     * Obtiene una localidad con el detalle de pais
     *                
     */

    public function getFull($idlocalidad) {

        $query = new AbstractSql();

        $query->setSelect("$this->id ,
                          CONCAT($this->table,' (',cpa,')',', ',par.pais) AS localidad,
                          localidad AS localidad_corta,
                          loc.pais_idpais,
                          loc.cpa,
                          par.idpais,
                          par.pais
                          ");
        $query->setFrom("$this->table loc 
                          INNER JOIN pais par ON (loc.pais_idpais = par.idpais)");


        $query->setWhere("loc.idlocalidad = $idlocalidad");

        $localidad = $this
                ->db
                ->Execute($query->getSql())
                ->FetchRow();

        return $localidad;
    }

}

//END_class 
?>