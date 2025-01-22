<?php

/**
 * 	Manager de provincia
 *
 * 	@author UTN
 * 	@version 1.0
 * 	@package managers\extensions
 */
class ManagerProvincia extends ManagerMaestros {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Constructor
        parent::__construct($db, "provincia", "idprovincia");
    }

    /** 	
     * 	Inserta un registro en la tabla correspondiente basandose en el arreglo recibido como parámetro 
     *
     * 	@author UTN
     * 	@version 1.0 
     * 	
     * 	@param mixed $record Arreglo que contiene todos los campos a insertar
     * 	@return int Retorna el ID Insertado o 0
     */
    public function insert($request) {



        //creo el registro
        $id = parent::insert($request);


        if ($id) {

            $this->setMsg(["msg"=>"Se dió de alta la provincia en el sistema","result"=>true]);
        }

        return $id;
    }

    /** 	
     * 	Realiza Update de un registro
     *
     * 	@author UTN
     * 	@version 1.0
     *
     * 	@param mixed $record Arreglo que contiene todos los campos para su actualización
     * 	@param int $id clave primaria del registro a actualizar.
     * 	@return int|booelan Retorna el id del registro actualizado o falso dependiendo de que se haya realizado correctamente el UPDATE
     */
    public function update($request, $id) {


        //Guardo el registro
        $result = parent::update($request, $id);

        //si se crea correctamente asocio las funcionaldades y si aplica o no

        if ($result) {

            $msg = $this->getMsg();

              $this->setMsg(["msg"=>"Se modificó la provincia en el sistema","result"=>true]);

          
        }


        return $result;
    }

    /**
     *   Listado estandar en formato JSON
     * 		
     * 	@author UTN
     * 	@version 1.0
     *
     * 	@param string $idpaginate ID de pagiación
     * 	@param array $request Contenido del request
     * 	@return string Listado en formato JSON
     */
    public function getListadoJSON($idpaginate = NULL, $request) {

        if (!is_null($idpaginate)) {
            $this->paginate($idpaginate, 25);
        }

        $query = new AbstractSql();
        $query->setSelect("$this->id,$this->table,pa.pais");
        $query->setFrom("$this->table p 
                                INNER JOIN pais pa ON (p.pais_idpais = pa.idpais)
                            ");

        // Filtro


        if ($request["descripcion"] != "") {

            $descripcion = cleanQuery($request["descripcion"]);

            $query->addAnd($this->table . " LIKE '%$descripcion%'");
        }

        if ($request["pais_idpais"] > 0) {

            $pais_idpais = (int) ($request["pais_idpais"]);

            $query->addAnd("p.pais_idpais = $pais_idpais");
        }

        $data = $this->getJSONList($query, array($this->table, "pais"), $request, $idpaginate);


        return $data;
    }

    /**
     *   Combo de provincias pertenecientes a un país
     * 		
     * 	@author UTN
     * 	@version 1.0
     *
     * 	@param int $pais_idpais ID del país que contiene las provincias
     * 	@return array Listado de registros
     */
    public function getComboProvinciasDePais($pais_idpais) {

        $query = new AbstractSql();
        $query->setSelect("$this->id,$this->table");
        $query->setFrom("$this->table p");
        $query->setWhere("pais_idpais = $pais_idpais");

        return $this->getComboBox($query, false);
    }

    /**
     *   Combo de provincias argentinas (pais_idpais = 1)
     * 		
     * 	@author UTN
     * 	@version 1.0
     *
     * 	@return array Listado de registros
     */
    public function getComboProvinciasArgentinas() {

        $query = new AbstractSql();
        $query->setSelect("$this->id,$this->table");
        $query->setFrom("$this->table p");
        $query->setWhere("pais_idpais = 1");
        $query->setOrderBy("$this->table ASC");


        return $this->getComboBox($query, false);
    }

}

//END_class 
?>