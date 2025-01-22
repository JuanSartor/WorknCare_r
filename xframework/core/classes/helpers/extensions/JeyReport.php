<?php

require_once(path_libs('libs_php/fpdf/fpdf.php'));
require_once(path_libs("libs_php/fpdi/fpdi.php"));
require_once(path_libs("libs_php/fpdi/fpdf_tpl.php"));

class JeyReport extends FPDI {

    public $page_number = 0;
    public $data = null;
    public $template = "";
    //Variable que se va a usar para mantener la iteración en los datos cuando se cambie de páginas
    public $iteracion = 0;
    public $draw = "";
    public $ancho_escritura = 190;
    public $titulo = "";
    public $debug_r = false;

    /**
     * Método que obtiene la cantidad de líneas.. Utilizado para las multiceldas
     * @param type $w
     * @param type $txt
     * @return int
     */
    public function NbLines($w, $txt) {



        $cw = &$this->CurrentFont['cw'];


        if ($w == 0)
            $w = $this->w - $this->rMargin - $this->x;
        $wmax = ($w - 2 * $this->cMargin) * 1000 / $this->FontSize;

        $s = str_replace("\r", '', $txt);
        $nb = strlen($s);
        if ($nb > 0 && $s[$nb - 1] == "\n")
            $nb--;
        $sep = -1;
        $i = 0;
        $j = 0;
        $l = 0;
        $nl = 1;
        while ($i < $nb) {
            $c = $s[$i];
            if ($c == "\n") {
                $i++;
                $sep = -1;
                $j = $i;
                $l = 0;
                $nl++;
                continue;
            }
            if ($c == ' ')
                $sep = $i;
            $l += $cw[$c];
            if ($l > $wmax) {
                if ($sep == -1) {
                    if ($i == $j)
                        $i++;
                } else
                    $i = $sep + 1;
                $sep = -1;
                $j = $i;
                $l = 0;
                $nl++;
            } else
                $i++;
        }



        return $nl;
    }

    /**
     * Método que realiza el dibujo de una tabla
     * @param type $array_cabecera : array("column1", "column2" "column3" "column4", ...)
     * @param type $array_datos : array(0 => array("dato1", "dato2" "dato3" "dato4", ...))
     * @param int $x
     * @param type $y
     * @param int $w ancho de la tabla
     * @return type
     */
    public function drawDinamicTable($array_cabecera, $array_datos, $x = 16, $y = 30, $h = 6, $w = NULL, $format) {

        $is_iteracion_negativa = false;

        if (is_null($w)) {
            $w = $this->ancho_escritura;
        }

        //Si la iteración es mayor a 0 tengo que agregar el título...
        if ($this->iteracion > 0 || $this->iteracion == -1) {

            if ($this->iteracion == -1) {
                $this->iteracion == 0;
                $is_iteracion_negativa = true;
            }

            parent::AddPage();

            //Agrego el header en caso de que tenga que agregar alguno
            $this->addHeaderMio();

            $this->addFooterMio();


            $this->template = "";
            $this->getTemplate();
            $x = 16;
            $y = 30;

            //Seteo el color de fondo de los Text
            $this->SetFillColor(219, 219, 219);

            /**
             * TÍTULO
             */
            $this->setXY($x, $y);
            $this->SetFont('Arial', 'B', 14);
            $this->MultiCell($w, 13, utf8_decode($this->titulo), 0, 'C', 0);

            $y += 20;
        }




        $ancho_columnas = $w / count($array_cabecera);

        $this->SetFillColor(235, 235, 235);

        /**
         * Dibujo Fila cabecera
         */
        foreach ($array_cabecera as $key => $cabecera) {
            $this->setXY($x + $ancho_columnas * $key, $y);

            /**
             * Pregunto Si se puede crear la tabla en esta hoja
             */
            $this->SetFont('Arial', '', 9);
            $mayor_numero_lineas = $this->getMayorNumeroLineas($array_datos[0], $ancho_columnas);

            if (($y + $mayor_numero_lineas * $h) > ($this->h - 20)) {

                //Agrego la página siguiente 
                $this->page_number++;
                $this->iteracion = -1;


                //Si ya viene de una iteración negativa quiere decir que no puede seguir escribiendo porque una fila de la tabla no entra en una hoja
                if (!$is_iteracion_negativa) {
                    $y = $this->drawDinamicTable($array_cabecera, $array_datos, $x, $y, $h, $w);
                }
                return $y;
            }

            $this->SetFont('Arial', 'B', 9);
            $this->MultiCell($ancho_columnas, $h + 5, utf8_decode($cabecera[0]), 1, 'C', 1);
        }

        $y += $h + 5;



        $this->SetFillColor(255, 255, 255);


        for ($i = $this->iteracion; $i < count($array_datos); $i++) {
            $this->SetFont('Arial', '', 9);

            if ($this->debug_r) {
                echo "$this->iteracion<pre>";
                print_r($array_datos[$i]);
                echo '</pre>';
            }
            $mayor_numero_lineas = $this->getMayorNumeroLineas($array_datos[$i], $ancho_columnas);


            if (($y + $mayor_numero_lineas * $h) > ($this->h - 20)) {

                //Agrego la página siguiente 
                $this->page_number++;
                $this->iteracion = $i == 0 ? -1 : $i;
                $y = $this->drawDinamicTable($array_cabecera, $array_datos, $x, $y, $h, $w);
                return $y;
            }


            $iteracion_array_datos = 0;
            foreach ($array_datos[$i] as $key => $value) {
                $this->setXY($x + $ancho_columnas * $iteracion_array_datos, $y);
                $this->SetFont('Arial', '', 9);
                $cantidad_lineas = $this->NbLines($ancho_columnas, utf8_decode($value));

                //Obtengo la alineación
                $alineacion = isset($array_cabecera[$key][1]) ? $array_cabecera[$key][1] : "L";

                $this->MultiCell($ancho_columnas, $h * ($mayor_numero_lineas == $cantidad_lineas ? 1 : $mayor_numero_lineas / $cantidad_lineas), utf8_decode($value), 1, $alineacion, 1);
                $iteracion_array_datos ++;
            }



            $y += $mayor_numero_lineas * $h;
        }


        $this->iteracion = 0;
        return $y;
    }

