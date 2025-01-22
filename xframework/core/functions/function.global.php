<?php

/**
 * 	function.global.php
 *
 * 	Funciones de uso Global 
 * 	
 * 	@author Sebastian Balestrini <sbalestrini@gmail.com>
 * 	@author Emanuel del Barco
 * 	    	
 * 	@version 1.0 
 *
 */
function get_combo_estados_turnos() {
    //%s as Combo_id , %s  as Combo_descripcion
    $combo = array();
    $combo["0"] = "Demandé";
    $combo["1"] = "Confirmé";
    $combo["3"] = "Décliné";
    return $combo;
}

function array_sub($arr) {
    if (!is_array($arr) || !count($arr)) {
        return false;
    } elseif (!count($arr)) {
        return $arr[0];
    } else {
        $base = array_shift($arr);
        foreach ($arr as $val)
            $base -= $val;
        return $base;
    }
}

/**
 * 	@author Sebastian Balestrini
 * 	@version 1.1
 * 	Dado un string lo convierte en una cadena SEO Friendly. Por defecto trunca en 255 caracteres
 *
 * 	@return string
 */
function str2seo($_string, $maxchars = 255) {

    //$_string = utf8_decode($_string);

    $cadena_final = ltrim(rtrim($_string));
    $cadena_final = strip_tags($_string);

    //fix 

    $cadena_final = mb_strtolower($cadena_final);
    //$cadena_final = strtolower($cadena_final);

    $cadena_final = str_replace(", ", "-", $cadena_final);
    $cadena_final = str_replace(": ", "-", $cadena_final);
    $cadena_final = str_replace(" - ", "-", $cadena_final);
    $cadena_final = str_replace(" ", "-", $cadena_final);
    $cadena_final = str_replace("  ", "-", $cadena_final);
    $cadena_final = str_replace(",", "-", $cadena_final);
    $cadena_final = str_replace("'", "", $cadena_final);
    $cadena_final = str_replace("\'", "", $cadena_final);
    $cadena_final = str_replace("\"", "", $cadena_final);
    $cadena_final = str_replace("/", "_", $cadena_final);
    $cadena_final = str_replace(";", "-", $cadena_final);
    $cadena_final = str_replace(":", "-", $cadena_final);
    $cadena_final = str_replace("º", "", $cadena_final);
    $cadena_final = str_replace("á", "a", $cadena_final);
    $cadena_final = str_replace("é", "e", $cadena_final);
    $cadena_final = str_replace("í", "i", $cadena_final);
    $cadena_final = str_replace("ó", "o", $cadena_final);
    $cadena_final = str_replace("ú", "u", $cadena_final);
    $cadena_final = str_replace("ä", "a", $cadena_final);
    $cadena_final = str_replace("ë", "e", $cadena_final);
    $cadena_final = str_replace("ï", "i", $cadena_final);
    $cadena_final = str_replace("ö", "o", $cadena_final);
    $cadena_final = str_replace("ü", "u", $cadena_final);
    $cadena_final = str_replace(".", "_", $cadena_final);
    $cadena_final = str_replace("!", "", $cadena_final);
    $cadena_final = str_replace("¡", "", $cadena_final);
    $cadena_final = str_replace("+", "", $cadena_final);
    $cadena_final = str_replace("?", "", $cadena_final);
    $cadena_final = str_replace("¿", "", $cadena_final);
    $cadena_final = str_replace("(", "", $cadena_final);
    $cadena_final = str_replace(")", "", $cadena_final);
    $cadena_final = str_replace("[", "", $cadena_final);
    $cadena_final = str_replace("]", "", $cadena_final);
    $cadena_final = str_replace("{", "", $cadena_final);
    $cadena_final = str_replace("}", "", $cadena_final);
    $cadena_final = str_replace("%", "-", $cadena_final);
    $cadena_final = str_replace("ñ", "ni", $cadena_final);
    $cadena_final = str_replace("à", "a", $cadena_final);
    $cadena_final = str_replace("è", "e", $cadena_final);
    $cadena_final = str_replace("ì", "i", $cadena_final);
    $cadena_final = str_replace("ò", "o", $cadena_final);
    $cadena_final = str_replace("ù", "u", $cadena_final);
    $cadena_final = str_replace("À", "a", $cadena_final);
    $cadena_final = str_replace("È", "e", $cadena_final);
    $cadena_final = str_replace("Ì", "i", $cadena_final);
    $cadena_final = str_replace("Ò", "o", $cadena_final);
    $cadena_final = str_replace("Ù", "u", $cadena_final);
    $cadena_final = str_replace("â", "a", $cadena_final);
    $cadena_final = str_replace("ê", "e", $cadena_final);
    $cadena_final = str_replace("î", "i", $cadena_final);
    $cadena_final = str_replace("ô", "o", $cadena_final);
    $cadena_final = str_replace("û", "u", $cadena_final);
    $cadena_final = str_replace("Â", "a", $cadena_final);
    $cadena_final = str_replace("Ê", "e", $cadena_final);
    $cadena_final = str_replace("Î", "i", $cadena_final);
    $cadena_final = str_replace("Ô", "o", $cadena_final);
    $cadena_final = str_replace("Û", "u", $cadena_final);
    $cadena_final = str_replace("ç", "c", $cadena_final);
    $cadena_final = str_replace("Ç", "c", $cadena_final);
    $cadena_final = str_replace("ã", "a", $cadena_final);
    $cadena_final = str_replace("õ", "o", $cadena_final);
    $cadena_final = str_replace("C", "c", $cadena_final);
    $cadena_final = str_replace("c", "c", $cadena_final);
    $cadena_final = str_replace("G", "g", $cadena_final);
    $cadena_final = str_replace("g", "g", $cadena_final);
    $cadena_final = str_replace("G", "g", $cadena_final);
    $cadena_final = str_replace("g", "g", $cadena_final);
    $cadena_final = str_replace("G", "g", $cadena_final);
    $cadena_final = str_replace("g", "g", $cadena_final);
    $cadena_final = str_replace("g", "g", $cadena_final);
    $cadena_final = str_replace("G", "g", $cadena_final);
    $cadena_final = str_replace("H", "h", $cadena_final);

    //buscamos cualquier caracter que no exté en los acpetados, y lo limpiamos
    $acepptedChars = "-_1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
    $cadena_final = preg_replace("/[^$acepptedChars]/", '', $cadena_final);


    $cadena_final = trim(substr($cadena_final, 0, $maxchars));


    if ($cadena_final[strlen($cadena_final) - 1] == "-") {
        $cadena_final = substr($cadena_final, 0, strlen($cadena_final) - 1);
    }

    return $cadena_final;
}

