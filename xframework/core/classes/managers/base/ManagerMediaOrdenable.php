<?php

/**
 * 	@autor Xinergia
 * 	@version 1.0
 * 	
 *
 */
// Incluimos la superclase Gestor
require_once(path_managers("base/ManagerMedia.php"));

/**
 * @autor Xinergia
 * @version 1.0
 * Class ManagerMediaOrdenable
 * 
 */
class ManagerMediaOrdenable extends ManagerMedia {

    private $parent_name = NULL;

    /*
     * 	@author Xinergia <info@e-xinergia.com>
     *
     *   Inserta un nuevo registro/si se subio un archivo ste lo asocia
     *           
     *
     *   @return int|boolean id del usuario creado o false en caso de error
     *
     */

    public function insert($request) {


        if (!is_null($this->parent_name)) {
            $parent = $request[$this->parent_name];
        } else {
            $parent = NULL;
        }


        $request["orden"] = $this->getOrdenUltimoValor($parent) + 1;

        $id = parent::insert($request);

        return $id;
    }

    /**
     * Ordenar, obtiene el orden de ultimo registro 
     *
     * */
    protected function getOrdenUltimoValor($parent = NULL) {


        if (!is_null($parent) && !is_null($this->parent_name)) {
            $rs = $this->db->Execute(sprintf("SELECT MAX(orden) AS ultimo FROM %s WHERE %s = '%s'", $this->getTable(), $this->parent_name, $parent));
        } else {
            $rs = $this->db->Execute(sprintf("SELECT MAX(orden) AS ultimo FROM %s", $this->getTable()));
        }


        if ($rs) {
            $result = $rs->FetchRow();
            return $result["ultimo"];
        } else {
            return 0;
        }
    }

    /**
     * Ordenar, obtiene el primer orden para un rango
     *
     * */
    private function getOrdenPrimerValor($parent = NULL) {

        if (!is_null($parent) && !is_null($this->parent_name)) {
            $rs = $this->db->Execute(sprintf("SELECT  MIN(orden) AS primero FROM %s WHERE %s = '%s'", $this->getTable(), $this->parent_name, $parent));
        } else {
            $rs = $this->db->Execute(sprintf("SELECT MIN(orden) AS primero FROM %s", $this->getTable()));
        }


        if ($rs) {
            $result = $rs->FetchRow();
            return $result["primero"];
        } else {
            return 0;
        }
    }

    /**
     * Ordenar, mueve en uno el orden hacia arriba
     *
     * */
    public function moverOrdenArriba($id) {

        $record = $this->get($id);

        if (is_null($this->parent_name)) {
            $parent = NULL;
        } else {
            $parent = $record[$this->parent_name];
        }

        if ($record["orden"] > 1 && $record["orden"] != $this->getOrdenPrimerValor($parent)) {

            $orden_nuevo = $record["orden"] - 1;

            $record_viejo = $this->getRecordByOrden($orden_nuevo, $parent);

            if ($record_viejo) {
                $this->setOrden($record_viejo[$this->getId()], $record["orden"], $parent);
            }

            $this->setOrden($id, $orden_nuevo, $parent);


            $this->setMsg(["msg" => "Actualizando", "result" => true]);
        } else {

            $this->setMsg(["msg" => "No hay valores para ordenar", "result" => false]);
        }

        return;
    }

    /**
     * Ordenar, mueve en uno el orden hacia Abajo
     *
     * */
    public function moverOrdenAbajo($id) {

        $record = $this->get($id);

        if (is_null($this->parent_name)) {
            $parent = NULL;
        } else {
            $parent = $record[$this->parent_name];
        }

        if ($record["orden"] != $this->getOrdenUltimoValor($parent)) {

            $orden_nuevo = $record["orden"] + 1;

            $record_viejo = $this->getRecordByOrden($orden_nuevo, $parent);

            if ($record_viejo) {
                $this->setOrden($record_viejo[$this->getId()], $record["orden"], $parent);
            }

            $this->setOrden($id, $orden_nuevo, $parent);

            $msg = array("result" => true);
            $msg["msg"] = sprintf("Actualizado");

            $this->setMsg(["msg" => "Actualizando", "result" => true]);
        } else {

            $this->setMsg(["msg" => "No hay valores para ordenar", "result" => false]);
        }


        return;
    }

    /**
     * Ordenar, obtiene un usuario para un orden y rango
     *
     * */
    private function getRecordByOrden($orden, $parent = NULL) {

        if (!is_null($parent) && !is_null($this->parent_name)) {
            $rs = $this->db->Execute(sprintf("SELECT *  FROM %s WHERE  orden = $orden AND %s = '%s'", $this->getTable(), $this->parent_name, $parent));
        } else {
            $rs = $this->db->Execute(sprintf("SELECT *  FROM %s WHERE orden = $orden", $this->getTable()));
        }

        if ($rs) {
            $result = $rs->FetchRow();
            return $result;
        } else {
            return false;
        }
    }

    /**
     * Ordenar, Establece si es posible un orden especifico
     *
     * */
    public function setOrden($id, $orden, $parent) {


        if ((int) $orden > 0) {

            $record = $this->get($id);

            $ultimo = $this->getOrdenUltimoValor($parent);

            if ($orden > $ultimo && $ultimo > 0) {
                $orden = $ultimo + 1;
            }

            $this->setMsg(["msg" => "Ordenado exitosamente", "msg" => true]);

            return $this->db->Execute(sprintf("UPDATE %s SET orden=$orden WHERE %s=$id", $this->getTable(), $this->getId()));
        } else {
            $this->setMsg(["msg" => "Imposible ordenar", "msg" => true]);
        }
    }

    /**
     *
     *  Segun los parametros de request
     *  Realiza una acción un otra           
     *
     * */
    public function doOrden($request) {

        $id = (int) $request['id'];
        $do_action = $request['do_action'];


        if ($do_action == "up") {
            return $this->moverOrdenArriba($id);
        } else if ($do_action == "down") {
            return $this->moverOrdenAbajo($id);
        }
    }

    /**
     *
     * */
    public function setOrderParentName($name = NULL) {
        $this->parent_name = $name;
    }

    /**
     *
     * */
    public function getOrderParentName() {
        return $this->parent_name = $name;
    }

}

//END_class 
?>