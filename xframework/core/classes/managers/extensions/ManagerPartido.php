<?php

/**
 * 	Manager de partido
 *
 * 	@author UTN
 * 	@version 1.0
 * 	@package managers\extensions
 */
class ManagerPartido extends ManagerMaestros {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Constructor
        parent::__construct($db, "partido", "idpartido");
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

            $this->setMsg(["msg" => "Se dió de alta el partido en el sistema", "result" => true]);
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
            $this->setMsg(["msg" => "Se han modificado los datos del partido en el sistema", "result" => true]);
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
        $query->setSelect("$this->id,$this->table,pa.pais, pro.provincia");
        $query->setFrom("$this->table par 
                                INNER JOIN provincia pro ON (par.provincia_idprovincia = pro.idprovincia)
                                INNER JOIN pais pa ON (pro.pais_idpais = pa.idpais)
                            ");

        // Filtro


        if ($request["descripcion"] != "") {

            $descripcion = cleanQuery($request["descripcion"]);

            $query->addAnd($this->table . " LIKE '%$descripcion%'");
        }

        if ($request["pais_idpais"] > 0) {

            $pais_idpais = (int) ($request["pais_idpais"]);

            $query->addAnd("pro.pais_idpais = $pais_idpais");
        }

        if ($request["provincia_idprovincia"] > 0) {

            $provincia_idprovincia = (int) ($request["provincia_idprovincia"]);

            $query->addAnd("par.provincia_idprovincia = $provincia_idprovincia");
        }

        $data = $this->getJSONList($query, array($this->table, "provincia", "pais"), $request, $idpaginate);


        return $data;
    }

    /**
     *   Listado combo con los partidos pertenecientes a una provincia		
     *
     * 	@author UTN
     * 	@version 1.0
     *
     * 	@param int $provincia_idprovincia ID de la provincia que contiene los partidos
     * 	@return array Listado de registros
     */
    public function getComboPartidosDeProvincia($provincia_idprovincia) {

        $query = new AbstractSql();
        $query->setSelect("$this->id,$this->table");
        $query->setFrom("$this->table");
        $query->setWhere("provincia_idprovincia = $provincia_idprovincia");

        return $this->getComboBox($query, false);
    }

}

//END_class 
?>