/**
  /**
 * Trunca un string
 *
 * */
function truncate($text, $numb, $etc = "...") {
    $text = html_entity_decode($text, ENT_QUOTES);
    if (strlen($text) > $numb) {
        $text = substr($text, 0, $numb);
        $text = substr($text, 0, strrpos($text, " "));

        $punctuation = ".!?:;,-"; //punctuation you want removed

        $text = (strspn(strrev($text), $punctuation) != 0) ?
                substr($text, 0, -strspn(strrev($text), $punctuation)) :
                $text;

        $text = $text . $etc;
    }
    $text = htmlentities($text, ENT_QUOTES);
    return $text;
}

/**
 *  Quita todo tipo de comillas
 *
 * */
function removeQuotes($string) {

    $string = str_replace("'", "", $string);
    $string = str_replace("\'", "", $string);
    $string = str_replace("\"", "", $string);
    $string = str_replace("`", "", $string);
    $string = str_replace("�", "", $string);

    return $string;
}

/**
 *  Quita todo tipo de acentos
 *
 * */
function removeAcutes($string) {


    $string = str_replace("á", "a", $string);
    $string = str_replace("é", "e", $string);
    $string = str_replace("í", "i", $string);
    $string = str_replace("ó", "o", $string);
    $string = str_replace("ú", "u", $string);
    $string = str_replace("Á", "A", $string);
    $string = str_replace("É", "E", $string);
    $string = str_replace("Í", "I", $string);
    $string = str_replace("Ó", "O", $string);
    $string = str_replace("Ú", "U", $string);
    $string = str_replace("ä", "a", $string);
    $string = str_replace("ë", "e", $string);
    $string = str_replace("ï", "i", $string);
    $string = str_replace("ö", "o", $string);
    $string = str_replace("ü", "u", $string);
    $string = str_replace("Ä", "A", $string);
    $string = str_replace("Ë", "E", $string);
    $string = str_replace("Ï", "I", $string);
    $string = str_replace("Ö", "O", $string);
    $string = str_replace("Ü", "U", $string);
    $string = str_replace("à", "a", $string);
    $string = str_replace("è", "e", $string);
    $string = str_replace("ì", "i", $string);
    $string = str_replace("ò", "o", $string);
    $string = str_replace("ù", "u", $string);
    $string = str_replace("À", "a", $string);
    $string = str_replace("È", "e", $string);
    $string = str_replace("Ì", "i", $string);
    $string = str_replace("Ò", "o", $string);
    $string = str_replace("Ù", "u", $string);
    $string = str_replace("â", "a", $string);
    $string = str_replace("ê", "e", $string);
    $string = str_replace("î", "i", $string);
    $string = str_replace("ô", "o", $string);
    $string = str_replace("û", "u", $string);
    $string = str_replace("Â", "a", $string);
    $string = str_replace("Ê", "e", $string);
    $string = str_replace("Î", "i", $string);
    $string = str_replace("Ô", "o", $string);
    $string = str_replace("Û", "u", $string);
    $string = str_replace("ç", "c", $string);
    $string = str_replace("Ç", "c", $string);
    $string = str_replace("ã", "a", $string);
    $string = str_replace("õ", "õ", $string);

    return $string;
}

