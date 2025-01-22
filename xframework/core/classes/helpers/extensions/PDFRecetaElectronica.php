<?php
require_once(path_libs("libs_php/fpdf/fpdf.php"));
require_once(path_libs("libs_php/fpdi/fpdi.php"));
require_once(path_libs("libs_php/fpdi/pdf_rotate.php"));

class PDFRecetaElectronica extends PDF_Rotate {

    private $y_ini = 10;
    public $ancho_escritura = 165;

    function __construct() {
        parent::__construct('P', 'mm', 'a4');
        $this->SetMargins(1, 1);
        $this->SetAutoPageBreak(true, 0);
    }

    public function getPDF($data, $file = NULL) {
        ob_start();


        $this->data = $data;


        $this->SetDisplayMode("real");

        $this->doPDF();

        if (is_null($file)) {
            $this->Output("ordonnance-{$data["receta_archivo"]["codigo"]}.pdf", "I");
        } else {
            @$this->Output($file, "F");
        }
        ob_end_flush();
    }

    public function doPDF() {



//Inicialmente dibujo el archivo la receta
        $this->drawReceta($this->data);
        if ($this->data["farmacia"] != 1) {
            $this->drawAnexo($this->data);
        }
    }

    /**
     * Método que dibuja la receta
     */
    public function drawReceta() {
        parent::AddPage();
        $this->getTemplate($this->data);
        if($this->data["preview"]==1 ){
            $this->AddCopyLabel();
        }
    }

    /*     * Metodo que recorre el array de preguntas y las inserta en el pdf
     * 
     * @return type
     */

    public function drawAnexo() {
        parent::AddPage();
        $this->drawBarcode();
        $this->drawInfoMedico();

        $this->drawInfoPaciente();
        $this->drawInfoFarmacia();

        $this->drawFinal();
    }
    
    //metodo que escribe una marca de orden Cancelada an medio de la Hoja

    function AddCopyLabel() {

        $this->SetTextColor(200, 200, 200);

        $this->SetFont('Arial', 'B', 70);


      $this->RotatedText(50, 170, "DUPLIQUER", 35);
        $this->SetTextColor(0, 0, 0);
        $this->SetFont('Arial', '', 8);
    }

    public function drawInfoMedico() {

        $data = $this->data;

        $x = 25;
        $y = 10;
        $h = 5;

        $this->setXY($x, $y);
        $this->SetFont('Arial', 'B', 12);
        $this->MultiCell($this->ancho_escritura, 5, utf8_decode("PREUVE DE PRESCRIPTION ELECTRONIQUE"), 0, 'C', 0);


        $y +=7;
        $this->setXY($x, $y);
        $this->Line($x, $y, $x + $this->ancho_escritura, $y);


        $y +=$h;
        $this->setXY($x, $y);
        $this->SetFont('Arial', '', 10);
        $this->MultiCell($this->ancho_escritura, 5, utf8_decode("Cabinet du "), 0, 'L', 0);

        $y +=$h;
        $this->setXY($x, $y);
        $this->SetFont('Arial', '', 10);
        $this->MultiCell($this->ancho_escritura, 5, utf8_decode("14, rue de Verdun 75010 Paris"), 0, 'L', 0);

        $y +=$h;
        $this->setXY($x, $y);
        $this->SetFont('Arial', '', 10);
        $this->MultiCell($this->ancho_escritura, 5, utf8_decode("No. AM: {$data["medico"]["numero_am"]}"), 0, 'L', 0);

        $y +=(2 * $h);
        $this->setXY($x, $y);
        $this->SetFont('Arial', '', 10);
        $this->MultiCell($this->ancho_escritura, 5, utf8_decode("{$data["medico"]["tituloprofesional"]} {$data["medico"]["nombre"]} {$data["medico"]["apellido"]}"), 0, 'L', 0);

        $y +=$h;
        $this->setXY($x, $y);
        $this->SetFont('Arial', '', 10);
        $this->MultiCell($this->ancho_escritura, 5, utf8_decode("{$data["medico"]["mis_especialidades"][0]["especialidad"]}"), 0, 'L', 0);

        $y +=$h;
        $this->setXY($x, $y);
        $this->SetFont('Arial', '', 10);
        $this->MultiCell($this->ancho_escritura, 5, utf8_decode("No. RPPS: {$data["medico"]["numero_rpps"]}"), 0, 'L', 0);

        $y +=$h;
        $this->setXY($x, $y);
        $this->SetFont('Arial', '', 10);
        $this->MultiCell($this->ancho_escritura, 5, utf8_decode("Tel (fixe) : 	01.33.45.54.4"), 0, 'L', 0);
    }