    /**
     * Método que realiza el dibujo de una tabla
     * @param type $array_cabecera : array("column1", "column2" "column3" "column4", ...)
     * @param type $array_datos : array(0 => array("dato1", "dato2" "dato3" "dato4", ...))
     * @param int $x
     * @param type $y
     * @param int $w ancho de la tabla
     * @return type
     */
    public function drawDinamicTableFormat($array_cabecera, $array_datos, $x = 16, $y = 30, $h = 6, $w = NULL, $format, $ancho_columnas_array = NULL) {

        $is_iteracion_negativa = false;
        $this->SetDrawColor(142, 153, 149); //gris

        if (is_null($w)) {
            $w = $this->ancho_escritura;
        }

        //Si la iteración es mayor a 0 tengo que agregar el título...
        if ($this->iteracion > 0 || $this->iteracion == -1) {

            if ($this->iteracion == -1) {
                $this->iteracion == 0;
                $is_iteracion_negativa = true;
            }

            parent::AddPage();

            //Agrego el header en caso de que tenga que agregar alguno
            $this->addHeaderMio();

            $this->addFooterMio();


            $this->template = "";
            $this->getTemplate();
            $x = 10;
            $y = 20;

            //Seteo el color de fondo de los Text
            $this->SetFillColor(255, 255, 255);

            /**
             * TÍTULO
             */
            $this->setXY($x, $y);
            $this->SetFont('Arial', 'B', 14);
            $this->MultiCell($w, 13, utf8_decode($this->titulo), 0, 'C', 0);

            $y += 20;
        }




        $ancho = $w / count($array_cabecera);

        $this->SetFillColor(255, 255, 255);

        /**
         * Dibujo Fila cabecera
         */
        $desplazamiento = 0;
        foreach ($array_cabecera as $key => $cabecera) {

            if (is_null($ancho_columnas_array)) {
                $ancho_columnas = $ancho;
            } else {
                $ancho_columnas = $ancho_columnas_array[$key];
            }

            if ($key == 0) {
                
            } else {
                
            }
            if (is_null($ancho_columnas_array)) {
                $this->setXY($x + $ancho_columnas * $key, $y);
            } else {
                $this->setXY($x + $desplazamiento, $y);
                $desplazamiento += $ancho_columnas;
            }


            /**
             * Pregunto Si se puede crear la tabla en esta hoja
             */
            $this->SetFont('Arial', '', 9);
            $mayor_numero_lineas = $this->getMayorNumeroLineas($array_datos[0], $ancho_columnas);

            if (($y + $mayor_numero_lineas * $h) > ($this->h - 20)) {

                //Agrego la página siguiente 
                $this->page_number++;
                $this->iteracion = -1;


                //Si ya viene de una iteración negativa quiere decir que no puede seguir escribiendo porque una fila de la tabla no entra en una hoja
                if (!$is_iteracion_negativa) {
                    $y = $this->drawDinamicTableFormat($array_cabecera, $array_datos, $x, $y, $h, $w, $format, $ancho_columnas_array);
                }
                return $y;
            }

            $this->SetFont('Arial', 'B', 8);
            $this->SetTextColor(0, 0, 0);

            $this->MultiCell($ancho_columnas, $h, utf8_decode($cabecera[0]), 1, 'L', 1);
        }

        $y += $h;



        $this->SetFillColor(255, 255, 255);


        for ($i = $this->iteracion; $i < count($array_datos); $i++) {


            $this->SetFont('Arial', '', 9);

            if ($this->debug_r) {
                echo "$this->iteracion<pre>";
                print_r($array_datos[$i]);
                echo '</pre>';
            }
           
            $mayor_numero_lineas = $this->getMayorNumeroLineas($array_datos[$i], $ancho_columnas,$ancho_columnas_array);

           

            if (($y + $mayor_numero_lineas * $h) > ($this->h - 20)) {

                //Agrego la página siguiente 
                $this->page_number++;
                $this->iteracion = $i == 0 ? -1 : $i;
                $y = $this->drawDinamicTableFormat($array_cabecera, $array_datos, $x, $y, $h, $w, $format, $ancho_columnas_array);
                return $y;
            }


            $iteracion_array_datos = 0;
            $desplazamiento = 0;
            foreach ($array_datos[$i] as $key => $value) {
                if (is_null($ancho_columnas_array)) {
                    $ancho_columnas = $ancho;
                } else {
                    $ancho_columnas = $ancho_columnas_array[$iteracion_array_datos];
                }
                if (is_null($ancho_columnas_array)) {
                    $this->setXY($x + $ancho_columnas * $iteracion_array_datos, $y);
                } else {
                    $this->setXY($x + $desplazamiento, $y);
                    $desplazamiento += $ancho_columnas;
                }


                $this->SetFont('Arial', '', 8);
                $this->SetTextColor(0, 0, 0);
                $cantidad_lineas = $this->NbLines($ancho_columnas, utf8_decode($value));
             
                //Obtengo la alineación
                $alineacion = isset($array_cabecera[$key][1]) ? $array_cabecera[$key][1] : "L";

                if ($key == "monto" && substr($value, 0, 1) == "-") {

                    $this->SetTextColor(232, 80, 80);
                } else {
                    $this->SetTextColor(0, 0, 0);
                }



                $this->MultiCell($ancho_columnas, $h * ($mayor_numero_lineas == $cantidad_lineas ? 1 : $mayor_numero_lineas / $cantidad_lineas), utf8_decode($value), '1', $alineacion, 1);

                $iteracion_array_datos ++;
            }



            $y += $mayor_numero_lineas * $h;
        }


        $this->iteracion = 0;
        return $y;
    }

