<?php

/**
 * 	@autor Xinergia
 * 	@version 1.0	29/05/2014
 * 	Manager de Banco
 *
 */
class ManagerBanco extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "banco", "idbanco");
        $this->setFlag("active");
        $this->default_paginate = "banco_list";
    }

    public function getCombo() {

        $query = new AbstractSql();
        $query->setSelect("$this->id,nombre_banco");
        $query->setFrom("$this->table");
        $query->setWhere("active=1");
        $query->setOrderBy("nombre_banco");

        return $this->getComboBox($query, false);
    }

    public function getListadoBancos() {
        $query = new AbstractSql();
        $query->setSelect("$this->id,nombre_banco,codigo");
        $query->setFrom("$this->table");
        $query->setWhere("active=1");
        $query->setOrderBy("nombre_banco");

        return $this->getList($query);
    }

    public function getListadoJSON($request, $idpaginate = NULL) {

        if (!is_null($idpaginate)) {
            $this->paginate($idpaginate, 50);
        }

        $query = new AbstractSql();
        $query->setSelect("*");

        $query->setFrom("
                $this->table b inner join pais p ON (b.pais_idpais=p.idpais)
            ");

        $query->setWhere("active=1");
        // Filtro
        if ($request["nombre_banco"] != "") {

            $nombre = cleanQuery($request["nombre_banco"]);

            $query->addAnd("nombre_banco LIKE '%$nombre%'");
        }
        if ($request["pais_idpais"] != "") {

            $pais_idpais = cleanQuery($request["pais_idpais"]);

            $query->addAnd("pais_idpais=$pais_idpais");
        }


        $data = $this->getJSONList($query, array("nombre_banco", "codigo", "pais"), $request, $idpaginate);

        return $data;
    }

    /**
     * Metodo que devuleve una entidad banco segun el codigo IBAN pasado como parametro
     * @param type $iban
     * @return boolean
     */
    public function getBancoXIBAN($ibanConEspacios) {

        $iban = str_replace(" ", "", $ibanConEspacios);
        if ($iban == "") {
            return false;
        }
        //pais determinado x primeros 2 caracteres
        $pais = substr($iban, 0, 2);
        if ($pais == "FR") {
            $bic = substr($iban, 4, 5);
            $banco = $this->getByFieldArray(["codigo", "pais_idpais"], [$bic, 1]);
            return $banco;
        }
        if ($pais == "LU") {
            $bic = substr($iban, 4, 3);
            $banco = $this->getByFieldArray(["codigo", "pais_idpais"], [$bic, 2]);
            return $banco;
        }
        if ($pais == "BE") {
            $bic = substr($iban, 4, 3);
            $banco = $this->getByFieldArray(["codigo", "pais_idpais"], [$bic, 3]);
            return $banco;
        }
        if ($pais == "CH") {
            $bic = substr($iban, 4, 5);
            $banco = $this->getByFieldArray(["codigo", "pais_idpais"], [$bic, 5]);
            return $banco;
        }
    }

}

//END_class
?>