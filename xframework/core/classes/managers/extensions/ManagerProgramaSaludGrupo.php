<?php

/**
 * 	@autor Juan Sartor
 * 	@version 	01/10/2021
 * 	Manager de Programas de salud grupo.
 *
 */
class ManagerProgramaSaludGrupo extends ManagerMedia {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "programa_salud_grupo", "idprograma_salud_grupo");
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
        if ($request["programa_salud_grupo"] != "") {

            $rdo = cleanQuery($request["programa_salud_grupo"]);

            $query->addAnd("nombre LIKE '%$rdo%'");
        }


        $data = $this->getJSONList($query, array("nombre"), $request, $idpaginate);

        return $data;
    }

    /**
     * Método que devuelve un registro 
     * @param type $id
     */
    public function get($id) {
        $record = parent::get($id);
        $imagenes = $this->getImagenes($id);
        $record["imagen"] = $imagenes["imagen"];
        $record["icon"] = $imagenes["icon"];
        return $record;
    }

    /**
     * Metodo que devuelve un array con lsa imagenes de la entidad
     * @param type $id
     * @return boolean
     */
    public function getImagenes($id) {

        if (is_file(path_entity_files("{$this->imgContainer}/$id/$id.png"))) {

            $imagen["imagen"] = array(
                "original" => URL_ROOT . "xframework/files/entities/{$this->imgContainer}/$id/{$id}.png",
                "perfil" => URL_ROOT . "xframework/files/entities/{$this->imgContainer}/$id/{$id}_perfil.png",
                "list" => URL_ROOT . "xframework/files/entities/{$this->imgContainer}/$id/{$id}_list.png",
                "usuario" => URL_ROOT . "xframework/files/entities/{$this->imgContainer}/$id/{$id}_usuario.png"
            );
        }

        if (is_file(path_entity_files("{$this->imgContainer}/$id/icon.png"))) {

            $imagen["icon"] = array(
                "original" => URL_ROOT . "xframework/files/entities/{$this->imgContainer}/$id/icon.png",
                "perfil" => URL_ROOT . "xframework/files/entities/{$this->imgContainer}/$id/icon_perfil.png",
                "list" => URL_ROOT . "xframework/files/entities/{$this->imgContainer}/$id/icon_list.png",
                "usuario" => URL_ROOT . "xframework/files/entities/{$this->imgContainer}/$id/icon_usuario.png"
            );
        }

        return $imagen;
    }

    /**
     * Metodo que devuelve el listao completo de programas de salud con sus imagenes correspondientes
     * @return type
     */
    public function getListadoProgramas() {
        $query = new AbstractSql();
        $query->setSelect("
                *
            ");
        $query->setFrom("
                $this->table 
            ");
        $query->setWhere("visible=1");
        $query->setOrderBy("orden ASC");
        $listado = $this->getList($query);

        //recorremos el listado y agregamos las imagenes
        foreach ($listado as $key => $item) {
            $listado[$key]["imagenes"] = $this->getImagenes($item[$this->id]);
        }
        return $listado;
    }

    /**
     * Método que permite exportar el listado los médicos en los programas de salud
     */
    public function ExportarMedicosProgramaSalud($request) {
        //$this->debug();
        //print_r($request);
        require_once(path_libs_php("PHPExcel/Classes/PHPExcel.php"));
        require_once(path_libs_php("PHPExcel/Classes/PHPExcel/IOFactory.php"));


        //obtenemos el programa seleccionado o todos los programas si no se selecciono uno en particular
        if ($request["idprograma_salud"] != "") {
            $programa_seleccionado = $this->get($request["idprograma_salud"]);
        }

        $query = new AbstractSql();
        $query->setSelect("*");
        $query->setFrom("(
                        SELECT m.idmedico,m.nombre,m.apellido,m.especialidad,pc.programa_salud_idprograma_salud FROM programa_medico_referente pmr INNER JOIN programa_categoria  pc ON (pc.idprograma_categoria=pmr.programa_categoria_idprograma_categoria) INNER JOIN v_medicos  m ON (pmr.medico_idmedico=m.idmedico)
                        UNION 
                        SELECT m.idmedico,m.nombre,m.apellido,m.especialidad,pc.programa_salud_idprograma_salud FROM programa_medico_complementario pmc INNER JOIN programa_categoria  pc ON (pc.idprograma_categoria=pmc.programa_categoria_idprograma_categoria) INNER JOIN v_medicos  m ON (pmc.medico_idmedico=m.idmedico)
                        ) as T");
        if ($request["idprograma_salud"] != "") {
            $query->setWhere("T.programa_salud_idprograma_salud = {$programa_seleccionado["idprograma_salud"]}");
        }

        $query->setOrderBy("T.especialidad ASC,T.nombre ASC,T.apellido ASC");

        $query->setGroupBy("T.idmedico");

        $data = $this->getList($query);
        //agregamos los medicos al array de programas
        $listado_medicos = $data;




        //completamos el archivo excel con los datos obtenidosﬁ
        //template
        $inputFileName = path_root() . "xframework/app/xadmin/view/templates/excel/listado_medicos_programa.xlsx";
        $inputFileType = PHPExcel_IOFactory::identify($inputFileName);
        $objReader = PHPExcel_IOFactory::createReader($inputFileType);
        $objPHPExcel = $objReader->load($inputFileName);


        $i = 0;
        $objPHPExcel->setActiveSheetIndex($i);
        $active_sheet = $objPHPExcel->getActiveSheet();
        $r_start = 4;
        //si hay programa seleccionado ponemos el nombre como titulo
        if ($request["idprograma_salud"] != "") {
            $active_sheet->setCellValue("A1", "{$programa_seleccionado["programa_salud"]}");
            $objPHPExcel->getActiveSheet()->getStyle("A1")->getFont()->setBold(true);
            $r_start = 3;
        }

        foreach ($listado_medicos as $medico) {
            //nombre
            $active_sheet->setCellValue("A$r_start", $medico["nombre"]);
            //apellido
            $active_sheet->setCellValue("B$r_start", $medico["apellido"]);
            //especialidad
            $active_sheet->setCellValue("C$r_start", $medico["especialidad"]);
            $r_start++;
        }




        if ($request["idprograma_salud"] != "") {
            $active_sheet->setTitle($programa_seleccionado['programa_salud']);
        } else {
            $active_sheet->setTitle("Programmes");
        }

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

        //header('Content-Type: application/vnd.ms-excel');
        header('Content-Type: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
        if ($request["idprograma_salud"] != "") {
            header('Content-Disposition: attachment;filename="' . str2seo($programa_seleccionado['programa_salud']) . '.xlsx"');
        } else {
            header('Content-Disposition: attachment;filename="programmes.xlsx"');
        }
        header('Cache-Control: max-age=0');
        $objWriter->save('php://output');
    }

    /**
     * Metodo que devuelve un listado de programas asociados en grupos
     */
    public function getListadoGrupoProgramas() {

        $query = new AbstractSQL();
        $query->setSelect("*");
        $query->setFrom("$this->table");
        $query->setWhere("visible=1");
        $query->setOrderBy("orden ASC");

        $listado = $this->getList($query);
        $ManagerProgramaSaludGrupoAsociacion = $this->getManager("ManagerProgramaSaludGrupoAsociacion");
        foreach ($listado as $key => $grupo) {
            // si esta logueado un paciente no hay q mostrarle la familia 15 pero si siempre en el front
            if ($_SESSION[URL_ROOT]["paciente_p"]['logged_account']["paciente"]["idpaciente"] != '') {
                if ($grupo["idprograma_salud_grupo"] != '15') {
                    $listado[$key]["listado_programas"] = $ManagerProgramaSaludGrupoAsociacion->getProgramasAsociados($grupo["idprograma_salud_grupo"]);
                }
            } else {
                $listado[$key]["listado_programas"] = $ManagerProgramaSaludGrupoAsociacion->getProgramasAsociados($grupo["idprograma_salud_grupo"]);
            }
        }


        return $listado;
    }

}

//END_class
?>