/**
 *  Devuelve el id de video de youtube de una url
 * 
 * */
function getYoutubeIdFromUrl($url) {

    $parts = explode('?v=', $url);
    if (count($parts) == 2) {
        $tmp = explode('&', $parts[1]);
        if (count($tmp) > 1) {
            return $tmp[0];
        } else {
            return $parts[1];
        }
    } else {
        return $url;
    }
}

function getHoy($lang) {

    if ($lang == "es") {

        $str = sprintf("%s %s de %s de %s", getDiaSemana(), date("j"), getNombreMes(), date("Y"));
    } else {

        $str = date("l, F j S, Y");
    }

    return $str;
}

/**
 * 	@author Sebastian Balestrini
 * 	@version 1.0
 *
 * 	Formatea un arreglo quitando los caracteres html y los valores q peudan causar un fallo de seguridas xss
 *
 * 	return void;
 */
function htmlspecialchars_array(&$data) {

    foreach ($data as $key => $value) {

        if (!is_array($value)) {
            $data[$key] = htmlspecialchars(strip_tags($value));
        } else {
            $this->htmlspecialchars_array($value);
        }
    }

    return $data;
}

/**
 *  Devuelve el nombre de un mes apartir de su numero
 *
 * */
function getNombreMes($mes = NULL) {

    if (is_null($mes) || $mes == "" || $mes == NULL) {
        $mes = date("n");
    }

    $meses = array(1 => "Janvier",
        2 => "F&eacute;vrier",
        3 => "Mars",
        4 => "Avril",
        5 => "Mai",
        6 => "Juin",
        7 => "Juillet",
        8 => "Ao&ucirc;t",
        9 => "Septembre",
        10 => "Octobre",
        11 => "Novembre",
        12 => "D&eacute;cembre");

    return $meses[(int) $mes];
}

/**
 *  Devuelve el nombre de un mes apartir de su numero
 *
 * */
function getNombreCortoMesSMS($mes = NULL) {

    if (is_null($mes) || $mes == "" || $mes == NULL) {
        $mes = date("n");
    }

    $meses = array(1 => "Jan",
        2 => "Fév",
        3 => "Mar",
        4 => "Avr",
        5 => "Mai",
        6 => "Juin",
        7 => "Juil",
        8 => "Août",
        9 => "Sep",
        10 => "Oct",
        11 => "Nov",
        12 => "Déc");

    return $meses[(int) $mes];
}

/**
 *  Devuelve el nombre de un mes apartir de su numero
 *
 * */
function getNombreCortoMes($mes = NULL) {

    if (is_null($mes) || $mes == "" || $mes == NULL) {
        $mes = date("n");
    }

    $meses = array(1 => "Jan",
        2 => "Fév",
        3 => "Mar",
        4 => "Avr",
        5 => "Mai",
        6 => "Juin",
        7 => "Juil",
        8 => "Ao&ucirc;",
        9 => "Sep",
        10 => "Oct",
        11 => "Nov",
        12 => "D&eacute;c");

    return $meses[(int) $mes];
}

/**
 * Devuelve un combo con los dias del mes
 *
 * */
