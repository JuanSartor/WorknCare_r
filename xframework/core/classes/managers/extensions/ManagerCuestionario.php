<?php

/**
 * 	@autor Xinergia
 * 	@version 1.0	20/11/2020
 * 	Manager de Programas de salud.
 *
 */
class ManagerCuestionario extends ManagerMedia {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "cuestionarios", "idcuestionario");
    }

    public function getListadoJSON($request, $idpaginate = NULL) {

        if (!is_null($idpaginate)) {
            $this->paginate($idpaginate, 20);
        }

        $query = new AbstractSql();
        $query->setSelect("t.idcuestionario as idcuestionario ,t.titulo as titulo, IF(p.pago_pendiente=2,'Verificar','Nada Pendiente') as transferencia_estado, e.empresa as empresa");
        $query->setFrom("
                $this->table t LEFT JOIN pago_recompensa_encuesta p ON (p.cuestionario_idcuestionario=t.idcuestionario)
           INNER JOIN empresa e ON (e.idempresa= t.empresa_idempresa) ");
        // Filtro
        if ($request["titulo"] != "") {

            $rdo = cleanQuery($request["titulo"]);

            $query->addAnd("t.titulo LIKE '%$rdo%'");
        }
        if ($request["empresa"] != "") {

            $rdo = cleanQuery($request["empresa"]);

            $query->addAnd("e.empresa LIKE '%$rdo%'");
        }


        $data = $this->getJSONList($query, array("titulo", "transferencia_estado", "empresa"), $request, $idpaginate);

        return $data;
    }

    public function getListadoJSONGenericos($request, $idpaginate = NULL) {
        if (!is_null($idpaginate)) {
            $this->paginate($idpaginate, 20);
        }

        $query = new AbstractSql();
        $query->setSelect("t.idcuestionario as idcuestionario ,t.titulo as titulo, IF(t.empresa_idempresa=0,'Nada Pendiente','error') as transferencia_estado, IF(t.empresa_idempresa=0,'GENERICO','error') as empresa");
        $query->setFrom("
                $this->table t");
        $query->setWhere("t.empresa_idempresa=0");
        // Filtro
        if ($request["titulo"] != "") {

            $rdo = cleanQuery($request["titulo"]);

            $query->addAnd("t.titulo LIKE '%$rdo%'");
        }
        if ($request["empresa"] != "") {

            $rdo = cleanQuery($request["empresa"]);

            $query->addAnd("e.empresa LIKE '%$rdo%'");
        }


        $data = $this->getJSONList($query, array("titulo", "transferencia_estado", "empresa"), $request, $idpaginate);

        return $data;
    }

    /**
     * Método que devuelve un registro 
     * @param type $id
     */
    public function get($id) {
        $record = parent::get($id);
        return $record;
    }

    /**
     * 
     *  obtengo listado de cuestionarios todos los de la familia pasada
     * @param type $request
     * @param type $idpaginate
     * @return type
     */
    public function getListadoCuestionarios($request, $idpaginate = null) {
        $query = new AbstractSql();
        $query->setSelect("t.*");
        $query->setFrom(" $this->table  t");
        $query->setWhere("t.id_familia_cuestionario=" . $request["id_familia_cuestionarios"]);
        $query->addAnd("t.genero_qr=0");
        $query->setOrderBy("t.idcuestionario DESC");
        $data = $this->getList($query);
        return $data;
    }

    /**
     * 
     * @param type $request
     * @param type $idpaginate
     *  listado de cuestionarios finalizados
     */
    public function getListadoCuestionariosFinalizados() {
        $idempresa = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idempresa"];
        $usuario_empresa = $this->getManager("ManagerUsuarioEmpresa")->get($_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idusuario_empresa"]);
        $query = new AbstractSql();
        $query->setSelect("*");
        $query->setFrom(" $this->table  t  INNER JOIN pago_recompensa_encuesta p ON (p.cuestionario_idcuestionario = t.idcuestionario)
        LEFT JOIN usuario_empresa u ON (t.usuarioempresa_idusuarioempresa = u.idusuario_empresa)");

        $query->setWhere("t.empresa_idempresa=" . $idempresa);
        $query->addAnd("t.estado=2");
        $query->addAnd("p.pago_pendiente!=0");
        $query->addAnd("p.pago_pendiente!=3");
        if ($usuario_empresa["tipo_usuario"] == '5') {
            $query->addAnd("t.usuarioempresa_idusuarioempresa=" . $usuario_empresa["idusuario_empresa"]);
        }
        $query->setOrderBy("t.idcuestionario DESC");
        $data = $this->getList($query);
        return $data;
    }

    public function deleteCuestionario($request) {

        $managerPregunta = $this->getManager("ManagerPregunta");
        $rdo = $managerPregunta->db->Execute("delete from $managerPregunta->table where cuestionarios_idcuestionario=$request");
        if ($rdo) {
            return parent::delete($request);
        } else {
            return false;
        }
    }

    /**
     * obtengo la cantidad de los cuestionarios genericos y asociados a la empresa
     * @return type
     */
    public function getCuestionariosEmpresa() {
        $idempresa = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idempresa"];
        $usuario_empresa = $this->getManager("ManagerUsuarioEmpresa")->get($_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idusuario_empresa"]);
        $query = new AbstractSql();
        $query->setSelect("count(*) as cantidad, f.nombre,ce.id_familia_cuestionario,f.nombre_en");
        $query->setFrom("cuestionarios ce
                inner join familia_cuestionarios f on (f.id_familia_cuestionarios=ce.id_familia_cuestionario)");
        $query->setWhere("ce.empresa_idempresa=0 or ce.empresa_idempresa=" . $idempresa);
        $query->addAnd("ce.visible=1");
        $query->addAnd("f.visible=1");
        $query->addAnd("ce.estado=0 or ce.estado=1 ");
        if ($usuario_empresa["tipo_usuario"] != '1') {
            $query->addAnd("ce.usuarioempresa_idusuarioempresa=0 or ce.usuarioempresa_idusuarioempresa=" . $usuario_empresa["idusuario_empresa"]);
        }
        $query->setGroupBy("ce.id_familia_cuestionario");
        return $this->getList($query);
    }

    /**
     *  metodo para crear nuevo cuestionario del lado empresa a partir de un modelo seleccionado
     * @param type $request
     */
    public function crearCuestionarioEmpresa($request) {
        $usuario_empresa = $this->getManager("ManagerUsuarioEmpresa")->get($_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idusuario_empresa"]);
        // $this->debug();
        // familia 1 va a ser mis modelos, creo el nuevo cuestionario
        $requestCuestionario["mensaje"] = $request["mensaje"];
        $requestCuestionario["id_familia_cuestionario"] = '1';
        $requestCuestionario["empresa_idempresa"] = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idempresa"];
        if ($request["estimacion_cuestionarios_totales"] != '') {
            $requestCuestionario["estimacion_cuestionarios_totales"] = $request["estimacion_cuestionarios_totales"];
        }
        if ($request["titulo"] != '') {
            $i = 1;
            $requestCuestionario["titulo"] = $request["titulo"];
            while ($this->getByFieldArray(["empresa_idempresa", "titulo"], [$requestCuestionario["empresa_idempresa"], $requestCuestionario["titulo"]])) {
                $requestCuestionario["titulo"] = $request["titulo"] . " (" . $i . ")";
                $i++;
            }
        }
        if ($request["fecha_inicio"] != '' && $request["band"] != 1) {
            $fechainiexplode = explode("/", $request["fecha_inicio"]);
            $fechaI = $fechainiexplode[2] . "-" . $fechainiexplode[1] . "-" . $fechainiexplode[0];
            $requestCuestionario["fecha_inicio"] = date("Y-m-d", strtotime($fechaI));
        }
        if ($request["fecha_fin"] != '' && $request["band"] != 1) {
            $fechafinexplode = explode("/", $request["fecha_fin"]);
            $fechaf = $fechafinexplode[2] . "-" . $fechafinexplode[1] . "-" . $fechafinexplode[0];
            $requestCuestionario["fecha_fin"] = date("Y-m-d", strtotime($fechaf));
        }
        $requestCuestionario["usuarioempresa_idusuarioempresa"] = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idusuario_empresa"];
        $idNuevoCuestionario = parent::process($requestCuestionario);

        // busco las preguntas del cuestionario que selecciono
        $managerPregunta = $this->getManager("ManagerPregunta");
        if ($request["idcuestionario"] != '') {
            $listado = $managerPregunta->getListadoPreguntas(["cuestionarios_idcuestionario" => $request["idcuestionario"]]);

            // inserto las preguntas del cuestionario que seleccion al nuevo cuestionario
            $requesPregunta[] = '';
            foreach ($listado as $pregunta) {
                if ($usuario_empresa["idioma_predeterminado"] == 'fr') {
                    $requesPregunta["pregunta"] = $pregunta["pregunta"];
                } else {
                    $requesPregunta["pregunta"] = $pregunta["pregunta_en"];
                }

                $requesPregunta["cuestionarios_idcuestionario"] = $idNuevoCuestionario;
                $rdofor = $managerPregunta->process($requesPregunta);
                $requesPregunta[] = '';
            }
        }

        // busco las preguntas abiertas del cuestionario
        $managerPreguntaAbierta = $this->getManager("ManagerPreguntaAbierta");
        if ($request["idcuestionario"] != '') {
            $listadoPreguAbiertas = $managerPreguntaAbierta->getListadoPreguntas(["cuestionario_idcuestionario" => $request["idcuestionario"]]);

            // inserto las preguntas del cuestionario que seleccion al nuevo cuestionario
            $requesPreguntaAb[] = '';
            foreach ($listadoPreguAbiertas as $pregunta) {
                if ($usuario_empresa["idioma_predeterminado"] == 'fr') {
                    $requesPreguntaAb["pregunta"] = $pregunta["pregunta"];
                } else {
                    $requesPregunta["pregunta"] = $pregunta["pregunta_en"];
                }
                $requesPreguntaAb["cuestionario_idcuestionario"] = $idNuevoCuestionario;
                $rdofor = $managerPreguntaAbierta->process($requesPreguntaAb);
                $requesPreguntaAb[] = '';
            }
        }


        // inserto la nueva pregunta si existe
        if ($request["nuevaPregunta"] != '' && $request["rtaCerrada"] == 'true') {
            $requesPregunta["pregunta"] = $request["nuevaPregunta"];
            $requesPregunta["cuestionarios_idcuestionario"] = $idNuevoCuestionario;
            $rdo = $managerPregunta->process($requesPregunta);
        } elseif ($request["nuevaPregunta"] != '' && $request["rtaCerrada"] == 'false') {
            $requesPregunta["pregunta"] = $request["nuevaPregunta"];
            $requesPregunta["cuestionario_idcuestionario"] = $idNuevoCuestionario;
            $rdo = $managerPreguntaAbierta->process($requesPregunta);
        } else {
            $rdo = false;
        }

        if ($rdo) {
            $this->setMsg(["result" => true, "msg" => "Pregunta agregada correctamente.", "idcuestionarionuevo" => $idNuevoCuestionario]);
            return true;
        } elseif ($rdofor) {
            $this->setMsg(["result" => true, "msg" => "Cuestionario creado correctamente.", "idcuestionarionuevo" => $idNuevoCuestionario]);
            return true;
        } else {
            $this->setMsg(["result" => false, "msg" => "No se pudo agregar la pregunta."]);
            return false;
        }
    }

    /**
     *  crear un cuestionario cuando eliminan una pregunta, 
     * es decir lo crea porque ya deja de ser generico
     * @param type $request
     * @return boolean
     */
    public function crearCuestionarioEmpresaConEliminacion($request) {
        $usuario_empresa = $this->getManager("ManagerUsuarioEmpresa")->get($_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idusuario_empresa"]);
        // familia 1 va a ser mis modelos, creo el nuevo cuestionario
        $requestCuestionario["mensaje"] = $request["mensaje"];
        $requestCuestionario["id_familia_cuestionario"] = '1';
        $requestCuestionario["empresa_idempresa"] = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idempresa"];
        if ($request["titulo"] != '') {
            $i = 1;
            $requestCuestionario["titulo"] = $request["titulo"];
            while ($this->getByFieldArray(["empresa_idempresa", "titulo"], [$requestCuestionario["empresa_idempresa"], $requestCuestionario["titulo"]])) {
                $requestCuestionario["titulo"] = $request["titulo"] . " (" . $i . ")";
                $i++;
            }
        }
        if ($request["estimacion_cuestionarios_totales"] != '') {
            $requestCuestionario["estimacion_cuestionarios_totales"] = $request["estimacion_cuestionarios_totales"];
        }
        if ($request["fecha_inicio"] != '') {
            $fechainiexplode = explode("/", $request["fecha_inicio"]);
            $fechaI = $fechainiexplode[2] . "-" . $fechainiexplode[1] . "-" . $fechainiexplode[0];
            $requestCuestionario["fecha_inicio"] = date("Y-m-d", strtotime($fechaI));
        }
        if ($request["fecha_fin"] != '') {
            $fechafinexplode = explode("/", $request["fecha_fin"]);
            $fechaf = $fechafinexplode[2] . "-" . $fechafinexplode[1] . "-" . $fechafinexplode[0];
            $requestCuestionario["fecha_fin"] = date("Y-m-d", strtotime($fechaf));
        }
        $requestCuestionario["usuarioempresa_idusuarioempresa"] = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idusuario_empresa"];

        $idNuevoCuestionario = parent::process($requestCuestionario);

        // busco las preguntas del cuestionario que selecciono
        $managerPregunta = $this->getManager("ManagerPregunta");
        $listado = $managerPregunta->getListadoPreguntas(["cuestionarios_idcuestionario" => $request["cuestionarios_idcuestionario"]]);

        $managerPreguntaAbierta = $this->getManager("ManagerPreguntaAbierta");
        $listadoPregAbiertas = $managerPreguntaAbierta->getListadoPreguntas(["cuestionario_idcuestionario" => $request["cuestionarios_idcuestionario"]]);


        $pieces = explode("-", $request["idpregunta"]);

        // inserto las preguntas del cuestionario que seleccion al nuevo cuestionario
        //aca entra si el id de la pregunta es cerrada, entonces veo cual tengo q eliminar
        if ($pieces[0] == 'cerrada') {
            $requesPregunta[] = '';
            foreach ($listado as $pregunta) {
                if ($pregunta["idpregunta"] != $pieces[1]) {
                    if ($usuario_empresa["idioma_predeterminado"] == 'fr') {
                        $requesPregunta["pregunta"] = $pregunta["pregunta"];
                    } else {
                        $requesPregunta["pregunta"] = $pregunta["pregunta_en"];
                    }
                    $requesPregunta["cuestionarios_idcuestionario"] = $idNuevoCuestionario;
                    $rdo = $managerPregunta->process($requesPregunta);
                    $requesPregunta[] = '';
                }
            }
        } else { // aca ingresa porque tengo q agregar todas las preguntas si el id a eliminar
            // no es cerrada
            $requesPregunta[] = '';
            foreach ($listado as $pregunta) {
                if ($usuario_empresa["idioma_predeterminado"] == 'fr') {
                    $requesPregunta["pregunta"] = $pregunta["pregunta"];
                } else {
                    $requesPregunta["pregunta"] = $pregunta["pregunta_en"];
                }
                $requesPregunta["cuestionarios_idcuestionario"] = $idNuevoCuestionario;
                $rdo = $managerPregunta->process($requesPregunta);
                $requesPregunta[] = '';
            }
        }


        if ($pieces[0] == 'abierta') { // pasa lo mismo que el if de arriba
            $requesPregunta[] = '';
            foreach ($listadoPregAbiertas as $pregunta) {
                if ($pregunta["idpregunta_abierta_cuestionario"] != $pieces[1]) {
                    if ($usuario_empresa["idioma_predeterminado"] == 'fr') {
                        $requesPregunta["pregunta"] = $pregunta["pregunta"];
                    } else {
                        $requesPregunta["pregunta"] = $pregunta["pregunta_en"];
                    }
                    $requesPregunta["cuestionario_idcuestionario"] = $idNuevoCuestionario;
                    $rdo = $managerPreguntaAbierta->process($requesPregunta);
                    $requesPregunta[] = '';
                }
            }
        } else {
            $requesPregunta[] = '';
            foreach ($listadoPregAbiertas as $pregunta) {
                if ($usuario_empresa["idioma_predeterminado"] == 'fr') {
                    $requesPregunta["pregunta"] = $pregunta["pregunta"];
                } else {
                    $requesPregunta["pregunta"] = $pregunta["pregunta_en"];
                }
                $requesPregunta["cuestionario_idcuestionario"] = $idNuevoCuestionario;
                $rdo = $managerPreguntaAbierta->process($requesPregunta);
                $requesPregunta[] = '';
            }
        }

        if ($rdo) {
            $this->setMsg(["result" => true, "msg" => "Pregunta eliminada correctamente.", "idcuestionarionuevo" => $idNuevoCuestionario]);
            return true;
        } else {
            $this->setMsg(["result" => false, "msg" => "No se pudo eliminar la pregunta."]);
            return false;
        }
    }

    public function getCantidadCuestionariosPreparados() {
        $idempresa = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idempresa"];
        $usuario_empresa = $this->getManager("ManagerUsuarioEmpresa")->get($_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idusuario_empresa"]);

        $query = new AbstractSql();
        $query->setSelect("count(*) as cantidad");
        $query->setFrom("cuestionarios ce");
        $query->setWhere("ce.empresa_idempresa=" . $idempresa);
        $query->addAnd("ce.estado=1");
        if ($usuario_empresa["tipo_usuario"] == '5') {
            $query->addAnd("ce.usuarioempresa_idusuarioempresa=" . $usuario_empresa["idusuario_empresa"]);
        }
        return $this->db->GetRow($query->getSql());
    }

    public function getCantidadCuestionariosFinalizados() {
        $idempresa = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idempresa"];
        $usuario_empresa = $this->getManager("ManagerUsuarioEmpresa")->get($_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idusuario_empresa"]);

        $query = new AbstractSql();
        $query->setSelect("count(*) as cantidad");
        $query->setFrom("cuestionarios ce");
        $query->setWhere("ce.empresa_idempresa=" . $idempresa);
        $query->addAnd("ce.estado=2");
        if ($usuario_empresa["tipo_usuario"] == '5') {
            $query->addAnd("ce.usuarioempresa_idusuarioempresa=" . $usuario_empresa["idusuario_empresa"]);
        }
        return $this->db->GetRow($query->getSql());
    }

    public function getUltimoCuestionarioFinalizado() {
        $idempresa = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idempresa"];

        $query = new AbstractSql();
        $query->setSelect("*");
        $query->setFrom("cuestionarios ce");
        $query->setWhere("ce.empresa_idempresa=" . $idempresa);
        $query->addAnd("ce.estado=2");
        $query->setOrderBy("ce.idcuestionario DESC");
        return $this->db->GetRow($query->getSql());
    }

    /**
     *  crear un cuestionario cuando actualizan una pregunta de un cuestionario generico, 
     * es decir lo crea porque ya deja de ser generico con la pregunta editada
     * @param type $request
     * @return boolean
     */
    public function crearCuestionarioEmpresaConEdicionDeGenerico($request) {
        $usuario_empresa = $this->getManager("ManagerUsuarioEmpresa")->get($_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idusuario_empresa"]);
        // familia 1 va a ser mis modelos, creo el nuevo cuestionario
        $requestCuestionario["mensaje"] = $request["mensaje"];
        $requestCuestionario["id_familia_cuestionario"] = '1';
        $requestCuestionario["empresa_idempresa"] = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idempresa"];
        if ($request["titulo"] != '') {
            $i = 1;
            $requestCuestionario["titulo"] = $request["titulo"];
            while ($this->getByFieldArray(["empresa_idempresa", "titulo"], [$requestCuestionario["empresa_idempresa"], $requestCuestionario["titulo"]])) {
                $requestCuestionario["titulo"] = $request["titulo"] . " (" . $i . ")";
                $i++;
            }
        }
        if ($request["estimacion_cuestionarios_totales"] != '') {
            $requestCuestionario["estimacion_cuestionarios_totales"] = $request["estimacion_cuestionarios_totales"];
        }
        if ($request["fecha_inicio"] != '') {
            $fechainiexplode = explode("/", $request["fecha_inicio"]);
            $fechaI = $fechainiexplode[2] . "-" . $fechainiexplode[1] . "-" . $fechainiexplode[0];
            $requestCuestionario["fecha_inicio"] = date("Y-m-d", strtotime($fechaI));
        }
        if ($request["fecha_fin"] != '') {
            $fechafinexplode = explode("/", $request["fecha_fin"]);
            $fechaf = $fechafinexplode[2] . "-" . $fechafinexplode[1] . "-" . $fechafinexplode[0];
            $requestCuestionario["fecha_fin"] = date("Y-m-d", strtotime($fechaf));
        }
        $requestCuestionario["usuarioempresa_idusuarioempresa"] = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idusuario_empresa"];
        $idNuevoCuestionario = parent::process($requestCuestionario);

        // busco las preguntas del cuestionario que selecciono
        $managerPregunta = $this->getManager("ManagerPregunta");
        $listado = $managerPregunta->getListadoPreguntas(["cuestionarios_idcuestionario" => $request["idcuestionario"]]);

        $managerPreguntaAbierta = $this->getManager("ManagerPreguntaAbierta");
        $listadoPregAbiertas = $managerPreguntaAbierta->getListadoPreguntas(["cuestionario_idcuestionario" => $request["idcuestionario"]]);

        $banderaTipoPregunta;
        $idPregActualizar;

        // inserto las preguntas del cuestionario que seleccion al nuevo cuestionario
        $requesPregunta[] = '';
        foreach ($listado as $pregunta) {
            if ($usuario_empresa["idioma_predeterminado"] == 'fr') {
                $requesPregunta["pregunta"] = $pregunta["pregunta"];
            } else {
                $requesPregunta["pregunta"] = $pregunta["pregunta_en"];
            }
            $requesPregunta["cuestionarios_idcuestionario"] = $idNuevoCuestionario;
            $rdo = $managerPregunta->process($requesPregunta);
            $requesPregunta[] = '';

            if ($pregunta["idpregunta"] == $request["idpregunta"] && $request["rtaCerrada"] == 'true' && $request["primerRta"] == 'cerrada') {
                // si la pregunta era cerrada y sigue siendo cerrada pongo la bandera en 1
                $banderaTipoPregunta = 1;
                $idPregActualizar = $rdo;
            }
            if ($pregunta["idpregunta"] == $request["idpregunta"] && $request["rtaCerrada"] == 'false' && $request["primerRta"] == 'cerrada') {
                // si la pregunta era cerrada y ahora pasa a ser abierta
                $banderaTipoPregunta = 2;
                $idPregActualizar = $rdo;
            }
        }


        // inserto las preguntas del cuestionario que seleccion al nuevo cuestionario preguntas abiertas
        $requesPreguntaAbierta[] = '';
        foreach ($listadoPregAbiertas as $pregunta) {
            if ($usuario_empresa["idioma_predeterminado"] == 'fr') {
                $requesPreguntaAbierta["pregunta"] = $pregunta["pregunta"];
            } else {
                $requesPreguntaAbierta["pregunta"] = $pregunta["pregunta_en"];
            }
            $requesPreguntaAbierta["cuestionario_idcuestionario"] = $idNuevoCuestionario;
            $rdo = $managerPreguntaAbierta->process($requesPreguntaAbierta);
            $requesPreguntaAbierta[] = '';
            print($pregunta["idpregunta"]);
            if ($pregunta["idpregunta_abierta_cuestionario"] == $request["idpregunta"] && $request["rtaCerrada"] == 'false' && $request["primerRta"] == 'abierta') {
                // si la pregunta era abierta y sigue siendo abierta pongo la bandera en 3
                $banderaTipoPregunta = 3;
                $idPregActualizar = $rdo;
            }
            if ($pregunta["idpregunta_abierta_cuestionario"] == $request["idpregunta"] && $request["rtaCerrada"] == 'true' && $request["primerRta"] == 'abierta') {
                // si la pregunta era abierta y ahora pasa a ser cerrada
                $banderaTipoPregunta = 4;
                $idPregActualizar = $rdo;
            }
        }

        switch ($banderaTipoPregunta) {
            case 1:
                $rdo = $managerPregunta->update(["pregunta" => $request["pregunta"]], $idPregActualizar);
                break;
            case 2:
                $managerPregunta->delete($idPregActualizar);
                $re["cuestionario_idcuestionario"] = $idNuevoCuestionario;
                $re["pregunta"] = $request["pregunta"];
                $rdo = $managerPreguntaAbierta->process($re);
                break;
            case 3:
                $rdo = $managerPreguntaAbierta->update(["pregunta" => $request["pregunta"]], $idPregActualizar);
                break;
            case 4:
                $managerPreguntaAbierta->delete($idPregActualizar);
                $re["cuestionarios_idcuestionario"] = $idNuevoCuestionario;
                $re["pregunta"] = $request["pregunta"];
                $rdo = $managerPregunta->process($re);
                break;
        }

        if ($rdo) {
            $this->setMsg(["result" => true, "msg" => "Pregunta actualizada correctamente.", "idcuestionario" => $idNuevoCuestionario]);
            return true;
        } else {
            $this->setMsg(["result" => false, "msg" => "No se pudo actualizar la pregunta."]);
            return false;
        }
    }

    public function getReportePDF($request) {
        // obtengo todas las respuestas del cuestionario pasado como parametro
        $ManagerRe = $this->getManager("ManagerRespuestasCuestionario");
        $respuestasAcuestionario = $ManagerRe->respuestaACuestionario($request["idcuestionario"]);
        $cantReaspuestas = count($respuestasAcuestionario);
        $request["cantReaspuestas"] = $cantReaspuestas;
        $rqP["cuestionario_idcuestionario"] = $request["idcuestionario"];
        $preguntasAbiertas = $this->getManager("ManagerPreguntaAbierta")->getListadoPreguntas($rqP);

        foreach ($preguntasAbiertas as $key => $value) {
            $preguntasAbiertas[$key]["respuestas"] = $this->getManager("ManagerRespuestasAbiertasCuestionario")->respuestaACuestionario($value["idpregunta_abierta_cuestionario"]);
        }
        //armo el diccionario donde c1 representa el id de pregunta y el resto es
        // cuantas respuestas hay de 1, 2, 3, 4
        $arrAuxiliar = explode(",", $respuestasAcuestionario[0]["respuestas"]);
        $diccionarioIdPreg = Array();
        $i = 0;
        $banderaPregCerr = 0;
        foreach ($arrAuxiliar as $idDic) {
            $c1 = substr(( stristr($idDic, "-")), 1);
            // print($idDic);
            $diccionarioIdPreg[$c1][1] = 0;
            $diccionarioIdPreg[$c1][2] = 0;
            $diccionarioIdPreg[$c1][3] = 0;
            $diccionarioIdPreg[$c1][4] = 0;
            $ManagerPregg = $this->getManager("ManagerPregunta");
            $pregunt = $ManagerPregg->get($c1);
            if ($pregunt != '') {
                $banderaPregCerr = 1;
            }
            $diccionarioIdPreg[$c1]["pregunta"] = $pregunt["pregunta"];
            $i++;
        }

        /**
         * $diccionarioIdPreg
         * este diccionario tiene el id de la pregunta
         * y en el valor 1 la cantidad de respuestas que tuvo como nada de acuerdo
         *  en la 2  casi de acuardo
         *  3 de acuerdo
         *  4 abolutamente de acuerdo
         * pregunta tiene el texto de la pregunta
         * 
         */
        foreach ($respuestasAcuestionario as $respuesta) {
            $arregloRespuestas = explode(",", $respuesta["respuestas"]);
            foreach ($arregloRespuestas as $respuestaApregunta) {

                $arregloRespuestas = explode("-", $respuestaApregunta);

                $diccionarioIdPreg[$arregloRespuestas[1]][$arregloRespuestas[0]] ++;
            }
        }
        // print_r($diccionarioIdPreg);
        $cantRtasAb = $this->getManager("ManagerRespuestasAbiertasCuestionario")->getCantidaRtasAbiertas($request["idcuestionario"]);
        $request["cantRtasAbiertas"] = $cantRtasAb["cantidad"];
        $request["cantPreguntasAbiertas"] = count($preguntasAbiertas);
        $request["cantPreguntasTotales"] = $request["cantPreguntasAbiertas"] + $request["cantidadPreguntas"];
        $request["banderaPregCerr"] = $banderaPregCerr;
        $cuestionario = $this->get($request["idcuestionario"]);
        $request["cuestAnonimo"] = $cuestionario["anonimo"];
        $request["usuario"] = $this->getManager("ManagerUsuarioEmpresa")->get($_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idusuario_empresa"]);

        // textos auxiliares
        $request["fechaEmision"] = $this->getManager("ManagerTextoAuxiliares")->get('2');
        $request["fechaFin"] = $this->getManager("ManagerTextoAuxiliares")->get('3');
        $request["preguntas"] = $this->getManager("ManagerTextoAuxiliares")->get('4');
        $request["preguntas_completas"] = $this->getManager("ManagerTextoAuxiliares")->get('5');

        $request["6"] = $this->getManager("ManagerTextoAuxiliares")->get('6');
        $request["7"] = $this->getManager("ManagerTextoAuxiliares")->get('7');
        $request["8"] = $this->getManager("ManagerTextoAuxiliares")->get('8');
        $request["9"] = $this->getManager("ManagerTextoAuxiliares")->get('9');

        $request["10"] = $this->getManager("ManagerTextoAuxiliares")->get('10');
        $request["11"] = $this->getManager("ManagerTextoAuxiliares")->get('11');
        $request["12"] = $this->getManager("ManagerTextoAuxiliares")->get('12');
        $request["13"] = $this->getManager("ManagerTextoAuxiliares")->get('13');

        $PDFInvitacionPass = new PDFReporteCuestionario();
        $PDFInvitacionPass->getPDF($request, $diccionarioIdPreg, $preguntasAbiertas);
    }

    /**
     * Generacion del excen informen cuestionario
     */
    public function exportarInformeCuestionario($request) {

        $usuario_empresa = $this->getManager("ManagerUsuarioEmpresa")->get($_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idusuario_empresa"]);
        $prenom = $this->getManager("ManagerTextoAuxiliares")->get('11');
        $nom = $this->getManager("ManagerTextoAuxiliares")->get('12');
        $email = $this->getManager("ManagerTextoAuxiliares")->get('13');

        $pas = $this->getManager("ManagerTextoAuxiliares")->get('6');
        $plu = $this->getManager("ManagerTextoAuxiliares")->get('7');
        $plu2 = $this->getManager("ManagerTextoAuxiliares")->get('8');
        $abs = $this->getManager("ManagerTextoAuxiliares")->get('9');

        function array_sort_by(&$arrIni, $col, $order = SORT_ASC) {
            $arrAux = array();
            foreach ($arrIni as $key => $row) {
                $arrAux[$key] = is_object($row) ? $arrAux[$key] = $row->$col : $row[$col];
                $arrAux[$key] = strtolower($arrAux[$key]);
            }
            array_multisort($arrAux, $order, $arrIni);
        }

        require_once(path_libs_php("PHPExcel/Classes/PHPExcel.php"));
        require_once(path_libs_php("PHPExcel/Classes/PHPExcel/IOFactory.php"));
        //$this->debug();
        // obtengo el cuestionario con las preguntas
        $query = new AbstractSql();
        $query->setSelect("*");
        $query->setFrom("cuestionarios c INNER JOIN preguntas p ON (c.idcuestionario=p.cuestionarios_idcuestionario)");
        $query->setWhere("c.idcuestionario = $request");

        $data = $this->getList($query);


        // obtengo las preguntas abiertas
        $queryA = new AbstractSql();
        $queryA->setSelect("*");
        $queryA->setFrom("cuestionarios c INNER JOIN preguntas_abiertas p ON (c.idcuestionario=p.cuestionario_idcuestionario)");
        $queryA->setWhere("c.idcuestionario = $request");

        $dataA = $this->getList($queryA);

        //template
        $inputFileName = path_root() . "xframework/app/empresa/view/templates/excel/listado_preguntas_template.xlsx";
        $inputFileType = PHPExcel_IOFactory::identify($inputFileName);
        $objReader = PHPExcel_IOFactory::createReader($inputFileType);
        $objPHPExcel = $objReader->load($inputFileName);

        $cuest = $this->get($request);
        $i = 0;
        $r_start = 3;
        $objPHPExcel->setActiveSheetIndex($i);
        $active_sheet = $objPHPExcel->getActiveSheet();
        $letrai = 'a';

        array_sort_by($data, "orden");
        // inserto las preguntas, es decir los titulos de cada columna
        foreach ($data as $cuestionario) {

            $active_sheet->setCellValue($letrai . $r_start, "{$cuestionario["pregunta"]}");
            $active_sheet->getStyle($letrai . $r_start)->applyFromArray(
                    array(
                        'fill' => array(
                            'type' => PHPExcel_Style_Fill::FILL_SOLID,
                            'color' => array('rgb' => 'FFE6D3')
                        )
                    )
            );

            $letrai++;
        }

        // inserto las preguntas abiertas
        $arrayRtas = Array();
        $posA = 0;
        $manaRtasAb = $this->getManager("ManagerRespuestasAbiertasCuestionario");
        $letraRtasAbierta = $letrai;
        foreach ($dataA as $cuestionario) {
            $arrayRtas[$posA] = $manaRtasAb->respuestaACuestionario($cuestionario["idpregunta_abierta_cuestionario"]);

            $active_sheet->setCellValue($letrai . $r_start, "{$cuestionario["pregunta"]}");
            $active_sheet->getStyle($letrai . $r_start)->applyFromArray(
                    array(
                        'fill' => array(
                            'type' => PHPExcel_Style_Fill::FILL_SOLID,
                            'color' => array('rgb' => 'FFE6D3')
                        )
                    )
            );
            $posA++;
            $letrai++;
        }


        // inserto nuevas columnas si no es anonimo, es decir el valor es 0
        if ($cuest["anonimo"] == '0') {
            if ($usuario_empresa["idioma_predeterminado"] == 'fr') {
                $active_sheet->setCellValue($letrai . $r_start, $prenom["texto_fr"]);
            } else {
                $active_sheet->setCellValue($letrai . $r_start, $prenom["texto_en"]);
            }
            $active_sheet->getStyle($letrai . $r_start)->applyFromArray(
                    array(
                        'fill' => array(
                            'type' => PHPExcel_Style_Fill::FILL_SOLID,
                            'color' => array('rgb' => 'E7E7E7')
                        )
                    )
            );
            $letrai++;
            if ($usuario_empresa["idioma_predeterminado"] == 'fr') {
                $active_sheet->setCellValue($letrai . $r_start, $nom["texto_fr"]);
            } else {
                $active_sheet->setCellValue($letrai . $r_start, $nom["texto_en"]);
            }
            $active_sheet->getStyle($letrai . $r_start)->applyFromArray(
                    array(
                        'fill' => array(
                            'type' => PHPExcel_Style_Fill::FILL_SOLID,
                            'color' => array('rgb' => 'E7E7E7')
                        )
                    )
            );
            $letrai++;
            if ($usuario_empresa["idioma_predeterminado"] == 'fr') {
                $active_sheet->setCellValue($letrai . $r_start, $email["texto_fr"]);
            } else {
                $active_sheet->setCellValue($letrai . $r_start, $email["texto_en"]);
            }
            $active_sheet->getStyle($letrai . $r_start)->applyFromArray(
                    array(
                        'fill' => array(
                            'type' => PHPExcel_Style_Fill::FILL_SOLID,
                            'color' => array('rgb' => 'E7E7E7')
                        )
                    )
            );
            $letrai++;
        }

        // inserto los titulos de las columnas para las fechas
//        $active_sheet->setCellValue($letrai . $r_start, "Start Date");
//        $active_sheet->getStyle($letrai . $r_start)->applyFromArray(
//                array(
//                    'fill' => array(
//                        'type' => PHPExcel_Style_Fill::FILL_SOLID,
//                        'color' => array('rgb' => 'FFFFFF')
//                    )
//                )
//        );
//        $letrai++;
        $active_sheet->setCellValue($letrai . $r_start, "Submit Date");
        $active_sheet->getStyle($letrai . $r_start)->applyFromArray(
                array(
                    'fill' => array(
                        'type' => PHPExcel_Style_Fill::FILL_SOLID,
                        'color' => array('rgb' => 'FFFFFF')
                    )
                )
        );


        //////////////////
        // aca empiezo a completar con los datos de las rtas
        // ///////////////
        // busco las rtas del cuestionario
        $manaRtas = $this->getManager("ManagerRespuestasCuestionario");
        $rtas = $manaRtas->respuestaACuestionario($request);

        // inserto las rtas en el excel
        $fila = 4;
        $filaInicialAbi;
        foreach ($rtas as $rta) {

            $arrAuxiliar = explode(",", $rta["respuestas"]);

            $col_rta = 'a';
            foreach ($arrAuxiliar as $idDic) {
                $texto_celda = '';

                $valor_rta = explode("-", $idDic);

                switch ($valor_rta[0]) {
                    case 1:

                        if ($usuario_empresa["idioma_predeterminado"] == 'fr') {
                            $texto_celda = $pas["texto_fr"];
                        } else {
                            $texto_celda = $pas["texto_en"];
                        }
                        break;
                    case 2:
                        if ($usuario_empresa["idioma_predeterminado"] == 'fr') {
                            $texto_celda = $plu["texto_fr"];
                        } else {
                            $texto_celda = $plu["texto_en"];
                        }
                        break;
                    case 3:
                        if ($usuario_empresa["idioma_predeterminado"] == 'fr') {
                            $texto_celda = $plu2["texto_fr"];
                        } else {
                            $texto_celda = $plu2["texto_en"];
                        }
                        break;
                    case 4:
                        if ($usuario_empresa["idioma_predeterminado"] == 'fr') {
                            $texto_celda = $abs["texto_fr"];
                        } else {
                            $texto_celda = $abs["texto_en"];
                        }
                        break;
                }
                $active_sheet->setCellValue($col_rta . $fila, "{$texto_celda}");
                $active_sheet->getStyle($col_rta . $fila)->applyFromArray(
                        array(
                            'fill' => array(
                                'type' => PHPExcel_Style_Fill::FILL_SOLID,
                                'color' => array('rgb' => 'FFE6D3')
                            )
                        )
                );
                $col_rta++;
            }
// inserto los datos si no es anonimo

            if (count($dataA) <= 0) {

                if ($cuest["anonimo"] == '0') {

                    $active_sheet->setCellValue($col_rta . $fila, $rta["nombre"]);
                    $active_sheet->getStyle($col_rta . $fila)->applyFromArray(
                            array(
                                'fill' => array(
                                    'type' => PHPExcel_Style_Fill::FILL_SOLID,
                                    'color' => array('rgb' => 'EAEAEA')
                                )
                            )
                    );
                    $col_rta++;
                    $active_sheet->setCellValue($col_rta . $fila, $rta["apellido"]);
                    $active_sheet->getStyle($col_rta . $fila)->applyFromArray(
                            array(
                                'fill' => array(
                                    'type' => PHPExcel_Style_Fill::FILL_SOLID,
                                    'color' => array('rgb' => 'EAEAEA')
                                )
                            )
                    );
                    $col_rta++;
                    $active_sheet->setCellValue($col_rta . $fila, $rta["email"]);
                    $active_sheet->getStyle($col_rta . $fila)->applyFromArray(
                            array(
                                'fill' => array(
                                    'type' => PHPExcel_Style_Fill::FILL_SOLID,
                                    'color' => array('rgb' => 'EAEAEA')
                                )
                            )
                    );
                    $col_rta++;
                }

                // inserto los datos de las fechas
//            $active_sheet->setCellValue($col_rta . $fila, "Start Date");
//            $active_sheet->getStyle($col_rta . $fila)->applyFromArray(
//                    array(
//                        'fill' => array(
//                            'type' => PHPExcel_Style_Fill::FILL_SOLID,
//                            'color' => array('rgb' => 'FFFFFF')
//                        )
//                    )
//            );
//            $col_rta++;
                $active_sheet->setCellValue($col_rta . $fila, $rta["fecha_registrada_respuestas"]);
                $active_sheet->getStyle($col_rta . $fila)->applyFromArray(
                        array(
                            'fill' => array(
                                'type' => PHPExcel_Style_Fill::FILL_SOLID,
                                'color' => array('rgb' => 'FFFFFF')
                            )
                        )
                );
            }

            $fila++;
            $filaInicialAbi = $fila + 1;
        }


        /**
         *  a partir de aca empiezo con las preguntas abiertas
         */
        //inserto las respuestas a las preguntas
        $letraRta = $letraRtasAbierta;
        $filaRta = 4;
        $cantCol = count($arrayRtas);
        $contC = 1;
        if (count($dataA) > 0) {
            foreach ($arrayRtas as $rtas) {
                foreach ($rtas as $rta) {

                    $active_sheet->setCellValue($letraRta . $filaRta, "{$rta["respuesta"]}");
                    $active_sheet->getStyle($letraRta . $filaRta)->applyFromArray(
                            array(
                                'fill' => array(
                                    'type' => PHPExcel_Style_Fill::FILL_SOLID,
                                    'color' => array('rgb' => 'FFE6D3')
                                )
                            )
                    );

                    if ($cantCol == $contC) {
                        $leDate = $letraRta;

                        if ($cuest["anonimo"] == '0') {
                            $leDate ++;
                            $active_sheet->setCellValue($leDate . $filaRta, "{$rta["nombre"]}");
                            $active_sheet->getStyle($leDate . $filaRta)->applyFromArray(
                                    array(
                                        'fill' => array(
                                            'type' => PHPExcel_Style_Fill::FILL_SOLID,
                                            'color' => array('rgb' => 'E7E7E7')
                                        )
                                    )
                            );
                            $leDate ++;
                            $active_sheet->setCellValue($leDate . $filaRta, "{$rta["apellido"]}");
                            $active_sheet->getStyle($leDate . $filaRta)->applyFromArray(
                                    array(
                                        'fill' => array(
                                            'type' => PHPExcel_Style_Fill::FILL_SOLID,
                                            'color' => array('rgb' => 'E7E7E7')
                                        )
                                    )
                            );
                            $leDate ++;
                            $active_sheet->setCellValue($leDate . $filaRta, "{$rta["email"]}");
                            $active_sheet->getStyle($leDate . $filaRta)->applyFromArray(
                                    array(
                                        'fill' => array(
                                            'type' => PHPExcel_Style_Fill::FILL_SOLID,
                                            'color' => array('rgb' => 'E7E7E7')
                                        )
                                    )
                            );
                        }
                        $leDate++;
                        $active_sheet->setCellValue($leDate . $filaRta, "{$rta["fecha_registrada_respuestas"]}");
                        $active_sheet->getStyle($leDate . $filaRta)->applyFromArray(
                                array(
                                    'fill' => array(
                                        'type' => PHPExcel_Style_Fill::FILL_SOLID,
                                        'color' => array('rgb' => 'FFFFFF')
                                    )
                                )
                        );
                    }

                    $filaRta++;
                }
                $filaRta = 4;
                $letraRta++;
                $contC++;
            }
        }
        $canCl = 1;
        for ($cl = 'a'; $cl <= $letraRta; $cl++) {
            $active_sheet->getStyle($cl . 1)->applyFromArray(
                    array(
                        'fill' => array(
                            'type' => PHPExcel_Style_Fill::FILL_SOLID,
                            'color' => array('rgb' => '3DB4C0')
                        )
                    )
            );
            $canCl++;
        }
        $c = $canCl / 2;
        $le = 'a';
        for ($i = 1; $i <= $c; $i++) {
            $le++;
        }
        $active_sheet->setCellValue('d' . '1', "Questionnaire");



        $active_sheet->setTitle("Questionnaire");
        //configuracion de hoja

        $active_sheet->getPageSetup()->setOrientation(PHPExcel_Worksheet_PageSetup::ORIENTATION_PORTRAIT);
        $active_sheet->getPageSetup()->setPaperSize(PHPExcel_Worksheet_PageSetup::PAPERSIZE_A4);
        $active_sheet->getPageSetup()->setFitToPage(true);
        $active_sheet->getPageSetup()->setFitToWidth(1);
        $active_sheet->getPageSetup()->setFitToHeight(0);


        $objPHPExcel->setActiveSheetIndex(0);

        // Write out as the new file
        $outputFileType = $inputFileType;
        $objWriter = PHPExcel_IOFactory::createWriter($objPHPExcel, $outputFileType);

        $fecha_actual = date("Y-m-d");

        //header('Content-Type: application/vnd.ms-excel');
        header('Content-Type: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
        header('Content-Disposition: attachment;filename="' . "questionnaire_rapport_" . $cuest["titulo"] . "_" . $fecha_actual . '.xlsx"');
        header('Cache-Control: max-age=0');
        ob_end_clean();
        $objWriter->save('php://output');
    }

    public function obtenerFacturas($idempresa) {
        $query = new AbstractSql();
        $query->setSelect("*, p.fecha_envio_factura as date");
        $query->setFrom("cuestionarios c, pago_recompensa_encuesta p ");
        $query->setWhere("c.empresa_idempresa = $idempresa");
        $query->addAnd("c.idcuestionario=p.cuestionario_idcuestionario");
        $query->addAnd("p.fecha_envio_factura!=''");
        $query->addAnd("p.pago_pendiente=2 or p.pago_pendiente=5");
        $factCuestion = $this->getList($query);

        foreach ($factCuestion as $fc) {

            $fc["date"] = $fc["fecha_envio_factura"];
        }
        return $factCuestion;
    }

    /**
     * 
     * @param type $idprograma
     * @return type
     * 
     * metodo para ver si gano alguna recompensa, recibo el id del programa y veifico si esta 
     * en la lista de los que gano
     * 
     */
    public function obtenerGratisOnoGanado($idprograma) {
        $idUsuWeb = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idusuarioweb"];
        $query = new AbstractSql();
        $query->setSelect("*");
        $query->setFrom("cuestionarios c, ganadores_recompensa g ");
        $query->setWhere("g.id_idusuarioweb_ganador = $idUsuWeb");
        $query->addAnd("c.idcuestionario=g.cuestionario_idcuestionario");
        $query->addAnd("g.recompensa_utilizada=0");
        $query->addAnd("c.programasalud_idprogramasalud=$idprograma");

        $rdo = $this->getList($query);
        if (count($rdo) > 0) {
            return true;
        } else {
            return false;
        }
    }

}

//END_class
?>