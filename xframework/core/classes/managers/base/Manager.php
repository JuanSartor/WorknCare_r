<?php

/**
 *  Manager
 *
 *  Clase que maneja las entidades que abstrae los comportamientos genericos que pueden realizarse sobre las tablas.
 *
 *  @author Sebastian Balestrini <sbalestrini@gmail.com>
 *  @version 1.0
 *
 */
require_once(path_managers("base/abstract/AbstractManager.php"));

class Manager extends AbstractManager {

    /**
     * 	@author Sebastian Balestrini
     * 	@version 1.0
     * 	
     * 	constructor de la clase 
     */
    function __construct($db, $table, $id, $flag = NULL) {

        parent::__construct($db, $table, $id, $flag);
    }

    /**
     * 	@author Sebastian Balestrini
     * 	@version 1.0
     * 	
     * 	Inserta un registro en la tabla correspondiente basandose en el arraglo recibido como parametros 
     * 	
     * 	@param mixed $record Arreglo que contiene todos los campos a insertar
     * 	@return int Retorna el ID Insertado o 0
     */
    public function insert($record) {


        $newid = parent::insert($record);

        if ($newid) {

            $this->setMsg(array("result" => true, "msg" => "Datos guardados con éxito",
                "id" => $newid
                    )
            );
            return $newid;
        } else {
            $this->setMsg(array("result" => false, "msg" => "Error, no se pudo crear el registro"
                    )
            );
            return false;
        }
    }

    /**
     * 	@author Sebastian Balestrini
     * 	@version 1.0
     *
     * 	Realiza Update de un registro
     *
     * 	@param mixed $record Arreglo que contiene todos los campos para su actualizacion
     * 	@param int $id PrimaryKey del registro a actualizar.
     *
     * 	@return booelan Retorna verdadero o falso segun se haya o no realizado el UPDATE correctamente
     */
    /* public function update($record,$id = NULL) {

      // Si el param ID es null, entonces se presupone que la primer componente del arreglo $record ser� el ID
      if (is_null($id)){
      $id = array_shift ( $record );
      } else{
      $id = $record[$this->id];
      }

      $result = parent::update($record,$id);

      return $result;
      } */

    /**
     * 	@author Sebastian Balestrini
     * 	@version 1.0
     * 	
     * 	Elimina un registro de la tabla alumnos
     * 	
     * 	@return booelan Retorna verdadero o falso segun se haya o no realizado el DELETE correctamente
     */
    public function delete($id, $force = false) {

        return parent::delete($id, $force);
    }

    /**
     * 	@author Emanuel del Barco
     * 	@version 1.0
     * 	
     * 	Combos general de estados posibles de las entidades
     * 	
     * 	@return array
     */
    public function getComboEstados($todos = false) {

        if ($todos) {
            return array(-1 => "Todos", 1 => "Activos", 0 => "Inactivos");
        } else {
            return array(1 => "Activos", 0 => "Inactivos");
        }
    }

    /**
     *    Averigua si un campo del registro es unico
     * 
     *    Si no existe devuelve verdadero, de lo contrario falso         		 
     *
     *
     * */
    public function validateUnique($field, $value, $id = NULL) {


        $table = $this->getTable();
        $f_id = $this->getId();

        if (is_null($id)) {
            $rs = $this->db->Execute("SELECT COUNT(*) AS qty FROM $table WHERE  $field= ?", [$value]);
        } else {
            $rs = $this->db->Execute("SELECT COUNT(*) AS qty FROM $table WHERE $f_id<>? AND $field=?", [$id, $value]);
        }

        if ($rs) {
            $result = $rs->FetchRow();

            if ($result["qty"] > 0) {

                return false;
            } else {
                return true;
            }
        } else {
            return false;
        }
    }

    /**
     *    Averigua si un conjunto de campo = valor son unicos
     * 
     *    Si no existe devuelve verdadero, de lo contrario falso         		 
     *
     *
     * */
    public function validateUniqueAr($values, $id = NULL) {

        $table = $this->getTable();
        $f_id = $this->getId();

        $condition = "";

        //for ($i=0;$i<count($values) ;$i++ ) {
        foreach ($values as $field => $value) {

            if ($condition == "") {
                $condition .= "$field='$value'";
            } else {
                $condition .= " AND $field='$value'";
            }
        }


        if (is_null($id)) {

            $rs = $this->db->Execute("SELECT COUNT(*) AS qty FROM $table WHERE  $condition ");
        } else {
            $rs = $this->db->Execute("SELECT COUNT(*) AS qty FROM $table WHERE $f_id<>'$id' AND ($condition) ");
        }

        if ($rs) {
            $result = $rs->FetchRow();

            if ($result["qty"] > 0) {

                return false;
            } else {
                return true;
            }
        } else {
            return false;
        }
    }

}

// EndClass
?>