<?php

require_once("JeyReport.php");

class PDFResumenConsulta extends JeyReport {

    private $y_ini = 10;

    function __construct() {
        parent::__construct('P', 'mm', 'a4');
        $this->SetMargins(10, 10);
        $this->SetAutoPageBreak(true, 0);
        $this->AliasNbPages("{totalPages}");
    }

    public function getPDF($data, $file = NULL) {
        ob_start();

        if (count($data) > 0) {
            $this->data = $data;
        } else {
            
        }

        $this->SetDisplayMode("real");

        $this->doPDF();

        if (is_null($file)) {
            $this->Output("invoice-" . $this->data["numero_factura"] . ".pdf", "I");
        } else {
            @$this->Output($file, "F");
        }
        ob_end_flush();
    }

    public function doPDF() {
        $this->ancho_escritura = 190;
        $this->draw = "factura";

//Inicialmente dibujo la carátula
        $this->AddPageMio();
    }

    /**
     * Agrega una página, le dibuja el header y el TAB correspondiente
     */
    public function AddPageMio() {

        parent::AddPage();

//Agrego el header en caso de que tenga que agregar alguno
        $this->addHeaderMio();

        $this->addFooterMio();

//$this->draw contendrá cual de los paginas se va a dibujar en el PDF
        switch ($this->draw) {
            case "factura":
                $this->drawFactura();
                break;

            default:
                return;
        }
    }

    /**
     * Método que dibujará el header, poniendo la fecha fecha del periodo y datos de la cuenta del medico
     */
    public function addHeaderMio() {
        
    }

    /**
     * Método utilizado para dibujar el footer 
     */
    public function addFooterMio() {

        $y = 282;
        $x = 10;
        $this->Line($x, $y, $x + $this->ancho_escritura, $y);
        /* DoctorPlus SAS - 2 boulevard Henri Becquerel 57970 Yutz (France) 
          Numéro de SIRET - 841 830 912 00017.
          support@doctorplus.eu
         */
        $this->SetFont('Arial', '', 7);
        //TEXTO FOOTER
        $this->SetXY($x, $y);
        $this->MultiCell(0, 5, utf8_decode("DoctorPlus SAS - 2 boulevard Henri Becquerel 57970 Yutz (France)"), 0, 'C', 0);
        $this->SetXY($x, $y + 3);
        $this->MultiCell(0, 5, utf8_decode("Numéro de SIRET - 841 830 912 00017"), 0, 'C', 0);
        $this->SetXY($x, $y + 6);
        $this->MultiCell(0, 5, utf8_decode("support@workncare.io"), 0, 'C', 0);

        //pagins
        $this->SetXY($x, $y);
        $this->MultiCell(0, 5, "Feuille " . ($this->page_number + 1) . "/" . $this->AliasNbPages, 0, 'R', 0);

        //fecha
        $this->SetFont('Times', 'I', 7);

        $this->SetXY($x, $y);
        $this->MultiCell(0, 5, date("d/m/Y H:i:s"), 0, 'L', 0);
    }

    /**
     * Método que obtiene el template, sea la carátula o no
     */
    public function getTemplate() {

        switch ($this->template) {
            case "caratula":
                //Si el template que se necesita es la carátula o no 
                //(usamos el mismo TEMPLATE para todas las paginas)
                $this->setSourceFile(path_view('templates/pdf/resumen_consulta_template.pdf'));
                break;
            case "pagina":

                //(usamos el mismo TEMPLATE para todas las paginas)
                $this->setSourceFile(path_view('templates/pdf/resumen_consulta_template.pdf'));
                break;
            default:
                $this->setSourceFile(path_view('templates/pdf/resumen_consulta_template.pdf'));
                break;
        }

        $tplIdx = $this->importPage(1);
// use the imported page and place it at point 10,10 with a width of 100 mm 
        $this->useTemplate($tplIdx, 0, 0);
        $this->SetTextColor(0, 0, 0);
    }