function getDias() {
    $dias = array();
    for ($i = 1; $i <= 31; $i++) {
        $dias[$i] = $i;
    }

    return $dias;
}

/**
 * Devuelve un combo con los meses de a�o, formato numerico
 *
 * */
function getMeses() {
    $meses = array();
    for ($i = 1; $i <= 12; $i++) {
        $meses[$i] = $i;
    }

    return $meses;
}

/**
 * Devuelve un combo con los a�os desde $anio_desde hasta el a�o actual
 *
 * */
function getAnios($anio_actual) {
    $anios = array();
    for ($i = $anio_actual; $i <= date("Y"); $i++) {
        $anios[$i] = $i;
    }
    return $anios;
}

/**
 * Prevenir sql injection
 *
 * */
function cleanQuery($string) {
    if (get_magic_quotes_gpc()) {  // prevents duplicate backslashes
        $string = stripslashes($string);
    }

    /* if (phpversion() >= '4.3.0')  {
      $string = mysql_real_escape_string($string);
      }else{
      $string = mysql_escape_string($string);
      } */
    return strip_tags($string);
}

function cleanHTMLData(&$value) {

    if (is_array($value)) {
        foreach ($value as $key => $sub_value) {
            cleanHTMLData($value[$key]);
        }
    } else {
        $value = cleanQuery(strip_tags($value));
        return;
    }
}

function utf8_decode_ar(&$data) {

    if (is_array($data)) {
        foreach ($data as $key => $sub_value) {
            utf8_decode_ar($data[$key]);
        }
    } else {
        $data = utf8_decode($data);
        return;
    }
}

function ref($str) {

    return str_pad($str, 7, "0", STR_PAD_LEFT);
}

/**
 *  Devuelve segun una fecha el dia de la semana en forma de numero entero	(0--6) donde 0=lunes	 
 *  @param $d int dia
 *  @param $m int mes
 *  @param $a int anio    
 *  @return integer dia de la semana                            		 
 *
 */
function getDiaSemana($d = NULL, $m = NULL, $a = NULL) {
    if (is_null($d)) {
        $d = date("d");
    }
    if (is_null($m)) {
        $m = date("m");
    }
    if (is_null($a)) {
        $a = date("Y");
    }
    $dia = getNumeroDiaSemana($d, $m, $a);
    switch ($dia) {
        case 0:
            return "Lundi";
            break;
        case 1:
            return "Mardi";
            break;
        case 2:
            return "Le mercredi";
            break;
        case 3:
            return "Jeudi";
            break;
        case 4:
            return "Vendredi";
            break;
        case 5:
            return "Samedi";
            break;
        case 6:
            return "Le dimanche";
            break;
    }
}

/**
 *  Devuelve segun una fecha el dia de la semana en forma de numero entero	(0--6) donde 0=lunes	 
 *  @param $d int dia
 *  @param $m int mes
 *  @param $a int anio    
 *  @return integer dia de la semana                            		 
 *
 */
function getNumeroDiaSemana($d, $m, $a) {
    $numerodiasemana = date('w', mktime(0, 0, 0, $m, $d, $a));
    //echo $numerodiasemana." -- <br> ";
    if ($numerodiasemana == 0)
        $numerodiasemana = 6;
    else
        $numerodiasemana--;

    return $numerodiasemana;
}

/**
 *  Devuelve el nombre corto de un dia	(1--7) donde 0=lunes	 
 *  @param $dia int dia
 *  @param $m int mes
 *  @param $a int anio    
 *  @return String nombre corto de dia de la semana                           		 
 *
 */
function getNombreCortoDia($dia) {

    switch ($dia) {
        case 1:
            return "Lun";
            break;
        case 2:
            return "Mar";
            break;
        case 3:
            return "Mer";
            break;
        case 4:
            return "Jeu";
            break;
        case 5:
            return "Ven";
            break;
        case 6:
            return "Sam";
            break;
        case 7:
            return "Dim";
            break;
    }
}

/**
 *  Devuelve el nombre de un dia (1--7) donde 0=lunes	 
 *  @param $dia int dia 
 *  @return String nombre corto de dia de la semana                           		 
 *
 */
