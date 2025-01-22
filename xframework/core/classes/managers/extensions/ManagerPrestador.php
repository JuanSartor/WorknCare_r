<?php

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Description of ManagerPrestador
 *
 * @author lucas
 */
class ManagerPrestador extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "prestador", "idprestador");
    }

    public function getListadoJSON($request, $idpaginate = NULL) {

        if (!is_null($idpaginate)) {
            $this->paginate($idpaginate, 20);
        }

        $query = new AbstractSql();
        $query->setSelect("
                *
            ");
        $query->setFrom("
                $this->table 
            ");

        // Filtro
        if ($request["nombre"] != "") {

            $rdo = cleanQuery($request["nombre"]);

            $query->addAnd("nombre LIKE '%$rdo%'");
        }



        $query->setOrderBy("nombre ASC");

        $data = $this->getJSONList($query, array("nombre", "razon_social", "cuit"), $request, $idpaginate);

        return $data;
    }

    /**
     *   Listado de Las Obras sociales con filtro de busqueda para autosugeridor
     * 		
     * 	@author Xinergia
     * 	@version 1.0
     *
     * 	@param int $request con parametros para la busqueda
     * 	@return array Listado de registros
     */
    public function getAutosuggest($request) {

        $queryStr = cleanQuery($request["query"]);

        $query = new AbstractSql();

        $query->setSelect(" p.idprestador AS data, p.nombre AS value");

        $query->setFrom(" $this->table p");

        $query->setWhere("p.nombre LIKE '%{$queryStr}%'");

        $query->setOrderBy("p.nombre ASC");


        $data = array(
            "query" => $request["query"],
            "suggestions" => $this->getList($query, false)
        );


        return json_encode($data);
    }

    /**
     *  Metodo que devuelve un combo de  prestadores
     * 
     * 
     */
    public function getCombo() {

        $query = new AbstractSql();
        $query->setSelect("$this->id,nombre");
        $query->setFrom("$this->table");
        return $this->getComboBox($query, false);
    }
    
    
    /**
     *  Metodo que devuelve un combo de  prestadores para el login del paciente
     * 
     * 
     */
    public function getComboLoginPrestador() {

        $query = new AbstractSql();
        $query->setSelect("$this->id,CONCAT('Iniciar con ',nombre)");
        $query->setFrom("$this->table");
        return $this->getComboBox($query, false);
    }

    /*     * Metodo que actualiza el regsitro de prestador con la preferencia de a pacientes  ofrece los servicios 
     * 
     * @param type $request
     */

    public function update_preferencia_servicios($request) {
        $record["pacientesTurno"] = $request["pacientesTurno"];
        $record["pacientesVideoConsultaTurno"] = $request["pacientesVideoConsultaTurno"];
        return parent::update($record, $_SESSION[URL_ROOT][CONTROLLER]['logged_account']['user']['prestador_idprestador']);
    }

    /*     * Metodod que devuelve un listado paginado en formato JSON de las videoconsultas realizadas por el prestador
     * 
     * @param type $request
     * @param type $idpaginate
     * @return type
     */

    public function getListadoVideoconsultasJSON($request, $idpaginate = NULL) {

        if (!is_null($idpaginate)) {
            $this->paginate($idpaginate, 20);
        }

        $query = new AbstractSql();
        $query->setSelect("
                        v.idvideoconsulta as $this->id,
                        ev.idestadoVideoConsulta,
                        v.numeroVideoConsulta,
                        ev.estadoVideoConsulta,
                        DATE_FORMAT(v.fecha_inicio,'%d/%m/%Y %H:%ihs') as fecha_format,
                        CONCAT(IFNULL(uwp.nombre,pf.nombre),' ',IFNULL(uwp.apellido,pf.apellido)) as nombre_paciente,
                        IF(rg.idrelacionGrupo is not null,p_tit.DNI,p.DNI) as DNI,
                        IF(rg.idrelacionGrupo is not null,CONCAT(CONCAT(UCASE(LEFT(rg.relacionInversa, 1)), LCASE(SUBSTRING(rg.relacionInversa, 2))),' de ',uwt.nombre,' ' ,uwt.apellido),'Titular') as titular,
                        IF(rg.idrelacionGrupo is not null,uwt.email,uwp.email) as email_paciente,
                        CONCAT(tp.titulo_profesional,' ',uwm.nombre,' ',uwm.apellido) as nombre_medico,
                        uwm.email as email_medico,
                        m.numeroCelular as celular_medico,
                        es.especialidad,
                        mc.motivoVideoConsulta,
                        ps.idperfilSaludConsulta
                        ");

        $query->setFrom("videoconsulta v
                        INNER JOIN estadovideoconsulta ev on (ev.idestadoVideoConsulta=v.estadoVideoConsulta_idestadoVideoConsulta)
                        INNER JOIN medico m ON (v.medico_idmedico = m.idmedico)
                        LEFT JOIN especialidadmedico esm ON (esm.medico_idmedico=m.idmedico)
                        LEFT JOIN especialidad es ON (es.idespecialidad=esm.especialidad_idespecialidad)
                        INNER JOIN usuarioweb uwm ON (m.usuarioweb_idusuarioweb = uwm.idusuarioweb)
                        LEFT JOIN titulo_profesional tp ON (m.titulo_profesional_idtitulo_profesional = tp.idtitulo_profesional)
                        INNER JOIN paciente p ON (p.idpaciente = v.paciente_idpaciente)
                        INNER JOIN paciente_prestador pp ON (p.idpaciente = pp.paciente_idpaciente)
                        LEFT JOIN usuarioweb uwp ON (p.usuarioweb_idusuarioweb = uwp.idusuarioweb)
                        LEFT JOIN pacientegrupofamiliar pf ON (p.idpaciente = pf.pacienteGrupo)
                        LEFT JOIN paciente p_tit ON (p_tit.idpaciente = pf.pacienteTitular)
                        LEFT JOIN usuarioweb uwt ON (p_tit.usuarioweb_idusuarioweb = uwt.idusuarioweb)
                        LEFT JOIN relaciongrupo rg ON (rg.idrelacionGrupo = pf.relacionGrupo_idrelacionGrupo) 
                        LEFT JOIN motivovideoconsulta mc ON (mc.idmotivoVideoConsulta = v.motivoVideoConsulta_idmotivoVideoConsulta)
                        LEFT JOIN motivorechazo mr ON (mr.idmotivoRechazo = v.motivoRechazo_idmotivoRechazo)
                        LEFT JOIN perfilsaludconsulta ps ON (ps.videoconsulta_idvideoconsulta = v.idvideoconsulta)
                          
                        ");

        $query->setWhere("v.prestador_idprestador = {$_SESSION[URL_ROOT][CONTROLLER]['logged_account']['user']['prestador_idprestador']}");

        // Filtro
        $paramsBind = [];
   
        if (isset($request["desde"]) && $request["desde"] != "") {
            $desde = $this->sqlDate($request["desde"]);
            $query->addAnd("v.fecha_inicio >= '$desde'");
        }

        if (isset($request["hasta"]) && $request["hasta"] != "") {
            $hasta = $this->sqlDate($request["hasta"]);
            $query->addAnd("v.fecha_inicio <= '$hasta'");
        }
        if ($request["estadoVideoConsulta_idestadoVideoConsulta"] != "") {

            $estadoVideoConsulta_idestadoVideoConsulta = cleanQuery($request["estadoVideoConsulta_idestadoVideoConsulta"]);
            $query->addAnd("estadoVideoConsulta_idestadoVideoConsulta =$estadoVideoConsulta_idestadoVideoConsulta");
        }
        if ($request["busqueda"] != "") {

            $rdo = cleanQuery($request["busqueda"]);

            $query->addAnd("((uwp.nombre LIKE '%$rdo%') 
                            OR (pf.nombre LIKE '%$rdo%') 
                            OR (uwp.apellido LIKE '%$rdo%')
                            OR (pf.apellido LIKE '%$rdo%' )
                            OR (uwm.nombre LIKE '%$rdo%') 
                            OR (uwm.apellido LIKE '%$rdo%')
                            OR (uwm.email LIKE '%$rdo%') 
                            OR (uwp.email LIKE '%$rdo%') 
                            OR (uwt.email LIKE '%$rdo%')
                            OR (pf.DNI LIKE '%$rdo%')
                            OR (p.DNI LIKE '%$rdo%')
                            OR (pp.nro_afiliado LIKE '%$rdo%') )");
            $paramsBind[] = "%{$request["busqueda"]}%";
            $paramsBind[] = "%{$request["busqueda"]}%";
            $paramsBind[] = "%{$request["busqueda"]}%";
            $paramsBind[] = "%{$request["busqueda"]}%";
            $paramsBind[] = "%{$request["busqueda"]}%";
            $paramsBind[] = "%{$request["busqueda"]}%";
            $paramsBind[] = "%{$request["busqueda"]}%";
            $paramsBind[] = "%{$request["busqueda"]}%";
            $paramsBind[] = "%{$request["busqueda"]}%";
            $paramsBind[] = "%{$request["busqueda"]}%";
            $paramsBind[] = "%{$request["busqueda"]}%";
            $paramsBind[] = "%{$request["busqueda"]}%";
        }

        $query->setGroupBy("idvideoconsulta");
        $data = $this->getJSONList($query, array("idestadoVideoConsulta", "numeroVideoConsulta", "motivoVideoConsulta", "estadoVideoConsulta", "fecha_format","nombre_paciente", "DNI", "titular", "email_paciente", "nombre_medico", "email_medico", "celular_medico", "especialidad", "idperfilSaludConsulta"), $request, $idpaginate, $paramsBind);

        return $data;
    }

    /*     * Metodod que devuelve un listado paginado en formato JSON de las consultas express realizadas por el prestador
     * 
     * @param type $request
     * @param type $idpaginate
     * @return type
     */

    public function getListadoConsultaExpressJSON($request, $idpaginate = NULL) {

        if (!is_null($idpaginate)) {
            $this->paginate($idpaginate, 20);
        }

        $query = new AbstractSql();
        $query->setSelect("
                        ce.idconsultaExpress as $this->id,
                        ece.idestadoConsultaExpress,
                        ce.numeroConsultaExpress,
                        ece.estadoConsultaExpress,
                        DATE_FORMAT(ce.fecha_inicio,'%d/%m/%Y %H:%ihs') as fecha_format,
                        CONCAT(IFNULL(uwp.nombre,pf.nombre),' ',IFNULL(uwp.apellido,pf.apellido)) as nombre_paciente,
                        IFNULL(p.DNI,pf.DNI) as DNI,
                        IF(rg.idrelacionGrupo is not null,CONCAT(CONCAT(UCASE(LEFT(rg.relacionInversa, 1)), LCASE(SUBSTRING(rg.relacionInversa, 2))),' de ',uwt.nombre,' ' ,uwt.apellido),'Titular') as titular,
                        IF(rg.idrelacionGrupo is not null,uwt.email,uwp.email) as email_paciente,
                        CONCAT(tp.titulo_profesional,' ',uwm.nombre,' ',uwm.apellido) as nombre_medico,
                        uwm.email as email_medico,
                        m.numeroCelular as celular_medico,
                        es.especialidad,
                        mc.motivoConsultaExpress,
                        ps.idperfilSaludConsulta
                        ");

        $query->setFrom("consultaexpress ce
                        INNER JOIN estadoconsultaexpress ece on (ece.idestadoConsultaExpress=ce.estadoConsultaExpress_idestadoConsultaExpress)
                        INNER JOIN medico m ON (ce.medico_idmedico = m.idmedico)
                        LEFT JOIN especialidadmedico esm ON (esm.medico_idmedico=m.idmedico)
                        LEFT JOIN especialidad es ON (es.idespecialidad=esm.especialidad_idespecialidad)
                        INNER JOIN usuarioweb uwm ON (m.usuarioweb_idusuarioweb = uwm.idusuarioweb)
                        LEFT JOIN titulo_profesional tp ON (m.titulo_profesional_idtitulo_profesional = tp.idtitulo_profesional)
                        INNER JOIN paciente p ON (p.idpaciente = ce.paciente_idpaciente)
                        INNER JOIN paciente_prestador pp ON (p.idpaciente = pp.paciente_idpaciente)
                        LEFT JOIN usuarioweb uwp ON (p.usuarioweb_idusuarioweb = uwp.idusuarioweb)
                        LEFT JOIN pacientegrupofamiliar pf ON (p.idpaciente = pf.pacienteGrupo)
                        LEFT JOIN paciente p_tit ON (p_tit.idpaciente = pf.pacienteTitular)
                        LEFT JOIN usuarioweb uwt ON (p_tit.usuarioweb_idusuarioweb = uwt.idusuarioweb)
                        LEFT JOIN relaciongrupo rg ON (rg.idrelacionGrupo = pf.relacionGrupo_idrelacionGrupo) 
                        LEFT JOIN motivoconsultaexpress mc ON (mc.idmotivoConsultaExpress = ce.motivoConsultaExpress_idmotivoConsultaExpress)
                        LEFT JOIN motivorechazo mr ON (mr.idmotivoRechazo = ce.motivoRechazo_idmotivoRechazo)
                        LEFT JOIN perfilsaludconsulta ps ON (ps.consultaExpress_idconsultaExpress = ce.idconsultaExpress)
                          
                        ");

        $query->setWhere("ce.prestador_idprestador = {$_SESSION[URL_ROOT][CONTROLLER]['logged_account']['user']['prestador_idprestador']}");

        // Filtro
        $paramsBind = [];

        if ($request["estadoConsultaExpress_idestadoConsultaExpress"] != "") {

            $estadoConsultaExpress_idestadoConsultaExpress = cleanQuery($request["estadoConsultaExpress_idestadoConsultaExpress"]);
            $query->addAnd("estadoConsultaExpress_idestadoConsultaExpress =$estadoConsultaExpress_idestadoConsultaExpress");
        }
        
       
        if (isset($request["desde"]) && $request["desde"] != "") {
            $desde = $this->sqlDate($request["desde"]);
            $query->addAnd("ce.fecha_inicio >= '$desde'");
        }

        if (isset($request["hasta"]) && $request["hasta"] != "") {
            $hasta = $this->sqlDate($request["hasta"]);
            $query->addAnd("ce.fecha_inicio <= '$hasta'");
        }
          
        if ($request["busqueda"] != "") {

            $rdo = cleanQuery($request["busqueda"]);

            $query->addAnd("((uwp.nombre LIKE '%$rdo%') 
                            OR (pf.nombre LIKE '%$rdo%') 
                            OR (uwp.apellido LIKE '%$rdo%')
                            OR (pf.apellido LIKE '%$rdo%' )
                            OR (uwm.nombre LIKE '%$rdo%') 
                            OR (uwm.apellido LIKE '%$rdo%')
                            OR (uwm.email LIKE '%$rdo%') 
                            OR (uwp.email LIKE '%$rdo%') 
                            OR (uwt.email LIKE '%$rdo%')
                            OR (pf.DNI LIKE '%$rdo%')
                            OR (p.DNI LIKE '%$rdo%')
                            OR (pp.nro_afiliado LIKE '%$rdo%') )");
            $paramsBind[] = "%{$request["busqueda"]}%";
            $paramsBind[] = "%{$request["busqueda"]}%";
            $paramsBind[] = "%{$request["busqueda"]}%";
            $paramsBind[] = "%{$request["busqueda"]}%";
            $paramsBind[] = "%{$request["busqueda"]}%";
            $paramsBind[] = "%{$request["busqueda"]}%";
            $paramsBind[] = "%{$request["busqueda"]}%";
            $paramsBind[] = "%{$request["busqueda"]}%";
            $paramsBind[] = "%{$request["busqueda"]}%";
            $paramsBind[] = "%{$request["busqueda"]}%";
            $paramsBind[] = "%{$request["busqueda"]}%";
            $paramsBind[] = "%{$request["busqueda"]}%";
        }

        $query->setGroupBy("idconsultaExpress");
        $data = $this->getJSONList($query, array("idestadoConsultaExpress", "numeroConsultaExpress", "motivoConsultaExpress", "estadoConsultaExpress","fecha_format", "nombre_paciente", "DNI", "titular", "email_paciente", "nombre_medico", "email_medico", "celular_medico", "especialidad", "idperfilSaludConsulta"), $request, $idpaginate, $paramsBind);

        return $data;
    }

    /*
     * 	@author Xinergia <info@xinergia.com.ar>
     *
     *   Reporte de recaudaciones por centro facilitador
     */

    public function getListadoRecaudacionesJSON($request, $idpaginate = null) {

        //pagino solo para guardar el request
        if (!is_null($idpaginate)) {
            $this->paginate($idpaginate, 25);
        }
        $query = new AbstractSql();
        $query->setSelect("
                        
                    m.idmedico as $this->id,
                    CONCAT(tp.titulo_profesional,' ',uwm.nombre,' ',uwm.apellido) as nombre_medico,                     
                    es.especialidad,
                    IFNULL(vc.qty,0) AS qty_vc,
                    IFNULL(vc.total,0) AS total_vc,
                    IFNULL(ce.qty,0) AS qty_ce,
                    IFNULL(ce.total,0) AS total_ce
                        ");

        $query->setFrom("medico m
                        LEFT JOIN (SELECT 
                                    vc.medico_idmedico,
                                    SUM(vc.`precio_tarifa_prestador` ) AS total,
                                    COUNT(*) AS qty
                                    FROM videoconsulta vc
                                    WHERE  vc.estadoVideoConsulta_idestadoVideoConsulta = 4 AND vc.prestador_idprestador ={$_SESSION[URL_ROOT][CONTROLLER]['logged_account']['user']['prestador_idprestador']} AND vc.precio_tarifa_prestador IS NOT NULL
                                    GROUP BY vc.medico_idmedico
                                 ) vc ON (m.`idmedico` = vc.medico_idmedico)

                        LEFT JOIN (SELECT 
                                ce.medico_idmedico,
                                SUM(ce.`precio_tarifa_prestador` ) AS total,
                                COUNT(*) AS qty
                                FROM consultaexpress ce
                                WHERE  ce.estadoConsultaExpress_idestadoConsultaExpress = 4 AND ce.prestador_idprestador = {$_SESSION[URL_ROOT][CONTROLLER]['logged_account']['user']['prestador_idprestador']} AND ce.precio_tarifa_prestador IS NOT NULL
                                GROUP BY ce.medico_idmedico
                                ) ce ON (m.`idmedico` = ce.medico_idmedico)
                        LEFT JOIN especialidadmedico esm ON (esm.medico_idmedico=m.idmedico)
                        LEFT JOIN especialidad es ON (es.idespecialidad=esm.especialidad_idespecialidad)
                        INNER JOIN usuarioweb uwm ON (m.usuarioweb_idusuarioweb = uwm.idusuarioweb)
                        LEFT JOIN titulo_profesional tp ON (m.titulo_profesional_idtitulo_profesional = tp.idtitulo_profesional)       
   
                        ");

        $query->setWhere("vc.qty IS NOT NULL OR  ce.qty IS NOT NULL");

        $query->setGroupBy("idmedico");
        $params = [];
        if (isset($request["desde"]) && $request["desde"] != "") {
            $desde = $this->sqlDate($request["desde"]);
            $query->addAnd("v.fecha_fin >= '$desde'");
        }

        if (isset($request["hasta"]) && $request["hasta"] != "") {
            $hasta = $this->sqlDate($request["hasta"]);
            $query->addAnd("v.fecha_fin <= '$hasta'");
        }

        if (isset($request["busqueda"]) && $request["busqueda"] != "") {
            $busqueda = $request["busqueda"];
            $query->addAnd("uwm.nombre  LIKE '%$busqueda%' OR u.apellido LIKE '%$busqueda%'");
            $params[] = "%$busqueda%";
            $params[] = "%$busqueda%";
        }

        $data = $this->getJSONList($query, array('nombre_medico', 'especialidad', "qty_ce", "total_ce", "qty_vc", "total_vc"), $request, $idpaginate);

        $data = json_decode($data);

        $total_ce = 0;
        $importe_ce = 0.0;
        $total_vc = 0;
        $importe_vc = 0.0;


        if ($data->rows) {
            /*
              $query->setSelect("
              SUM(cc.importe) AS recaudacion
              ");

              $query->setOrderBy(NULL);

              $query->setGroupBy(NULL);

              $query->setLimit(NULL);

              $total_recaudado = $this
              ->db
              ->GetOne($query->getSql()); */

            // $data->total_recaudado = $total_recaudado;
            $data->total_ce = 0;
            $data->importe_ce = 0.0;
            $data->total_vc = 0;
            $data->importe_vc = 0.0;
        } else {
            $data->total_ce = 0;
            $data->importe_ce = 0.0;
            $data->total_vc = 0;
            $data->importe_vc = 0.0;
        }

        return json_encode($data);
    }

}