    /**
     * MEtodo que dibuja la factura del medico
     */
    public function drawFactura() {
        $this->template = "caratula";
        $this->getTemplate();

        //nombre 
        $center = $this->w / 2;
        $y = 30;
        $x = 10;

        $nombreMedico = "{$this->data["medico"]["nombre"]} {$this->data["medico"]["apellido"]} ";

        $this->SetFont('Arial', 'B', 16);
        $this->SetXY($x, $y);
        $this->MultiCell(60, 10, utf8_decode($nombreMedico), 0, 'L', 0);


        //calculo fecha
        $dias_mes = getCantidadDiasMes($this->data["periodo"]["mes"]);
        $fecha_actual = date("Y-m-d");
        $time_actual = strtotime($fecha_actual);
        $time_periodo = strtotime("{$this->data["periodo"]["anio"]}-{$this->data["periodo"]["mes"]}-{$dias_mes}");

        if ($time_actual < $time_periodo) {
            list($año_act, $mes_act, $dia_act) = explode("-", $fecha_actual);
            $fecha_factura = "{$dia_act}/{$mes_act}/{$año_act}";
        } else {
            $fecha_factura = "{$dias_mes}/{$this->data["periodo"]["mes"]}/{$this->data["periodo"]["anio"]}";
        }

        //dibujo header
        $y = 42;
        $x = 10;
        $calle = ucfirst(strtolower($this->data["medico"]["direccion"]["direccion"]));
        $direccionProfesional = "{$this->data["medico"]["direccion"]["numero"]} {$calle}";
        //Numero calle y nombre:
        $this->SetFont('Arial', '', 10);
        $this->SetXY($x, $y);
        $this->MultiCell(90, 5, utf8_decode($direccionProfesional), 0, 'L', 0);

        // numero de factura
        $this->SetFont('Arial', '', 10);
        $this->SetXY($x + 110, $y);
        $this->MultiCell(35, 5, utf8_decode("Numéro de facture:"), 0, 'L', 0);

        $this->SetXY($x + 145, $y);
        $this->MultiCell(40, 5, $this->data["numero_factura"], 0, 'L', 0);


        //CP y ciudad
        $ciudad = ucfirst(strtolower($this->data["medico"]["direccion"]["localidad_corta"]));
        $cpciudad = "{$this->data["medico"]["direccion"]["cpa"]} {$ciudad}";
        $this->SetXY($x, $y += 5);
        $this->MultiCell(90, 5, utf8_decode($cpciudad), 0, 'L', 0);

        // fecha de emision
        $datosFecha = explode("-", $this->data["consulta"]["fecha_inicio"]);
        $mescorto = getNombreCortoMes($datosFecha[1]);
        $anioF = $datosFecha[0];
        $diaF = substr($datosFecha[2], 0, 2);
        $this->SetXY($x + 110, $y);
        $this->MultiCell(35, 5, utf8_decode("Date d´émission:"), 0, 'L', 0);
        $this->SetXY($x + 145, $y);
        $this->MultiCell(40, 5, utf8_decode($diaF . " " . $mescorto . ". " . $anioF), 0, 'L', 0);

        //Pais:
        $paisMedico = ucfirst(strtolower($this->data["medico"]["direccion"]["pais"]));
        $this->SetXY($x, $y += 5);
        $this->MultiCell(65, 5, utf8_decode($paisMedico), 0, 'L', 0);

        $this->SetXY($x + 110, $y);
        $this->MultiCell(65, 5, utf8_decode("Facture générée automatiquement"), 0, 'L', 0);


        //email
        $this->SetXY($x, $y += 5);
        $this->MultiCell(100, 5, utf8_decode($this->data["medico"]["email"]), 0, 'L', 0);


        //facturar a
        $this->SetFont('Arial', 'B', 10);
        $this->SetXY($x, $y += 15);
        $this->MultiCell(45, 5, utf8_decode("Facturer à"), 0, 'L', 0);


        //nombre y apellido del paciente
        $nombrePaciente = ucfirst(strtolower($this->data["paciente"]["nombre"]));
        $apellidoPaciente = ucfirst(strtolower($this->data["paciente"]["apellido"]));
        $this->SetFont('Arial', '', 10);
        $this->SetXY($x, $y += 5);
        $this->MultiCell(150, 5, utf8_decode("{$nombrePaciente} {$apellidoPaciente}"), 0, 'L', 0);
        //email del paciente

        $this->SetFont('Arial', '', 10);
        $this->SetXY($x, $y += 5);
        $this->MultiCell(150, 5, utf8_decode("{$this->data["paciente"]["email"]}"), 0, 'L', 0);


        // factura emitida por
        $this->SetFont('Arial', 'B', 10);
        $this->SetXY($x, $y += 15);
        $this->MultiCell(45, 5, utf8_decode("Facture émise par:"), 0, 'L', 0);

        $this->SetFont('Arial', '', 10);
        $this->SetXY($x, $y += 5);
        $this->MultiCell(150, 5, utf8_decode("{$nombreMedico} - {$direccionProfesional}, {$cpciudad}, {$paisMedico}"), 0, 'L', 0);

        $this->SetXY($x, $y += 5);
        $this->MultiCell(55, 5, utf8_decode("Numéro d'identification fiscale:"), 0, 'L', 0);
        $this->SetXY($x + 50, $y);
        $this->MultiCell(90, 5, utf8_decode($this->data["infofiscal"]["identificacion_fiscal"]), 0, 'L', 0);

        $this->SetXY($x, $y += 5);
        $this->MultiCell(42,5, utf8_decode("Condition contre la TVA:"), 0, 'L', 0);
        $this->SetXY($x + 42, $y);
        if ($this->data["infofiscal"]["condicion_iva"] == '0') {
            $condicionTVA = "TVA non applicable, article 293 B du CGI";
        } else {
            $condicionTVA = $this->data["infofiscal"]["numero_tva"];
        }
        $this->MultiCell(90, 5, utf8_decode($condicionTVA), 0, 'L', 0);

        //dibujo las consultas
        //Seteo el color de fondo de los Text
        $this->SetFillColor(224, 75, 24);

        $array_datos = $this->data["listado_consultas_beneficiarios"];

        $y = $this->getY() + 5;

        //calculamos si entra la tabla  en el resto de la hoja
        if (($y + 10) < ($this->h - 20)) {

            $array_cabecera = array(
                0 => array("Date"),
                1 => array("Patient"),
                2 => array("Description"),
                3 => array("N°"),
                4 => array("Price Unitare")
            );

            $ancho_columnas = [20, 80, 45, 25, 25];
            $y = $this->drawDinamicTableFormat($array_cabecera, $array_datos, $x, $y, 5, $this->ancho_escritura, null, $ancho_columnas);
        }
    }

}

?>