    public function AcceptPageBreak() {
        parent::AcceptPageBreak();
    }

    public function drawBarcode() {




        $data = $this->data;

        /* NUMERO aM */
        $url_barcode = url_web("common.php?action=1&modulo=common&submodulo=barcode&f=jpg&s=ean-128&w=200&h=50&d=" . $data["medico"]["numero_am"]);
        $this->SetFillColor(255, 255, 255);
        $this->Image($url_barcode, 90, 20, '', '', "JPG");
        $this->setXY(100, 35);
        $this->SetFont('Arial', '', 10);

        $this->MultiCell(50, 5, utf8_decode("No. AM: {$data["medico"]["numero_am"]}"), 0, 'C', 1);

        /* NUMERO RPPS */
        $url_barcode = url_web("common.php?action=1&modulo=common&submodulo=barcode&f=jpg&s=ean-128&w=200&h=50&d=" . $data["medico"]["numero_rpps"]);

        $this->Image($url_barcode, 90, 40, '', '', "JPG");
        $this->setXY(100, 55);
        $this->SetFont('Arial', '', 10);

        $this->MultiCell(50, 5, utf8_decode("No. RPPS: {$data["medico"]["numero_rpps"]}"), 0, 'C', 1);
    }

    public function drawInfoPaciente() {

        $data = $this->data;

        $x = 25;
        $h = 5;
        $y = $this->getY();
        $y +=(2 * $h);


        $this->setXY($x, $y);
        $this->SetFont('Arial', '', 10);
        $sexo = $data["paciente"]["sexo"] == 1 ? "Mr." : "Mme.";
        $this->MultiCell($this->ancho_escritura, 5, utf8_decode("Pour: {$sexo} {$data["paciente"]["nombre"]} {$data["paciente"]["apellido"]}, né le {$data["paciente"]["fechaNacimiento_format"]}, ({$data["paciente"]["edad_anio"]} ans)"), 0, 'L', 0);

        $y +=$h;
        $this->setXY($x, $y);
        $this->SetFont('Arial', '', 10);
        $fecha_hora = explode(" ", $data["videoconsulta"]["inicio_sala"]);

        $fecha = explode("-", $fecha_hora[0]);
        $this->MultiCell($this->ancho_escritura, 5, utf8_decode("Date de la téléconsultation: {$fecha[2]}/{$fecha[1]}/{$fecha[0]}"), 0, 'L', 0);

        $y +=$h;
        $this->setXY($x, $y);
        $this->SetFont('Arial', '', 10);
        $this->MultiCell($this->ancho_escritura, 5, utf8_decode("No. Carte Vitale: {$data["paciente"]["tarjeta_vitale"]}"), 0, 'L', 0);

        $y +=(2 * $h);
        $this->setXY($x, $y);
        $this->SetFont('Arial', 'B', 10);
        $this->MultiCell($this->ancho_escritura, 5, utf8_decode("SECTION PATIENT"), 0, 'L', 0);


        $y +=$h;
        $this->setXY($x, $y);
        $this->SetFont('Arial', '', 10);
        $this->MultiCell($this->ancho_escritura, 7, utf8_decode("N'oubliez pas de présenter votre prescription accompagnée \n de la preuve ci-présente de prescription électronique!"), 1, 'C', 0);
    }

