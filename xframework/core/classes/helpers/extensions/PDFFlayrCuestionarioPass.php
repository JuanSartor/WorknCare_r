<?php

require_once("JeyReport.php");

class PDFFlayrCuestionarioPass extends JeyReport {

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
            $this->Output("flyer-questionnaire-pass-bienetre.pdf", "I");
        } else {
            @$this->Output($file, "F");
        }
        ob_end_flush();
    }

    public function doPDF() {
        $this->ancho_escritura = 190;
        $this->draw = "invitacion";

//Inicialmente dibujo la carátula
        $this->AddPageMio();
    }

    /**
     * Agrega una página, le dibuja el header y el TAB correspondiente
     */
    public function AddPageMio() {

        parent::AddPage();



//$this->draw contendrá cual de los paginas se va a dibujar en el PDF
        switch ($this->draw) {
            case "invitacion":
                $this->drawInvitacion();
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
        
    }

    /**
     * Método que obtiene el template, sea la carátula o no
     */
    public function getTemplate() {

        $empresa = $this->data["empresa"];
        $cuestionario = $this->data["cuestionario"];


        if (CONTROLLER == 'frontend_2' || $empresa["image"] == '') {
            switch ($this->template) {
                case "caratula":
                    //Si el template que se necesita es la carátula o no 
                    //(usamos el mismo TEMPLATE para todas las paginas)
                    if ($cuestionario["cantidad"] > '0') {
                        $this->setSourceFile(path_view('templates/pdf/template_flyers_cuestionario_personalizable.pdf'));
                    } else {
                        $this->setSourceFile(path_view('templates/pdf/template_flyers_cuestionario_personalizable.pdf'));
                    }
                    $tplIdx = $this->importPage(1);
                    break;
                case "invitacion":
                    //Si el template que se necesita es la carátula o no 
                    //(usamos el mismo TEMPLATE para todas las paginas)
                    if ($cuestionario["cantidad"] > '0') {
                        $this->setSourceFile(path_view('templates/pdf/template_flyers_cuestionario_personalizable.pdf'));
                    } else {
                        $this->setSourceFile(path_view('templates/pdf/template_flyers_cuestionario_personalizable.pdf'));
                    }
                    $tplIdx = $this->importPage(1);
                    break;
                default:
                    if ($cuestionario["cantidad"] > '0') {
                        $this->setSourceFile(path_view('templates/pdf/template_flyers_cuestionario_personalizable.pdf'));
                    } else {
                        $this->setSourceFile(path_view('templates/pdf/template_flyers_cuestionario_personalizable.pdf'));
                    }
                    $tplIdx = $this->importPage(1);
                    break;
            }
        } else {
            switch ($this->template) {
                case "caratula":
                    //Si el template que se necesita es la carátula o no 
                    //(usamos el mismo TEMPLATE para todas las paginas)
                    $this->setSourceFile(path_view('templates/pdf/template_flyers_cuestionario_personalizable.pdf'));
                    $tplIdx = $this->importPage(1);
                    break;
                case "invitacion":
                    //Si el template que se necesita es la carátula o no 
                    //(usamos el mismo TEMPLATE para todas las paginas)
                    $this->setSourceFile(path_view('templates/pdf/template_flyers_cuestionario_personalizable.pdf'));
                    $tplIdx = $this->importPage(1);
                    break;
                default:
                    $this->setSourceFile(path_view('templates/pdf/template_flyers_cuestionario_personalizable.pdf'));
                    $tplIdx = $this->importPage(1);
                    break;
            }
        }


// use the imported page and place it at point 10,10 with a width of 100 mm 
        $this->useTemplate($tplIdx, 0, 0);
        $this->SetTextColor(0, 0, 0);
    }

    /**
     * Metodo que dibuja la caratula de la invitacion
     */
    public function drawCaratula() {

        $this->draw = "invitacion";
        $this->AddPageMio();
    }

    /**
     * Metodo que dibuja la invitacion
     */
    public function drawInvitacion() {
        $this->template = "invitacion";
        $this->getTemplate();


        $this->setXY(16, 80);
        $this->SetFont('Arial', 'B', 24);
        $this->MultiCell(170, 5, utf8_decode($this->data["cuestionario"]["titulo_flyer"]), 0, 'C', 0);

        $this->setXY(19, 113);
        $this->SetFont('Arial', '', 16);
        $this->MultiCell(175, 5, utf8_decode($this->data["cuestionario"]["subtitulo_flyer"]), 0, 'L', 0);
        $this->setXY(19, 255);
        $this->SetFont('Arial', '', 16);
        $this->MultiCell(175, 5, utf8_decode($this->data["cuestionario"]["complementario_flyer"]), 0, 'L', 0);


        $y = 186;
        $x = 65;

        $hashc = $this->data["hashc"];

        $this->Image(path_files("temp/qr_invitacion/$hashc.png"), $x + 4.8, $y - 17, 70, 70);
        if ($this->data["empresa"]["image"]) {
            $this->Image(path_files($this->data["img"]), 169, 260, 25, 25);
        }
    }

}

?>