function getNombreDia($dia) {
    switch ((int) $dia) {
        case 0:
            return "Lundi";
            break;
        case 1:
            return "Mardi";
            break;
        case 2:
            return "Mercredi";
            break;
        case 3:
            return "Jeudi";
            break;
        case 4:
            return "Vendredi";
            break;
        case 5:
            return "Samedi";
            break;
        case 6:
            return "Dimanche";
            break;
    }
}

if (!function_exists('mb_ucfirst')) {

    function mb_ucfirst($str, $to_lower = true, $charset = 'utf-8') {
        $first = mb_strtoupper(mb_substr($str, 0, 1, $charset), $charset);
        $end = mb_substr($str, 1, mb_strlen($str, $charset), $charset);
        // Convert them all to lowercase (if specified)
        if ($to_lower) {
            $end = mb_strtolower($end, $charset);
        }
        return $first . $end;
    }

}
// First letter lowercase
if (!function_exists('mb_lcfirst')) {

    function mb_lcfirst($str, $charset = 'utf-8') {
        $first = mb_strtolower(mb_substr($str, 0, 1, $charset), $charset);
        return $first . mb_substr($str, 1, mb_strlen($str, $charset), $charset);
    }

}

function nombre2iniciales($nombre) {

    $list = explode(" ", $nombre);


    $salida = "";
    foreach ($list as $tmp) {
        $salida .= $tmp[0];
    }

    return $salida;
}

/**
 * Obtiene un par de fechas en formato ISO8601-extended para usar en mercadopago
 * @param type $numeroCuotas la cantidad de meses que hasta la fecha de fin
 * @return array con los string fechaInicio y fechaFin
 */
function fechaMP($numeroCuotas) {
    // Our input
    $time = microtime(true);
    // Determining the microsecond fraction
    $microSeconds = sprintf("%06d", ($time - floor($time)) * 1000000);
    // Creating our DT object
    $tz = new DateTimeZone("Etc/UTC"); // NOT using a TZ yields the same result, and is actually quite a bit faster. This serves just as an example.
    $dt = new DateTime(date('Y-m-d H:i:s.' . $microSeconds, $time), $tz);
    // Compiling the date. Limiting to milliseconds, without rounding
    $fecha_inicio = sprintf(
            "%s%03d%s", $dt->format("Y-m-d\TH:i:s."), floor($dt->format("u") / 1000), $dt->format("O")
    );
    // Formatting according to ISO 8601-extended
    $intervalo = new DateInterval('P' . $numeroCuotas . 'M');
    $dt->add($intervalo);

    $fecha_fin = sprintf(
            "%s%03d%s", $dt->format("Y-m-d\TH:i:s."), floor($dt->format("u") / 1000), $dt->format("O")
    );

    $rdo = array("fechaInicio" => $fecha_inicio, "fechaFin" => $fecha_fin);
    return $rdo;
}

//fechaMP

/* * Metodo que formatea una fecha de 01-01-1999 a 01 Ene 1999
 * 
 * @param type $fecha
 */

function fechaToString($fecha, $hora = 0) {

    if (strchr($fecha, '/') != "") {
        $date_explode = explode(" ", $fecha);

        list($d, $m, $y) = preg_split("[/]", $date_explode[0]);
        $mes = getNombreCortoMes((int) $m);
        if ($hora == 1) {
            $hora_str = substr($date_explode[1], 0, 5);
            return "$d $mes $y $hora_str";
        } else {
            return "$d $mes $y ";
        }
    }
    if (strchr($fecha, '-') != "") {
        $date_explode = explode(" ", $fecha);

        list($y, $m, $d) = preg_split("[-]", $date_explode[0]);
        $mes = getNombreCortoMes((int) $m);
        if ($hora == 1) {
            $hora_str = substr($date_explode[1], 0, 5);
            return "$d $mes $y $hora_str";
        } else {
            return "$d $mes $y ";
        }
    }
}

function fechaToStringSMS($fecha, $hora = 0) {

    if (strchr($fecha, '/') != "") {
        $date_explode = explode(" ", $fecha);

        list($d, $m, $y) = preg_split("[/]", $date_explode[0]);
        $mes = getNombreCortoMes((int) $m);
        if ($hora == 1) {
            $hora_str = substr($date_explode[1], 0, 5);
            return "$d $mes $y $hora_str";
        } else {
            return "$d $mes $y ";
        }
    }
    if (strchr($fecha, '-') != "") {
        $date_explode = explode(" ", $fecha);

        list($y, $m, $d) = preg_split("[-]", $date_explode[0]);
        $mes = getNombreCortoMesSMS((int) $m);
        if ($hora == 1) {
            $hora_str = substr($date_explode[1], 0, 5);
            return "$d $mes $y $hora_str";
        } else {
            return "$d $mes $y ";
        }
    }
}

