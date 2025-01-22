<?php

require_once("JeyReport.php");

class PDFReporteCapsula extends JeyReport {

    private $y_ini = 10;

    function __construct() {
        parent::__construct('P', 'mm', 'a4');
        $this->SetMargins(10, 10);
        $this->SetAutoPageBreak(true, 0);
        $this->AliasNbPages("{totalPages}");
    }

    public function getPDF($request, $file = NULL) {
        ob_start();

        $this->SetDisplayMode("real");

        $this->doPDF($request);

        if (is_null($file)) {
            $this->Output("résultats-capsule.pdf", "I");
        } else {
            @$this->Output($file, "F");
        }
        ob_end_flush();
    }

    public function doPDF($request) {
        $this->ancho_escritura = 190;
        $this->draw = "invitacion";

//Inicialmente dibujo la carátula
        $this->AddPageMio($request);
    }

    /**
     * Agrega una página, le dibuja el header y el TAB correspondiente
     */
    public function AddPageMio($request) {

        parent::AddPage();



//$this->draw contendrá cual de los paginas se va a dibujar en el PDF
        switch ($this->draw) {
            case "invitacion":
                $this->drawInvitacion($request);
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

        $this->setSourceFile(path_view('templates/pdf/template_capsula_1_blanco.pdf'));
        $tplIdx = $this->importPage(1);

// use the imported page and place it at point 10,10 with a width of 100 mm 
        $this->useTemplate($tplIdx, 0, 0);
        $this->SetTextColor(0, 0, 0);
    }

    /**
     * Metodo que dibuja la caratula de la invitacion
     */
    public function drawCaratula() {
//Dibujamos la pagina con QR
        $this->draw = "invitacion";
        $this->AddPageMio();
    }

    /**
     * Metodo que dibuja la invitacion
     */
    public function drawInvitacion($request) {


        $this->template = "invitacion";
        $this->getTemplate();
        $contadorPagina = 1;


        $this->SetXY(0, 24.8);          // Primero establece Donde estará la esquina superior izquierda donde estará tu celda
        $this->SetFillColor(245, 245, 245); // establece el color del fondo de la celda (en este caso es AZUL
        $this->Cell(210, 45, '', 0, 0, '', True);
        $this->SetFillColor(26, 54, 97);
        $this->Circle(15, 39.4, 1.2, 'F');
        $this->SetFont('Arial', 'B', 13);
        $this->SetTextColor(92, 92, 92);
        $this->setXY(17, 30);
        if ($request["usuario"]["idioma_predeterminado"] == 'fr') {
            $this->MultiCell(100, 20, utf8_decode($request["fecha"]["texto_fr"]), 0, 'L', 0);
        } else {
            $this->MultiCell(100, 20, utf8_decode($request["fecha"]["texto_en"]), 0, 'L', 0);
        }
        $this->SetFont('Arial', 'B', 13);
        $this->SetTextColor(92, 92, 92);
        $this->setXY(57, 30);
        $this->MultiCell(50, 20, date("d/m/Y", strtotime($request["fecha_inicio"])), 0, 'L', 0);


        $this->SetFont('Arial', 'B', 18);
        $this->SetTextColor(92, 92, 92);
        $this->setXY(15, 48);
        if ($request["usuario"]["idioma_predeterminado"] == 'fr') {
            $this->MultiCell(100, 20, utf8_decode($request["titu"]["texto_fr"]), 0, 'L', 0);
        } else {
            $this->MultiCell(100, 20, utf8_decode($request["titu"]["texto_en"]), 0, 'L', 0);
        }
        $this->SetFont('Arial', '', 18);
        $this->SetTextColor(92, 92, 92);
        $this->setXY(57, 48);
        $this->MultiCell(120, 20, utf8_decode($request["titulo"]), 0, 'L', 0);


        $this->SetFont('Arial', 'B', 16);
        $this->SetTextColor(26, 54, 97); // azul oscuro
        $this->setXY(15, 70);
        if ($request["usuario"]["idioma_predeterminado"] == 'fr') {
            $this->MultiCell(100, 20, utf8_decode($request["numTot"]["texto_fr"]), 0, 'L', 0);
        } else {
            $this->MultiCell(100, 20, utf8_decode($request["numTot"]["texto_en"]), 0, 'L', 0);
        }


        $this->SetFillColor(92, 92, 92); // gris oscuro
        $this->Circle(163, 80, 1, 'F');
        $this->Line(80, 80, 162, 80);
        $this->SetFont('Arial', 'B', 16);
        $this->SetTextColor(242, 145, 0); //naranja
        $this->setXY(165, 70);
        $this->MultiCell(100, 20, $request["cant_visitas"], 0, 'L', 0);

        $this->SetFillColor(92, 92, 92); // gris oscuro
        $this->Circle(190, 105, 1, 'F');
        $this->Line(60, 105, 189, 105);
        $this->SetFont('Arial', 'B', 16);
        $this->SetTextColor(26, 54, 97); //negro
        $this->setXY(15, 95);
        if ($request["usuario"]["idioma_predeterminado"] == 'fr') {
            $this->MultiCell(100, 20, utf8_decode($request["paDates"]["texto_fr"]), 0, 'L', 0);
        } else {
            $this->MultiCell(100, 20, utf8_decode($request["paDates"]["texto_en"]), 0, 'L', 0);
        }


        $this->SetXY(15, 113);
        $this->SetFillColor(26, 54, 97);
        $this->Cell(90, 8, '', 0, 0, '', True);
        $this->SetXY(105, 113);
        $this->SetFillColor(242, 145, 0);
        $this->Cell(90, 8, '', 0, 0, '', True);

        $this->SetFont('Arial', 'B', 14);
        $this->SetTextColor(255, 255, 255); //naranja
        $this->setXY(18, 112);
        if ($request["usuario"]["idioma_predeterminado"] == 'fr') {
            $this->MultiCell(50, 10, utf8_decode($request["dates"]["texto_fr"]), 0, 'L', 0);
        } else {
            $this->MultiCell(50, 10, utf8_decode($request["dates"]["texto_en"]), 0, 'L', 0);
        }

        $this->SetFont('Arial', 'B', 14);
        $this->SetTextColor(255, 255, 255); // blanco
        $this->setXY(108, 112);
        if ($request["usuario"]["idioma_predeterminado"] == 'fr') {
            $this->MultiCell(100, 10, utf8_decode($request["num"]["texto_fr"]), 0, 'L', 0);
        } else {
            $this->MultiCell(100, 10, utf8_decode($request["num"]["texto_en"]), 0, 'L', 0);
        }

        $y = 124;
        $i = 1;
        foreach ($request["lista"] as $elemento) {

            if (($i % 2) != 0) {
                $this->SetXY(15, $y);
                $this->SetFillColor(198, 207, 232);
                $this->Cell(180, 8, '', 0, 0, '', True);
            } else {
                $this->SetXY(15, $y);
                $this->SetFillColor(245, 245, 245);
                $this->Cell(180, 8, '', 0, 0, '', True);
            }
            $i++;

            $this->SetFont('Arial', '', 14);
            $this->SetTextColor(92, 92, 92);
            $this->setXY(18, $y);

            $fecha = date('l jS \of F Y h:i:s A', strtotime($elemento["fecha_realizada"]));

            if (strpos($fecha, "Monday") !== false) {
                if ($request["usuario"]["idioma_predeterminado"] == 'fr') {
                    $dia = "Lundi";
                } else {
                    $dia = "Monday";
                }
            } elseif (strpos($fecha, "Tuesday") !== false) {
                if ($request["usuario"]["idioma_predeterminado"] == 'fr') {
                    $dia = "Mardi";
                } else {
                    $dia = "Tuesday";
                }
            } elseif (strpos($fecha, "Wednesday") !== false) {
                if ($request["usuario"]["idioma_predeterminado"] == 'fr') {
                    $dia = "Mercredi";
                } else {
                    $dia = "Wednesday";
                }
            } elseif (strpos($fecha, "Thursday") !== false) {
                if ($request["usuario"]["idioma_predeterminado"] == 'fr') {
                    $dia = "Jeudi";
                } else {
                    $dia = "Thursday";
                }
            } elseif (strpos($fecha, "Friday") !== false) {
                if ($request["usuario"]["idioma_predeterminado"] == 'fr') {
                    $dia = "Vendredi";
                } else {
                    $dia = "Friday";
                }
            } elseif (strpos($fecha, "Saturday") !== false) {
                if ($request["usuario"]["idioma_predeterminado"] == 'fr') {
                    $dia = "Samedi";
                } else {
                    $dia = "Saturday";
                }
            } else {
                if ($request["usuario"]["idioma_predeterminado"] == 'fr') {
                    $dia = "Dimanche";
                } else {
                    $dia = "Sunday";
                }
            }

            if (strpos($fecha, "January") !== false) {
                if ($request["usuario"]["idioma_predeterminado"] == 'fr') {
                    $mes = "Janvier";
                } else {
                    $mes = "January";
                }
            } elseif (strpos($fecha, "February") !== false) {
                if ($request["usuario"]["idioma_predeterminado"] == 'fr') {
                    $mes = "Février";
                } else {
                    $mes = "February";
                }
            } elseif (strpos($fecha, "March") !== false) {
                if ($request["usuario"]["idioma_predeterminado"] == 'fr') {
                    $mes = "Mars";
                } else {
                    $mes = "March";
                }
            } elseif (strpos($fecha, "April") !== false) {
                if ($request["usuario"]["idioma_predeterminado"] == 'fr') {
                    $mes = "Avril";
                } else {
                    $mes = "April";
                }
            } elseif (strpos($fecha, "May") !== false) {
                if ($request["usuario"]["idioma_predeterminado"] == 'fr') {
                    $mes = "Mai";
                } else {
                    $mes = "May";
                }
            } elseif (strpos($fecha, "June") !== false) {
                if ($request["usuario"]["idioma_predeterminado"] == 'fr') {
                    $mes = "Juin";
                } else {
                    $mes = "June";
                }
            } elseif (strpos($fecha, "July") !== false) {
                if ($request["usuario"]["idioma_predeterminado"] == 'fr') {
                    $mes = "Juillet";
                } else {
                    $mes = "July";
                }
            } elseif (strpos($fecha, "August") !== false) {
                if ($request["usuario"]["idioma_predeterminado"] == 'fr') {
                    $mes = "Août";
                } else {
                    $mes = "August";
                }
            } elseif (strpos($fecha, "September") !== false) {
                if ($request["usuario"]["idioma_predeterminado"] == 'fr') {
                    $mes = "Septembre";
                } else {
                    $mes = "September";
                }
            } elseif (strpos($fecha, "October") !== false) {
                if ($request["usuario"]["idioma_predeterminado"] == 'fr') {
                    $mes = "Octobre";
                } else {
                    $mes = "October";
                }
            } elseif (strpos($fecha, "November") !== false) {
                if ($request["usuario"]["idioma_predeterminado"] == 'fr') {
                    $mes = "Novembre";
                } else {
                    $mes = "November";
                }
            } else {
                if ($request["usuario"]["idioma_predeterminado"] == 'fr') {
                    $mes = "Décembre";
                } else {
                    $mes = "December";
                }
            }


            $arr = explode(" ", $fecha);
            $this->MultiCell(100, 8, utf8_decode($dia) . " " . substr($arr[1], 0, -2) . " " . utf8_decode($mes), 0, 'L', 0);
            $this->SetFont('Arial', '', 14);
            $this->SetTextColor(92, 92, 92);
            $this->setXY(108, $y);
            $this->MultiCell(100, 8, utf8_decode($elemento["cantidad"]), 0, 'L', 0);
            $y = $y + 8;


            // control para cambiar de pagina

            if ($y > 275) {
                $this->SetFont('Arial', 'B', 14);
                $this->SetTextColor(155, 155, 155); //gris oscuro
                $this->setXY(188, 275);
                $this->MultiCell(100, 20, $contadorPagina, 0, 'L', 0);

                $contadorPagina++;

                parent::AddPage();
                $y = 10;
                $this->setSourceFile(path_view('templates/pdf/template_capsula_blanco.pdf'));
                $tplIdx = $this->importPage(1);
                $this->useTemplate($tplIdx, 0, 0);
            }
        }






        $this->SetFont('Arial', 'B', 14);
        $this->SetTextColor(155, 155, 155); //gris oscuro
        $this->setXY(188, 275);
        $this->MultiCell(100, 20, $contadorPagina, 0, 'L', 0);


//        if (count($preguntasAbiertas) > 0) {
//            if ($request["banderaPregCerr"] == '1') {
//                $contadorPagina++;
//                parent::AddPage();
//
//                $this->SetFont('Arial', 'B', 14);
//                $this->SetTextColor(155, 155, 155); //gris oscuro
//                $this->setXY(188, 270);
//                $this->MultiCell(100, 20, $contadorPagina, 0, 'L', 0);
//
//                $y = 10;
//                $this->setSourceFile(path_view('templates/pdf/template_capsula_blanco.pdf'));
//                $tplIdx = $this->importPage(1);
//                $this->useTemplate($tplIdx, 0, 0);
//                $pag++;
//            } else {
//                $y = 110;
//            }
//        }
    }

    function Circle($x, $y, $r, $style = 'D') {
        $this->Ellipse($x, $y, $r, $r, $style);
    }

    function Ellipse($x, $y, $rx, $ry, $style = 'D') {
        if ($style == 'F')
            $op = 'f';
        elseif ($style == 'FD' || $style == 'DF')
            $op = 'B';
        else
            $op = 'S';
        $lx = 4 / 3 * (M_SQRT2 - 1) * $rx;
        $ly = 4 / 3 * (M_SQRT2 - 1) * $ry;
        $k = $this->k;
        $h = $this->h;
        $this->_out(sprintf('%.2F %.2F m %.2F %.2F %.2F %.2F %.2F %.2F c', ($x + $rx) * $k, ($h - $y) * $k, ($x + $rx) * $k, ($h - ($y - $ly)) * $k, ($x + $lx) * $k, ($h - ($y - $ry)) * $k, $x * $k, ($h - ($y - $ry)) * $k));
        $this->_out(sprintf('%.2F %.2F %.2F %.2F %.2F %.2F c', ($x - $lx) * $k, ($h - ($y - $ry)) * $k, ($x - $rx) * $k, ($h - ($y - $ly)) * $k, ($x - $rx) * $k, ($h - $y) * $k));
        $this->_out(sprintf('%.2F %.2F %.2F %.2F %.2F %.2F c', ($x - $rx) * $k, ($h - ($y + $ly)) * $k, ($x - $lx) * $k, ($h - ($y + $ry)) * $k, $x * $k, ($h - ($y + $ry)) * $k));
        $this->_out(sprintf('%.2F %.2F %.2F %.2F %.2F %.2F c %s', ($x + $lx) * $k, ($h - ($y + $ry)) * $k, ($x + $rx) * $k, ($h - ($y + $ly)) * $k, ($x + $rx) * $k, ($h - $y) * $k, $op));
    }

}

?>