    public function drawFinal() {

        $x = 25;
        $h = 5;
        $y = $this->getY();
        $y +=(3 * $h);

        $this->setXY($x, $y);
        $this->SetFont('Arial', '', 8);
        $this->MultiCell($this->ancho_escritura, 5, utf8_decode("Cette ordonnance électronique a été générée par la plateforme de téléconsultation DoctorPlus, en conformité avec les conditions requises par la loi du 13 août 2004 no 2004-810 relative à l'assurance maladie (article 34). Elle respecte notamment les conditions de d'identification du prescripteur, d'une transmission et conservation propres à garantir son intégrité et confidentialité. Dans le cadre de la télémédecine le professionnel de santé est habilité à prescrire une ordonnance dématérialisée suite à un acte de télémédecine"), 0, 'L', 0);

        $y +=(6 * $h);
        $this->setXY($x, $y);
        $this->SetFont('Arial', 'B', 8);
        $this->MultiCell($this->ancho_escritura, 5, utf8_decode("DoctorPlus n'est pas pas un service d'urgences. Appelez le 15 si vous devez consulter pour une urgence."), 0, 'L', 0);

        $y +=(2 * $h);
        $this->setXY($x, $y);
        $this->Line($x, $y, $x + $this->ancho_escritura, $y);

        $y +=$h;
        $this->setXY($x, $y);
        $this->SetFont('Arial', '', 8);
        $this->MultiCell($this->ancho_escritura, 5, utf8_decode("DoctorPlus SAS"), 0, 'C', 0);

        $y += $h;
        $this->setXY($x, $y);
        $this->SetFont('Arial', '', 8);
        $this->MultiCell($this->ancho_escritura, 5, utf8_decode("2 boulevard Henri Becquerel 57970 Yutz (France)"), 0, 'C', 0);

        $y += $h;
        $this->setXY($x, $y);
        $this->SetFont('Arial', '', 8);
        $this->MultiCell($this->ancho_escritura, 5, utf8_decode("Numéro de SIRET - 841 830 912 00017"), 0, 'C', 0);

        $y += $h;
        $this->setXY($x, $y);
        $this->SetFont('Arial', '', 8);
        $this->MultiCell($this->ancho_escritura, 5, utf8_decode("support@workncare.io / Tel. + 33 (0)6 09 81 69 34"), 0, 'C', 0);
    }

    public function drawInfoFarmacia() {

        $data = $this->data;

        $x = 25;
        $h = 5;
        $y = $this->getY();
        $y +=(2 * $h);

        $this->setXY($x, $y);
        $this->SetFont('Arial', 'B', 10);
        $this->MultiCell($this->ancho_escritura, 5, utf8_decode("SECTION PHARMACIE"), 0, 'L', 0);

        $this->Rect($x, $y + 5, $this->ancho_escritura, 85);

        $y +=(2 * $h);
        $this->setXY($x, $y);
        $this->SetFont('Arial', '', 10);
        $this->MultiCell($this->ancho_escritura, 5, utf8_decode("Prescription électronique générée par"), 0, 'C', 0);

        $this->Image(path_themes("imgs/doctorplus_logo_300.jpg"), 210 / 2 - 25, $y + 8, 50);


        $y +=(5 * $h);
        $this->setXY($x, $y);
        $this->SetFont('Arial', '', 10);
        $this->MultiCell($this->ancho_escritura, 5, utf8_decode("Vérifiez tout d'abord que la prescription n'a pas déja été délivrée dans une autre pharmacie. Pour ce faire, veuillez utiliser le lien ci-dessous, qui vous permettra de vous connecter à l'espace pharmacie pour vérifier le statut de la prescription :"), 0, 'C', 0);


        $y +=(4 * $h);
        $this->setXY($x, $y);
        $this->SetFont('Arial', 'B', 10);
        $this->MultiCell($this->ancho_escritura, 5, utf8_decode(url_web("ordonnance/")), 0, 'C', 0);



        $y +=(2 * $h);
        $this->setXY($x, $y);
        $this->SetFont('Arial', 'B', 10);
        $this->MultiCell($this->ancho_escritura, 5, utf8_decode("UTILISER LE CODE"), 0, 'C', 0);


        $y +=(2 * $h);
        //mitad a4= 210/2
        $this->setXY(210 / 2 - 25, $y);
        $this->SetFont('Arial', 'B', 15);
        $this->SetTextColor(238, 52, 68);

        $this->MultiCell(50, 10, utf8_decode("{$data["receta_archivo"]["codigo"]}"), 1, 'C', 0);
        $this->SetTextColor(0, 0, 0);
    }

    /**
     * Método que obtiene el template para armar el pdf
     * @param type $data
     */
    public function getTemplate($data) {

        $this->setSourceFile($data["file"]);
        $tplIdx = $this->importPage(1);
        // use the imported page and place it at point 10,10 with a width of 100 mm 
        $this->useTemplate($tplIdx, 0, 0);

        $this->SetTextColor(0, 0, 0);
    }

}

?>