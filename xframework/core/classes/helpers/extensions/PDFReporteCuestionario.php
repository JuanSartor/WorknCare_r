<?php

require_once("JeyReport.php");

class PDFReporteCuestionario extends JeyReport {

    private $y_ini = 10;

    function __construct() {
        parent::__construct('P', 'mm', 'a4');
        $this->SetMargins(10, 10);
        $this->SetAutoPageBreak(true, 0);
        $this->AliasNbPages("{totalPages}");
    }

    public function getPDF($request, $diccionarioIdPreg, $preguntasAbiertas, $file = NULL) {
        ob_start();

        $this->SetDisplayMode("real");

        $this->doPDF($request, $diccionarioIdPreg, $preguntasAbiertas);

        if (is_null($file)) {
            $this->Output("résultats-questionnaire.pdf", "I");
        } else {
            @$this->Output($file, "F");
        }
        ob_end_flush();
    }

    public function doPDF($request, $diccionarioIdPreg, $preguntasAbiertas) {
        $this->ancho_escritura = 190;
        $this->draw = "invitacion";

//Inicialmente dibujo la carátula
        $this->AddPageMio($request, $diccionarioIdPreg, $preguntasAbiertas);
    }

    /**
     * Agrega una página, le dibuja el header y el TAB correspondiente
     */
    public function AddPageMio($request, $diccionarioIdPreg, $preguntasAbiertas) {

        parent::AddPage();



//$this->draw contendrá cual de los paginas se va a dibujar en el PDF
        switch ($this->draw) {
            case "invitacion":
                $this->drawInvitacion($request, $diccionarioIdPreg, $preguntasAbiertas);
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

        $this->setSourceFile(path_view('templates/pdf/template_cuestionario_1_blanco.pdf'));
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
    public function drawInvitacion($request, $diccionarioIdPreg, $preguntasAbiertas) {

// qudeaste aca tenes el diccionario ya todo ahora tenes q hacer un for recorrer y hacer la parte 
// del pdf fijate que ya pusiste una pregunta abajo

        $cantPaginas = intdiv($request["cantidadPreguntas"], 2) + 1;
        $rtaspixel = $request["cantRtasAbiertas"] * 25;
        $prepixel = $request["cantPreguntasAbiertas"] * 15;
//        print($rtaspixel);
//        print($prepixel);
//        die();
        if ($prepixel > 0 && $rtaspixel > 0 && $request["banderaPregCerr"] == '1') {
            $cantPaginas = $cantPaginas + intdiv($rtaspixel + $prepixel, 270) + 1;
        }
        if ($prepixel > 0 && $rtaspixel > 0 && $request["banderaPregCerr"] != '1') {
            $cantPaginas = $cantPaginas + intdiv($rtaspixel + $prepixel, 270) + 1;
        }
        $pag = 1;
        $this->template = "invitacion";
        $this->getTemplate();

        $this->SetFont('Arial', '', 12);
        $this->SetTextColor(0, 0, 0); //negro
        $this->setXY(15, 35);
        if ($request["usuario"]["idioma_predeterminado"] == 'fr') {
            $this->MultiCell(100, 20, utf8_decode($request["fechaEmision"]["texto_fr"]), 0, 'L', 0);
        } else {
            $this->MultiCell(100, 20, utf8_decode($request["fechaEmision"]["texto_en"]), 0, 'L', 0);
        }

        $this->SetFont('Arial', '', 12);
        $this->SetTextColor(0, 0, 0); //negro
        $this->setXY(57, 35);
        $this->MultiCell(50, 20, date("d/m/Y", strtotime(date("Ymd"))), 0, 'L', 0);

        $this->SetFont('Arial', '', 12);
        $this->SetTextColor(0, 0, 0); //negro
        $this->setXY(15, 41);
        if ($request["usuario"]["idioma_predeterminado"] == 'fr') {
            $this->MultiCell(100, 20, utf8_decode($request["fechaFin"]["texto_fr"]), 0, 'L', 0);
        } else {
            $this->MultiCell(100, 20, utf8_decode($request["fechaFin"]["texto_en"]), 0, 'L', 0);
        }
        $this->SetFont('Arial', '', 12);
        $this->SetTextColor(0, 0, 0); //negro
        $this->setXY(57, 41);
        $this->MultiCell(50, 20, date("d/m/Y", strtotime($request["fecha_fin"])), 0, 'L', 0);

//$idempresa = $empresa["idempresa"];
// $this->Image(path_files("temp/qr_invitacion/$idempresa.png"), $x - 5, $y - 64, 40, 40);
//   $this->Image(path_themes("imgs/header-cuestionario.jpg"), $x - 5, $y - 64, 180, 40);
        $this->SetFont('Arial', 'B', 12);
        $this->SetTextColor(0, 0, 0); //negro
        $this->setXY(15, 50);
        if ($request["usuario"]["idioma_predeterminado"] == 'fr') {
            $this->MultiCell(100, 20, utf8_decode($request["titulo"]), 0, 'L', 0);
        } else {
            $this->MultiCell(100, 20, utf8_decode($request["titulo_en"]), 0, 'L', 0);
        }

        $this->SetFont('Arial', '', 12);
        $this->SetTextColor(237, 121, 158); //rosa
        $this->setXY(15, 60);
        if ($request["usuario"]["idioma_predeterminado"] == 'fr') {
            $this->MultiCell(100, 20, utf8_decode($request["cantPreguntasTotales"] . " " . $request["preguntas"]["texto_fr"]), 0, 'L', 0);
        } else {
            $this->MultiCell(100, 20, utf8_decode($request["cantPreguntasTotales"] . " " . $request["preguntas"]["texto_en"]), 0, 'L', 0);
        }

        $this->SetFont('Arial', '', 12);
        $this->SetTextColor(0, 0, 0); //rosa
        $this->setXY(15, 67);
        if ($request["usuario"]["idioma_predeterminado"] == 'fr') {
            $this->MultiCell(100, 20, utf8_decode($request["cantReaspuestas"] . " " . $request["preguntas_completas"]["texto_fr"]), 0, 'L', 0);
        } else {
            $this->MultiCell(100, 20, utf8_decode($request["cantReaspuestas"] . " " . $request["preguntas_completas"]["texto_en"]), 0, 'L', 0);
        }


//        $this->SetFont('Arial', 'B', 14);
//        $this->SetTextColor(155, 155, 155); //gris oscuro
//        $this->setXY(15, 90);
//        $this->MultiCell(100, 20, utf8_decode("Détails"), 0, 'L', 0);


        $contadorPagina = 1;


        $y = 85;
        $cantElementDic = count($diccionarioIdPreg);
        $cont = 1;


        $this->SetFont('Arial', 'B', 14);
        $this->SetTextColor(155, 155, 155); //gris oscuro
        $this->setXY(188, 270);
        $this->MultiCell(100, 20, $contadorPagina, 0, 'L', 0);


        if ($request["banderaPregCerr"] == '1') {
            foreach ($diccionarioIdPreg as $rtaPregunta) {
                $yRta = $y + 5;

                /*   $this->SetXY(12, $y);          // Primero establece Donde estará la esquina superior izquierda donde estará tu celda
                  $this->SetFont('Arial', 'B', 11);
                  // Establece el color del texto (en este caso es blanco)
                  $this->SetFillColor(255, 255, 255); // establece el color del fondo de la celda (en este caso es blanco
                  $this->Cell(190, 100, '', 0, 0, 'L', True); // en orden lo que informan estos parametros es:
                 */
                $this->SetTextColor(237, 121, 158);
                $this->SetXY(15, $y + 2);
                $this->SetFont('Arial', '', 12);
                $this->MultiCell(185, 8, utf8_decode($rtaPregunta["pregunta"]), 0, 'L', False);

// seccion con que dibujo las barras de porcentaje 
                $resulParc1 = (100 * $rtaPregunta[1]) / $request["cantReaspuestas"];
                $ancho1 = (120 * $resulParc1) / 100;
                $this->SetFont('Arial', '', 10);
                $this->SetTextColor(0, 0, 0);
                $this->SetXY(15, $yRta);
                if ($request["usuario"]["idioma_predeterminado"] == 'fr') {
                    $this->Cell(190, 20, utf8_decode($request["6"]["texto_fr"]), 0, 0, 'L', False);
                } else {
                    $this->Cell(190, 20, utf8_decode($request["6"]["texto_en"]), 0, 0, 'L', False);
                }
                $this->SetXY(125, $yRta + 2);
                $this->SetFont('Arial', '', 10);
                $this->SetTextColor(155, 155, 155);
                if (!is_nan($resulParc1)) {
                    $this->Cell(190, 16, utf8_decode(round($resulParc1, 0) . "%"), 0, 0, 'L', False);
                } else {
                    $this->Cell(190, 16, utf8_decode("0%"), 0, 0, 'L', False);
                }
                $this->SetFillColor(234, 234, 234);
                $this->RoundedRect(15, $yRta + 12, 120, 4, 2, '1234', 'F');
                $this->SetFillColor(61, 185, 198);
                if ($ancho1 > 0) {
                    $this->RoundedRect(15, $yRta + 12, $ancho1, 4, 2, '1234', 'F');
                }

                $resulParc2 = (100 * $rtaPregunta[2]) / $request["cantReaspuestas"];
                $ancho2 = (120 * $resulParc2) / 100;
                $this->SetFont('Arial', '', 10);
                $this->SetTextColor(0, 0, 0);
                $this->SetXY(15, $yRta + 12);
                if ($request["usuario"]["idioma_predeterminado"] == 'fr') {
                    $this->Cell(190, 20, utf8_decode($request["7"]["texto_fr"]), 0, 0, 'L', False);
                } else {
                    $this->Cell(190, 20, utf8_decode($request["7"]["texto_en"]), 0, 0, 'L', False);
                }
                $this->SetXY(125, $yRta + 11);
                $this->SetFont('Arial', '', 10);
                $this->SetTextColor(155, 155, 155);
                if (!is_nan($resulParc2)) {
                    $this->Cell(190, 22, utf8_decode(round($resulParc2, 0) . "%"), 0, 0, 'L', False);
                } else {
                    $this->Cell(190, 22, utf8_decode("0%"), 0, 0, 'L', False);
                }
                $this->SetFillColor(234, 234, 234);
                $this->RoundedRect(15, $yRta + 24, 120, 4, 2, '1234', 'F');
                $this->SetFillColor(61, 185, 198);
                if ($ancho2 > 0) {
                    $this->RoundedRect(15, $yRta + 24, $ancho2, 4, 2, '1234', 'F');
                }


                $resulParc3 = (100 * $rtaPregunta[3]) / $request["cantReaspuestas"];
                $ancho3 = (120 * $resulParc3) / 100;
                $this->SetFont('Arial', '', 10);
                $this->SetTextColor(0, 0, 0);
                $this->SetXY(15, $yRta + 24);
                if ($request["usuario"]["idioma_predeterminado"] == 'fr') {
                    $this->Cell(190, 20, utf8_decode($request["8"]["texto_fr"]), 0, 0, 'L', False);
                } else {
                    $this->Cell(190, 20, utf8_decode($request["8"]["texto_en"]), 0, 0, 'L', False);
                }
                $this->SetXY(125, $yRta + 23);
                $this->SetFont('Arial', '', 10);
                $this->SetTextColor(155, 155, 155);
                if (!is_nan($resulParc3)) {
                    $this->Cell(190, 22, utf8_decode(round($resulParc3, 0) . "%"), 0, 0, 'L', False);
                } else {
                    $this->Cell(190, 22, utf8_decode("0%"), 0, 0, 'L', False);
                }
                $this->SetFillColor(234, 234, 234);
                $this->RoundedRect(15, $yRta + 36, 120, 4, 2, '1234', 'F');
                $this->SetFillColor(61, 185, 198);
                if ($ancho3 > 0) {
                    $this->RoundedRect(15, $yRta + 36, $ancho3, 4, 2, '1234', 'F');
                }


                $resulParc4 = (100 * $rtaPregunta[4]) / $request["cantReaspuestas"];
                $ancho4 = (120 * $resulParc4) / 100;
                $this->SetFont('Arial', '', 10);
                $this->SetTextColor(0, 0, 0);
                $this->SetXY(15, $yRta + 36);
                if ($request["usuario"]["idioma_predeterminado"] == 'fr') {
                    $this->Cell(190, 20, utf8_decode($request["9"]["texto_fr"]), 0, 0, 'L', False);
                } else {
                    $this->Cell(190, 20, utf8_decode($request["9"]["texto_en"]), 0, 0, 'L', False);
                }
                $this->SetXY(125, $yRta + 47);
                $this->SetFont('Arial', '', 10);
                $this->SetTextColor(155, 155, 155);
                if (!is_nan($resulParc4)) {
                    $this->Cell(190, -2, utf8_decode(round($resulParc4, 0) . "%"), 0, 0, 'L', False);
                } else {
                    $this->Cell(190, -2, utf8_decode("0%"), 0, 0, 'L', False);
                }
                $this->SetFillColor(234, 234, 234);
                $this->RoundedRect(15, $yRta + 48, 120, 4, 2, '1234', 'F');
                $this->SetFillColor(61, 185, 198);
                if ($ancho4 > 0) {
                    $this->RoundedRect(15, $yRta + 48, $ancho4, 4, 2, '1234', 'F');
                }

                $resulParc1 = 0;
                $resulParc2 = 0;
                $resulParc3 = 0;
                $resulParc4 = 0;
                $ancho4 = 0;
                $ancho3 = 0;
                $ancho2 = 0;
                $ancho1 = 0;

//////////////////////////////////////////////////////

                $y = $y + 65;

                if ($cont < $cantElementDic) {
                    if (( $y + 60) >= 295) {
                        /* $this->SetFont('Arial', 'B', 14);
                          $this->SetTextColor(155, 155, 155); //gris oscuro
                          $this->setXY(188, 270);
                          $this->MultiCell(100, 20, $pag . "/" . $cantPaginas, 0, 'L', 0); */
                        $contadorPagina++;
                        $pag++;
                        parent::AddPage();
                        $this->SetFont('Arial', 'B', 14);
                        $this->SetTextColor(155, 155, 155); //gris oscuro
                        $this->setXY(188, 270);
                        $this->MultiCell(100, 20, $contadorPagina, 0, 'L', 0);

                        $y = 10;
                        $this->setSourceFile(path_view('templates/pdf/template_cuestionario_blanco.pdf'));
                        $tplIdx = $this->importPage(1);
                        $this->useTemplate($tplIdx, 0, 0);
                        $this->SetTextColor(0, 0, 0);
                    }
                    /* else {
                      $this->SetFont('Arial', 'B', 14);
                      $this->SetTextColor(155, 155, 155); //gris oscuro
                      $this->setXY(188, 270);
                      $this->MultiCell(100, 20, $pag . "/" . $cantPaginas, 0, 'L', 0);
                      $y = $y + 5;
                      } */
                    $cont++;
                }
                /*  else {
                  $this->SetFont('Arial', 'B', 14);
                  $this->SetTextColor(155, 155, 155); //gris oscuro
                  $this->setXY(188, 270);
                  $this->MultiCell(100, 20, $pag . "/" . $cantPaginas, 0, 'L', 0);
                  $y = $y + 5;
                  } */
            }
        }

////
// aca arranco la parte para graficar las preguntas y respuestas abiertas
        if (count($preguntasAbiertas) > 0) {
            if ($request["banderaPregCerr"] == '1') {
                $contadorPagina++;
                parent::AddPage();

                $this->SetFont('Arial', 'B', 14);
                $this->SetTextColor(155, 155, 155); //gris oscuro
                $this->setXY(188, 270);
                $this->MultiCell(100, 20, $contadorPagina, 0, 'L', 0);

                $y = 10;
                $this->setSourceFile(path_view('templates/pdf/template_cuestionario_blanco.pdf'));
                $tplIdx = $this->importPage(1);
                $this->useTemplate($tplIdx, 0, 0);
                $pag++;
            } else {
                $y = 110;
            }
//        print_r($preguntasAbiertas);
//        die();
            $totalPre = count($preguntasAbiertas);
            $t = 1;
            $band = 0;
            foreach ($preguntasAbiertas as $preg) {
                if ($t == $totalPre) {
                    $band = 1;
                }

                $cantRtas = count($preg["respuestas"]);
//                if ($request["cuestAnonimo"] == '1') {
//                    $largo = ($request["cantRtasAbiertas"] / $request["cantPreguntasAbiertas"]) * 16;
//                } else {
//                    $largo = ($request["cantRtasAbiertas"] / $request["cantPreguntasAbiertas"]) * 23;
//                }
                //   $this->SetXY(12, $y);          // Primero establece Donde estará la esquina superior izquierda donde estará tu celda
                $this->SetFont('Arial', 'B', 11);
                $this->SetTextColor(237, 121, 158);  // Establece el color del texto (en este caso es blanco)
                // $this->SetFillColor(255, 255, 255); // establece el color del fondo de la celda (en este caso es blanco
                //  $this->Cell(190, 15, '', 0, 0, 'L', True); // en orden lo que informan estos parametros es:
                $this->SetXY(15, $y + 2);
                $this->MultiCell(185, 8, utf8_decode($preg["pregunta"]), 0, 'L', False);
                $this->Line(12, $y + 10, 196, $y + 10);
                $this->Line(196, $y + 10, 196, $y + 16);
                $this->Line(12, $y + 10, 12, $y + 16);
                $this->SetXY(15, $y + 9);
                $this->SetTextColor(117, 113, 113);
                if ($request["usuario"]["idioma_predeterminado"] == 'fr') {
                    $this->MultiCell(185, 8, utf8_decode($request["10"]["texto_fr"]), 0, 'L', False);
                } else {
                    $this->MultiCell(185, 8, utf8_decode($request["10"]["texto_en"]), 0, 'L', False);
                }
                if ($request["cuestAnonimo"] != '1') {
                    $this->Line(95, $y + 10, 95, $y + 16);
                    $this->SetXY(98, $y + 9);
                    if ($request["usuario"]["idioma_predeterminado"] == 'fr') {
                        $this->MultiCell(185, 8, utf8_decode($request["11"]["texto_fr"]), 0, 'L', False);
                    } else {
                        $this->MultiCell(185, 8, utf8_decode($request["11"]["texto_en"]), 0, 'L', False);
                    }
                    $this->Line(130, $y + 10, 130, $y + 16);
                    $this->SetXY(134, $y + 9);
                    if ($request["usuario"]["idioma_predeterminado"] == 'fr') {
                        $this->MultiCell(185, 8, utf8_decode($request["12"]["texto_r"]), 0, 'L', False);
                    } else {
                        $this->MultiCell(185, 8, utf8_decode($request["12"]["texto_en"]), 0, 'L', False);
                    }
                    $this->Line(160, $y + 10, 160, $y + 16);
                    $this->SetXY(164, $y + 9);
                    if ($request["usuario"]["idioma_predeterminado"] == 'fr') {
                        $this->MultiCell(185, 8, utf8_decode($request["13"]["texto_fr"]), 0, 'L', False);
                    } else {
                        $this->MultiCell(185, 8, utf8_decode($request["13"]["texto_en"]), 0, 'L', False);
                    }
                }


                $y = $y + 15;
                foreach ($preg["respuestas"] as $rta) {

                    //   $this->SetXY(12, $y);          // Primero establece Donde estará la esquina superior izquierda donde estará tu celda
                    $this->SetFont('Arial', '', 10);
                    $this->SetTextColor(117, 113, 113);  // Establece el color del texto (en este caso es blanco)
                    //  $this->SetFillColor(255, 255, 255); // establece el color del fondo de la celda (en este caso es blanco
                    //  $this->Cell(190, 15, '', 0, 0, 'L', True); // en orden lo que informan estos parametros es:
                    $this->Line(12, $y + 1, 196, $y + 1);
                    $this->Line(12, $y + 1, 12, $y + 11);
                    $this->Line(196, $y + 1, 196, $y + 11);
                    $this->SetXY(12, $y + 2);
                    $this->MultiCell(85, 4, utf8_decode($rta["respuesta"]), 0, 'L', False);
                    $y = $y + 10;

                    if ($request["cuestAnonimo"] != '1') {
                        $this->Line(95, $y - 9, 95, $y + 1);
                        $this->Line(130, $y - 9, 130, $y + 1);
                        $this->Line(160, $y - 9, 160, $y + 1);
                        $this->SetFont('Arial', '', 9);
                        $this->SetTextColor(117, 113, 113);
                        if ($rta["nombre"] != '' || $rta["apellido"] != '') {

                            $this->SetXY(95, $y - 7);
                            $this->MultiCell(36, 4, utf8_decode($rta["nombre"]), 0, 'L', False);
                            $this->SetXY(130, $y - 7);
                            $this->MultiCell(32, 4, utf8_decode($rta["apellido"]), 0, 'L', False);
                            $this->SetXY(160, $y - 7);
                            $this->MultiCell(36, 4, utf8_decode($rta["email"]), 0, 'L', False);
                        } else {
                            $this->SetXY(160, $y - 7);
                            $this->MultiCell(36, 4, utf8_decode($rta["email"]), 0, 'L', False);
                        }
                    }
                    if ($y > 280) {
                        $this->Line(12, $y + 1, 196, $y + 1);
                        $contadorPagina++;

                        $this->SetFont('Arial', 'B', 14);
                        $this->SetTextColor(155, 155, 155); //gris oscuro
                        $this->setXY(188, 270);
                        $this->MultiCell(100, 20, $contadorPagina, 0, 'L', 0);

                        parent::AddPage();
                        $y = 0;
                        $this->setSourceFile(path_view('templates/pdf/template_cuestionario_blanco.pdf'));
                        $tplIdxa = $this->importPage(1);
                        $this->useTemplate($tplIdxa, 0, 0);
                    }
                }
                $this->Line(12, $y + 1, 196, $y + 1);
                $y = $y + 20;
                if ($y > 290) {
                    $contadorPagina++;

                    $this->SetFont('Arial', 'B', 14);
                    $this->SetTextColor(155, 155, 155); //gris oscuro
                    $this->setXY(188, 270);
                    $this->MultiCell(100, 20, $contadorPagina, 0, 'L', 0);

                    parent::AddPage();
                    $y = 10;
                    $this->setSourceFile(path_view('templates/pdf/template_cuestionario_blanco.pdf'));
                    $tplIdxa = $this->importPage(1);
                    $this->useTemplate($tplIdxa, 0, 0);
                }

                $t++;
            }
        }
    }

    /**
     * 
     * @param type $x
     * @param type $y
     * @param type $w
     * @param type $h
     * @param type $r
     * @param type $corners
     * @param type $style
     * 
     *  funcion auxiliar que ocupo para dibujar la barra de porcentaje
     */
    function RoundedRect($x, $y, $w, $h, $r, $corners = '1234', $style = '') {
        $k = $this->k;
        $hp = $this->h;
        if ($style == 'F')
            $op = 'f';
        elseif ($style == 'FD' || $style == 'DF')
            $op = 'B';
        else
            $op = 'S';
        $MyArc = 4 / 3 * (sqrt(2) - 1);
        $this->_out(sprintf('%.2F %.2F m', ($x + $r) * $k, ($hp - $y) * $k));

        $xc = $x + $w - $r;
        $yc = $y + $r;
        $this->_out(sprintf('%.2F %.2F l', $xc * $k, ($hp - $y) * $k));
        if (strpos($corners, '2') === false)
            $this->_out(sprintf('%.2F %.2F l', ($x + $w) * $k, ($hp - $y) * $k));
        else
            $this->_Arc($xc + $r * $MyArc, $yc - $r, $xc + $r, $yc - $r * $MyArc, $xc + $r, $yc);

        $xc = $x + $w - $r;
        $yc = $y + $h - $r;
        $this->_out(sprintf('%.2F %.2F l', ($x + $w) * $k, ($hp - $yc) * $k));
        if (strpos($corners, '3') === false)
            $this->_out(sprintf('%.2F %.2F l', ($x + $w) * $k, ($hp - ($y + $h)) * $k));
        else
            $this->_Arc($xc + $r, $yc + $r * $MyArc, $xc + $r * $MyArc, $yc + $r, $xc, $yc + $r);

        $xc = $x + $r;
        $yc = $y + $h - $r;
        $this->_out(sprintf('%.2F %.2F l', $xc * $k, ($hp - ($y + $h)) * $k));
        if (strpos($corners, '4') === false)
            $this->_out(sprintf('%.2F %.2F l', ($x) * $k, ($hp - ($y + $h)) * $k));
        else
            $this->_Arc($xc - $r * $MyArc, $yc + $r, $xc - $r, $yc + $r * $MyArc, $xc - $r, $yc);

        $xc = $x + $r;
        $yc = $y + $r;
        $this->_out(sprintf('%.2F %.2F l', ($x) * $k, ($hp - $yc) * $k));
        if (strpos($corners, '1') === false) {
            $this->_out(sprintf('%.2F %.2F l', ($x) * $k, ($hp - $y) * $k));
            $this->_out(sprintf('%.2F %.2F l', ($x + $r) * $k, ($hp - $y) * $k));
        } else
            $this->_Arc($xc - $r, $yc - $r * $MyArc, $xc - $r * $MyArc, $yc - $r, $xc, $yc - $r);
        $this->_out($op);
    }

    function _Arc($x1, $y1, $x2, $y2, $x3, $y3) {
        $h = $this->h;
        $this->_out(sprintf('%.2F %.2F %.2F %.2F %.2F %.2F c ', $x1 * $this->k, ($h - $y1) * $this->k, $x2 * $this->k, ($h - $y2) * $this->k, $x3 * $this->k, ($h - $y3) * $this->k));
    }

}

?>