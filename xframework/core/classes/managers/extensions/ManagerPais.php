<?php

/**
 * 	Manager de pa�s
 *
 * 	@author UTN
 * 	@version 1.0
 * 	@package managers\extensions
 */
class ManagerPais extends ManagerMaestros {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Constructor
        parent::__construct($db, "pais", "idpais");
    }

    /**
     * 	Inserta un registro en la tabla correspondiente basandose en el arreglo recibido como par�metro
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
            $this->setMsg(["msg" => "Se dió de alta el país en el sistema", "result" => true]);
        }

        return $id;
    }

    /**
     * 	Realiza Update de un registro
     *
     * 	@author UTN
     * 	@version 1.0
     *
     * 	@param mixed $record Arreglo que contiene todos los campos para su actualizaci�n
     * 	@param int $id clave primaria del registro a actualizar.
     * 	@return int|booelan Retorna el id del registro actualizado o falso dependiendo de que se haya realizado correctamente el UPDATE
     */
    public function update($request, $id) {

        //Guardo el registro
        $result = parent::update($request, $id);

        //si se crea correctamente asocio las funcionaldades y si aplica o no

        if ($result) {
            $this->setMsg(["msg" => "Se han modificado los datos del país en el sistema", "result" => true]);
        }

        return $result;
    }

    /**
     * 	Listado o combo con los paises y su caracter�stica telef�nica
     *
     * 	@author UTN
     * 	@version 1.0
     *
     * 	@return array
     */
    public function getComboTel() {

        $query = new AbstractSql();
        $query->setSelect("$this->id,IFNULL(CONCAT('(',caracteristica,') ',$this->table),$this->table)");
        $query->setFrom($this->table);
        $query->setOrderBy("idpais ASC");

        return $this->getComboBox($query, false);
    }
    
     public function getCombo() {

        $query = new AbstractSql();
        $query->setSelect("$this->id,$this->table");
        $query->setFrom($this->table);
        $query->setOrderBy("idpais ASC");

        return $this->getComboBox($query, false);
    }

    public function getListadoJSON($idpaginate = NULL, $request) {

        if (!is_null($idpaginate)) {
            $this->paginate($idpaginate, 25);
        }

        $query = new AbstractSql();
        $query->setSelect("$this->id,$this->table,caracteristica");
        $query->setFrom("$this->table p
                            ");

        // Filtro

        if ($request["descripcion"] != "") {

            $descripcion = cleanQuery($request["descripcion"]);

            $query->addAnd($this->table . " LIKE '%$descripcion%'");
        }


        $data = $this->getJSONList($query, array($this->table, "caracteristica"), $request, $idpaginate);

        return $data;
    }

}

//END_class
?>