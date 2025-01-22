<?php

/**
 *  AbstractManager
 *
 *  Superclase Abstracta que abstrae los comportamientos genericos que pueden realizarse sobre las tablas.
 *
 *  @author Sebastian Balestrini <sbalestrini@gmail.com>
 *  @version 1.0 2010-01-01
 *
 */
class AbstractManager {

    protected $db;
    //protected $smarty =  NULL;
    protected $table;
    protected $id = NULL;
    protected $flag = NULL;
    protected $default_paginate = NULL;
    protected $msg;

    /**
     * 	@author Sebastian Balestrini
     * 	@version 1.0
     *
     * 	Constructor de la clase
     *
     * 	@params mixed $db Instancia de Adodb
     * 	@params string $table Nombre de la tabla sobre a que actuar� el Manager
     * 	@params string $id nombre del campo que es clave primaria
     * 	@params string $flag Nombre de el campo flag de la tabla
     *
     * 	@return mixed Deuelve una instancia de Manager
     */
    function __construct($db, $table, $id, $flag = NULL) {

        $this->db = $db;
        $this->msg = "";

        $this->setTable(strtolower($table));
        $this->setId($id);

        // El flag se utiliza para determinar si est� activo o no el registro. En base a esto podemos hacer bajas logicas o fisicas
        if (!is_null($flag)) {
            $this->flag = $flag;
        }

        $this->default_paginate = $table . "_list";
        if (TRADUCCION_IDIOMA == "en") {
            $this->idioma_col = "_en";
        }
    }

    /**
     * 	@author Sebastian Balestrini
     * 	@version 1.0
     *
     * 	Abstrae la funcionalidad de INSERT sobre un registro en la Base de Datos
     *
     * 	@param array $record Arreglo que contiene todos los campos a insertar
     * 	@return int|false Retorna el ID Insertado o false en caso contrario
     */
    public function insert($record) {

        //checkar
        $this->stripslashes_array($record);

        $result = $this->db->AutoExecute($this->table, $record, 'INSERT');

        // Guardamos la salida y limpiamos el buffer
        $salida = $_SESSION["last_auxoexecute"];

        if ($result) {

            $newid = $this->db->Insert_ID();


            $this->setMsg(array("result" => true, "msg" => "Datos guardados con éxito", "id" => $newid));

            //paginacion x defecto // OJO, si no es x defecto habria que repaginar                            
            if (!is_null($this->default_paginate)) {
                $this->rePaginate($this->default_paginate);
            }

            return $newid;
        } else {
            $this->setMsg(array("result" => false, "msg" => "Error, no se pudo crear el registro"));
            return false;
        }
    }

    /**
     * 	@author Sebastian Balestrini
     * 	@version 1.0
     *
     * 	Elimina un registro de la tabla
     *
     * 	@param int $id Primary Key del registro a eliminar
     * 	@return boolean $force Flag que indica forzar el borrado fisico.
     *
     * 	@return booelan verdadero o falso segun se haya o no realizado el DELETE correctamente
     */
    public function delete($id, $force = false) {


        if (is_null($this->flag) || $force) {



            // Realizamos la Consulta de Eliminacion
            $delete = sprintf("DELETE FROM %s WHERE %s = %d", $this->table, $this->id, $this->db->toSQL($id, "int"));


            $result = $this->db->Execute($delete);
        } else {
            $result = $this->suspend($id);
        }

        if ($result) {

            //paginacion x defecto // OJO, si no es x defecto habria que repaginar                            
            if (!is_null($this->default_paginate)) {
                $this->rePaginate($this->default_paginate);
            }


            $this->setMsg(array("result" => true, "msg" => "Registro ELIMINADO con éxito"));

            return true;
        } else {

            $this->setMsg(array("result" => false, "msg" => "Error, no se pudo ELIMINAR el registro"));
            return false;
        }
    }