    /**
     * Método que retorna el mayor número de líneas para los datos
     * @param type $datos
     * @param type $w
     * @return type
     */
    public function getMayorNumeroLineas($datos, $w, $ancho_columnas_array = null) {

        $numero_lineas = 1;
        foreach ($datos as $key => $dato) {
            if (is_null($ancho_columnas_array)) {
                $cant = $this->NbLines($w, utf8_decode($dato));
            } else {
                $cant = $this->NbLines($ancho_columnas_array[$key], utf8_decode($dato));
            }
          

            $numero_lineas = $cant > $numero_lineas ? $cant : $numero_lineas;
        }

        return $numero_lineas;
    }

    /**
     * 
     * @param type $x
     * @param type $y
     * @param type $string1
     * @param type $string2
     * @param type $w : Ancho del multiCell
     * @param type $h : Altura del multiCell
     * @param type $font1 : array con los valores de la fuente del $string1 => $font1 = array('Arial', '', 11);
     * @param type $font2 : array con los valores de la fuente del $string2 => $font2 = array('Arial', '', 11);
     * @return type: Retorna el $y en el que terminó de escribir
     */
    public function drawReglon($x, $y, $string1, $string2, $w, $h = 6, $font1 = null, $font2 = null, $fillcolor = [219, 235, 255]) {

        if (is_null($font1)) {
            $this->SetFont('Arial', 'B', 8);
        } else {
            $this->SetFont($font1[0], $font1[1], $font1[2]);
        }


        $align1 = isset($font1[3]) && $font1[3] != "" ? $font1[3] : 'L';
        $align2 = isset($font2[3]) && $font2[3] != "" ? $font2[3] : 'L';

        //Verifico cual de los dos reglones son los mayores
        $n_lineas1 = $this->NbLines($w + 1, utf8_decode($string1));
        $n_lineas2 = $this->NbLines($w + 1, utf8_decode($string2));
        $max = max($n_lineas1, $n_lineas2);


        if (($y + $max * $h) > ($this->h - 20)) {

            $this->page_number ++;
            parent::AddPage();

            //Agrego el header en caso de que tenga que agregar alguno
            $this->addHeaderMio();

            $this->addFooterMio();


            $this->template = "";
            $this->getTemplate();
            $y = 30;

            //Seteo el color de fondo de los Text
            $this->SetFillColor($fillcolor[0], $fillcolor[0], $fillcolor[0]);

            /**
             * TÍTULO
             */
            $this->setXY(16, $y);
            $this->SetFont('Arial', 'B', 16);
            $this->MultiCell($this->ancho_escritura, 13, utf8_decode($this->titulo), 0, 'C', 1);


            $y = $this->drawReglon($x, $y += 20, $string1, $string2, $w, $h, $font1, $font2);

            return $y;
        }

        //Color para el campo que es estático
        $this->SetFillColor($fillcolor[1], $fillcolor[1], $fillcolor[1]);

        if (is_null($font1)) {
            $this->SetFont('Arial', 'B', 8);
        } else {
            $this->SetFont($font1[0], $font1[1], $font1[2]);
        }


        //Campo nombre información
        $this->setXY($x, $y);
        $this->MultiCell($w, $h * ($max == $n_lineas1 ? 1 : $max), utf8_decode($string1), 1, $align1, 1);


        //Quito color para el campo que es información
        $this->SetFillColor($fillcolor[2], $fillcolor[2], $fillcolor[2]);
        if (is_null($font2)) {
            $this->SetFont('Arial', '', 9);
        } else {
            $this->SetFont($font2[0], $font2[1], $font2[2]);
        }
        //Campo información
        $this->setXY($x + $w, $y);
        $this->MultiCell($w, $h * ($max == $n_lineas2 ? 1 : $max), utf8_decode($string2), 1, $align2, 1);


        //Retorno la altura de abajo


        return $y + $h * $max;
    }

