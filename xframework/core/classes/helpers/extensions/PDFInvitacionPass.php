<?php

require_once("JeyReport.php");

class PDFInvitacionPass extends JeyReport {

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
            $this->Output("invitation-workncare.pdf", "I");
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



//$this->draw contendrá cual de los paginas se va a dibujar en el PDF
        switch ($this->draw) {
            case "caratula":
                $this->drawCaratula();
                break;
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
        $idempresa = $empresa["idempresa"];


        if (CONTROLLER == 'frontend_2' || $empresa["image"] == '') {
            switch ($this->template) {
                case "caratula":
                    //Si el template que se necesita es la carátula o no 
                    //(usamos el mismo TEMPLATE para todas las paginas)
                    $this->setSourceFile(path_view('templates/pdf/template_invitacion_pass_bienetre_n.pdf'));
                    $tplIdx = $this->importPage(1);
                    break;
                case "invitacion":
                    //Si el template que se necesita es la carátula o no 
                    //(usamos el mismo TEMPLATE para todas las paginas)
                    $this->setSourceFile(path_view('templates/pdf/template_invitacion_pass_bienetre_n.pdf'));
                    $tplIdx = $this->importPage(2);
                    break;
                default:
                    $this->setSourceFile(path_view('templates/pdf/template_invitacion_pass_bienetre_n.pdf'));
                    $tplIdx = $this->importPage(2);
                    break;
            }
        } else {
            switch ($this->template) {
                case "caratula":
                    //Si el template que se necesita es la carátula o no 
                    //(usamos el mismo TEMPLATE para todas las paginas)
                    $this->setSourceFile(path_view('templates/pdf/template_invitacion_pass_bienetre_n.pdf'));
                    $tplIdx = $this->importPage(1);
                    break;
                case "invitacion":
                    //Si el template que se necesita es la carátula o no 
                    //(usamos el mismo TEMPLATE para todas las paginas)
                    $this->setSourceFile(path_view('templates/pdf/template_invitacion_pass_bienetre_n.pdf'));
                    $tplIdx = $this->importPage(2);
                    break;
                default:
                    $this->setSourceFile(path_view('templates/pdf/template_invitacion_pass_bienetre_n.pdf'));
                    $tplIdx = $this->importPage(2);
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
        $this->template = "caratula";
        $this->getTemplate();
        $empresa = $this->data["empresa"];
        $idempresa = $empresa["idempresa"];
        if (CONTROLLER != 'frontend_2' && $empresa["image"] != '') {
            $y = 74;
            $x = 175;
            $this->Image(path_files("entities/empresa/$idempresa/{$idempresa}_usuario.jpg"), $x, $y, 20, 20);
        }
        $cod_pass = $empresa["codigo_pass"];
        $this->SetFont('Arial', 'B', 14);
        $this->SetTextColor(255, 255, 255);

        $this->SetXY(142, 248);
        $this->MultiCell(28, 5, utf8_decode($cod_pass), 0, 'C', 0);

        $this->Image(path_files("temp/qr_invitacion/$idempresa.png"), 137, 183, 40, 40);
//Dibujamos la pagina con QR
        $this->draw = "invitacion";
        $this->AddPageMio();
    }

    /**
     * Metodo que dibuja la invitacion
     */
    public function drawInvitacion() {
        $this->template = "invitacion";
        $this->getTemplate();


        $center = $this->w / 2;
        $y = 168;
        $x = 140;

        $empresa = $this->data["empresa"];

        $idempresa = $empresa["idempresa"];

        $this->Image(path_files("temp/qr_invitacion/$idempresa.png"), $x - 5, $y - 75, 40, 40);

//        if (CONTROLLER != 'frontend_2' && $empresa["image"] != '') {
//            $y = 74;
//            $x = 175;
//            $this->Image(path_files("entities/empresa/$idempresa/{$idempresa}_usuario.jpg"), $x, $y, 20, 20);
//        }
    }

}

?>