    /**
     * 	@author Sebastian Balestrini
     * 	@version 1.0
     * 	
     * 	Realiza baja de multiples registros
     * 	
     * 	@return booelan Retorna verdadero o falso segun se haya o no realizado el DELETE correctamente
     */
    public function deleteMultiple($ids, $force = false) {

        $records = explode(",", $ids);

        if (count($records) == 0) {

            $this->setMsg(array("result" => false, "msg" => "No se han seleccionado registros para la borrar"));

            return false;
        } else {

            foreach ($records as $id) {
                $this->delete($id, $force);
            }


            $this->setMsg(array("result" => true, "msg" => "Se dió de baja el/los registros del sistema"));


            return true;
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
    public function update($record, $id = NULL) {

        // Si el param ID es null, entonces se presupone que la primer componente del arreglo $record ser� el ID
        if (is_null($id)) {
            $id = array_shift($record);
        }

        $this->stripslashes_array($record);

        $result = $this->db->AutoExecute($this->table, $record, 'UPDATE', sprintf("%s = %d", $this->id, $id));

        if ($result) {

            //paginacion x defecto // OJO, si no es x defecto habria que repaginar                            
            if (!is_null($this->default_paginate)) {
                $this->rePaginate($this->default_paginate);
            }


            $this->setMsg(array("result" => true, "msg" => "Registro actualizado con éxito", "id" => $id));
        } else {
            $this->setMsg(array("result" => false, "msg" => "Error, no se pudo actualizar el registro"));
        }

        if ($result) {
            return $id;
        } else {
            return false;
        }
    }

    /**
     * 	@author Emanuel del Barco
     * 	@author Sebastian Balestrini
     * 	@version 1.0
     *
     * 	Procesa peticiones al manager. Insert o update segun el caso.
     * 	Para clases que hereden, puede tener un comportamiento totalmente diferente.
     *
     * 	@params mixed $request Arreglo Asociativo que contiene todos los de insersion o actualizacion
     *
     * 	@return string mensaje de exito o de falla
     */
    public function process($request) {

        //verificamos si es update o insert
        if (isset($request[$this->id]) && $request[$this->id] != "") {
            $result = $this->update($request, $request[$this->id]);
        } else {
            $result = $this->insert($request);
        }
        //mensajes por defecto si insert o update no lo modificaron.
        if ($result && $this->getMsg() == "") {
            $this->setMsg("[true]ok[true]");

            $this->setMsg(array("result" => true, "msg" => "ok"));
        } else if ($this->getMsg() == "") {

            $this->setMsg(array("result" => false, "msg" => "error"));
        }
        return $result;
    }

    /**
     * 	@author Sebastian Balestrini
     * 	@version 1.0
     *
     * 	Obtiene la lista de registros, puede ser de una tabla (si no esta definido el from de la consulta)
     * 	o una vista (si ya se definio el from)
     *
     * 	@param $query $mixed $consulta Clase Sql, trae la consulta sql
     * 	@param boolean $useFlag Flag que indica si se usa la bandera de activo en la lista
     * 	@param string $idpaginate Id de paginacion de SmartyPaginate. En caso de q querramos
     * 	paginar la lista.
     * 	@return mixed Retorna un arreglo de registros o False en caso contrario
     */
    public function getList($query = NULL, $useFlag = false, $idpaginate = NULL, $paramsBind = null) {
        // Verificams que la $query est� vacia o no
        if (is_null($query)) {
            $query = new AbstractSql();
        }
        // Si la tabla utiliza un Flag de Activo/Suspendido, lo agregamos a la $query
        /* if ($useFlag){
          $query->addAnd($this->getSqlFlag());
          } */
        //si el from es null se setea el nombre de la tabla de la instancia actual
        if (is_null($query->getFrom()))
            $query->setFrom($this->table);

        // Obtenemos el String de la consulta
        $sql = $query->getSql();

        // Si no hay paginacion hacemos una consulta com�n
        if (is_null($idpaginate)) {
            $rs = $this->db->Execute($sql, $paramsBind);
        } else {


            $qStored = SmartyPaginate::getQuery($idpaginate);

            if (!is_null($qStored)) {

                $query->fromArray($qStored);

                $query->setLimit(SmartyPaginate::getCurrentIndex($idpaginate) . "," . SmartyPaginate::getLimit($idpaginate));

                $rs = $this->db->Execute($query->getSql(), $paramsBind);

                $result["records"] = SmartyPaginate::getTotal($idpaginate);

                $result["page"] = SmartyPaginate::getCurrentPage($idpaginate);

                $result["total"] = SmartyPaginate::getPageTotal($idpaginate);
            } else {


                //limpio el limit para que no aplique si hay uno guardado    
                $sql = $query->getSql();

                //calculamos el total de la consulta para paginar.
                $rs = $this->db->selectLimit($sql, SmartyPaginate::getLimit($idpaginate), SmartyPaginate::getCurrentIndex($idpaginate));

                $rsTotal = $this->db->Execute($sql, $paramsBind);

                $result["records"] = $rsTotal->RecordCount();

                SmartyPaginate::setTotal($result["records"], $idpaginate);

                SmartyPaginate::setSQL($sql, $idpaginate);

                $result["page"] = SmartyPaginate::getCurrentPage($idpaginate);

                $result["total"] = SmartyPaginate::getPageTotal($idpaginate);

                $query->setLimit(SmartyPaginate::getCurrentIndex($idpaginate) . "," . SmartyPaginate::getLimit($idpaginate));


                SmartyPaginate::setQuery($query->toArray(), $idpaginate);
                SmartyPaginate::storeRequest($idpaginate);
            }


            /*   //calculamos el total de la consulta para paginar.
              $rs = $this->db->SelectLimit($sql, SmartyPaginate::getLimit($idpaginate), SmartyPaginate::getCurrentIndex($idpaginate));
              $rsTotal = $this->db->Execute($sql);

              //echo "CURRENT ".SmartyPaginate::getCurrentIndex($idpaginate);

              //echo "$sql";

              SmartyPaginate::setTotal($rsTotal->RecordCount(), $idpaginate);
              SmartyPaginate::setSQL($sql, $idpaginate);
             */
        }

        // Variable donde se gaurdar�n los resultados de la consulta
        $records = array();
        // Iteramos sobre el resultado y armamos el arreglo que vamos a retornar
        if ($rs)
            while (!$rs->EOF) {
                $records[] = $rs->FetchRow();
            }

        return $records;
    }

    /**
     * 	@author Emanel del Barco
     * 	@version 1.0
     *
     * 	Obtiene la lista de registros en formato JOSON para utilizar el componente jqGrid, 
     * 	
     *
     * 	@param $query $mixed $consulta Clase Sql, 
     * 	@param array $return_field son los campos que se deben devolver a la gruilla, si no no funciona ;)
     * 	@param string $idpaginate Id de paginacion de SmartyPaginate. En caso de q querramos
     * 	paginar la lista.
     * 	@param array $request parametros para realizar busqueda
     * 			
     * 	@return mixed Retorna un arreglo de registros o False en caso contrario
     */
    public function getListPaginado($query, $idpaginate = NULL) {


        //print_r($_SESSION['SmartyPaginate'][$idpaginate]);

        $result = array(
            "total" => "0",
            "records" => "0",
            "page" => "0",
            "rows" => array()
        );


        // Si no hay paginacion hacemos una consulta com�n
        if (is_null($idpaginate)) {

            $sql = $query->getSql();

            $rs = $this->db->Execute($sql);

            $result["total"] = $rs->RecordCount();
        } else {

            $qStored = SmartyPaginate::getQuery($idpaginate);

            if (!is_null($qStored)) {

                $query->setLimit(SmartyPaginate::getCurrentIndex($idpaginate) . "," . SmartyPaginate::getLimit($idpaginate));

                $rs = $this->db->Execute($query->getSql());

                $result["records"] = SmartyPaginate::getTotal($idpaginate);

                $result["page"] = SmartyPaginate::getCurrentPage($idpaginate);

                $result["total"] = SmartyPaginate::getPageTotal($idpaginate);
            } else {

                //limpio el limit para que no aplique si hay uno guardado    
                $sql = $query->getSql();

                //calculamos el total de la consulta para paginar.
                $rs = $this->db->selectLimit($sql, SmartyPaginate::getLimit($idpaginate), SmartyPaginate::getCurrentIndex($idpaginate));

                $rsTotal = $this->db->Execute($sql);

                $result["records"] = $rsTotal->RecordCount();

                SmartyPaginate::setTotal($result["records"], $idpaginate);

                SmartyPaginate::setSQL($sql, $idpaginate);

                $result["page"] = SmartyPaginate::getCurrentPage($idpaginate);

                $result["total"] = SmartyPaginate::getPageTotal($idpaginate);

                $query->setLimit(SmartyPaginate::getCurrentIndex($idpaginate) . "," . SmartyPaginate::getLimit($idpaginate));

                SmartyPaginate::setQuery($query->toArray(), $idpaginate);
            }
        }

        if ($rs) {

            while (!$rs->EOF) {

                $record = $rs->FetchRow();

                $rows[] = $record;
            }

            $result["rows"] = $rows;
        }



        //si no hay registros fuerzo la pagina a 0
        if ($result["total"] == 0) {
            $result["page"] = 0;
        }


        return $result;
    }

    /**
     * 	@author Emanel del Barco
     * 	@version 1.0
     *
     * 	Obtiene la lista de registros en formato JOSON para utilizar el componente jqGrid, 
     * 	
     *
     * 	@param $query $mixed $consulta Clase Sql, 
     * 	@param array $return_field son los campos que se deben devolver a la gruilla, si no no funciona ;)
     * 	@param string $idpaginate Id de paginacion de SmartyPaginate. En caso de q querramos
     * 	paginar la lista.
     * 	@param array $request parametros para realizar busqueda
     * 			
     * 	@return mixed Retorna un arreglo de registros o False en caso contrario
     */
    public function getJSONList($query, $return_fields, $request, $idpaginate = NULL) {



        //print_r($_SESSION['SmartyPaginate'][$idpaginate]);

        $result = array(
            "total" => "0",
            "records" => "0",
            "page" => "0",
            "rows" => array()
        );

        if (is_array($request) && isset($request["do_reset"]) && ($request["do_reset"] == 1)) {

            $this->rePaginate($idpaginate);
        }

        // Si no hay paginacion hacemos una consulta com�n
        if (is_null($idpaginate)) {

            //si viene order by!


            if (isset($request["sidx"]) && isset($request["sord"])) {
                $query->setOrderBy($request["sidx"] . " " . $request["sord"]);
            }

            $sql = $query->getSql();

            $rs = $this->db->Execute($sql);

            $result["total"] = $rs->RecordCount();
        } else {

            //siempre viene order by!                

            if (isset($request["sidx"]) && isset($request["sord"])) {
                $query->setOrderBy($request["sidx"] . " " . $request["sord"]);
            }


            $qStored = SmartyPaginate::getQuery($idpaginate);

            if (!is_null($qStored)) {

                $query->setLimit(SmartyPaginate::getCurrentIndex($idpaginate) . "," . SmartyPaginate::getLimit($idpaginate));

                $rs = $this->db->Execute($query->getSql());

                $result["records"] = SmartyPaginate::getTotal($idpaginate);

                $result["page"] = SmartyPaginate::getCurrentPage($idpaginate);

                $result["total"] = SmartyPaginate::getPageTotal($idpaginate);
            } else {


                //limpio el limit para que no aplique si hay uno guardado    
                $sql = $query->getSql();

                //calculamos el total de la consulta para paginar.
                $rs = $this->db->selectLimit($sql, SmartyPaginate::getLimit($idpaginate), SmartyPaginate::getCurrentIndex($idpaginate));

                $rsTotal = $this->db->Execute($sql);

                $result["records"] = $rsTotal->RecordCount();

                SmartyPaginate::setTotal($result["records"], $idpaginate);

                SmartyPaginate::setSQL($sql, $idpaginate);

                $result["page"] = SmartyPaginate::getCurrentPage($idpaginate);

                $result["total"] = SmartyPaginate::getPageTotal($idpaginate);

                $query->setLimit(SmartyPaginate::getCurrentIndex($idpaginate) . "," . SmartyPaginate::getLimit($idpaginate));

                SmartyPaginate::setQuery($query->toArray(), $idpaginate);
            }
        }
        // Iteramos sobre el resultado y armamos el arreglo que vamos a retornar
        if ($rs) {

            $cell = array();

            while (!$rs->EOF) {

                $my_cell = array();

                $record = $rs->FetchRow();

                $cell["id"] = $record[$this->getId()];

                //acciones
                $my_cell[] = "";

                foreach ($return_fields as $field) {
                    $my_cell[] = $record[$field];
                }

                $cell["cell"] = $my_cell;
                $rows[] = $cell;
            }

            $result["rows"] = $rows;
        }

        //si no hay registros fuerzo la pagina a 0
        if ($result["total"] == 0) {
            $result["page"] = 0;
        }

        //$this->print_r($result);               

        return json_encode($result);
    }

    /**
     * 	@author Sebastian Balestrini
     * 	@version 1.0
     *
     * 	Obtiene para ser utilizada en un combo.
     * 	La lista esta compuesta por dos campos Combo_id = clave unica de la tabla y Combo_descripcion = Descripcion del campo.
     *
     *
     * 	@param AbstractSQL $query Objeto con la consutla correspondiente
     * 	@param boolean $useFlag  Indica si es que se la tabla tiene, usar la bandera para filtrar los registros inactivos
     *
     * 	@return mixed Retorna un arreglo de registros o False en caso contrario
     */
    public function getComboBox($query, $useFlag = true) {

        if ($useFlag) {
            $query->setFrom($this->table);
            $query->addAnd($this->flag);
        }
        if ($query->getFrom() == "") {
            $query->setFrom($this->table);
        }
        $select_original = $query->getSelect();
        $campos = array();

        $posComa = strpos($select_original, ',');
        // como se buscan dos campos separamos en dos campos Combo_id y  Combo_descripcion para q sea general.
        $campos[0] = substr($select_original, 0, $posComa); //desde el comienzo hasta la coma
        $campos[1] = substr($select_original, $posComa + 1, strlen($select_original)); //desde la coma hasta el final
        $query->setSelect(sprintf(' %s as Combo_id , %s  as Combo_descripcion ', $campos[0], $campos[1]));


        $rs = $this->db->Execute($query->getSql());

        // Variable donde se gaurdar�n los resultados de la consulta
        $recrds = array();

        if ($rs)
            while (!$rs->EOF) {
                $record_temp = $rs->FetchRow();
                $recrds[$record_temp['Combo_id']] = $record_temp['Combo_descripcion'];
            }

        return $recrds;
    }

    /**
     * 	@author Sebastian Balestrini
     * 	@version 1.0
     *
     *
     * 	Devuelve los n ultimos registros agregados
     *
     * 	@param integer $n M�ximo n�mero de elementos a devolver
     * 	@param object $AbstractSql class Opcionalmente puede recibir un query
     *
     * 	@return mixed Retorna un arreglo de registros
     */
    public function getLatest($n = 10, $query = NULL, $only_record = false) {

        if (is_null($query)) {

            $query = new AbstractSql();
            $query->setSelect("*");
            $query->setFrom($this->table);
            $query->setOrderBy($this->id . " DESC");
        }

        $query->setLimit("0,$n");

        return $this->getList($query);
    }

    /**
     * 	@author Emanuel del Barco
     * 	@version 1.0
     *
     * 	Devuelve el ultimo elemento teniendo en cuenta la clave principal
     * 	El ultimo elemento se considera el de id mas alto
     *
     * 	@return mixed Retorna un arreglo que corresponde a los campos del regsitro mas actual
     */
    public function getLastOne() {

        $rs = $this->db->Execute(sprintf("SELECT *	FROM %s WHERE %s = (SELECT MAX(%s) FROM %s)", $this->table, $this->id, $this->id, $this->table));
        if ($rs) {
            return $rs->FetchRow();
        } else {
            return false;
        }
    }

    /**
     * 	@author Sebastian Balestrini
     * 	@version 1.0
     *
     * 	Obtiene un registro
     *
     * 	@param int $id clave principal del alumno
     * 	@param string $consulta instancia de la clase SQL
     * 	@param string $alias alias de la tabla dentro del join
     *
     * 	@return mixed Retorna un registro o False en caso contrario
     */
    public function get($id, $query = NULL, $alias = NULL) {

        // Si no recibimos una $query creamos una nueva instancia de �sta
        if (is_null($query)) {
            $query = new AbstractSql;
        }
        // Si no hay from, obtenemos el de la entidad actual
        if (is_null($query->getFrom())) {
            $query->setFrom($this->table);
        }

        if (is_null($alias)) {

            if (is_int($id))
                $query->setWhere(sprintf(" %s = %d", $this->id, $this->db->toSQL($id, "int")));
            else
                $query->setWhere(sprintf(" %s = %s", $this->id, $this->db->toSQL($id, "text")));
        } else {

            if (is_int($id))
                $query->setWhere(sprintf(" %s = %d", $alias . "." . $this->id, $this->db->toSQL($id, "int")));
            else
                $query->setWhere(sprintf(" %s = %s", $alias . "." . $this->id, $this->db->toSQL($id, "text")));
        }

        $sql = $query->getSql();
        $rs = $this->db->Execute($sql);

        if ($rs) {
            return $rs->FetchRow();
        } else {
            return false;
        }
    }

    /**
     * 	@author Emanuel del Barco
     * 	@version 1.0
     *
     * 	Obtiene un registro a partir de un campo con indice unico
     *
     * 	@param string $value Valor por el cual se buscar�
     * 	@param string $field Nombre del campo por el cual se obtendr� el registro
     *
     * 	@return mixed Retorna un registro o False en caso contrario
     */
    public function getByField($field, $value) {

        $query = new AbstractSql;
        $query->setFrom($this->table);

        $query->setWhere(sprintf(" %s = %s", $field, $this->db->toSQL($value, "text")));

        $sql = $query->getSql();
        $rs = $this->db->Execute($sql);

        if ($rs)
            return $rs->FetchRow();
        else
            return false;
    }

    /**
     * 	@author Emanuel del Barco
     * 	@version 1.0
     *
     * 	Obtiene un registro a partir de un campos con indice unico obtenidos de un array
     *
     * 	@param type $values Array de Valores por el cual se buscar�
     * 	@param type $fields Array del Nombre del campo por el cual se obtener el registro
     *
     * 	@return mixed Retorna un registro o False en caso contrario
     */
    public function getByFieldArray($fields, $values) {

        $query = new AbstractSql;
        $query->setFrom($this->table);

        $query->setWhere("1=1");
        if (count($fields) != count($values)) {
            return false;
        }
        foreach ($fields as $key => $field) {
            $value = $values[$key];
            $query->addAnd(sprintf(" %s = %s", $field, $this->db->toSQL($value, "text")));
        }

        $sql = $query->getSql();
        $rs = $this->db->Execute($sql);

        if ($rs)
            return $rs->FetchRow();
        else
            return false;
    }

    /**
     * 	@author Sebastian Balestrini
     * 	@version 1.0
     *
     * 	Setea los parametros de paginacion
     *
     * 	@param object $smarty Referencia a la instancia de smarty
     * 	@param string $idpaginte ID de paginacion
     * 	@param inteneger $limit Limite de la pagniacion.
     * 	@param boolean $seo Flag que indica si utilizaremos paginacion SEO o no
     *
     * 	@return void
     */
    public function paginate($idpaginate = 'default', $limit = 1, $seo = false) {

        //si paginate es default, busco si se definio default_paginate para el manager
        if ($idpaginate == "default" && !is_null($this->default_paginate)) {
            $idpaginate = $this->default_paginate;
        }


        // required connect
        SmartyPaginate::connect($idpaginate);

        // para paginacion seo
        SmartyPaginate::setSEO($seo, $idpaginate);

        // Setea la cantidad de items por p�gina
        SmartyPaginate::setLimit($limit, $idpaginate);

        SmartyPaginate::assign(SmartySingleton::getInstance(), 'paginate', $idpaginate);

        SmartyPaginate::setGetparameter($idpaginate);
    }

    /**
     * 	@author Emanuel del Barco
     * 	@version 1.0
     *
     * 	Resetea la paginacion
     *
     * 	@param string $idpaginate ID de la paginacion.
     *
     * 	@return void
     */
    public function resetPaginate($idpaginate = 'default') {
        SmartyPaginate::reset($idpaginate);
    }

    /**
     * 	@author Emanuel del Barco
     * 	@version 1.0
     *
     * 	Recalcula los todales para una paginaci�n
     *
     * 	@param string $idpaginate ID de la paginacion.
     *
     * 	@return void
     */
    public function rePaginate($idpaginate) {

        if (SmartyPaginate::isConnected($idpaginate)) {

            $arQuery = SmartyPaginate::getQuery($idpaginate);

            if (is_array($arQuery)) {

                //quito el limit para que recalcule sobre el total de registros
                unset($arQuery["limit"]);

                $query = new AbstractSql();

                $query->fromArray($arQuery);

                $sql = $query->getSql();

                $rsTotal = $this->db->Execute($sql);

                $result["records"] = $rsTotal->RecordCount();

                SmartyPaginate::setTotal($result["records"], $idpaginate);
            }
        }
    }

    /**
     * 	@author Sebastian Balestrini
     * 	@version 1.0
     *
     * 	Setea el campo Bandera de una Tabla en 0 para que aparezca suspendido (Baja logica)
     *
     * 	@param int $id Valor de la Clave Principal
     *
     * 	@return boolean  Verdadero/falso segun se haya o no podido realizar la actualizacion
     */
    public function suspend($id) {

        $registro[$this->flag] = 0;

        // Condicion a Evaluar e la Sentencia UPDATE
        $where = sprintf("%s = %d", $this->id, $this->db->toSQL($id, "int"));

        $result = $this->db->AutoExecute($this->table, $registro, 'UPDATE', $where);

        if ($result) {

            $this->setMsg(array("result" => true, "msg" => "Registro SUSPENDIDO con éxito"));
            return true;
        } else {
            $this->setMsg(array("result" => false, "msg" => "Error, no se pudo SUSPENDER el registro"));
            return false;
        }

        return $id;
    }

    /**
     * 	@author Sebastian Balestrini
     * 	@version 1.0
     *
     * 	Activa un registro previamente suspendido
     *
     * 	@param string $id Valor de la Clave Principal
     *
     * 	@return boolean Devuelve true o false segun se haya podido o no activar el registro
     */
    public function activate($id) {

        $record[$this->flag] = 1;

        // Condicion a Evaluar e la Sentencia UPDATE
        $sql = sprintf("%s = %d", $this->id, $this->db->toSQL($id, "int"));

        $result = $this->db->AutoExecute($this->table, $record, 'UPDATE', $sql);

        if ($result) {
            $this->setMsg(array("result" => true, "msg" => "Registro ACTIVADO con éxito"));
            return true;
        } else {
            $this->setMsg(array("result" => false, "msg" => "Error, no se pudo ACTIVAR el registro"));
            return false;
        }
    }

    /**
     * 	@author Sebastian Balestrini
     * 	@version 1.0
     *
     * 	Devuelve si un registro est� o no activo
     *
     * 	@param int $id Clave primaria del registro
     *
     * 	@return boolean Devuelve true si el registro est� activo
     */
    public function isActive($id) {

        if (is_null($flag)) {
            return false;
        } else {
            $sql = sprintf("SELECT %s FROM %s WHERE %s = %d", $this->flag, $this->table, $this->id, $this->db->toSQL($id, "int"));
            $rs = $this->db->Execute($sql);
        }
        if ($row = $rs->FetchRow())
            return $row[$this->flag];
        else
            return false;
    }

    /**
     * 	@author Sebastian Balestrini
     * 	@version 1.0
     *
     * 	Setea la variable privada $tabla
     *
     * 	@param string $tabla Nombre de la Tabla que manipular�
     *
     * 	@return void
     */
    protected function setTable($table) {
        $this->table = $table;
    }

    /**
     * 	@author Sebastian Balestrini
     * 	@version 1.0
     *
     * 	Setea la variable privada $tabla
     *
     * 	@return string Nombre de la Tabla que manipular�
     */
    public function getTable() {
        return $this->table;
    }

    /**
     * 	@author Sebastian Balestrini
     * 	@version 1.0
     *
     * 	Setea la variable privada $id
     *
     * 	@param string $id Nombre de la clave primaria que manipular�
     *
     * 	@return void
     */
    protected function setId($id) {
        $this->id = $id;
    }

    /**
     * 	@author Sebastian Balestrini
     * 	@version 1.0
     *
     * 	Setea la variable privada $id
     *
     * 	@param string $id Nombre de la clave primaria que manipular�
     *
     * 	@return void
     */
    public function getId() {
        return $this->id;
    }

    /**
     * 	@author Sebastian Balestrini
     * 	@version 1.0
     *
     * 	Setea la uinstancia ADOdb de la Base de Datos
     *
     * 	@param miced $db Instancia ADOdb
     *
     * 	@return void
     */
    protected function setDb($db) {
        $this->db = $db;
    }

    /**
     * 	@author Sebastian Balestrini
     * 	@version 1.0
     *
     * 	Setea la variable privada $bandera
     *
     * 	@param string $bandera Nombre del campo que es Bandera en la tabla
     *
     * 	@return void
     */
    public function setFlag($flag) {
        $this->flag = $flag;
    }

    /**
     * 	@author Sebastian Balestrini
     * 	@version 1.0
     *
     * 	Retorna el nombre del campo Flag de la tabla en cuestion
     *
     * 	@return string Nombre del campo que es Bandera en la tabla
     */
    public function getFlag() {
        return $this->flag;
    }

    /**
     * 	@author Sebastian Balestrini
     * 	@version 1.0
     *
     * 	@return string Descripcion del ultimo mensage guardado
     */
    public function getMsg() {

        return $this->msg;
    }

    /**
     * 	@author Sebastian Balestrini
     * 	@version 1.0
     *
     * 	Setea el mensaje del manager.
     * 	@param string $mensajeErorr Descripcion del error.
     *
     */
    public function setMsg($msg) {

        $this->msg = $msg;
    }

    /**
     * 	@author Sebastian Balestrini
     *
     * 	Recibe una fecha en formado DD/MM/AAAA y la conviete a AAAA-MM-DD
     *
     * 	@param int $inicio Inicio
     * 	@param int $desplazamiento Desplazamiento
     *
     * 	@return void
     */
    public function sqlDate($fecha, $separador = '-', $ondlyDate = false) {

        list($fecha, $hora) = explode(' ', $fecha);
        list($dd, $mm, $aa) = preg_split("/[-\/]/", $fecha);

        if (checkdate($mm, $dd, $aa)) {
            if ($ondlyDate)
                return $aa . $separador . $mm . $separador . $dd;
            else
                return $aa . $separador . $mm . $separador . $dd . " $hora";
        }
        else {
            return false;
        }
    }

    /**
     * 	@author Emanuel del Barco
     *
     * 	Recibe un array de valores (por ejemplo:$_REQUEST) se fija si magic quotes esta activado para que las comillas queden sin escapar
     *
     * 	@param array $arreglo Arrelo codificado con utf8
     *
     * 	@return array arreglo modificado
     */
    private function stripslashes_array(&$arreglo) {
        if (get_magic_quotes_gpc()) {
            foreach ($arreglo as $k => $v) {
                if (!is_array($v)) {
                    $arreglo[$k] = trim(stripslashes($v)); // str_replace("'", "''", trim(stripslashes($v)));
                } else {
                    $this->stripslashes_array($v);
                    $arreglo[$k] = $v;
                }
            }
        } else {
            foreach ($arreglo as $k => $v) {
                if (!is_array($v)) {
                    $arreglo[$k] = trim($v);
                } else {
                    $this->stripslashes_array($v);
                    $arreglo[$k] = $v;
                }
            }
        }
    }

    /**
     * 	@author Sebastian Balestrini
     * 	@author Emanuel del Barco
     *
     * 	Intenta realizar una consulta incrementando el valor de un campo de la tabla a la cual esta asociado el manager
     *
     * 	@param integer $id id del registro a incrementar
     * 	@param string $field nombre del campo q se va a incrementar
     * 	@param integer $n cantidad a incrementar.
     *
     * 	@return integer id actualizado o 0 si no se pudo
     */
    public function increase($id, $field, $n = 1) {
        $sqlUpdate = sprintf("UPDATE %s SET $field=$field+$n
                                    WHERE %s = $id", $this->table, $this->id);
        return $this->db->Execute($sqlUpdate);
    }

    /**
     * 	@author Sebastian Balestrini
     * 	@author Emanuel del Barco
     *
     * 	Intenta realizar una consulta decrementando el valor de un campo
     * 	de la tabla a la cual esta asociado el manager
     *
     * 	@param integer $id id del registro a decrementar
     * 	@param string $field nombre del campo q se va a decrementar
     * 	@param integer $n cantidad a decrementar.
     * 	@return integer id actualizado o 0 si no se pudo
     */
    public function decrease($id, $field, $n = 1) {
        $sqlUpdate = sprintf("UPDATE %s SET $field=$field-$n
                                    WHERE %s = $id", $this->table, $this->id);
        return $this->db->Execute($sqlUpdate);
    }

    /**
     * 	@author Sebastian Balestrini
     *
     * 	Setea la instancia de smarty para que el manager la pueda acceder y trabajar
     *
     * 	@param object $smarty instancia de smarty
     */
    /* 	public function setSmarty($smarty){

      $this->smarty = $smarty;
      } */

    /**
     * 	@author Sebastian Balestrini
     * 	@version 1.0
     *
     * 	Incluye e instancia un manager
     *
     * 	@return int Retorna instancia de mananger
     */
    public function getManager() {

        $num_args = func_num_args();

        if ($num_args > 0) {

            $manager = func_get_arg(0);

            //$fileManager = path_managers("$manager.php");

            if (class_exists($manager)) {

                //require_once($fileManager);

                $params = func_get_args();

                array_shift($params);

                if (count($params) > 1) {
                    $php_code = sprintf('$manager = new %s(%s);', $manager, '$this->db' . ",'" . implode("','", $params) . "'");
                } else {
                    $php_code = sprintf('$manager = new %s(%s);', $manager, '$this->db');
                }


                eval($php_code);



                eval($php_code);

                return $manager;
            } else {

                //lanzo una exepcion, el manager solicitado no existe
                throw new Exception("$manager NO ha sido definido");
                return false;
            }
        } else {
            return false;
        }
    }

    /**
     * 	@author Sebastian Balestrini
     * 	@version 1.0
     *
     * 	Realiza un print_r de un array
     *
     * 	@param string $class Nombre de la Clase
     *
     * 	@return void
     */
    public function print_r($array) {

        echo "<pre>";
        print_r($array);
        echo "</pre>";
    }

    /**
     * 	@author Sebastian Balestrini
     * 	@version 1.0
     *
     * 	Formatea una fecha con formato yyyy/mm/dd a fecha con formato valido para rss
     *
     * 	@param string $date fecha
     * 	@return string
     */
    public function getRssDate($date) {

        list($fecha, $hora) = explode(" ", $date);
        list($aaaa, $mm, $dd) = preg_split("/[-\/]/", $fecha);
        $mktime = mktime(0, 0, 0, $mm, $dd, $aaaa);
        $dateRss = date("r", $mktime);
        return $dateRss;
    }

    /**
     * 	@author Sebastian Balestrini
     * 	@version 1.0
     *
     * 	Formatea un arreglo quitando los caracteres html y los valores q peudan causar un fallo de seguridas xss
     *
     * 	return void;
     */
    public function htmlspecialchars_array(&$data) {

        foreach ($data as $key => $value) {

            if (!is_array($value)) {
                $data[$key] = htmlspecialchars(strip_tags($value));
            } else {
                $this->htmlspecialchars_array($value);
            }
        }

        return $data;
    }

    /**
     * 	@author Sebastian Balestrini
     * 	@version 1.0
     * 	
     * 	Activa un registro previamente suspendido
     * 	
     * 	@param string $id Valor de la Clave Principal
     *
     * 	@return boolean Devuelve true o false segun se haya podido o no activar el registro
     */
    function setActive($id) {

        $record[$this->flag] = 1;

        // Condicion a Evaluar e la Sentencia UPDATE
        $sql = sprintf("%s = %d", $this->id, $this->db->toSQL($id, "int"));

        $result = $this->db->AutoExecute($this->table, $record, 'UPDATE', $sql);

        if ($result) {
            $this->setMsg(array("result" => true, "msg" => "Registro ACTIVADO con éxito"));
            return true;
        } else {
            $this->setMsg(array("result" => false, "msg" => "Error, no se pudo ACTIVAR el registro"));
            return false;
        }
    }

    function debug($debug = true) {
        $this->db->debug = $debug;
    }

    /**
     * 	@author Sebastian Balestrini
     * 	@version 1.0
     *
     * 	Devuelve la paginacion por defecto del manager, si es que tiene
     * 	si no tiene devuelve null		
     *
     * 	
     * 	@return string|NULL
     */
    public function getDefaultPaginate() {

        return $this->default_paginate;
    }

}

// EndClass
?>