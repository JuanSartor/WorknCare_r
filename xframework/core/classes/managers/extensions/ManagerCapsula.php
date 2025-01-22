<?php

class ManagerCapsula extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    public function __construct($db) {

// Llamamos al constructor del a superclase
        parent::__construct($db, "capsula", "idcapsula");
    }

    /*
     *  1 es file
     *  2 es link
     *  3 es videoo
     *  4 es grabacion de video
     * 
     */

    public function process($request) {

        return parent::process($request);
    }

    public function cantCapsulasListas() {
        $idUsuarioEmpresa = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idusuario_empresa"];
        $query = new AbstractSql();
        $query->setSelect("count(*) as cant");
        $query->setFrom("{$this->table} c");
        $query->setWhere("c.usuarioempresa_idusuarioempresa='$idUsuarioEmpresa'");
        $query->addAnd("c.estado= 1 or c.estado=2");

        return $this->db->getRow($query->getSql());
    }

    public function cantVisitasTotales() {
        $idUsuarioEmpresa = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idusuario_empresa"];
        $query = new AbstractSql();
        $query->setSelect("SUM(cant_visitas) as cant");
        $query->setFrom("{$this->table} c");
        $query->setWhere("c.usuarioempresa_idusuarioempresa='$idUsuarioEmpresa'");
        $query->addAnd("c.estado= 3");

        return $this->db->getRow($query->getSql());
    }

    public function cantCapsulasFinalizadas() {
        $idUsuarioEmpresa = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idusuario_empresa"];
        $query = new AbstractSql();
        $query->setSelect("count(*) as cant");
        $query->setFrom("{$this->table} c");
        $query->setWhere("c.usuarioempresa_idusuarioempresa='$idUsuarioEmpresa'");
        $query->addAnd("c.estado= 3");

        return $this->db->getRow($query->getSql());
    }

    /**
     * obtengo las capsulas propias de la empresa y los genericos
     * @return type
     */
    public function getCapsulasEmpresa() {

        $query = new AbstractSql();
        $query->setSelect("count(*) as cantidad, f.nombre,ce.familia_capsula_id_familia_capsula,f.nombre_en");
        $query->setFrom("contenedor_capsula ce
                inner join familia_capsulas f on (f.id_familia_capsula=ce.familia_capsula_id_familia_capsula) ");
        $query->setWhere("ce.visible=1");
        $query->addAnd("f.visible=1");
        $query->setGroupBy("ce.familia_capsula_id_familia_capsula");
        return $this->getList($query);
    }

    public function getCapsulaLista() {
        $idUsuarioEmpresa = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idusuario_empresa"];
        $query = new AbstractSql();
        $query->setSelect("*");
        $query->setFrom("{$this->table} c");
        $query->setWhere("c.usuarioempresa_idusuarioempresa='$idUsuarioEmpresa'");
        $query->addAnd("c.estado= 1 or c.estado=2");

        return $this->db->getRow($query->getSql());
    }

    public function getListadoCapsulasFinalizadas() {
        $usuario_empresa = $this->getManager("ManagerUsuarioEmpresa")->get($_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idusuario_empresa"]);
        $query = new AbstractSql();
        $query->setSelect("*");
        $query->setFrom(" $this->table  t INNER JOIN usuario_empresa u ON (t.usuarioempresa_idusuarioempresa = u.idusuario_empresa) LEFT JOIN linkcapsula l ON (t.idcapsula = l.capsula_idcapsula)");

        $query->setWhere("t.estado=3");

        $query->addAnd("t.usuarioempresa_idusuarioempresa=" . $usuario_empresa["idusuario_empresa"]);

        $query->setOrderBy("t.idcapsula DESC");
        $data = $this->getList($query);
        return $data;
    }

    public function getListadoCapsulasFormContenedor($request, $idpaginate = null) {
        $query = new AbstractSql();
        $query->setSelect("t.*");
        $query->setFrom(" $this->table  t");
        $query->setWhere("t.contenedorcapsula_idcontenedorcapsula=" . $request["contenedorcapsula_idcontenedorcapsula"]);
        $query->setOrderBy("t.idcapsula DESC");
        $data = $this->getList($query);
        return $data;
    }

    /**
     * 
     * @param type $request
     * @param type $idpaginate
     * @return type
     * obtengo las capsulas creadas desde el admin
     */
    public function getListadoCapsulaAdmin($request, $idpaginate = NULL) {


        if (!is_null($idpaginate)) {
            $this->paginate($idpaginate, 20);
        }

        $query = new AbstractSql();
        $query->setSelect("
               t.*, c.titulo as contenedor
            ");
        $query->setFrom("
                $this->table t, contenedor_capsula c 
            ");
        $query->setWhere("t.usuarioempresa_idusuarioempresa=0");
        $query->addAnd("t.contenedorcapsula_idcontenedorcapsula=c.idcontenedorcapsula");
        // Filtro
        if ($request["titulo"] != "") {

            $rdo = cleanQuery($request["titulo"]);

            $query->addAnd("t.titulo LIKE '%$rdo%'");
        }


        $data = $this->getJSONList($query, array("titulo", "contenedor"), $request, $idpaginate);

        return $data;
    }

    public function deleteMultiple($ids) {

        $records = explode(",", $ids);

        foreach ($records as $id) {

            parent::delete($id);
        }
        return true;
    }

    /**
     * exportacion de excel
     */
    public function exportarInformeCapsula($request) {

        require_once(path_libs_php("PHPExcel/Classes/PHPExcel.php"));
        require_once(path_libs_php("PHPExcel/Classes/PHPExcel/IOFactory.php"));
        //$this->debug();

        $usuario_empresa = $this->getManager("ManagerUsuarioEmpresa")->get($_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idusuario_empresa"]);
        $tit = $this->getManager("ManagerTextoAuxiliares")->get('20');
        $num = $this->getManager("ManagerTextoAuxiliares")->get('21');
        $dat = $this->getManager("ManagerTextoAuxiliares")->get('22');
        $numin = $this->getManager("ManagerTextoAuxiliares")->get('23');


        $queryA = new AbstractSql();
        $queryA->setSelect("*");
        $queryA->setFrom("capsula c");
        $queryA->setWhere("c.idcapsula = $request");

        $dataA = $this->db->getRow($queryA->getSql());

        //template
        $inputFileName = path_root() . "xframework/app/empresa/view/templates/excel/capsule_rapport.xlsx";
        $inputFileType = PHPExcel_IOFactory::identify($inputFileName);
        $objReader = PHPExcel_IOFactory::createReader($inputFileType);
        $objPHPExcel = $objReader->load($inputFileName);

        $i = 0;
        $r_start = 3;
        $objPHPExcel->setActiveSheetIndex($i);
        $active_sheet = $objPHPExcel->getActiveSheet();
        $letrai = 'b';

        if ($usuario_empresa["idioma_predeterminado"] == 'fr') {
            $active_sheet->setCellValue('a' . '3', $tit["texto_fr"]);
            $active_sheet->setCellValue('a' . '4', $num["texto_fr"]);
            $active_sheet->setCellValue('a' . '6', $dat["texto_fr"]);
            $active_sheet->setCellValue('b' . '6', $numin["texto_fr"]);
        } else {
            $active_sheet->setCellValue('a' . '3', $tit["texto_en"]);
            $active_sheet->setCellValue('a' . '4', $num["texto_en"]);
            $active_sheet->setCellValue('a' . '6', $dat["texto_en"]);
            $active_sheet->setCellValue('b' . '6', $numin["texto_en"]);
        }


        // aca tenes q ver si es en ingles o frances y dependiendo de eso pones el titulo
        $active_sheet->setCellValue($letrai . $r_start, $dataA["titulo"]);


//obtengo historial de visitas
        $Manager = $this->getManager("ManagerCapsulaRegistroVisitas");
        $visitas = $Manager->getListadoVisitasCantidad($request);

        $fila_h = 7;
        $total_visitas = 0;
        foreach ($visitas as $elemento) {

            $fecha = date('l jS \of F Y h:i:s A', strtotime($elemento["fecha_realizada"]));

            if (strpos($fecha, "Monday") !== false) {
                if ($usuario_empresa["idioma_predeterminado"] == 'fr') {
                    $dia = "Lundi";
                } else {
                    $dia = "Monday";
                }
            } elseif (strpos($fecha, "Tuesday") !== false) {
                if ($usuario_empresa["idioma_predeterminado"] == 'fr') {
                    $dia = "Mardi";
                } else {
                    $dia = "Tuesday";
                }
            } elseif (strpos($fecha, "Wednesday") !== false) {
                if ($usuario_empresa["idioma_predeterminado"] == 'fr') {
                    $dia = "Mercredi";
                } else {
                    $dia = "Wednesday";
                }
            } elseif (strpos($fecha, "Thursday") !== false) {
                if ($usuario_empresa["idioma_predeterminado"] == 'fr') {
                    $dia = "Jeudi";
                } else {
                    $dia = "Thursday";
                }
            } elseif (strpos($fecha, "Friday") !== false) {
                if ($usuario_empresa["idioma_predeterminado"] == 'fr') {
                    $dia = "Vendredi";
                } else {
                    $dia = "Friday";
                }
            } elseif (strpos($fecha, "Saturday") !== false) {
                if ($usuario_empresa["idioma_predeterminado"] == 'fr') {
                    $dia = "Samedi";
                } else {
                    $dia = "Saturday";
                }
            } else {
                if ($usuario_empresa["idioma_predeterminado"] == 'fr') {
                    $dia = "Dimanche";
                } else {
                    $dia = "Sunday";
                }
            }

            if (strpos($fecha, "January") !== false) {
                if ($usuario_empresa["idioma_predeterminado"] == 'fr') {
                    $mes = "Janvier";
                } else {
                    $mes = "January";
                }
            } elseif (strpos($fecha, "February") !== false) {
                if ($usuario_empresa["idioma_predeterminado"] == 'fr') {
                    $mes = "Fevrier";
                } else {
                    $mes = "February";
                }
            } elseif (strpos($fecha, "March") !== false) {
                if ($usuario_empresa["idioma_predeterminado"] == 'fr') {
                    $mes = "Mars";
                } else {
                    $mes = "March";
                }
            } elseif (strpos($fecha, "April") !== false) {
                if ($usuario_empresa["idioma_predeterminado"] == 'fr') {
                    $mes = "Avril";
                } else {
                    $mes = "April";
                }
            } elseif (strpos($fecha, "May") !== false) {
                if ($usuario_empresa["idioma_predeterminado"] == 'fr') {
                    $mes = "Mai";
                } else {
                    $mes = "May";
                }
            } elseif (strpos($fecha, "June") !== false) {
                if ($usuario_empresa["idioma_predeterminado"] == 'fr') {
                    $mes = "Juin";
                } else {
                    $mes = "June";
                }
            } elseif (strpos($fecha, "July") !== false) {
                if ($usuario_empresa["idioma_predeterminado"] == 'fr') {
                    $mes = "Juillet";
                } else {
                    $mes = "July";
                }
            } elseif (strpos($fecha, "August") !== false) {
                if ($usuario_empresa["idioma_predeterminado"] == 'fr') {
                    $mes = "Aout";
                } else {
                    $mes = "August";
                }
            } elseif (strpos($fecha, "September") !== false) {
                if ($usuario_empresa["idioma_predeterminado"] == 'fr') {
                    $mes = "Septembre";
                } else {
                    $mes = "September";
                }
            } elseif (strpos($fecha, "October") !== false) {
                if ($usuario_empresa["idioma_predeterminado"] == 'fr') {
                    $mes = "Octobre";
                } else {
                    $mes = "October";
                }
            } elseif (strpos($fecha, "November") !== false) {
                if ($usuario_empresa["idioma_predeterminado"] == 'fr') {
                    $mes = "Novembre";
                } else {
                    $mes = "November";
                }
            } else {
                if ($usuario_empresa["idioma_predeterminado"] == 'fr') {
                    $mes = "Decembre";
                } else {
                    $mes = "December";
                }
            }
            $arr = explode(" ", $fecha);
            $letraiA = 'a';
            $letraCa = 'b';
            $active_sheet->setCellValue($letraiA . $fila_h, utf8_decode($dia) . " " . substr($arr[1], 0, -2) . " " . utf8_decode($mes));
            $active_sheet->setCellValue($letraCa . $fila_h, $elemento["cantidad"]);
            $fila_h++;
            $total_visitas = $total_visitas + $elemento["cantidad"];
        }
        $ftotal = 4;
        $active_sheet->setCellValue($letraCa . $ftotal, $total_visitas);
        $active_sheet->setTitle("Capsule");
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
        header('Content-Disposition: attachment;filename="' . "capsule_rapport_" . $dataA["titulo"] . "_" . $fecha_actual . '.xlsx"');
        header('Cache-Control: max-age=0');
        ob_end_clean();
        $objWriter->save('php://output');
    }

    /**
     * reporte pdf
     */
    public function getReportePDFcapsula($request) {

        $Manager = $this->getManager("ManagerCapsulaRegistroVisitas");
        $request["lista"] = $Manager->getListadoVisitasCantidad($request["idcapsula"]);
        $request["usuario"] = $this->getManager("ManagerUsuarioEmpresa")->get($_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idusuario_empresa"]);

        $request["fecha"] = $this->getManager("ManagerTextoAuxiliares")->get('14');
        $request["titu"] = $this->getManager("ManagerTextoAuxiliares")->get('15');
        $request["numTot"] = $this->getManager("ManagerTextoAuxiliares")->get('16');
        $request["paDates"] = $this->getManager("ManagerTextoAuxiliares")->get('17');
        $request["dates"] = $this->getManager("ManagerTextoAuxiliares")->get('18');
        $request["num"] = $this->getManager("ManagerTextoAuxiliares")->get('19');

        $PDFInvitacionPass = new PDFReporteCapsula();
        $PDFInvitacionPass->getPDF($request);
    }

    public function cantCapsulasContenedoresGenericas() {
        $idUsuarioEmpresa = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idusuario_empresa"];
        $query = new AbstractSql();
        $query->setSelect("count(*) as cant");
        $query->setFrom("{$this->table} c");
        $query->setWhere("c.usuarioempresa_idusuarioempresa='$idUsuarioEmpresa'");
        $query->addAnd("c.estado= 1 or c.estado=2");

        return $this->db->getRow($query->getSql());
    }

}

//END_class