/**
 *  Devuelve segun una fecha el dia de la semana en forma de numero entero	(0--6) donde 0=lunes	 
 *  @param $d int dia
 *  @param $m int mes
 *  @param $a int anio    
 *  @return integer dia de la semana                            		 
 *
 */
function getDiaSemanaXFecha($fecha = NULL) {

    if (is_null($fecha)) {
        $fecha = date("Y-m-d");
    }

    list($a, $m, $d) = preg_split("[-]", $fecha);

    $dia = getNumeroDiaSemana($d, $m, $a);
    switch ($dia) {
        case 0:
            return "Lundi";
            break;
        case 1:
            return "Mardi";
            break;
        case 2:
            return "Mercredi";
            break;
        case 3:
            return "Jeudi";
            break;
        case 4:
            return "Vendredi";
            break;
        case 5:
            return "Samedi";
            break;
        case 6:
            return "Dimanche";
            break;
    }
}

/* Devuelve el numero de dias del mes
 * 
 */

function getCantidadDiasMes($mes) {
    switch ((int) $mes) {
        case 1:
            return 31;
        case 2:
            //detectar bisiesto
            if (date("L")) {
                return 29;
            } else {
                return 28;
            }
        case 3:
            return 31;
        case 4:
            return 30;
        case 5:
            return 31;
        case 6:
            return 30;
        case 7:
            return 31;
        case 8:
            return 31;
        case 9:
            return 30;
        case 10:
            return 31;
        case 11:
            return 30;
        case 12:
            return 31;
    }
}

/* * Funcion que verifica la sintaxis correcta de un mail
 * 
 * @param type $email
 * @return type
 */

function isValidEmail($email) {
    return filter_var($email, FILTER_VALIDATE_EMAIL) && preg_match('/@.+\./', $email);
}

/**
 * Traduccion de un string
 * @param type $text
 * @param string $idioma
 * @return type
 */
function x_translate($text, $idioma = NULL) {




    if (defined("TRADUCCION_IDIOMA") && TRADUCCION_IDIOMA && defined("TRADUCIR_SISTEMA") && TRADUCIR_SISTEMA) {

        require_once(path_root("xframework/translate/translate_" . TRADUCCION_IDIOMA . ".php"));

        $translations = Translations::getTranslations();
        //reemplazamos "Paciente" -> "Cliente" en profesionales no medicos
        if (isset($translations[$text]) && $translations[$text] != "") {
            if (CONTROLLER === "medico" && $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["tipo_especialidad"] == 2 && $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["tipo_identificacion"] == 2) {
                //reemplazamos "Paciente" -> "Cliente";
                if (strpos($translations[$text], "Patient") !== false) {
                    $translations[$text] = str_replace("Patient", "Client", $translations[$text]);
                } else if (strpos($translations[$text], "patient") !== false) {
                    $translations[$text] = str_replace("patient", "client", $translations[$text]);
                } else if (strpos($translations[$text], "PATIENT") !== false) {
                    $translations[$text] = str_replace("PATIENT", "CLIENT", $translations[$text]);
                }
            }
        }


        
        //verificamos la ocurrencia de los caracteres [[ ]] que indican un texto variable
        if (strpos($text, "[[") > 0 && strpos($text, "]]") > 0) {

            //cortamos el texto variable para buscar la traduccion con la mascara [[%s]] en la posicion del texto variable
            $init = strpos($text, "[[") + 2;
            $end = strpos($text, "]]");
            $cant = $end - $init;
            //guardamos el texto a reemplazar
            $texto_variable = substr($text, $init, $cant);

            $text = str_replace($texto_variable, "%s", $text);
            //buscamos la traduccion y reemplazamos el texto variabke
            if (isset($translations[$text]) && $translations[$text] != "") {

                return str_replace("[[%s]]", $texto_variable, $translations[$text]);
            }
        }

        //  print_r($translations);
        if (isset($translations[$text]) && $translations[$text] != "") {
            return str_replace("'","&apos;",$translations[$text]);
        } else {
            return $text;
        }
    } else {

        return $text;
    }
}

?>