    /**
     * 
     * @param type $x
     * @param type $y
     * @param type $string1
     * @param type $string2
     * @param type $w : Ancho del multiCell
     * @param type $h : Altura del multiCell
     * @param type $font1 : array con los valores de la fuente del $string1 => $font1 = array('Arial', '', 11);
     * @param type $font2 : array con los valores de la fuente del $string2 => $font2 = array('Arial', '', 11);
     * @return type: Retorna el $y en el que terminó de escribir
     */
    public function drawReglon1_3($x, $y, $string1, $string2, $w, $h = 6, $font1 = null, $font2 = null, $fillcolor = [219, 235, 255]) {
        if (is_null($font1)) {
            $this->SetFont('Arial', 'B', 8);
        } else {
            $this->SetFont($font1[0], $font1[1], $font1[2]);
        }


        //Verifico cual de los dos reglones son los mayores
        $n_lineas1 = $this->NbLines($w + 1, utf8_decode($string1));
        $n_lineas2 = $this->NbLines($w + 1, utf8_decode($string2));
        $max = max($n_lineas1, $n_lineas2);

        if (($y + $max * $h) > ($this->h - 20)) {

            $this->page_number ++;
            parent::AddPage();

            //Agrego el header en caso de que tenga que agregar alguno
            $this->addHeaderMio();

            $this->addFooterMio();


            $this->template = "";
            $this->getTemplate();
            $y = 30;

            //Seteo el color de fondo de los Text
            $this->SetFillColor($fillcolor[0], $fillcolor[0], $fillcolor[0]);

            /**
             * TÍTULO
             */
            $this->setXY(16, $y);
            $this->SetFont('Arial', 'B', 16);
            $this->MultiCell($this->ancho_escritura, 13, utf8_decode($this->titulo), 0, 'C', 1);


            $y = $this->drawReglon($x, $y += 20, $string1, $string2, $w, $h, $font1, $font2);

            return $y;
        }

        //Color para el campo que es estático
        $this->SetFillColor($fillcolor[1], $fillcolor[1], $fillcolor[1]);

        if (is_null($font1)) {
            $this->SetFont('Arial', 'B', 8);
        } else {
            $this->SetFont($font1[0], $font1[1], $font1[2]);
        }
        //Campo nombre información
        $this->setXY($x, $y);
        $this->MultiCell($w / 4, $h * ($max == $n_lineas1 ? 1 : $max), utf8_decode($string1), 1, 'L', 1);


        //Quito color para el campo que es información
        $this->SetFillColor($fillcolor[2], $fillcolor[2], $fillcolor[2]);
        if (is_null($font2)) {
            $this->SetFont('Arial', '', 9);
        } else {
            $this->SetFont($font2[0], $font2[1], $font2[2]);
        }
        //Campo información
        $this->setXY($x + $w / 4, $y);
        $this->MultiCell(($w / 4) * 3, $h * ($max == $n_lineas2 ? 1 : $max), utf8_decode($string2), 1, 'L', 1);


        //Retorno la altura de abajo


        return $y + $h * $max;
    }

}
