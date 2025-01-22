<?php

/**
 * 	@autor Xinergia
 * 	@version 1.0	29/05/2014
 * 	Manager de Las Obras Sociales - Prepagas
 *
 */
class ManagerEspecialidades extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "especialidad", "idespecialidad");
    }

    /*
     * 	@author Xinergia <info@e-xinergia.com>
     *   @version 1.0
     */

    public function insert($request) {

        $id = parent::insert($request);

        //si se crea correctamente asocio las funcionaldades y si aplica o no
        if ($id) {

            $this->setMsg(["msg" => "La Especialidad ha sido creado con éxito", "result" => true]);
        }

        return $id;
    }

    public function getListadoJSON($idpaginate = NULL, $request) {

        if (!is_null($idpaginate)) {
            $this->paginate($idpaginate, $request["rows"]);
        }

        $query = new AbstractSql();
        $query->setSelect("idespecialidad,
            especialidad,
            CASE tipo
                WHEN 1 THEN 'Especialidad médica' 
                WHEN 2 THEN 'Profesional de la salud'
            END as tipo,
            IF(acceso_directo=1,'OUI','NON') as acceso_directo,
            CASE tipo_identificacion
                WHEN 0 THEN 'RPPS' 
                WHEN 1 THEN 'ADELI' 
                WHEN 2 THEN 'Otra'
            END as tipo_identificacion,
            IF(requiere_numero_am=1,'OUI','NON') as requiere_numero_am,
            IF(requiere_sector=1,'OUI','NON') as requiere_sector,
            IF(requiere_modo_facturacion=1,'OUI','NON') as requiere_modo_facturacion,
            IFNULL(CONCAT('€ ',max_vc_turno),'') as max_vc_turno
                ");

        $query->setFrom("
                $this->table
            ");

        // Filtro
        if ($request["especialidad"] != "") {

            $nombre = cleanQuery($request["especialidad"]);

            $query->addAnd("especialidad LIKE '%$nombre%'");
        }
        if ($request["tipo"] != "") {

            $tipo = cleanQuery($request["tipo"]);

            $query->addAnd("tipo=$tipo");
        }



        $data = $this->getJSONList($query, array("especialidad", "tipo", "max_vc_turno", "acceso_directo", "tipo_identificacion", "requiere_numero_am", "requiere_sector", "requiere_modo_facturacion"), $request, $idpaginate);

        return $data;
    }

    /**
     * Método que devuelve un array con todos los datos de especialides para un combo
     * Con la opcion $medico=1 devuelve solo las especialidades de medicos activos en el sistema
     */
    public function getComboList($medicos = 0) {

        $query = new AbstractSql();
        $query->setSelect("e.*");

        if ($medicos) {
            $query->setFrom(" $this->table e 
                            inner join especialidadmedico em ON (e.idespecialidad=em.especialidad_idespecialidad)
                            INNER JOIN medico m ON (m.idmedico=em.medico_idmedico)");
            $query->setWhere("(m.active=1 and m.validado=1)");
        } else {
            $query->setFrom("$this->table e");
        }

        $query->setGroupBy("idespecialidad");

        $query->setOrderBy("especialidad");


        return $this->getList($query);
    }

    /**
     * Método que devuelve un combo de especialides
     * Con la opcion $medico=1 devuelve solo las especialidades de medicos activos en el sistema
     */
    public function getCombo($medicos = 0) {

        $query = new AbstractSql();
        $query->setSelect("$this->id,especialidad");

        if ($medicos) {
            $query->setFrom(" $this->table e 
                            inner join especialidadmedico em ON (e.idespecialidad=em.especialidad_idespecialidad)
                            INNER JOIN medico m ON (m.idmedico=em.medico_idmedico)");
            $query->setWhere("(m.active=1 and m.validado=1)");
        } else {
            $query->setFrom("$this->table e");
        }

        $query->setGroupBy("idespecialidad");

        $query->setOrderBy("especialidad");


        return $this->getComboBox($query, false);
    }

    /**
     * Método que devuelve un combo de especialides de acceso directo
     * Con la opcion $medico=1 devuelve solo las especialidades de medicos activos en el sistema
     */
    public function getComboAccesoDirecto() {
        $query = new AbstractSql();
        $query->setSelect("$this->id,especialidad");


        $query->setFrom(" $this->table e");
        $query->setWhere("e.acceso_directo = 1");

        // $query->setGroupBy("idespecialidad");

        $query->setOrderBy("especialidad");


        return $this->getComboBox($query, false);
    }

    /**
     *   Listado de las especialidades con filtro de busqueda para autosugeridor
     * 		
     * 	@author Xinergia
     * 	@version 1.0
     *
     * 	@param int $request con parametros para la busqueda
     * 	@return array Listado de registros
     */
    public function getAutosuggest($request = null, $all = 1) {
        $query = new AbstractSql();

        $query->setSelect(" e.$this->id AS data, e.especialidad AS value");
        if ($all == 1) {
            $query->setFrom(" $this->table e");
        } else {
            $query->setFrom(" $this->table e inner join especialidadmedico em ON (e.idespecialidad=em.especialidad_idespecialidad)");
        }

        if (!is_null($request)) {
            $queryStr = cleanQuery($request["query"]);
            $query->setWhere("e.especialidad LIKE '%$queryStr%'");
        }
        $query->setGroupBy("e.idespecialidad");
        $query->setOrderBy(" e.especialidad ASC");

        $data = array(
            "query" => $request["query"],
            "suggestions" => $this->getList($query, false)
        );

        return json_encode($data);
    }

    /**
     *   Listado de las especialidades con filtro de busqueda para autosugeridor
     * 		
     * 	@author Xinergia
     * 	@version 1.0
     *
     * 	@param int $request con parametros para la busqueda
     * 	@return array Listado de registros
     */
    public function getAutosuggestComplete($request = null) {

        $query = new AbstractSql();

        $query->setSelect(" e.$this->id AS data, e.especialidad AS value");

        $query->setFrom(" $this->table e");

        if (!is_null($request)) {
            $queryStr = cleanQuery($request["query"]);
            $query->setWhere("e.especialidad LIKE '%$queryStr%'");
        }

        $query->setOrderBy("e.especialidad ASC");


        return json_encode($this->getList($query, FALSE));
    }

    /**
     *  Todas las especialidades que maneja un profesional a tagsimput
     *
     * */
    public function getEspecialidadesTagsInputMedico($idMedico) {

        $query = new AbstractSql();
        $query->setSelect("
            e.$this->id  AS id ,
            e.especialidad AS value
        ");
        $query->setFrom("
                   especialidadmedico em
                   JOIN $this->table e ON (em.especialidad_idespecialidad = e.$this->id)
        ");

        $query->setWhere("em.medico_idMedico = $idMedico");
        $query->setGroupBy("em.especialidad_idespecialidad");

        $especialidades_medico_list = $this->getList($query, false);

        return $especialidades_medico_list;
    }

}

//END_class
?>