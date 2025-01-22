<?php

require_once(path_libs("libs_php/fpdf/fpdf.php"));
require_once(path_libs("libs_php/fpdi/fpdi.php"));
require_once(path_libs("libs_php/fpdi/pdf_rotate.php"));
define('EURO', chr(128));

class PDFFacturaTransferenciaCuestionario extends PDF_Rotate {

    private $y_ini = 10;

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

        if (is_null($data["file"])) {
            $this->Output("fac-quest-{$data["pago"]["idpago_recompensa_encuesta"]}.pdf", "I");
        } else {
            @$this->Output($data["file"], "F");
        }
        ob_end_flush();
    }

    public function doPDF() {

        parent::AddPage();
        $this->drawFactura($this->data);
    }

    public function drawFactura() {

        $data = $this->data;

        $x = 10;
        $y = 10;
        $h = 5;

        $this->setXY($x, $y);
        $this->SetFont('Arial', 'B', 16);
        $this->MultiCell(40, 5, utf8_decode("Facture"), 0, 'L', 0);
        $this->Image(path_themes("imgs/log_p_n_blanco.jpg"), 165, $y, 30, 15);



        $this->setXY($x, $y + 10);
        $this->SetFont('Arial', 'B', 10);
        $this->MultiCell(60, 5, utf8_decode("Numéro de facture"), 0, 'L', 0);

        $this->setXY($x + 40, $y + 10);
        $this->SetFont('Arial', 'B', 10);
        $this->MultiCell(60, 5, utf8_decode("FQUEST{$data["pago"]["idpago_recompensa_encuesta"]}"), 0, 'L', 0);

        $this->setXY($x, $y + 15);
        $this->SetFont('Arial', '', 10);
        $this->MultiCell(60, 5, utf8_decode("Date d'émission"), 0, 'L', 0);

        $fechahoy = date("F j, Y");
        $this->setXY($x + 40, $y + 15);
        $this->SetFont('Arial', '', 10);
        $this->MultiCell(60, 5, utf8_decode("{$fechahoy}"), 0, 'L', 0);




        $this->setXY($x, $y + 25);
        $this->SetFont('Arial', 'B', 10);
        $this->MultiCell(40, 5, utf8_decode("Doctorplus SAS"), 0, 'L', 0);

        $this->setXY($x + 100, $y + 25);
        $this->SetFont('Arial', 'B', 10);
        $this->MultiCell(40, 5, utf8_decode("Facturer à"), 0, 'L', 0);


        $this->setXY($x, $y + 30);
        $this->SetFont('Arial', '', 10);
        $this->MultiCell(40, 5, utf8_decode("2 bld Henri Becquerel"), 0, 'L', 0);

        $this->setXY($x + 100, $y + 30);
        $this->SetFont('Arial', '', 10);
        $this->MultiCell(70, 5, utf8_decode("{$data["empresa"]["empresa"]}"), 0, 'L', 0);

        $this->setXY($x, $y + 35);
        $this->SetFont('Arial', '', 10);
        $this->MultiCell(40, 5, utf8_decode("57970 Yutz"), 0, 'L', 0);

        $this->setXY($x + 100, $y + 35);
        $this->SetFont('Arial', '', 10);
        $this->MultiCell(70, 5, utf8_decode("{$data["contratante"]["email"]}"), 0, 'L', 0);

        $this->setXY($x, $y + 40);
        $this->SetFont('Arial', '', 10);
        $this->MultiCell(40, 5, utf8_decode("France"), 0, 'L', 0);

        $this->setXY($x, $y + 45);
        $this->SetFont('Arial', '', 10);
        $this->MultiCell(60, 5, utf8_decode("support@workncare.io"), 0, 'L', 0);


        $this->setXY($x, $y + 60);
        $this->SetFont('Arial', 'B', 14);
        $this->MultiCell(120, 5, utf8_decode("{$data["monto"]} ") . EURO, 0, 'L', 0);



        $this->setXY($x, $y + 70);
        $this->SetFont('Arial', '', 10);
        $this->MultiCell(140, 5, utf8_decode("Facture émise par :"), 0, 'L', 0);

        $this->setXY($x, $y + 80);
        $this->SetFont('Arial', '', 10);
        $this->MultiCell(140, 5, utf8_decode("DoctorPlus SAS - 2 boulevard Henri Becquerel 57970 Yutz (France)"), 0, 'L', 0);

        $this->setXY($x, $y + 85);
        $this->SetFont('Arial', '', 10);
        $this->MultiCell(140, 5, utf8_decode("Numéro de SIRET : 841 830 912 00017"), 0, 'L', 0);

        $this->setXY($x, $y + 90);
        $this->SetFont('Arial', '', 10);
        $this->MultiCell(140, 5, utf8_decode("Numéro de RCS : Thionville B 841 830 912"), 0, 'L', 0);

        $this->setXY($x, $y + 95);
        $this->SetFont('Arial', '', 10);
        $this->MultiCell(140, 5, utf8_decode("Numéro de TVA: FR69841830912"), 0, 'L', 0);


        $this->setXY($x, $y + 105);
        $this->SetFont('Arial', '', 10);
        $this->MultiCell(140, 5, utf8_decode("Pour toute question, contacter notre service client : support@workncare.io"), 0, 'L', 0);

        $this->setXY($x, $y + 110);
        $this->SetFont('Arial', '', 10);
        $this->MultiCell(140, 5, utf8_decode("Merci d'avoir souscrit à notre offre!"), 0, 'L', 0);



        $this->setXY($x, $y + 120);
        $this->SetFont('Arial', '', 9);
        $this->MultiCell(140, 5, utf8_decode("Description"), 0, 'L', 0);

        $this->setXY($x + 85, $y + 120);
        $this->SetFont('Arial', '', 9);
        $this->MultiCell(140, 5, utf8_decode("Qté"), 0, 'L', 0);

        $this->setXY($x + 130, $y + 120);
        $this->SetFont('Arial', '', 9);
        $this->MultiCell(140, 5, utf8_decode("Prix unitaire"), 0, 'L', 0);

        $this->setXY($x + 170, $y + 120);
        $this->SetFont('Arial', '', 9);
        $this->MultiCell(140, 5, utf8_decode("Montant"), 0, 'L', 0);

        $this->setXY($x, $y + 127.5);
        $this->Line($x, $y + 127.5, $x + 190, $y + 127.5);


        $this->setXY($x, $y + 130);
        $this->SetFont('Arial', 'B', 9);
        $this->MultiCell(140, 5, utf8_decode("Achat de prestation (sondage)"), 0, 'L', 0);

        $this->setXY($x + 85, $y + 130);
        $this->SetFont('Arial', '', 9);
        $this->MultiCell(140, 5, utf8_decode("{$data["cuestionario"]["cantidad"]}"), 0, 'L', 0);

        $this->setXY($x + 130, $y + 130);
        $this->SetFont('Arial', '', 9);
        $this->MultiCell(140, 5, utf8_decode("{$data["precioUn"]}"), 0, 'L', 0);

        $this->setXY($x + 170, $y + 130);
        $this->SetFont('Arial', '', 9);
        $this->MultiCell(140, 5, utf8_decode("{$data["monto"]} ") . EURO, 0, 'L', 0);



        $this->setXY($x + 85, $y + 140);
        $this->SetFont('Arial', '', 9);
        $this->MultiCell(140, 5, utf8_decode("Sous-total"), 0, 'L', 0);


        $this->setXY($x + 170, $y + 140);
        $this->SetFont('Arial', '', 9);
        $this->MultiCell(140, 5, utf8_decode("{$data["monto"]} ") . EURO, 0, 'L', 0);


        $this->setXY($x + 85, $y + 147.5);
        $this->SetFont('Arial', '', 9);
        $this->MultiCell(140, 5, utf8_decode("Total"), 0, 'L', 0);


        $this->setXY($x + 170, $y + 147.5);
        $this->SetFont('Arial', '', 9);
        $this->MultiCell(140, 5, utf8_decode("{$data["monto"]} ") . EURO, 0, 'L', 0);




        $this->setXY($x + 85, $y + 155);
        $this->SetFont('Arial', 'B', 9);
        $this->MultiCell(140, 5, utf8_decode("Montant dû"), 0, 'L', 0);


        $this->setXY($x + 170, $y + 155);
        $this->SetFont('Arial', 'B', 9);
        $this->MultiCell(140, 5, utf8_decode("{$data["monto"]} ") . EURO, 0, 'L', 0);


        $this->setXY($x, $y + 170);
        $this->SetFont('Arial', '', 9);
        $this->MultiCell(190, 5, utf8_decode("Attention : tout retard de règlement donnera lieu de plein droit et sans qu'aucune mise en demeure ne soit nécessaire au paiement de pénalités de retard sur la base de 3 fois le taux d'intérêt légal et au paiement d'une indemnité forfaitaire pour frais de recouvrement d'un montant de 40 eur."), 0, 'L', 0);


        $this->setXY($x, $y + 190);
        $this->SetFont('Arial', '', 9);
        $this->MultiCell(190, 5, utf8_decode("Note : paiement relatif à l'achat d'une prestation dans le cadre d'un sondage. La TVA est décomptée de la prestation le cas échéant. Validité de la prestation : 12 mois."), 0, 'L', 0);



        $this->setXY($x, $y + 260);
        $this->Line($x, $y + 260, $x + 190, $y + 260);

        $this->setXY($x, $y + 267);
        $this->SetFont('Arial', '', 9);
        $this->MultiCell(190, 5, utf8_decode("FQUEST{$data["pago"]["idpago_recompensa_encuesta"]}") . " - " . utf8_decode("{$data["monto"]} ") . EURO, 0, 'L', 0);
    }

}

?>