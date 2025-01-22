<?php

require_once("JeyReport.php");

class PDFResumenPeriodo extends JeyReport {

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
            $this->Output("resume-" . $this->data["periodo"]["mes_format"] . "-" . $this->data["periodo"]["anio"] . ".pdf", "I");
        } else {
            @$this->Output($file, "F");
        }
        ob_end_flush();
    }

    public function doPDF() {
        $this->ancho_escritura = 190;
        $this->draw = "caratula";

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

//$this->draw contendrá cual de los TABS se va a dibujar en el PDF
        switch ($this->draw) {
            case "caratula":
                $this->drawResumen();
                break;
            case "pagina":

                $this->drawConsultasFacturadas();
                break;
            case "resumen-consultas":
                $this->drawListadoConsultasResumen();
                break;
            case "resumen-consultas-fr":
                $this->drawDescripcionResumenConsultasFR();
                break;
            case "resumen-consultas-no-fr":
                $this->drawDescripcionResumenConsultasNOFR();
                break;


            default:
                return;
        }
    }

    /**
     * Método que dibujará el header, poniendo la fecha fecha del periodo y datos de la cuenta del medico
     */
    public function addHeaderMio() {
        $x = 10;
        $y = 10;


        $this->setXY($x, $y);
        $this->SetFont('Arial', 'B', 10);
        $this->MultiCell(60, 15, utf8_decode("Période {$this->data["periodo"]["mes"]}/{$this->data["periodo"]["anio"]}"), 0, 'L', 0);

        $this->setXY($x += 30, $y);

        $this->SetFont('Arial', '', 9);
        $dias_mes = getCantidadDiasMes($this->data["periodo"]["mes"]);
        $fecha_actual = date("Y-m-d");
        $time_actual = strtotime($fecha_actual);
        $time_periodo = strtotime("{$this->data["periodo"]["anio"]}-{$this->data["periodo"]["mes"]}-{$dias_mes}");

        if ($time_actual < $time_periodo) {
            list($año_act, $mes_act, $dia_act) = explode("-", $fecha_actual);
            $this->MultiCell(45, 15, " 1/{$this->data["periodo"]["mes"]}/{$this->data["periodo"]["anio"]} au {$dia_act}/{$mes_act}/{$año_act}", 0, 'L', 0);
        } else {
            $this->MultiCell(45, 15, " 1/{$this->data["periodo"]["mes"]}/{$this->data["periodo"]["anio"]} au {$dias_mes}/{$this->data["periodo"]["mes"]}/{$this->data["periodo"]["anio"]}", 0, 'L', 0);
        }

        $y = 15;
        $this->setXY($x += 110, $y);
        $this->SetFont('Arial', 'B', 9);
        $this->MultiCell(70, 5, "Titulaire du compte:", 0, 'L', 0);
        $this->setXY($x, $y += 5);
        $nombre = "{$this->data["medico"]["tituloprofesional"]} {$this->data["medico"]["nombre"]} {$this->data["medico"]["apellido"]} ";
        $this->MultiCell(70, 5, utf8_decode($nombre), 0, 'L', 0);

        if ($this->data["medico"]["pais_idpais"] == 1) {
            $this->setXY($x, $y += 5);
            $this->MultiCell(70, 5, utf8_decode("AM: " . $this->data["medico"]["numero_am"]), 0, 'L', 0);

            $this->setXY($x, $y += 5);
            $this->MultiCell(70, 5, utf8_decode("RPPS: " . $this->data["medico"]["numero_rpps"]), 0, 'L', 0);
            $this->Rect(148, 15, 52, 20);
        } else {
            $this->Rect(148, 15, 52, 20);
        }
    }

    public function drawHonorarios() {

        $y_start = $y = 45;
        $x_start = $x = 10;
        $this->setXY($x, $y);
        $h = 7;
        //Honoriaries du mois
        $this->SetFont('Arial', 'B', 10);
        $this->setXY($x, $y);
        $this->MultiCell($this->ancho_escritura, $h, utf8_decode("HONORAIRES DU MOIS"), 1, 'L', 0);

        //Total 
        $this->SetFont('Arial', 'B', 10);
        $this->setXY(148, $y);
        $this->MultiCell(20, $h, "TOTAL", 0, 'L', 0);


        //Total facturado en EUR
        $this->SetFont('Arial', 'B', 10);
        $this->setXY(170, $y);
        $total_periodo = $this->data["periodo"]["importe_videoconsulta"] + $this->data["periodo"]["importe_consulta_express"];
        $this->MultiCell(30, $h, utf8_decode("EUR " . $total_periodo), 0, 'R', 0);

        //Quitamos las consultas ALD del resumen
        /*
          if ($this->data["medico"]["pais_idpais"] == 1) {
          //LABEL - Consultations prestées non crédités (facturer séparément)
          $this->SetFont('Arial', '', 9);

          $this->setXY($x, $y + $h);
          $this->MultiCell($this->ancho_escritura, $h, utf8_decode("      - Consultations prestées non crédités (facturer séparément)"), 1, 'L', 0);

          //Total facturado en EUR
          $this->setXY(170, $y + $h);
          $total_ald = $this->data["periodo"]["importe_videoconsultas_ald"];
          $this->MultiCell(30, $h, utf8_decode("- EUR " . $total_ald), 0, 'R', 0);
          } else {
          $total_ald = 0;
          } */
        $total_ald = 0;

        //LABEL - - Coût d'utilisation Compte sans abonnement
        $y = $this->getY();
        $this->SetFont('Arial', '', 9);
        $this->setXY($x, $y);
        if ($this->data["medico"]["planProfesional"] == 1) {
            $this->MultiCell($this->ancho_escritura, $h, utf8_decode("      - Coût d'utilisation Compte avec abonnement"), 1, 'L', 0);
            //Total facturado en EUR
            $this->setXY(170, $y);
            $total_comision = 0.00;
            $this->MultiCell(30, $h, utf8_decode("- EUR " . $total_comision), 0, 'R', 0);
        } else {
            $this->MultiCell($this->ancho_escritura, $h, utf8_decode("      - Coût d'utilisation Compte sans abonnement"), 1, 'L', 0);
            //Total facturado en EUR
            $this->setXY(170, $y);
            $total_comision = $this->data["periodo"]["importe_comision_videoconsulta"] + $this->data["periodo"]["importe_comision_consulta_express"];
            $this->MultiCell(30, $h, utf8_decode("- EUR " . $total_comision), 0, 'R', 0);
        }

        // MONTANT NET CREDITE SUR VOTRE COMPTE
        $y = $this->getY();
        $this->SetFont('Arial', 'B', 10);
        $this->setXY($x, $y);
        $this->MultiCell($this->ancho_escritura, $h, utf8_decode(" MONTANT NET CREDITE SUR VOTRE COMPTE"), 1, 'L', 0);
        //Total 
        $this->SetFont('Arial', 'B', 10);
        $this->setXY(148, $y);
        $this->MultiCell(20, $h, "TOTAL", 0, 'L', 0);

        //Total facturado en EUR
        $this->SetFont('Arial', 'B', 10);
        $this->setXY(170, $y);
        $total_neto = $total_periodo - $total_comision - $total_ald;
        $this->MultiCell(30, $h, utf8_decode("EUR " . $total_neto), 0, 'R', 0);
    }

    /**
     * Método utilizado para dibujar el footer de detalle consulta Frances
     */
    public function drawDescripcionResumenConsultasFR() {

        $y = 265;
        $x = 10;
        $this->Line($x, $y, $x + $this->ancho_escritura, $y);

        $this->SetXY($x, $y);
        $this->SetFont('Arial', 'B', 7);
        $this->MultiCell(0, 4, utf8_decode("Ce relevé d'activité présente au moment de son impression l'état de vos honoraires réalisés par votre cabinet sur DoctorPlus."), 0, 'C', 0);

        $y = $this->getY();
        $this->SetXY($x, $y);
        $this->SetFont('Arial', 'BU', 7);
        $this->MultiCell(0, 5, utf8_decode("FACTURATION CPAM"), 0, 'C', 0);

        $y = $this->getY();
        $this->SetXY($x, $y);
        $this->SetFont('Arial', 'B', 7);
        $this->MultiCell(0, 4, utf8_decode("N'oubliez de facturer les téléconsultations de vos patients éligibles au remboursement de la CPAM!"), 0, 'C', 0);

        $y = $this->getY();
        $this->SetXY($x, $y);
        $this->SetFont('Arial', '', 7);
        $this->MultiCell(0, 4, utf8_decode("Vous devez envoyer la FSE en mode dégradé (télétransmission) via votre logiciel professionnel ou envoyer la FS à vos patients."), 0, 'C', 0);


        //dibujamos la factura del medico
        $this->page_number++;

        parent::AddPage();

        $this->addFooterMio();

        $this->drawFactura();
    }

    /**
     * Método utilizado para dibujar el footer de detalle consulta NO Frances
     */
    public function drawDescripcionResumenConsultasNOFR() {

        $y = 265;
        $x = 10;
        $this->Line($x, $y, $x + $this->ancho_escritura, $y);

        $this->SetXY($x, $y);
        $this->SetFont('Arial', 'B', 7);
        $this->MultiCell(0, 4, utf8_decode("Ce relevé d'activité présente au moment de son impression l'état de vos honoraires réalisés par votre cabinet sur DoctorPlus"), 0, 'C', 0);

        $y = $this->getY();
        $this->SetXY($x, $y);
        $this->SetFont('Arial', 'B', 7);
        $this->MultiCell(0, 4, utf8_decode("et les montants crédités sur votre compte."), 0, 'C', 0);


        $y = $this->getY();
        $this->SetXY($x, $y);
        $this->SetFont('Arial', 'BU', 7);
        $this->MultiCell(0, 5, utf8_decode("RESUME D'ACTIVITE"), 0, 'C', 0);

        $y = $this->getY();
        $this->SetXY($x, $y);
        $this->SetFont('Arial', '', 7);
        $this->MultiCell(0, 4, utf8_decode("C'est le total des consultations payées par les patients et créditées sur votre compte DoctorPlus"), 0, 'C', 0);


        //dibujamos la factura del medico
        $this->page_number++;

        parent::AddPage();

        $this->addFooterMio();

        $this->drawFactura();
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
                $this->setSourceFile(path_view('templates/pdf/resumen_periodo_template.pdf'));
                break;
            case "pagina":

                //(usamos el mismo TEMPLATE para todas las paginas)
                $this->setSourceFile(path_view('templates/pdf/resumen_periodo_template.pdf'));
                break;
            default:
                $this->setSourceFile(path_view('templates/pdf/resumen_periodo_template.pdf'));
                break;
        }

        $tplIdx = $this->importPage(1);
