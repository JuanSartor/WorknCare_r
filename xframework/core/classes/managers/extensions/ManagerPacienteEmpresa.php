<?php

/**
 * 	@autor Xinergia
 * 	@version 1.0	20/11/2020
 * 	Manager de pacientes beneficiarios de Programas de salud empleados de una empresa.
 *
 */
class ManagerPacienteEmpresa extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "paciente_empresa", "idpaciente_empresa");
        $this->default_paginate = "beneficiarios_listado";
    }

    /**
     * Métodos que devuelve el listado de pacientes beneficiarios de un Pass bien-être de una empresa
     * @param type $requesr
     */
    public function getListadoBeneficiarios($request, $idpaginate = null) {
        //verificamos si el medico tiene habilitada la videocosulta


        if (isset($request["do_reset"]) && $request["do_reset"] == 1) {
            $this->resetPaginate($idpaginate);
        }

        if (!is_null($idpaginate)) {
            $this->paginate($idpaginate, 10);
        }

        $idusuario_empresa = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["id"];
        $usuario_empresa = $this->getManager("ManagerUsuarioEmpresa")->get($idusuario_empresa);

        //Seteo el current page
        $request["current_page"] = $request["current_page"] != "" ? $request["current_page"] : 1;
        SmartyPaginate::setCurrentPage($request["current_page"], $idpaginate);

        $query = new AbstractSql();

        $query->setSelect("pe.*,
                            p.apellido,
                            p.nombre,
                            p.email,
                            u.fecha_alta
                        ");

        $query->setFrom("paciente_empresa pe INNER JOIN v_pacientes p ON (pe.paciente_idpaciente=p.idpaciente) INNER JOIN usuarioweb u ON (p.usuarioweb_idusuarioweb=u.idusuarioweb)");




        $query->setWhere("pe.empresa_idempresa = {$usuario_empresa['empresa_idempresa']}");


        $query->setOrderBy("pe.estado,u.fecha_alta DESC");


        //añadimos los filtros de fecha

        if ($request["filtro_busqueda"] != "") {

            $filtro_busqueda = cleanQuery($request["filtro_busqueda"]);
            $query->addAnd("p.nombre LIKE '%{$filtro_busqueda}%' OR p.apellido LIKE '%{$filtro_busqueda}%' OR p.email LIKE '%{$filtro_busqueda}%'");
        }




        $query->setGroupBy("p.idpaciente");

        $listado = $this->getListPaginado($query, $idpaginate);



        if ($listado["rows"] && count($listado["rows"]) > 0) {

            foreach ($listado["rows"] as $key => $value) {
                //Tengo que formatear la fecha d.
                if ($value["fecha_alta"] != "") {
                    $listado["rows"][$key]["fecha_alta_format"] = fechaToString($value["fecha_alta"], 1);
                }
            }
        }
        return $listado;
    }

    /**
     * Métodos que devuelve el listado de pacientes beneficiarios de un Pass bien-être de una empresa
     * @param type $requesr
     */
    public function getListadoBeneficiariosJSON($request, $idpaginate = null) {

        //verificamos si el medico tiene habilitada la videocosulta


        if (isset($request["do_reset"]) && $request["do_reset"] == 1) {
            $this->resetPaginate($idpaginate);
        }

        if (!is_null($idpaginate)) {
            $this->paginate($idpaginate, 10);
        }

        //Seteo el current page
        $request["current_page"] = $request["page"] != "" ? $request["page"] : 1;
        SmartyPaginate::setCurrentPage($request["current_page"], $idpaginate);

        $query = new AbstractSql();

        $query->setSelect("pe.*,
                            IF(pe.estado=1,'Activo','Pendiente de validación') as estado_format,
                            p.apellido,
                            p.nombre,
                            p.email,
                            u.fecha_alta,
                            DATE_FORMAT(u.fecha_alta, '%d/%m/%Y') as fecha_alta_format,
                            pe.paciente_idpaciente
                        ");

        $query->setFrom("paciente_empresa pe INNER JOIN v_pacientes p ON (pe.paciente_idpaciente=p.idpaciente) INNER JOIN usuarioweb u ON (p.usuarioweb_idusuarioweb=u.idusuarioweb)");




        $query->setWhere("pe.empresa_idempresa = {$request['idempresa']}");


        $query->setOrderBy("pe.estado,u.fecha_alta DESC");


        //añadimos los filtros de fecha

        if ($request["filtro_busqueda"] != "") {

            $filtro_busqueda = cleanQuery($request["filtro_busqueda"]);
            $query->addAnd("p.nombre LIKE '%{$filtro_busqueda}%' OR p.apellido LIKE '%{$filtro_busqueda}%' OR p.email LIKE '%{$filtro_busqueda}%'");
        }


        $query->setGroupBy("p.idpaciente");

        $data = $this->getJSONList($query, array("nombre", "apellido", "email", "fecha_alta_format", "estado_format", "paciente_idpaciente"), $request, $idpaginate);


        return $data;
    }

    /**
     * Metodo que cambia el estado de un paciente (rechazado/aceptado) del listado pacientes de una empresa
     * @param type $request
     */
    public function cambiar_estado($request) {

        if ($request["front"] == '') {
            $idusuario_empresa = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["id"];
        } else {
            $idusuario_empresa = $request["front"];
        }
        $usuario_empresa = $this->getManager("ManagerUsuarioEmpresa")->get($idusuario_empresa);
        //verificamos si la suscripcion está cancelada, no se pueden aceptar mas beneficiarios
        if ($usuario_empresa["cancelar_suscripcion"] == 2) {
            $this->setMsg(["msg" => "No se pueden modificar sus beneficiarios. Su suscripción ha sido cancelada", "result" => false]);
            return false;
        }


        $empresa = $this->getManager("ManagerEmpresa")->get($usuario_empresa["idempresa"]);
        //verififcamos que la empresa tenga saldo maximo disponible para agregar otro beneficiario, (si lo establecio)
        if ($empresa["presupuesto_maximo"] != "") {

            $info_beneficiarios = $this->getManager("ManagerPacienteEmpresa")->getInfoBeneficiariosInscriptos($empresa["idempresa"]);
            $plan = $this->getManager("ManagerProgramaSaludPlan")->get($empresa["plan_idplan"]);

            if ((int) $empresa["presupuesto_maximo"] > 0) {
                //sumamos un beneficiacios y vemos excede el presupuesto mensual
                $info_beneficiarios["consumo_beneficiarios"] = ($info_beneficiarios["beneficiarios_verificados"] + 1) * $plan["precio"];
                $info_beneficiarios["credito_disponible"] = $empresa["presupuesto_maximo"] - $info_beneficiarios["consumo_beneficiarios"];

                if ((int) $info_beneficiarios["credito_disponible"] < 0) {
                    $this->setMsg(["msg" => "Se ha excedido el máximo de beneficiarios admitidos por su empresa. Debe aumentar su presupuesto mensual si desea aceptar mas beneficiarios en el Pase de Bienestar", "result" => false]);
                    return false;
                }
            }
        }
        if ($request["ids"] == "") {
            $this->setMsg(["msg" => "Error, no se pudo actualizar el registro", "result" => false]);
            return false;
        }
        $ids_paciente = explode(",", $request["ids"]);
        $exito = false;
        foreach ($ids_paciente as $id) {

            $paciente_empresa = parent::get($id);

            if ($paciente_empresa["empresa_idempresa"] == $usuario_empresa["idempresa"]) {
                //verificamos si el beneficiado no se ha facturado aun en Stipe, enviamos un reporte de uso del beneficio de cuenta empresa
                //Cuando lo validamos tambien lo marcamos para facturar como beneficiario, si luego se desactiva se facturara igual
                if ($paciente_empresa["estado"] != '2') {
                    //entra si el estado de la empresa es pendiente de validacion, no suspendido
                    if ($request["estado"] == 1) {
                        $record["facturar"] = 1;
                        $record["fecha_activacion"] = date("Y-m-d");
                    }
                }

                $record["estado"] = $request["estado"];
                //verificamos si el paciente tenia un estado distinto
                if ($paciente_empresa["estado"] != $record["estado"]) {
                    if ($paciente_empresa["estado"] == '1') {
                        // es decir si estava activo pasa a suspendido no a inactivo,
                        // porque inactivo es el estado inicial
                        $record["estado"] = '2';
                    }
                    if ($paciente_empresa["estado"] == '2') {
                        // es decir si estava suspendido pasa a activo
                        $record["estado"] = '1';
                    }
                    $this->db->StartTrans();
                    $upd = parent::update($record, $paciente_empresa["idpaciente_empresa"]);
                    if ($upd) {


                        if ($request["estado"] == 1) {
                            if ($request["front"] == '') {
                                $mail = $this->sendEmailActivacionBeneficiario($paciente_empresa["paciente_idpaciente"]);
                                if (!$mail) {
                                    $this->db->FailTrans();
                                    $this->db->CompleteTrans();
                                    $this->setMsg(["msg" => "Error, no se pudo actualizar el registro", "result" => false]);
                                    return false;
                                }
                            }

                            if ($paciente_empresa["estado"] != '2') {
                                //si la suscripcion es de empresa y no obra social, incrementamos el uso del servicio
                                //a las empresas se les cobra por beneficiarios registrado a medida que se inscriben,  pero las OS compran un pack completo 
                                if ($paciente_empresa["facturar"] == 0 && $empresa["obra_social"] == 0) {
                                    $reporte_stripe = $this->getManager("ManagerProgramaSaludSuscripcion")->reportar_beneficiarios($usuario_empresa["idempresa"]);
                                    if (!$reporte_stripe) {
                                        $this->db->FailTrans();
                                        $this->db->CompleteTrans();
                                        $this->setMsg(["msg" => "Error, no se pudo actualizar el registro", "result" => false]);
                                        return false;
                                    }
                                }
                            }
                        }

                        $this->db->CompleteTrans();
                    } else {
                        $this->db->FailTrans();
                        $this->db->CompleteTrans();
                        $this->setMsg(["msg" => "Error, no se pudo actualizar el registro", "result" => false]);
                        return false;
                    }
                }
                $exito = true;
            }
        }
        if ($exito) {
            if ($request["estado"] == 1) {
                $this->setMsg(["msg" => "Beneficiario aceptado con éxito", "result" => true]);
                return true;
            } else {
                $this->setMsg(["msg" => "Beneficiario suspendido con éxito", "result" => true]);
                return true;
            }
        } else {
            $this->setMsg(["msg" => "Error, no se pudo actualizar el registro", "result" => false]);
            return false;
        }
    }

    /**
     * Metodo que elimina un beneficiario del listado pacientes de una empresa solo si aun no ha utilizado el pass
     * @param type $request
     */
    public function eliminar_beneficiario($request) {

        $idusuario_empresa = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["id"];
        $usuario_empresa = $this->getManager("ManagerUsuarioEmpresa")->get($idusuario_empresa);
        //verificamos si la suscripcion está cancelada, no se pueden aceptar mas beneficiarios
        if ($usuario_empresa["cancelar_suscripcion"] == 2) {
            $this->setMsg(["msg" => "No se pueden modificar sus beneficiarios. Su suscripción ha sido cancelada", "result" => false]);
            return false;
        }

        $empresa = $this->getManager("ManagerEmpresa")->get($usuario_empresa["idempresa"]);

        if ($request["ids"] == "") {
            $this->setMsg(["msg" => "Error, no se pudo actualizar el registro", "result" => false]);
            return false;
        }
        $ids_paciente = explode(",", $request["ids"]);
        $exito = false;
        foreach ($ids_paciente as $id) {

            $paciente_empresa = parent::get($id);

            if ($paciente_empresa["empresa_idempresa"] == $usuario_empresa["idempresa"]) {

                if ($paciente_empresa["cant_consultaexpress"] != "0" || $paciente_empresa["cant_videoconsulta"] != "0") {
                    $this->setMsg(["msg" => "Error. No se puede eliminar este beneficiario porque ya ha comenzado a utilizar las consultas disponibles del Pase de Salud", "result" => false]);
                    return false;
                }
                $this->db->StartTrans();
                $upd = parent::delete($id, true);
                if ($upd) {
                    //si la suscripcion es de empresa y no obra social, informamos el uso del servicio en stripe
                    //a las empresas se les cobra por beneficiarios registrado, pero las OS compran un pack completo 
                    if ($empresa["obra_social"] == 0) {
                        $reporte_stripe = $this->getManager("ManagerProgramaSaludSuscripcion")->reportar_beneficiarios($usuario_empresa["idempresa"]);
                        if (!$reporte_stripe) {
                            $this->db->FailTrans();
                            $this->db->CompleteTrans();
                            $this->setMsg(["msg" => "Error, no se pudo eliminar el beneficiario", "result" => false]);
                            return false;
                        }
                    }

                    $this->db->CompleteTrans();
                    $exito = true;
                }
            }
        }
        if ($exito) {
            $this->setMsg(["msg" => "Beneficiario eliminado con éxito", "result" => true]);
            return true;
        } else {
            $this->setMsg(["msg" => "Error, no se pudo actualizar el registro", "result" => false]);
            return false;
        }
    }

    /**
     * Método de envío de email para la validación de la cuenta del beneficiario.
     * @param type $idpaciente
     * @return boolean
     */
    public function sendEmailActivacionBeneficiario($idpaciente) {

        $ManagerPaciente = $this->getManager("ManagerPaciente");
        $paciente = $ManagerPaciente->get($idpaciente);
        $idusuario_empresa = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["id"];
        $usuario_empresa = $this->getManager("ManagerUsuarioEmpresa")->get($idusuario_empresa);
        $empresa_entera = $this->getManager("ManagerEmpresa")->get($usuario_empresa["empresa_idempresa"]);
        $mEmail = $this->getManager("ManagerMail");
        $mEmail->setHTML(true);

        //ojo solo arnet local
        $mEmail->setPort("587");

        $mEmail->setSubject("WorknCare | Vous pouvez utiliser votre Pass !");


        $smarty = SmartySingleton::getInstance();

        $smarty->assign("usuario", $paciente);
        $smarty->assign("sistema", NOMBRE_SISTEMA);
        $smarty->assign("empresa", $usuario_empresa);
        $smarty->assign("empresa_entera", $empresa_entera);


        $mEmail->setBody($smarty->Fetch("email/confirmacion_activacion_cuenta_beneficiario.tpl"));


        $mEmail->addTo($paciente["email"]);


        //header a todos los comentarios!
        if ($mEmail->send()) {

            return true;
        } else {
            $this->setMsg(array("result" => false, "msg" => "No se pudo enviar el mensaje"));
            return false;
        }
    }

    /**
     * Envío del Email para al usuario empresa cuando un nuevo paciente se registra como su beneficiario
     * @param type $idpaciente
     * @return boolean
     */
    public function sendEmailNuevoBeneficiarioEmpresa($idpaciente) {
        $paciente_empresa = $this->getByField("paciente_idpaciente", $idpaciente);
        $paciente = $this->getManager("ManagerPaciente")->get($idpaciente);

        //recuperamos los usuarios admin
        $query = new AbstractSql();
        $query->setSelect("email,nombre,apellido");
        $query->setFrom("usuario_empresa");
        $query->setWhere("estado=1 and empresa_idempresa={$paciente_empresa["empresa_idempresa"]} and (tipo_usuario=1 OR tipo_usuario=3 OR tipo_usuario=4)");
        $usuarios = $this->getList($query);




        $envio = false;
        if (count($usuarios) > 0) {
            foreach ($usuarios as $usuario_empresa) {
                $mEmail = $this->getManager("ManagerMail");
                $mEmail->setHTML(true);

                //ojo solo arnet local
                $mEmail->setPort("587");
                $mEmail->setFromName("Notifications WorknCare");
                if ($usuario_empresa["idioma_predeterminado"] == "fr") {
                    $mEmail->setSubject("WorknCare : nouveau bénéficiaire inscrit !");
                } else {
                    $mEmail->setSubject("WorknCare : new beneficiary registered !");
                }

                $smarty = SmartySingleton::getInstance();

                $smarty->assign("usuario", $paciente);
                $smarty->assign("usuario_empresa", $usuario_empresa);
                $mEmail->setBody($smarty->Fetch("email/nuevo_beneficiario_empresa.tpl"));
                $mEmail->addTo($usuario_empresa["email"]);
                $envio = $mEmail->send();
            }
        } else {
            $this->setMsg(array("result" => false, "msg" => "No se pudo enviar el mensaje"));
            return false;
        }

        if ($envio) {
            return true;
        } else {
            //$this->setMsg(["result" => false, "msg" => "No se pudo enviar el mensaje"]);
            return false;
        }
    }

    /**
     * Cron encargado de enviar un recordatorio a los administradores de la cuenta empresa cuando hay beneficiarios pendientes de verificacion
     * @param type $idempresa
     */
    public function cron_recordatorio_beneficiarios_pendientes() {
        $query = new AbstractSql();
        $query->setSelect("DISTINCT(pe.empresa_idempresa)");
        $query->setFrom("paciente_empresa pe INNER JOIN paciente p ON(pe.paciente_idpaciente=p.idpaciente) INNER JOIN usuarioweb u ON (p.usuarioweb_idusuarioweb=u.idusuarioweb)");
        $query->setWhere("u.registrado=1 AND pe.estado=0");

        $data = $this->getList($query);

        foreach ($data as $pendientes) {
            if ($pendientes["empresa_idempresa"] != "") {
                $this->sendEmailRecordatorioBeneficiariosPendientes($pendientes["empresa_idempresa"]);
            }
        }
    }

    /**
     * Envío del Email para al usuario empresa cuando tiene beneficiarios pendientes
     * @param type $idempresa
     * @return boolean
     */
    public function sendEmailRecordatorioBeneficiariosPendientes($idempresa) {




        //Obtener los beneficiarios pendientes
        $query = new AbstractSql();
        $query->setSelect("u.nombre, u.apellido, u.email");
        $query->setFrom("paciente_empresa pe INNER JOIN paciente p ON(pe.paciente_idpaciente=p.idpaciente) INNER JOIN usuarioweb u ON (p.usuarioweb_idusuarioweb=u.idusuarioweb)");
        $query->setWhere("u.registrado=1 AND pe.estado=0 AND pe.empresa_idempresa=$idempresa");

        $usuarios_pendientes = $this->getList($query);



        //obtener mails admin empresa
        $query2 = new AbstractSql();
        $query2->setSelect("email,nombre, apellido");
        $query2->setFrom("usuario_empresa");
        $query2->setWhere("estado=1 and empresa_idempresa=$idempresa and (tipo_usuario = 1 OR tipo_usuario = 3 OR tipo_usuario=4 )");
        $usuarios_mail = $this->getList($query2);
        //enviamos el mail a los usuarios de la empresa
        $envio = false;
        if (count($usuarios_mail) > 0) {
            foreach ($usuarios_mail as $usuario) {

                $mEmail = $this->getManager("ManagerMail");
                $mEmail->setHTML(true);

                //ojo solo arnet local
                $mEmail->setPort("587");
                $mEmail->setFromName("Notifications WorknCare");
                $mEmail->setSubject("WorknCare: bénéficiaires en attente de validation!");
                $smarty = SmartySingleton::getInstance();
                $smarty->assign("usuarios_pendientes", $usuarios_pendientes);
                $smarty->assign("usuario_empresa", $usuario);
                $mEmail->addTo($usuario["email"]);
                $mEmail->setBody($smarty->Fetch("email/beneficiarios_pedientes_empresa.tpl"));
                $envio = $mEmail->send();
            }
        } else {
            $this->setMsg(array("result" => false, "msg" => "No se pudo enviar el mensaje"));
            return false;
        }

        //header a todos los comentarios!
        if ($envio) {

            return true;
        } else {
            //$this->setMsg(["result" => false, "msg" => "No se pudo enviar el mensaje"]);
            return false;
        }
    }

    /**
     * Método que devuelve la informacion de los beneficiarios inscriptos y verificados de una empresa
     */
    public function getInfoBeneficiariosInscriptos($idempresa) {
        $empresa = $this->getManager("ManagerEmpresa")->get($idempresa);
        /**
         * el 28-09-2022 Juan
         * tuve que agregar pe.estado!=2 porque agregue el estado suspendido que es diferente a inactivo
         */
        $info["beneficiarios_inscriptos"] = $this->db->getOne("select count(idpaciente_empresa) from paciente_empresa pe INNER JOIN paciente p ON(pe.paciente_idpaciente=p.idpaciente) INNER JOIN usuarioweb u ON (p.usuarioweb_idusuarioweb=u.idusuarioweb) WHERE  u.registrado=1 AND pe.estado!=2 AND empresa_idempresa={$idempresa}");
        $info["beneficiarios_verificados"] = $this->db->getOne("select count(idpaciente_empresa) from paciente_empresa where empresa_idempresa={$idempresa} and estado=1");


        if ($empresa["cant_empleados"] != "") {
            $info["tasa_inscripcion"] = ceil((int) $info["beneficiarios_inscriptos"] / (int) $empresa["cant_empleados"] * 100);
        }
        if ((int) $info["beneficiarios_inscriptos"] > 0) {
            $info["tasa_verificacion"] = ceil((int) $info["beneficiarios_verificados"] / (int) $info["beneficiarios_inscriptos"] * 100);
        }
        return $info;
    }

    /**
     * Generacion de listado de beneficiarios en excel
     */
    public function ExportarListadoBeneficiarios($request) {
        require_once(path_libs_php("PHPExcel/Classes/PHPExcel.php"));
        require_once(path_libs_php("PHPExcel/Classes/PHPExcel/IOFactory.php"));

        $idusuario_empresa = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["id"];
        $usuario_empresa = $this->getManager("ManagerUsuarioEmpresa")->get($idusuario_empresa);

        $query = new AbstractSql();
        $query->setSelect("pe.*,
                            IF(pe.estado=1,'Activo','Pendiente de validación') as estado_format,
                            p.apellido,
                            p.nombre,
                            p.email,
                            u.fecha_alta,
                            DATE_FORMAT(u.fecha_alta, '%d/%m/%Y') as fecha_alta_format,
                            pe.paciente_idpaciente
                        ");

        $query->setFrom("paciente_empresa pe INNER JOIN v_pacientes p ON (pe.paciente_idpaciente=p.idpaciente) INNER JOIN usuarioweb u ON (p.usuarioweb_idusuarioweb=u.idusuarioweb)");
        $query->setWhere("pe.empresa_idempresa = {$usuario_empresa["idempresa"]}");
        if ($request["ids"] != "") {
            $query->addAnd("pe.idpaciente_empresa in ({$request["ids"] })");
        }
        $query->setOrderBy("u.fecha_alta DESC");



        $query->setGroupBy("p.idpaciente");

        $data = $this->getList($query);

        //Obtener Listado Según El Excel que se necesite obtener
        //template
        $inputFileName = path_root() . "xframework/app/empresa/view/templates/excel/listado_beneficiarios_template.xlsx";
        $inputFileType = PHPExcel_IOFactory::identify($inputFileName);
        $objReader = PHPExcel_IOFactory::createReader($inputFileType);
        $objPHPExcel = $objReader->load($inputFileName);


        $i = 0;
        $r_init = $r_start = 4;
        $objPHPExcel->setActiveSheetIndex($i);
        $active_sheet = $objPHPExcel->getActiveSheet();
        //iteramos sobre los beneficiarios
        foreach ($data as $beneficiario) {



            $params_xls = array(
                "r_start" => $r_start,
                "active_sheet" => $active_sheet
            );

            $pendientes = 0;
            $disponibles = 0;
            $confirmados = 0;
            $declinados = 0;
            $ausentes = 0;

            //nombre
            $active_sheet->setCellValue("A$r_start", "{$beneficiario["nombre"]} {$beneficiario["apellido"]}");
            //fecha
            $active_sheet->setCellValue("B$r_start", PHPExcel_Shared_Date::PHPToExcel($beneficiario["fecha_alta_format"]));
            $active_sheet->getStyle("B$r_start")->getNumberFormat()->setFormatCode(PHPExcel_Style_NumberFormat::FORMAT_DATE_YYYYMMDD2);
            //estado
            $estado_beneficiarios = $beneficiario["estado"] == "1" ? "Actif" : "En attente";
            $active_sheet->setCellValue("C$r_start", $estado_beneficiarios);


            $params_xls["r_start"] = $r_start;
            $r_start++;
        }

        $active_sheet->setTitle("Bénéficiaires inscrits");
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
        header('Content-Disposition: attachment;filename="' . "beneficiaires_inscrits_" . $fecha_actual . '.xlsx"');
        header('Cache-Control: max-age=0');
        ob_end_clean();
        $objWriter->save('php://output');
    }

    // obtengo la cantidad de beneficiarios con estado=1 
    public function getCantidadBeneficiarios() {
        $query = new AbstractSql();
        $query->setSelect("COUNT(*) as cantidad");
        $query->setFrom("$this->table");
        $query->setWhere("estado='1'");

        $registro = $this->db->GetRow($query->getSql());

        $this->setMsg(["cantidad" => $registro["cantidad"]]);
    }

    /**
     *  descuento la cantidad de videoconsultas porque se rechazo el reembolso desde el xadmin
     * @param type $idpaciente_empresa
     * @return type
     */
    public function descontarReembolso($idpaciente_empresa) {
        $query = new AbstractSql();
        $query->setSelect("*");
        $query->setFrom("$this->table");
        $query->setWhere("idpaciente_empresa=$idpaciente_empresa");
        $registro = $this->db->GetRow($query->getSql());
        $nuevoValor = intval($registro["cant_videoconsulta"]) - 1;
        return parent::update(["cant_videoconsulta" => $nuevoValor], $idpaciente_empresa);
    }

    /**
     *  aumento la cantidad de videoconsultas porque realizo un reembolso
     * @param type $idpaciente_empresa
     * @return type
     */
    public function aumentarReembolso($idpaciente_empresa) {
        $query = new AbstractSql();
        $query->setSelect("*");
        $query->setFrom("$this->table");
        $query->setWhere("idpaciente_empresa=$idpaciente_empresa");
        $registro = $this->db->GetRow($query->getSql());
        $nuevoValor = intval($registro["cant_videoconsulta"]) + 1;
        return parent::update(["cant_videoconsulta" => $nuevoValor], $idpaciente_empresa);
    }

    /**
     *  actualizo los pacientes que dejan de ser beneficiarios a particulares
     *  y elimino la relacion con la empresa en la tabla paciente_empresa
     * 
     * @param type $idempresa
     * @param type $idsbeneficiario
     * @return type
     */
    public function eliminarBeneficiarioEmpresa($idempresa) {

        // actualizo los pacientes que eran beneficiarios a no beneficiarios
        $this->getManager("ManagerPaciente")->actualizarExBeneficiarios($idempresa);

        // elimino de la tabla paciente_empresa asi no son mas beneficiario
        $rdo2 = $this->db->Execute("delete from paciente_empresa where empresa_idempresa=$idempresa");
        return $rdo2;
    }

    /**
     *  obtengo los ids de los beneficiarios
     * @param type $idempresa
     * @return type
     */
    public function getListIdsBeneficiarios($idempresa) {
        $query = new AbstractSql();
        $query->setSelect("paciente_idpaciente");
        $query->setFrom("paciente_empresa");
        $query->setWhere("empresa_idempresa=$idempresa  and estado=1 ");
        return $this->getList($query);
    }

    /**
     * exporto los beneficiarios en excel para ocupar en MailChimp
     */
    public function exportarBeneficiarios() {
        require_once(path_libs_php("PHPExcel/Classes/PHPExcel.php"));
        require_once(path_libs_php("PHPExcel/Classes/PHPExcel/IOFactory.php"));

        // obtengo el cuestionario con las preguntas
        $query = new AbstractSql();
        $query->setSelect("*");
        $query->setFrom("paciente_empresa p INNER JOIN paciente pa ON (p.paciente_idpaciente=pa.idpaciente)
                        INNER JOIN usuarioweb us ON (us.idusuarioweb=pa.usuarioweb_idusuarioweb)
                        INNER JOIN empresa e ON (e.idempresa = p.empresa_idempresa)
                        LEFT JOIN programa_salud_excepcion pse ON ( p.empresa_idempresa = pse.empresa_idempresa )");

        $query->setWhere("p.estado = 1");

        $data = $this->getList($query);


        $programas = $this->getManager("ManagerProgramaSalud")->getListadoProgramas();

        $valArray = 0;
        foreach ($data as $elem) {
            $ArrayEle = array_map('intval', explode(",", $elem["programa_salud_excepcion"]));

            $cad = '';
            foreach ($programas as $programa) {
                if (!in_array(intval($programa["idprograma_salud"]), $ArrayEle)) {

                    $cad = $programa["programa_salud"] . ', ' . $cad;
                }
            }
            $data[$valArray]["programas-asociados"] = substr($cad, 0, -2);
            $valArray++;
        }

        //template
        $inputFileName = path_root() . "xframework/app/xadmin/view/templates/excel/listado_beneficiarios.xlsx";
        $inputFileType = PHPExcel_IOFactory::identify($inputFileName);
        $objReader = PHPExcel_IOFactory::createReader($inputFileType);
        $objPHPExcel = $objReader->load($inputFileName);


        $i = 0;
        $r_start = 4;
        $objPHPExcel->setActiveSheetIndex($i);
        $active_sheet = $objPHPExcel->getActiveSheet();
        // inserto las preguntas, es decir los titulos de cada columna
        foreach ($data as $beneficiario) {

            $active_sheet->setCellValue('a' . $r_start, $beneficiario["nombre"] . ' ' . $beneficiario["apellido"]);
            $active_sheet->setCellValue('b' . $r_start, $beneficiario["email"]);
            $active_sheet->setCellValue('c' . $r_start, $beneficiario["empresa"]);
            $active_sheet->setCellValue('d' . $r_start, $beneficiario["programas-asociados"]);

            $r_start++;
        }

        $active_sheet->setTitle("Bénéficiaires");
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
        header('Content-Disposition: attachment;filename="' . "beneficiaires_rapport_" . "_" . $fecha_actual . '.xlsx"');
        header('Cache-Control: max-age=0');
        ob_end_clean();
        $objWriter->save('php://output');
    }

}

//END_class
?>