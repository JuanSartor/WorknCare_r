<?php

/**
 * ManagerFiltrosBusquedaVideoConsulta administra los filtros de busqueda de profesionales de una videoconsulta 
 * al realizarla a los prefesionales en la red, para asegurar que los medicos de la bolsa sigan cumpliendo 
 * con los filtros de la busqueda al momento de tomar una videoconsulta, por si han modificado sus perfiles.
 *
 * @author lucas
 */
class ManagerFiltrosBusquedaVideoConsulta extends AbstractManager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "filtrosbusquedavideoconsulta", "idfiltrosBusquedaVideoConsulta");
    }

    /*     * Metodo que permite guardar los filtros con los que se seleccionaron los medicos de la bolsa de videoconsulta
     * 
     * @param type $request
     * @return boolean
     */

    public function insert($request) {


        if ($request["especialidad_idespecialidad"] == "" && $request["idprograma_categoria"] == "" && $request["idprograma_salud"] == "") {
            $this->setMsg(["result" => false, "msg" => "Ingrese una especialidad a buscar"]);
            return false;
        }
        if ($_SESSION[URL_ROOT]["paciente_p"]['logged_account']["paciente"]["prestador_idprestador"] == "") {
            if ($request["rango_minimo"] == "" || $request["rango_maximo"] == "") {
                $this->setMsg(["result" => false, "msg" => "Ingrese el rango minimo  y maximo de tarifas a buscar"]);
                return false;
            }
        }

        $request["videoconsulta_idvideoconsulta"] = $request["idvideoconsulta"];
        $borrar_old = $this->db->Execute("delete from $this->table where videoconsulta_idvideoconsulta=" . $request["idvideoconsulta"]);

        if ($borrar_old) {
            $rdo = parent::insert($request);
        }
        if ($rdo) {
            $login_prestador = 0;

            $this->setMsg(["result" => true, "msg" => "Filtros de busqueda creados con exito", "login_prestador" => $login_prestador]);
            return true;
        } else {
            $this->setMsg(["result" => false, "msg" => "No se pudieron crear los filtros de busqueda. Intente nuevamente"]);
            return false;
        }
    }

    /**
     * Método que retorna un listado con los médicos pertenecientes a la bolsa, donde publicará la consulta el paciente
     * Cada médico debe tener la preferencia y al menos una especialidad
     * 
     * @param type $idvideoconsulta
     * @return boolean
     */
    public function getMedicosBolsa($idvideoconsulta) {

        $filtro = $this->getByField("videoconsulta_idvideoconsulta", $idvideoconsulta);
        $consulta = $this->getManager("ManagerVideoConsulta")->get($idvideoconsulta);
        //$this->print_r($request);
        $ManagerProfesionalBloqueo = $this->getManager("ManagerProfesionalBloqueo");
        $profesionales_bloqueados = $ManagerProfesionalBloqueo->getBloqueados($consulta["paciente_idpaciente"]);

        $ManagerMedicoEliminadoVideoConsulta = $this->getManager("ManagerMedicoEliminadoVideoConsulta");
        $profesionales_eliminados = $ManagerMedicoEliminadoVideoConsulta->getElimiadosVideoConsulta($idvideoconsulta);


        $query = new AbstractSql();

        $query->setSelect("idmedico,getEstrellasMedicos(m.idmedico) as valoracion, p.valorPinesVideoConsulta");

        $query->setFrom("medico m
                            INNER JOIN especialidadmedico em ON (m.idmedico = em.medico_idmedico)
                            INNER JOIN preferencia p ON (m.preferencia_idPreferencia = p.idpreferencia)
                            LEFT JOIN idiomamedico im ON (m.idmedico=im.medico_idMedico)
                            LEFT JOIN consultorio c ON (m.idmedico=c.medico_idmedico)
                            LEFT JOIN direccion d ON (c.direccion_iddireccion=d.iddireccion)
                            LEFT JOIN profesionalvaloracion pv ON (pv.medico_idmedico=m.idmedico)
                            LEFT JOIN obrasocialmedico osm ON (osm.medico_idmedico=m.idmedico)
                            LEFT JOIN profesionalesfrecuentes_pacientes pf ON (m.idmedico=pf.medico_idmedico and pf.paciente_idpaciente={$consulta["paciente_idpaciente"]})
                            LEFT JOIN programa_medico_referente pmr ON (pmr.medico_idMedico = m.idmedico) 
                            LEFT JOIN programa_medico_complementario pmc ON (pmc.medico_idmedico = m.idmedico)
                            LEFT JOIN programa_categoria pc ON (pmc.programa_categoria_idprograma_categoria=pc.idprograma_categoria OR pmr.programa_categoria_idprograma_categoria=pc.idprograma_categoria)

                    ");
        $query->setWhere("p.valorPinesVideoConsulta is not null");
        $query->addAnd("m.active=1 AND m.validado=1");
        //verificamos que tenga habilitada la consulta a todos los pacientes o sea frecuente
        $query->addAnd("((p.pacientesVideoConsulta=1) OR (p.pacientesVideoConsulta=2 AND pf.idprofesionalesFrecuentes_pacientes IS NOT NULL))");


        //Programa de salud
        if ((int) $filtro["idprograma_salud"] > 0) {
            $query->addAnd("pc.programa_salud_idprograma_salud = {$filtro["idprograma_salud"]}");
        }
        //categorias de programa de salud
        if ((int) $filtro["idprograma_categoria"] > 0) {
            $query->addAnd("pmr.programa_categoria_idprograma_categoria = {$filtro["idprograma_categoria"]} OR pmc.programa_categoria_idprograma_categoria = {$filtro["idprograma_categoria"]} ");
        }


        //No estén dentro de los profesionales bloqueados
        if ($profesionales_bloqueados != "") {
            $query->addAnd("idmedico NOT IN ($profesionales_bloqueados)");
        }

        //No estén dentro de los profesionales elimindos del listado
        if ($profesionales_eliminados != "") {
            $query->addAnd("idmedico NOT IN ($profesionales_eliminados)");
        }

        //Si no hay especialidad, retorno falso, porque es obligatoria
        if ($filtro["especialidad_idespecialidad"] != "") {
            $query->addAnd("em.especialidad_idespecialidad = " . $filtro["especialidad_idespecialidad"]);
        }

        /**
         * Filtros de rangos
         */
        if ($filtro["rango_minimo"] != "") {
            $query->addAnd("p.valorPinesVideoConsulta >= " . $filtro["rango_minimo"]);
        }

        if ($filtro["rango_maximo"] != "") {
            $query->addAnd("p.valorPinesVideoConsulta <= " . $filtro["rango_maximo"]);
        }

        if ($filtro["subEspecialidad_idsubEspecialidad"] != "") {
            $query->addAnd("em.subEspecialidad_idsubEspecialidad = " . $filtro["subEspecialidad_idsubEspecialidad"]);
        }
        if ($filtro["obraSocial_idobraSocial"] != "") {
            $query->addAnd("osm.obraSocial_idobraSocial=" . $filtro["obraSocial_idobraSocial"]);
        }
        if ($filtro["idioma_ididioma"] != "") {
            $query->addAnd("idioma_ididioma=" . $filtro["idioma_ididioma"]);
        }
        if ($filtro["localidad_idlocalidad"] != "") {
            $query->addAnd("localidad_idlocalidad=" . $filtro["localidad_idlocalidad"]);
        }
        if ($filtro["pais_idpais"] != "") {

            $query->addAnd("m.pais_idpais=" . $filtro["pais_idpais"] . "|| d.pais_idpais=" . $filtro["pais_idpais"]);
        }
        if ($filtro["sector_idsector"] != "") {

            $query->addAnd("m.sector_idsector=" . $filtro["sector_idsector"]);
        }
        if ($filtro["valoracion"] != "") {
            $query->setGroupBy("m.idmedico having valoracion in (" . $filtro["valoracion"] . ")");
        } else {
            $query->setGroupBy("m.idmedico");
        }

        /** consulta que obtiene las  tarifas max/min de los medicos seleccionados para actualizar el filtro */
        $query2 = new AbstractSql();
        $query2->setSelect("max(valorPinesVideoConsulta) as rango_maximo,min(valorPinesVideoConsulta) as rango_minimo");
        $query2->setFrom("(" . $query->getSql() . ")as T");
        $res = $this->db->getRow($query2->getSql());
        $this->db->StartTrans();
        //actualizamos el rango maximo y minimo
        $rdo = parent::update(["rango_minimo" => $res["rango_minimo"], "rango_maximo" => $res["rango_maximo"]], $filtro["idfiltrosBusquedaVideoConsulta"]);
        if (!$rdo) {
            $this->db->FailTrans();
            return false;
        }
        $this->db->CompleteTrans();

        return $this->getList($query);
    }

    /**
     * Listado paginado de medicos en la bolsa videoconsultas
     * @param array $request
     * @param type $idpaginate
     */
    public function getListadoPaginadoMedicosBolsa($request, $idpaginate = null) {



        if (isset($request["do_reset"]) && $request["do_reset"] == 1) {
            $this->resetPaginate($idpaginate);
        }

        if (!is_null($idpaginate)) {
            $this->paginate($idpaginate, 10);
        }
        //obtengo los filtros con los que se creo la CE
        $filtro = $this->getByField("videoconsulta_idvideoconsulta", $request["idvideoconsulta"]);

//Paciente que se encuentra en el array de SESSION de header paciente
        $ManagerPaciente = $this->getManager("ManagerPaciente");
        $paciente = $ManagerPaciente->getPacienteXHeader();
        $idpaciente = $paciente["idpaciente"];

        $ManagerMedicoEliminadoVideoConsulta = $this->getManager("ManagerMedicoEliminadoVideoConsulta");
        $profesionales_eliminados = $ManagerMedicoEliminadoVideoConsulta->getElimiadosVideoConsulta($request["idvideoconsulta"]);


        //Seteo el current page
        $request["current_page"] = $request["current_page"] != "" ? $request["current_page"] : 1;
        SmartyPaginate::setCurrentPage($request["current_page"], $idpaginate);

        $query = new AbstractSql();

        $query->setSelect("*,getEstrellasMedicos(m.idmedico) as valoracion");

        $query->setFrom("medico m
                            INNER JOIN usuarioweb uw ON (m.usuarioweb_idusuarioweb = uw.idusuarioweb)
                            INNER JOIN especialidadmedico em ON (m.idmedico = em.medico_idmedico)
                            INNER JOIN titulo_profesional tp ON (m.titulo_profesional_idtitulo_profesional=tp.idtitulo_profesional)
                            INNER JOIN preferencia p ON (m.preferencia_idPreferencia = p.idpreferencia)
                            LEFT JOIN idiomamedico im ON (m.idmedico=im.medico_idMedico)
                            LEFT JOIN consultorio c ON (m.idmedico=c.medico_idmedico and c.is_virtual=0  and c.flag=1)
                            LEFT JOIN direccion d ON (c.direccion_iddireccion=d.iddireccion)
                            LEFT JOIN profesionalvaloracion pv ON (pv.medico_idmedico=m.idmedico)
                            LEFT JOIN obrasocialmedico osm ON (osm.medico_idmedico=m.idmedico)
                            LEFT JOIN medicomispacientes mmp ON (mmp.medico_idmedico = m.idmedico AND mmp.paciente_idpaciente=$idpaciente)
                            LEFT JOIN programa_medico_referente pmr ON (pmr.medico_idMedico = m.idmedico) 
                            LEFT JOIN programa_medico_complementario pmc ON (pmc.medico_idmedico = m.idmedico)
                            LEFT JOIN programa_categoria pc ON (pmc.programa_categoria_idprograma_categoria=pc.idprograma_categoria OR pmr.programa_categoria_idprograma_categoria=pc.idprograma_categoria)
                    ");

        $query->setWhere("p.valorPinesVideoConsulta is not null");
        $query->addAnd("m.active = 1");
        $query->addAnd("m.validado = 1");
        //No estén dentro de los profesionales bloqueados
        if ($profesionales_eliminados != "") {
            $query->addAnd("idmedico NOT IN ($profesionales_eliminados)");
        }
        //especialidad
        if ($filtro["especialidad_idespecialidad"] != "") {
            $query->addAnd("em.especialidad_idespecialidad = " . $filtro["especialidad_idespecialidad"]);
        }
        //Programa de salud
        if ((int) $filtro["idprograma_salud"] > 0) {
            $query->addAnd("pc.programa_salud_idprograma_salud = {$filtro["idprograma_salud"]}");
        }
        //categorias de programa de salud
        if ((int) $filtro["idprograma_categoria"] > 0) {
            $query->addAnd("pmr.programa_categoria_idprograma_categoria = {$filtro["idprograma_categoria"]} OR pmc.programa_categoria_idprograma_categoria = {$filtro["idprograma_categoria"]} ");
        }
        /**
         * Filtros de rangos
         */
        if ((int) $filtro["rango_minimo"] > 0) {
            $query->addAnd("p.valorPinesVideoConsulta >= " . $filtro["rango_minimo"]);
        }

        if ((int) $filtro["rango_maximo"] > 0) {
            $query->addAnd("p.valorPinesVideoConsulta <= " . $filtro["rango_maximo"]);
        }

        if ((int) $filtro["subEspecialidad_idsubEspecialidad"] > 0) {
            $query->addAnd("em.subEspecialidad_idsubEspecialidad = " . $filtro["subEspecialidad_idsubEspecialidad"]);
        }

        if ($filtro["obraSocial_idobraSocial"] != "") {
            $query->addAnd("osm.obraSocial_idobraSocial=" . $filtro["obraSocial_idobraSocial"]);
        }
        if (isset($filtro["idioma_ididioma"]) && $filtro["idioma_ididioma"] != "") {
            $query->addAnd("idioma_ididioma=" . $filtro["idioma_ididioma"]);
        }
        if (isset($filtro["localidad_idlocalidad"]) && $filtro["localidad_idlocalidad"] != "") {
            $query->addAnd("localidad_idlocalidad=" . $filtro["localidad_idlocalidad"]);
        }

        if (isset($filtro["sector_idsector"]) && $filtro["sector_idsector"] != "") {
            $query->addAnd("sector_idsector=" . $filtro["sector_idsector"]);
        }
        if (isset($filtro["pais_idpais"]) && $filtro["pais_idpais"] != "") {

            $query->addAnd("m.pais_idpais=" . $filtro["pais_idpais"] . "|| d.pais_idpais=" . $filtro["pais_idpais"]);
        }
        if (isset($filtro["valoracion"]) && $filtro["valoracion"] != "") {
            $query->setGroupBy("m.idmedico HAVING (p.pacientesVideoConsulta=1 OR mmp.idmedicoMedicosMisPacientes is not null) AND valoracion in (" . $filtro["valoracion"] . ")");
        } else {
            $query->setGroupBy("m.idmedico HAVING (p.pacientesVideoConsulta=1 OR mmp.idmedicoMedicosMisPacientes is not null)");
        }
        if (isset($request["order"]) && $request["order"] != "") {
            switch ($request["order"]) {
                case 'alfabetico':
                    $query->setOrderBy("nombre asc");
                    break;
                case 'tarifa-asc':
                    $query->setOrderBy("valorPinesVideoConsulta asc");
                    break;
                case 'tarifa-desc':
                    $query->setOrderBy("valorPinesVideoConsulta desc");
                    break;
                case 'evaluacion':
                    $query->setOrderBy("valoracion desc");
                    break;
            }
        }


        $listado = $this->getListPaginado($query, $idpaginate);



//agregamos la informarcion extra
        if ($listado["rows"] && count($listado["rows"]) > 0) {

            $ManagerProfesionalBloqueo = $this->getManager("ManagerProfesionalBloqueo");
            $ManagerProfesionalFavorito = $this->getManager("ManagerProfesionalFavorito");
            $ManagerProfesionalValoracion = $this->getManager("ManagerProfesionalValoracion");
            $ManagerMedico = $this->getManager("ManagerMedico");
            $ManagerEspecialidadMedico = $this->getManager("ManagerEspecialidadMedico");
            $ManagerProfesionalesFrecuentesPacientes = $this->getManager("ManagerProfesionalesFrecuentesPacientes");
            foreach ($listado["rows"] as $key => $medico) {
                //verificamos si el medico tiene habilitada la VC  para todos los pacientes

                if ($medico["pacientesVideoConsulta"] == 2) {
                    $frecuente = $ManagerProfesionalesFrecuentesPacientes->isFrecuente($medico["idmedico"], $idpaciente);

                    if (!$frecuente) {
                        //elimnamos el medico y saltamos al prox
                        unset($listado["rows"][$key]);
                        continue;
                    }
                }
                $listado["rows"][$key]["imagen"] = $ManagerMedico->tieneImagen($medico["idmedico"]);

                $listado["rows"][$key]["bloqueo"] = $ManagerProfesionalBloqueo->isBloqueado($medico["idmedico"], $idpaciente);
                $listado["rows"][$key]["valoracion"] = $ManagerProfesionalValoracion->getCantidadRecomendaciones($medico["idmedico"]);
                $listado["rows"][$key]["estrellas"] = $ManagerProfesionalValoracion->getCantidadEstrellas($medico["idmedico"]);
                $listado["rows"][$key]["especialidad"] = $ManagerEspecialidadMedico->getEspecialidadesMedico($medico["idmedico"]);
                $listado["rows"][$key]["favorito"] = $ManagerProfesionalFavorito->isFavorito($medico["idmedico"], $idpaciente);
                $listado["rows"][$key]["frecuente"] = $frecuente;
            }
        }


        return $listado;
    }

    /**
     * Id´s de los médicos pertenecientes a una bolsa de publicación del paciente
     * @param type $idvideoconsulta
     * @return string|boolean
     */
    public function getIdsMedicosBolsa($idvideoconsulta) {
        //si se loguea como prestador buscamos todos los medicos del prestador segun los filtros
        if ($_SESSION[URL_ROOT]["paciente_p"]['logged_account']["paciente"]["prestador_idprestador"] != "") {
            $ids_medicos_bolsa = $this->getMedicosPrestador($idvideoconsulta);
        } else {
            $ids_medicos_bolsa = $this->getMedicosBolsa($idvideoconsulta);
        }


        if ($ids_medicos_bolsa && count($ids_medicos_bolsa) > 0) {
            $ids = ",";
            foreach ($ids_medicos_bolsa as $key => $value) {
                $ids .= $value["idmedico"] . ",";
            }
            return $ids;
        } else {
            return false;
        }
    }

    /**
     * Método que retorna un listado con los médicos pertenecientes al prestador para la bolsa donde publicará la consulta el paciente
     *
     * 
     * @param type $idvideoconsulta
     * @return boolean
     */
    public function getMedicosPrestador($idvideoconsulta) {
        $filtro = $this->getByField("videoconsulta_idvideoconsulta", $idvideoconsulta);

        //$this->print_r($request);


        $query = new AbstractSql();

        $query->setSelect("idmedico,getEstrellasMedicos(m.idmedico) as valoracion, p.valorPinesConsultaExpress");

        $query->setFrom("medico m
                            INNER JOIN especialidadmedico em ON (m.idmedico = em.medico_idmedico)
                            INNER JOIN preferencia p ON (m.preferencia_idPreferencia = p.idpreferencia)
                            LEFT JOIN idiomamedico im ON (m.idmedico=im.medico_idMedico)
                            LEFT JOIN consultorio c ON (m.idmedico=c.medico_idmedico)
                            LEFT JOIN direccion d ON (c.direccion_iddireccion=d.iddireccion)
                            LEFT JOIN profesionalvaloracion pv ON (pv.medico_idmedico=m.idmedico)
                            LEFT JOIN obrasocialmedico osm ON (osm.medico_idmedico=m.idmedico)
                            LEFT JOIN medico_prestador mp ON (mp.medico_idmedico=m.idmedico)
                            LEFT JOIN programa_medico_referente pmr ON (pmr.medico_idMedico = m.idmedico) 
                            LEFT JOIN programa_medico_complementario pmc ON (pmc.medico_idmedico = m.idmedico)
                            LEFT JOIN programa_categoria pc ON (pmc.programa_categoria_idprograma_categoria=pc.idprograma_categoria OR pmr.programa_categoria_idprograma_categoria=pc.idprograma_categoria)
                    ");




        $query->setWhere("mp.prestador_idprestador=" . $_SESSION[URL_ROOT]["paciente_p"]['logged_account']["paciente"]["prestador_idprestador"]);


        //especialidad
        if ($filtro["especialidad_idespecialidad"] != "") {
            $query->addAnd("em.especialidad_idespecialidad = " . $filtro["especialidad_idespecialidad"]);
        }
        //Programa de salud
        if ((int) $filtro["idprograma_salud"] > 0) {
            $query->addAnd("pc.programa_salud_idprograma_salud = {$filtro["idprograma_salud"]}");
        }
        //categorias de programa de salud
        if ((int) $filtro["idprograma_categoria"] > 0) {
            $query->addAnd("pmr.programa_categoria_idprograma_categoria = {$filtro["idprograma_categoria"]} OR pmc.programa_categoria_idprograma_categoria = {$filtro["idprograma_categoria"]} ");
        }
        /**
         * Filtros de rangos
         */
        if ($filtro["subEspecialidad_idsubEspecialidad"] != "") {
            $query->addAnd("em.subEspecialidad_idsubEspecialidad = " . $filtro["subEspecialidad_idsubEspecialidad"]);
        }
        if ($filtro["obraSocial_idobraSocial"] != "") {
            $query->addAnd("osm.obraSocial_idobraSocial=" . $filtro["obraSocial_idobraSocial"]);
        }
        if ($filtro["idioma_ididioma"] != "") {
            $query->addAnd("idioma_ididioma=" . $filtro["idioma_ididioma"]);
        }
        if ($filtro["localidad_idlocalidad"] != "") {
            $query->addAnd("localidad_idlocalidad=" . $filtro["localidad_idlocalidad"]);
        }
        if ($filtro["pais_idpais"] != "") {
            $query->addAnd("m.pais_idpais=" . $filtro["pais_idpais"] . "|| d.pais_idpais=" . $filtro["pais_idpais"]);
        }
        if ($filtro["sector_idsector"] != "") {
            $query->addAnd("m.sector_idsector=" . $filtro["sector_idsector"]);
        }


        if ($filtro["valoracion"] != "") {
            $query->setGroupBy("m.idmedico having valoracion in (" . $filtro["valoracion"] . ")");
        } else {
            $query->setGroupBy("m.idmedico");
        }



        return $this->getList($query);
    }

    /*     * Metodo que devuelve un array con el rango de precios de los medicos de la bolsa de profesionales
     * filtrados por los distintos campos de busqueda del formulario
     * 
     * @param type $request filtros de busqueda 
     */

    public function getRangoPrecioMedicosBolsa($request) {
        //Paciente que se encuentra en el array de SESSION de header paciente
        $ManagerPaciente = $this->getManager("ManagerPaciente");
        $paciente = $ManagerPaciente->getPacienteXHeader();
        $idpaciente = $paciente["idpaciente"];
        /*         * consulta que obtiene los medicos y sus tarifas segun los filtros de busqueda* */
        $subQuery = new AbstractSql();
        $subQuery->setSelect("idmedico,idconsultorio,c.direccion_iddireccion,idioma_ididioma,especialidad_idespecialidad,preferencia_idPreferencia, valorPinesVideoConsulta,getEstrellasMedicos(m.idmedico) as valoracion");
        $subQuery->setFrom("medico m
                            LEFT JOIN especialidadmedico em on (m.idmedico=em.medico_idmedico)
                            LEFT JOIN preferencia p on (p.idpreferencia=m.preferencia_idPreferencia)
                            LEFT JOIN idiomamedico im on (m.idmedico=im.medico_idMedico)
                            LEFT JOIN consultorio c on (m.idmedico=c.medico_idmedico)
                            LEFT JOIN direccion d on (c.direccion_iddireccion=d.iddireccion)
                            LEFT JOIN obrasocialmedico osm ON (osm.medico_idmedico=m.idmedico) 
                            LEFT JOIN profesionalesfrecuentes_pacientes pf ON (m.idmedico=pf.medico_idmedico and pf.paciente_idpaciente=$idpaciente)
                            LEFT JOIN programa_medico_referente pmr ON (pmr.medico_idMedico = m.idmedico) 
                            LEFT JOIN programa_medico_complementario pmc ON (pmc.medico_idmedico = m.idmedico)
                            LEFT JOIN programa_categoria pc ON (pmc.programa_categoria_idprograma_categoria=pc.idprograma_categoria OR pmr.programa_categoria_idprograma_categoria=pc.idprograma_categoria)
            ");
        $subQuery->setWhere("valorPinesVideoConsulta is not NULL");
        $subQuery->addAnd("m.active=1 AND m.validado=1");
        //verificamos que tenga habilitada la consulta a todos los pacientes o sea frecuente
        $subQuery->addAnd("((p.pacientesVideoConsulta=1) OR (p.pacientesVideoConsulta=2 AND pf.idprofesionalesFrecuentes_pacientes IS NOT NULL))");


        if (isset($request["especialidad_idespecialidad"]) && $request["especialidad_idespecialidad"] != "") {
            $subQuery->addAnd("especialidad_idespecialidad=" . $request["especialidad_idespecialidad"]);
        }
        //Programa de salud
        if ((int) $request["idprograma_salud"] > 0) {
            $subQuery->addAnd("pc.programa_salud_idprograma_salud = {$request["idprograma_salud"]}");
        }
        //categorias de programa de salud
        if ((int) $request["idprograma_categoria"] > 0) {
            $subQuery->addAnd("pmr.programa_categoria_idprograma_categoria = {$request["idprograma_categoria"]} OR pmc.programa_categoria_idprograma_categoria = {$request["idprograma_categoria"]} ");
        }
        /**
         * Filtros de rangos
         */
        if ((int) $request["rango_minimo"] > 0) {
            $subQuery->addAnd("p.valorPinesVideoConsulta >= " . $request["rango_minimo"]);
        } else {
            $subQuery->addAnd("p.valorPinesVideoConsulta >=" . PRECIO_MINIMO_VC);
        }

        if ((int) $request["rango_maximo"] > 0) {
            $subQuery->addAnd("p.valorPinesVideoConsulta <= " . $request["rango_maximo"]);
        } else {
            $subQuery->addAnd("p.valorPinesVideoConsulta <=" . PRECIO_MAXIMO_VC);
        }
        if (isset($request["subEspecialidad_idsubEspecialidad"]) && (int) $request["subEspecialidad_idsubEspecialidad"] > 0) {
            $subQuery->addAnd("subEspecialidad_idsubEspecialidad=" . $request["subEspecialidad_idsubEspecialidad"]);
        }
        if (isset($request["obraSocial_idobraSocial"]) && $request["obraSocial_idobraSocial"] != "") {
            $subQuery->addAnd("osm.obraSocial_idobraSocial=" . $request["obraSocial_idobraSocial"]);
        }
        if (isset($request["idioma_ididioma"]) && $request["idioma_ididioma"] != "") {
            $subQuery->addAnd("idioma_ididioma=" . $request["idioma_ididioma"]);
        }
        if (isset($request["localidad_idlocalidad"]) && $request["localidad_idlocalidad"] != "") {
            $subQuery->addAnd("localidad_idlocalidad=" . $request["localidad_idlocalidad"]);
        }
        if (isset($request["pais_idpais"]) && $request["pais_idpais"] != "") {

            $subQuery->addAnd("m.pais_idpais=" . $request["pais_idpais"] . "|| d.pais_idpais=" . $request["pais_idpais"]);
        }
        if (isset($request["sector_idsector"]) && $request["sector_idsector"] != "") {

            $subQuery->addAnd("m.sector_idsector=" . $request["sector_idsector"]);
        }

        if (isset($request["valoracion"]) && $request["valoracion"] != "") {
            $subQuery->setGroupBy("m.idmedico having valoracion in (" . $request["valoracion"] . ")");
        } else {
            $subQuery->setGroupBy("m.idmedico");
        }


        //colocamos los precios en un array
        $list_medicos = $this->getList($subQuery);
        $array_precios = array();

        //se crea el array con cada elemento del intervalo cada 5
        for ($i = PRECIO_MINIMO_VC; $i <= PRECIO_MAXIMO_VC; $i = $i + 5) {
            $array_precios[$i] = 0;
        }
        //contamos la cantidad de medico por precio
        foreach ($list_medicos as $medico) {
            //redondeamos el multiplo de 10 inferior siguiente del precio de consulta
            $mod = ((int) $medico["valorPinesVideoConsulta"]) % 5;
            $key = (int) $medico["valorPinesVideoConsulta"] - (int) $mod;
            $array_precios[$key] = (int) $array_precios[$key] + 1;
        }

        $result["precios"] = $array_precios;
        $result["intervalos"] = count($array_precios);
        $result["cantidad_max"] = max($array_precios);

        if ((int) $result["cantidad_max"] > 0) {
            $result["tarifa_recomendada"] = array_keys($array_precios, $result["cantidad_max"])[0];
        }

        return $result;
    }

    /*     * Metodo que limpia los filtros de busqueda de una nueva consulta para realizar una nueva busqueda
     * 
     * @param type $idvideoconsulta
     * @return boolean
     */

    public function deleteFiltrosBusqueda($idvideoconsulta) {

        //$consulta=$this->getManager("ManagerVideoConsulta")->get($idvideoconsulta);
        $rdo1 = $this->db->Execute("delete from medicoeliminadovideoconsulta where videoconsulta_idvideoconsulta=$idvideoconsulta");

        $rdo2 = $this->db->Execute("delete from filtrosbusquedavideoconsulta where videoconsulta_idvideoconsulta=$idvideoconsulta");

        if ($rdo1 && $rdo2) {
            $this->setMsg(["result" => true, "msg" => "Filtros de busqueda eliminados con exito"]);
            return true;
        } else {
            $this->setMsg(["result" => false, "msg" => "No se pudieron limpiar los filtros de busqueda. Intente nuevamente"]);
            return false;
        }
    }

    /*     * Metodo que devuelve la informacion para generar los tags de filtro de busqueda en consulta en la red
     * 
     * @param type $request
     */

    public function getTagsFiltro($request) {

        unset($request["modulo"]);
        unset($request["submodulo"]);
        unset($request["cname"]);
        unset($request["from_filtro"]);
        $ManagerEspecialidades = $this->getManager("ManagerEspecialidades");
        $ManagerSubespecialidades = $this->getManager("ManagerSubespecialidades");
        $ManagerObraSocial = $this->getManager("ManagerObrasSociales");

        $result = [];
        if (COUNT($request["idespecialidad"] > 0)) {
            foreach ($request["idespecialidad"] as $id) {
                $tag = [];
                $tag["clave"] = "idespecialidad";
                $tag["id"] = $id;
                $tag["text"] = $ManagerEspecialidades->get($id)["especialidad"];
                $result[] = $tag;
            }
        }

        if (COUNT($request["idsubespecialidad"] > 0)) {
            foreach ($request["idsubespecialidad"] as $id) {
                $tag = [];
                $tag["clave"] = "idsubespecialidad";
                $tag["id"] = $id;
                $tag["text"] = $ManagerSubespecialidades->get($id)["subEspecialidad"];
                $result[] = $tag;
            }
        }

        if (COUNT($request["idobrasocial"] > 0)) {
            foreach ($request["idobrasocial"] as $id) {
                $tag = [];
                $tag["clave"] = "idobrasocial";
                $tag["id"] = $id;
                $tag["text"] = $ManagerObraSocial->get($id)["nombre"];
                $result[] = $tag;
            }
        }
        return $result;
    }

    /*     * Metodo que retorna la cantidad de videoconsulta en cada rango de precio para el slider de filtro de busqueda por rango de precios
     * 
     */

    public function getRangoPreciosVideoConsulta() {

        $array_precios = array();

        //se crea el array con cada elemento del intervalo cada $10
        for ($i = 5; $i <= 60; $i = $i + 5) {
            $res = $this->db->getRow("select count(idvideoconsulta) as cant from videoconsulta vc inner join filtrosbusquedavideoconsulta f on (f.videoconsulta_idvideoconsulta=ce.idvideoconsulta)
                                      where estadoVideoConsulta_idestadoVideoConsulta=1
                                      and $i BETWEEN f.rango_minimo and f.rango_maximo");
            $array_precios[$i] = $res["cant"];
        }
        $result["precios"] = $array_precios;
        $result["intervalos"] = count($array_precios);
        $result["cantidad_max"] = max($array_precios);
        return $result;
    }

}