// use the imported page and place it at point 10,10 with a width of 100 mm 
        $this->useTemplate($tplIdx, 0, 0);
        $this->SetTextColor(0, 0, 0);
    }

    /**
     * Método que dibuja la carátula
     */
    public function drawResumen() {
        $this->template = "caratula";
        $this->getTemplate();
        $this->drawHonorarios();



        //TITULO RESUME ACTIVITE
        $center = $this->w / 2;
        $y = $this->getY() + 10;

        $this->SetFont('Arial', 'B', 10);
        $this->SetXY($center - 30, $y);
        $this->MultiCell(60, 10, utf8_decode("RESUME D'ACTIVITE"), 1, 'C', 0);



        $y_start = $y = $this->getY() + 5;
        $x_start = $x = 10;
        //Label Consulta Express (prive)
        $this->setXY($x, $y);
        //recuadro borde
        $this->MultiCell($this->ancho_escritura, 15, "", 1, 'C', 0);

        $this->Image(path_themes("imgs/ico_ce_pdf.jpg"), $x + 4, $y + 3, 7, 7);
        $this->SetFont('Arial', 'B', 9);
        $this->setXY($x += 12, $y);
        $this->MultiCell(100, 15, utf8_decode("Conseil (privé)"), 0, 'L', 0);

        //Total de consultas
        $this->SetFont('Arial', 'B', 11);
        $this->setXY($x += 100, $y);
        $this->MultiCell(30, 10, utf8_decode($this->data["periodo"]["total_consulta_express"]), 0, 'C', 0);
        $this->SetFont('Arial', '', 9);
        $this->setXY($x, $y + 10);
        $this->MultiCell(30, 5, utf8_decode("Consultations"), 0, 'C', 0);
        //Total facturado
        $this->SetFont('Arial', 'B', 11);
        $this->setXY($x += 25, $y);
        $this->MultiCell(30, 10, utf8_decode("EUR" . $this->data["periodo"]["importe_consulta_express"]), 0, 'C', 0);
        $this->SetFont('Arial', '', 9);
        $this->setXY($x, $y + 10);
        $this->MultiCell(30, 5, utf8_decode("Total"), 0, 'C', 0);
        //Total comisiones
        $this->SetFont('Arial', 'B', 11);
        $this->SetTextColor(224, 42, 75); //color rojo
        $this->setXY($x += 25, $y);
        $this->MultiCell(30, 10, utf8_decode("- EUR" . $this->data["periodo"]["importe_comision_consulta_express"]), 0, 'C', 0);
        $this->SetTextColor(0, 0, 0); //color negro
        $this->SetFont('Arial', '', 9);
        $this->setXY($x, $y + 10);
        $this->MultiCell(30, 5, utf8_decode("Coût"), 0, 'C', 0);


        //Label Video Consultas (prive)

        $y_start = $y = $this->getY();
        $x_start = $x = 10;

        $this->setXY($x, $y);
        //recuadro borde
        $this->MultiCell($this->ancho_escritura, 15, "", 1, 'C', 0);

        $this->Image(path_themes("imgs/ico_vc_pdf.jpg"), $x + 4, $y + 3, 7, 7);
        $this->SetFont('Arial', 'B', 9);
        $this->setXY($x += 12, $y);
        $this->MultiCell(100, 15, utf8_decode("Vidéo Consultation  (privé)"), 0, 'L', 0);

        //Total de consultas
        $this->SetFont('Arial', 'B', 11);
        $this->setXY($x += 100, $y);
        $this->MultiCell(30, 10, utf8_decode($this->data["periodo"]["total_videoconsulta_particulares"]), 0, 'C', 0);
        $this->SetFont('Arial', '', 9);
        $this->setXY($x, $y + 10);
        $this->MultiCell(30, 5, utf8_decode("Consultations"), 0, 'C', 0);
        //Total facturado
        $this->SetFont('Arial', 'B', 11);
        $this->setXY($x += 25, $y);
        $this->MultiCell(30, 10, utf8_decode("EUR" . $this->data["periodo"]["importe_videoconsulta_particulares"]), 0, 'C', 0);
        $this->SetFont('Arial', '', 9);
        $this->setXY($x, $y + 10);
        $this->MultiCell(30, 5, utf8_decode("Total"), 0, 'C', 0);
        //Total comisiones
        $this->SetTextColor(224, 42, 75); //color rojo
        $this->SetFont('Arial', 'B', 11);
        $this->setXY($x += 25, $y);
        $this->MultiCell(30, 10, utf8_decode("- EUR" . $this->data["periodo"]["importe_comision_videoconsulta_particulares"]), 0, 'C', 0);
        $this->SetTextColor(0, 0, 0); //color negro
        $this->SetFont('Arial', '', 9);
        $this->setXY($x, $y + 10);
        $this->MultiCell(30, 5, utf8_decode("Coût"), 0, 'C', 0);


        if ($this->data["medico"]["pais_idpais"] == 1) {
            //Label Vidéo Consultation (Rembousement CPAM)

            $y_start = $y = $this->getY();
            $x_start = $x = 10;

            $this->setXY($x, $y);
            //recuadro borde
            $this->MultiCell($this->ancho_escritura, 15, "", 1, 'C', 0);

            $this->Image(path_themes("imgs/ico_vc_pdf.jpg"), $x + 4, $y + 3, 7, 7);
            $this->SetFont('Arial', 'B', 9);
            $this->setXY($x += 12, $y);
            $this->MultiCell(100, 15, utf8_decode("Vidéo Consultation (Rembousement CPAM)"), 0, 'L', 0);

            //Total de consultas
            $this->SetFont('Arial', 'B', 11);
            $this->setXY($x += 100, $y);
            $this->MultiCell(30, 10, utf8_decode($this->data["periodo"]["total_videoconsulta_reintegro"]), 0, 'C', 0);
            $this->SetFont('Arial', '', 9);
            $this->setXY($x, $y + 10);
            $this->MultiCell(30, 5, utf8_decode("Consultations"), 0, 'C', 0);
            //Total facturado
            $this->SetFont('Arial', 'B', 11);
            $this->setXY($x += 25, $y);
            $this->MultiCell(30, 10, utf8_decode("EUR" . $this->data["periodo"]["importe_videoconsulta_reintegro"]), 0, 'C', 0);
            $this->SetFont('Arial', '', 9);
            $this->setXY($x, $y + 10);
            $this->MultiCell(30, 5, utf8_decode("Total"), 0, 'C', 0);
            //Total comisiones
            $this->SetTextColor(224, 42, 75); //color rojo
            $this->SetFont('Arial', 'B', 11);
            $this->setXY($x += 25, $y);
            $this->MultiCell(30, 10, utf8_decode("- EUR" . $this->data["periodo"]["importe_comision_videoconsulta_reintegro"]), 0, 'C', 0);
            $this->SetTextColor(0, 0, 0); //color negro
            $this->SetFont('Arial', '', 9);
            $this->setXY($x, $y + 10);
            $this->MultiCell(30, 5, utf8_decode("Coût"), 0, 'C', 0);
        }

        //quitamos las consultas ALD - se suman a las consultas con reembolso
        /*
          if ($this->data["medico"]["pais_idpais"] == 1) {
          //Label Vidéo Consultations Paciente ALD (Remboursement CPAM)

          $y_start = $y = $this->getY();
          $x_start = $x = 10;

          $this->setXY($x, $y);
          //recuadro borde
          $this->MultiCell($this->ancho_escritura, 15, "", 1, 'C', 0);

          $this->Image(path_themes("imgs/ico_vc_pdf.jpg"), $x + 4, $y + 3, 7, 7);
          $this->SetFont('Arial', 'B', 9);
          $this->setXY($x += 12, $y);
          $this->MultiCell(100, 15, utf8_decode("Vidéo Consultations Paciente ALD (Remboursement CPAM) "), 0, 'L', 0);

          //Total de consultas
          $this->SetFont('Arial', 'B', 11);
          $this->setXY($x += 100, $y);
          $this->MultiCell(30, 10, utf8_decode($this->data["periodo"]["total_videoconsulta_ald"]), 0, 'C', 0);
          $this->SetFont('Arial', '', 9);
          $this->setXY($x, $y + 10);
          $this->MultiCell(30, 5, utf8_decode("Consultations"), 0, 'C', 0);
          //Total facturado
          $this->SetFont('Arial', 'B', 11);
          $this->setXY($x += 25, $y);
          $this->MultiCell(30, 10, utf8_decode("EUR" . $this->data["periodo"]["importe_videoconsultas_ald"]), 0, 'C', 0);
          $this->SetFont('Arial', '', 9);
          $this->setXY($x, $y + 10);
          $this->MultiCell(30, 5, utf8_decode("Total"), 0, 'C', 0);

          //Total comisiones

          $this->SetTextColor(224, 42, 75); //color rojo
          $this->SetFont('Arial', 'B', 8);
          $this->setXY($x += 28, $y + 2);
          $this->MultiCell(25, 4, utf8_decode("Honoraires à facturer séparément"), 0, 'C', 0);
          $this->SetTextColor(0, 0, 0); //color negro
          $this->SetFont('Arial', '', 9);
          $this->setXY($x, $y + 10);
          $this->MultiCell(30, 5, utf8_decode(""), 0, 'C', 0);
          }
         */

        //Finalización del dibujo, agrego DATOS GENERALES
        //Quitamos las consultas que deben ser facturadas a CPAM
        /* if ($this->data["medico"]["pais_idpais"] == 1) {
          $this->drawConsultasFacturadas();
          $this->drawConsultasPendienteFacturacion();
          } */
        $this->draw = "resumen-consultas";
        $this->page_number++;
        $this->AddPageMio();
    }

    /*     * Metodo que dibuja las consultas facturadas
     * 
     * @return type
     */

    public function drawConsultasFacturadas() {
        $this->template = "pagina";
        $this->getTemplate();
        $x = 10;

        //TITULO RESUME ACTIVITE
        $center = $this->w / 2;
        $y = $this->getY() + 10;

        $this->SetFont('Arial', 'B', 10);
        $this->SetXY($center - 30, $y);
        $this->MultiCell(60, 10, utf8_decode("RESUME DE FACTURATION"), 1, 'C', 0);

        //dibujo las consultas
        $y_start = $y = $this->getY() + 5;

        $this->SetFont('Arial', 'B', 10);
        $this->SetXY($x, $y);
        $this->MultiCell($this->ancho_escritura, 7, utf8_decode("TELECONSULTATIONS DEJA FACTUREES A LA CPAM"), 0, 'L', 0);

        //Seteo el color de fondo de los Text
        $this->SetFillColor(224, 75, 24);
        $array_datos = $this->data["listado_cpam_facturadas"];


        //calculamos si entra la tabla  en el resto de la hoja
        if (($y + 10) < ($this->h - 20)) {
            $this->SetFont('Arial', '', 8);
            $array_cabecera = [["Nr"], ["Date"], ["Titulaire"], ["Patient"], ["ALD"], ["Consultation"], ["Carte Vitale"], ["Code"], ["Montant"]];

            $y += 10;
            $ancho_columnas = [15, 25, 30, 30, 10, 20, 25, 20, 15];
            $y = $this->drawDinamicTableFormat($array_cabecera, $array_datos, $x, $y, 5, $this->ancho_escritura, NULL, $ancho_columnas);

            $this->setXY($x, $y);
        }




        //echo $y; echo "-"; echo $this->h;
        if (($y ) < ($this->h - 20)) {

            $this->y_ini = $this->GetY();
            $this->setXY($x, $this->y_ini);

            //$this->drawFinal();
        } else {
            //si no entra agregamos otra pagina

            $this->page_number++;
            $this->draw = "final";

            $this->AddPageMio();
            $y = 30;
            $this->y_ini = $y;
            $this->setXY($x, $y);
        }
    }

    /*     * Metodo que dibuja las consultas pendientes de facturacion
     * 
     * @return type
     */

    public function drawConsultasPendienteFacturacion() {
        $this->template = "pagina";
        $this->getTemplate();
        $x = 10;

        //TITULO 

        $y = $this->getY() + 5;

        $this->SetFont('Arial', 'B', 10);
        $this->SetXY($x, $y);
        $this->MultiCell($this->ancho_escritura, 7, utf8_decode("TELECONSULTATIONS EN ATTENTE DE FACTURATION CPAM"), 0, 'L', 0);

        //dibujo las consultas
        //Seteo el color de fondo de los Text
        $this->SetFillColor(224, 75, 24);
        $array_datos = $this->data["listado_cpam_pendientes"];
        $y = $this->getY() + 2;

        //calculamos si entra la tabla  en el resto de la hoja
        if (($y + 10) < ($this->h - 20)) {

            $array_cabecera = [["Nr"], ["Date"], ["Titulaire"], ["Patient"], ["ALD"], ["Consultation"], ["Carte Vitale"], ["Code"], ["Montant"]];
            $ancho_columnas = [15, 25, 30, 30, 10, 20, 25, 20, 15];
            $y = $this->drawDinamicTableFormat($array_cabecera, $array_datos, $x, $y, 5, $this->ancho_escritura, NULL, $ancho_columnas);

            $this->setXY($x, $y);
        }
    }

    /**
     * MEtodo que dibuja la factura del medico
     */
    public function drawFactura() {
        $this->template = "pagina";
        $this->getTemplate();
        //nombre
        $x = 140;
        $y = 15;
        $this->Rect($x, $y, 60, 10);
        $this->setXY($x, $y);
        $this->SetFont('Arial', 'B', 10);
        $this->MultiCell(60, 5, "Attention:", 0, 'L', 0);
        $this->setXY($x, $y += 5);
        $nombre = "{$this->data["medico"]["tituloprofesional"]} {$this->data["medico"]["nombre"]} {$this->data["medico"]["apellido"]} ";
        $this->MultiCell(60, 5, utf8_decode($nombre), 0, 'L', 0);



        //TITULO 
        $center = $this->w / 2;
        $y = 30;

        $this->SetFont('Arial', 'B', 10);
        $this->SetXY($center - 30, $y);
        $this->MultiCell(60, 10, utf8_decode("FACTURE DOCTORPLUS"), 1, 'C', 0);

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
        $y = 45;
        $x = 10;
        //Numéro de facture:
        $this->SetFont('Arial', '', 10);
        $this->SetXY($x, $y);
        $this->MultiCell(45, 5, utf8_decode("Numéro de facture:"), 0, 'L', 0);

        $this->SetXY($x + 45, $y);
        $this->MultiCell(90, 5, $this->data["periodo"]["numero_factura"], 0, 'L', 0);

        //Date de facture:
        $this->SetXY($x, $y += 5);
        $this->MultiCell(45, 5, utf8_decode("Date de la facture :"), 0, 'L', 0);

        $this->SetXY($x + 45, $y);
        $this->MultiCell(90, 5, utf8_decode("{$fecha_factura}"), 0, 'L', 0);

        //Pèriode de facturation:
        $this->SetXY($x, $y += 5);
        $this->MultiCell(45, 5, utf8_decode("Pèriode de facturation:"), 0, 'L', 0);

        $nombre_mes = getNombreCortoMes($this->data["periodo"]["mes"]);

        $nombre_mes = html_entity_decode($nombre_mes);
        $this->SetXY($x + 45, $y);
        $this->MultiCell(90, 5, utf8_decode("{$nombre_mes} {$this->data["periodo"]["anio"]}"), 0, 'L', 0);

        //Société
        $this->SetXY($x, $y += 5);
        $this->MultiCell(45, 5, utf8_decode("Société:"), 0, 'L', 0);

        $this->SetXY($x + 45, $y);
        $this->MultiCell(90, 5, utf8_decode("DoctorPlus"), 0, 'L', 0);

        //Adresse
        $this->SetXY($x, $y += 5);
        $this->MultiCell(45, 5, utf8_decode("Adresse:"), 0, 'L', 0);

        $this->SetXY($x + 45, $y);
        $this->MultiCell(90, 5, utf8_decode("2 bld Henri Becquerel 57970"), 0, 'L', 0);

        //Paiement
        $this->SetXY($x, $y += 5);
        $this->MultiCell(45, 5, utf8_decode("Paiement:"), 0, 'L', 0);

        $this->SetXY($x + 45, $y);
        $this->MultiCell(90, 5, utf8_decode("déjà réglé par convention de preuve électronique"), 0, 'L', 0);



        //dibujo las consultas
        //Seteo el color de fondo de los Text
        $this->SetFillColor(224, 75, 24);
        $array_datos = $this->data["datos_factura"];
        $y = $this->getY() + 2;

        //calculamos si entra la tabla  en el resto de la hoja
        if (($y + 10) < ($this->h - 20)) {

            $array_cabecera = array(
                0 => array("Objet"),
                1 => array("Description"),
                2 => array("Montant HT"),
                3 => array("TVA"),
                4 => array("TTC")
            );

            $ancho_columnas = [60, 60, 25, 25, 25];
            $y = $this->drawDinamicTableFormat($array_cabecera, $array_datos, $x, $y, 5, $this->ancho_escritura, null, $ancho_columnas);
        }

        //dibujamos la factura del medico
        $this->page_number++;

        parent::AddPage();

        $this->addFooterMio();

        $this->drawResumenConsultasBeneficiarios();
    }

    /**
     * MEtodo que dibuja la factura con el resumen de consultas a beneficiarios
     */
    public function drawResumenConsultasBeneficiarios() {
        $this->template = "pagina";
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
        $y = 40;
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

        $this->SetXY($x + 148, $y);
        $numero_factura = STR_PAD($this->data["medico"]["idmedico"].$this->data["periodo"]["anio"].$this->data["periodo"]["mes"], 10, "0", STR_PAD_LEFT);
        $this->MultiCell(40, 5, $numero_factura, 0, 'L', 0);



        //CP y ciudad
        $ciudad = ucfirst(strtolower($this->data["medico"]["direccion"]["localidad_corta"]));
        $cpciudad = "{$this->data["medico"]["direccion"]["cpa"]} {$ciudad}";
        $this->SetXY($x, $y += 5);
        $this->MultiCell(90, 5, utf8_decode($cpciudad), 0, 'L', 0);

        // fecha de emision
        $nombre_mes = getNombreCortoMes($this->data["periodo"]["mes"]);
        $nombre_mes = html_entity_decode($nombre_mes);
        $this->SetXY($x + 110, $y);
        $this->MultiCell(45, 5, utf8_decode("Pèriode de facturation:"), 0, 'L', 0);
        $this->SetXY($x + 148, $y);
        $this->MultiCell(50, 5, utf8_decode("{$nombre_mes} {$this->data["periodo"]["anio"]}"), 0, 'L', 0);

        //Pais:
        $paisMedico = ucfirst(strtolower($this->data["medico"]["direccion"]["pais"]));
        $this->SetXY($x, $y += 5);
        $this->MultiCell(65, 5, utf8_decode($paisMedico), 0, 'L', 0);

        $this->SetXY($x + 110, $y);
        $this->MultiCell(65, 5, utf8_decode("Facture générée automatiquement"), 0, 'L', 0);



        //email
        $this->SetXY($x, $y += 5);
        $this->MultiCell(65, 5, utf8_decode($this->data["medico"]["email"]), 0, 'L', 0);


        //facturar a
        $this->SetFont('Arial', 'B', 10);
        $this->SetXY($x, $y += 15);
        $this->MultiCell(45, 5, utf8_decode("Facturer à"), 0, 'L', 0);


        $this->SetFont('Arial', '', 10);
        $this->SetXY($x, $y += 5);
        $this->MultiCell(125, 5, utf8_decode("DOCTORPLUS SAS - SIREN/SIRET:84183091200017"), 0, 'L', 0);
        $this->SetXY($x, $y += 5);
        $this->MultiCell(125, 5, utf8_decode("2 bld Henri Becquerel"), 0, 'L', 0);
        $this->SetXY($x, $y += 5);
        $this->MultiCell(125, 5, utf8_decode("57970 YUTZ"), 0, 'L', 0);
        $this->SetXY($x, $y += 5);
        $this->MultiCell(125, 5, utf8_decode("France"), 0, 'L', 0);
        $this->SetXY($x, $y += 5);
        $this->MultiCell(125, 5, utf8_decode("compta@doctorplus.fr"), 0, 'L', 0);

        // factura emitida por
        $this->SetFont('Arial', 'B', 10);
        $this->SetXY($x, $y += 15);
        $this->MultiCell(45, 5, utf8_decode("Facture émise par:"), 0, 'L', 0);

        $this->SetFont('Arial', '', 10);
        $this->SetXY($x, $y += 5);
        $this->MultiCell(100, 5, utf8_decode("{$nombreMedico} - {$direccionProfesional}, {$cpciudad}, {$paisMedico}"), 0, 'L', 0);

        $this->SetXY($x, $y += 5);
        $this->MultiCell(55, 5, utf8_decode("Numéro d'identification fiscale:"), 0, 'L', 0);
        $this->SetXY($x + 50, $y);
        $this->MultiCell(90, 5, utf8_decode($this->data["infofiscal"]["identificacion_fiscal"]), 0, 'L', 0);

        $this->SetXY($x, $y += 5);
        $this->MultiCell(42, 5, utf8_decode("Condition contre la TVA:"), 0, 'L', 0);
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
        $y = $this->getY() + 2;

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
        //Total
        $sumatotal = 0;
        foreach ($array_datos as &$dato) {
            $monto = explode(' ', $dato["precioTarifa"]);
            $sumatotal = $sumatotal + $monto[0];
        }
        $this->SetFont('Arial', 'B', 10);
        $this->SetXY($x + 85, $y += 5);
        $this->MultiCell(85, 5, utf8_decode("Total consultations béneficiaires WorknCare:"), 0, 'L', 0);
        $this->SetXY($x + 170, $y);
        $this->MultiCell(20, 5, utf8_decode($sumatotal . ' EUR'), 0, 'L', 0);
    }

    public function drawListadoConsultasResumen() {
        $this->template = "pagina";
        $this->getTemplate();
        $x = 10;
        $y = 40;

        $this->SetFont('Arial', 'B', 10);
        $this->SetXY($x, $y);
        // print_r($this->data["medico"]);
        if ($this->data["medico"]["planProfesional"] == 1) {
            $this->MultiCell($this->ancho_escritura, 7, utf8_decode("DETAIL DES CONSULTATIONS : COMPTE AVEC ABONNEMENT"), 0, 'L', 0);
        } else {
            $this->MultiCell($this->ancho_escritura, 7, utf8_decode("DETAIL DES CONSULTATIONS : COMPTE SANS ABONNEMENT"), 0, 'L', 0);
        }

        //dibujo las consultas
        //Seteo el color de fondo de los Text
        $this->SetFillColor(224, 75, 24);
        $array_datos = $this->data["listado_movimientos"];
        $y = $this->getY() + 2;

        //calculamos si entra la tabla  en el resto de la hoja


        $array_cabecera = array(
            0 => array("Titulaire"),
            1 => array("Patient"),
            2 => array("Consultation"),
            3 => array("Date"),
            4 => array("Montant"),
            5 => array("Detail")
        );

        $ancho_columnas = [42, 42, 20, 25, 20, 40];
        $y = $this->drawDinamicTableFormat($array_cabecera, $array_datos, $x, $y, 4, $this->ancho_escritura, NULL, $ancho_columnas);
        $this->setXY($x, $y);



        if ($y < ($this->h - 35)) {

            if ($this->data["medico"]["pais_idpais"] == 1) {
                $this->drawDescripcionResumenConsultasFR();
            } else {
                $this->drawDescripcionResumenConsultasNOFR();
            }
        } else {

            $this->page_number++;
            if ($this->data["medico"]["pais_idpais"] == 1) {
                $this->draw = "resumen-consultas-fr";
            } else {
                $this->draw = "resumen-consultas-no-fr";
            }
            $y = 30;
            $this->y_ini = $y;
            $this->setXY($x, $y);
            $this->AddPageMio();
        }
    }

}

?>