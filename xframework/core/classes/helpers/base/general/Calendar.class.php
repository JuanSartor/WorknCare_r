<?php

  /**
   * 	@autor Xinergia
   * 	@version 1.0	2008-04-14
   * 	Manager de Calendarios
   *
   */

  /**
   * @autor Xinergia
   * @version 1.0	2008-04-14
   * Class ManagerCalendar
   */
  class Calendar {

      /** constructor
       * 	@param $db instancia de adodb
       */
      function __construct() {

          //codigo aqui...
      }

      /**
       *  Devuelve el ultimo dia de un mes		 
       *  @param $mes int Numero del mes para calcular el ultimo dia
       *  @param $anio int Anio 
       *  @return integer numero de dias del mes                            		 
       *
       */
      public function daysOfMonth($mes, $anio) {
          if (((fmod($anio, 4) == 0) and ( fmod($anio, 100) != 0)) or ( fmod($anio, 400) == 0)) {
              $dias_febrero = 29;
          } else {
              $dias_febrero = 28;
          }
          //echo $mes;
          switch ((int) $mes) {
              case 1:case 3:case 5:case 7:case 8:case 10:case 12:
                  return 31;
                  break;
              case 2:
                  return $dias_febrero;
                  break;
              case 4:case 6:case 9:case 11:
                  return 30;
                  break;
          }
      }

      /**
       * 
       * @param type $fechanacimiento
       * @return type
       */
      function calculaEdad($fechanacimiento) {
          list($ano, $mes, $dia) = explode("-", $fechanacimiento);
          $ano_diferencia = date("Y") - $ano;
          $mes_diferencia = date("m") - $mes;
          $dia_diferencia = date("d") - $dia;
          if ($dia_diferencia < 0 || $mes_diferencia < 0)
              $ano_diferencia--;
          return $ano_diferencia;
      }

      /**
       *  Devuelve segun una fecha el dia de la semana en forma de numero entero		 
       *  @param $d int dia
       *  @param $m int mes
       *  @param $a int anio    
       *  @return integer dia de la semana                            		 
       *
       */
      public function getDayNumberOnWeek($d, $m, $a) {
          $numerodiasemana = date('w', mktime(0, 0, 0, $m, $d, $a));
          //echo $numerodiasemana." -- <br> ";
          if ($numerodiasemana == 0)
              $numerodiasemana = 6;
          else
              $numerodiasemana--;

          return $numerodiasemana;
      }

      /**
       *  Devuelve una matriz de 4x6 para armar el mes y sus dias correspondientes
       *  @param $empty string valor para los dias vacios    
       *  @return array                            		 
       *
       */
      function getMonthMatrix($empty = "&nbsp;") {
          return array(
                0 => array(0 => array("dia" => $empty, "ocupdado" => 0), 1 => array("dia" => $empty, "ocupado" => 0), 2 => array("dia" => $empty, "ocupado" => 0), 3 => array("dia" => $empty, "ocupado" => 0), 4 => array("dia" => $empty, "ocupado" => 0), 5 => array("dia" => $empty, "ocupado" => 0), 6 => array("dia" => $empty, "ocupado" => 0)),
                1 => array(0 => array("dia" => $empty, "ocupado" => 0), 1 => array("dia" => $empty, "ocupado" => 0), 2 => array("dia" => $empty, "ocupado" => 0), 3 => array("dia" => $empty, "ocupado" => 0), 4 => array("dia" => $empty, "ocupado" => 0), 5 => array("dia" => $empty, "ocupado" => 0), 6 => array("dia" => $empty, "ocupado" => 0)),
                2 => array(0 => array("dia" => $empty, "ocupado" => 0), 1 => array("dia" => $empty, "ocupado" => 0), 2 => array("dia" => $empty, "ocupado" => 0), 3 => array("dia" => $empty, "ocupado" => 0), 4 => array("dia" => $empty, "ocupado" => 0), 5 => array("dia" => $empty, "ocupado" => 0), 6 => array("dia" => $empty, "ocupado" => 0)),
                3 => array(0 => array("dia" => $empty, "ocupado" => 0), 1 => array("dia" => $empty, "ocupado" => 0), 2 => array("dia" => $empty, "ocupado" => 0), 3 => array("dia" => $empty, "ocupado" => 0), 4 => array("dia" => $empty, "ocupado" => 0), 5 => array("dia" => $empty, "ocupado" => 0), 6 => array("dia" => $empty, "ocupado" => 0)),
                4 => array(0 => array("dia" => $empty, "ocupado" => 0), 1 => array("dia" => $empty, "ocupado" => 0), 2 => array("dia" => $empty, "ocupado" => 0), 3 => array("dia" => $empty, "ocupado" => 0), 4 => array("dia" => $empty, "ocupado" => 0), 5 => array("dia" => $empty, "ocupado" => 0), 6 => array("dia" => $empty, "ocupado" => 0)));
      }

      /**
       *  Devuelve el numero de semana     
       *  @return integer                            		 
       *
       */
      function getNumberOfWeeks($dia, $mes, $anio) {

          $primerDia = $this->getDayNumberOnWeek(1, $mes, $anio);
          $diasSemana = $primerDia;
          $numeroSemana = 1;

          for ($i = 1; $i < $dia; $i++) {
              $diasSemana++;
              if (($diasSemana == ($numeroSemana * 7))) {

                  $numeroSemana++;
              }
          }
          return $numeroSemana - 1;
      }

      function getMonth($mes, $anio, &$matrizMes) {


          $primerDia = $this->getDayNumberOnWeek(1, $mes, $anio);

          $diasSemana = $primerDia;

          $numeroSemana = 1;


          for ($i = 1; $i <= $this->daysOfMonth($mes, $anio); $i++) {
              $matrizMes[$numeroSemana - 1][$this->getDayNumberOnWeek($i, $mes, $anio)]['dia'] = $i;
              $diasSemana++;
              if (($diasSemana == ($numeroSemana * 7))) {
                  $numeroSemana++;
              }
          }

          return $matrizMes;
      }

      function getArrayMonths() {

          return array(1 => "Janvier",
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
      }
      
       function getMonths($mes) {
          $array = array(1 => "Janvier",
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
          return $array[$mes];
      }

      function getMonthsShort($mes) {
          $array = array(1 => "Jan",
        2 => "F&eacute;v",
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
          return $array[$mes];
      }

      function getFechasDP($date) {
          list($a, $m, $d) = preg_split("[-]", $date);

          $ms = $this->getMonthsShort((int) $m);
          return "$d $ms $a";
      }

      function getArrayDays() {
          $dias = array();
          for ($i = 1; $i <= 31; $i++) {
              $dias[$i] = $i;
          }

          return $dias;
      }

      
      /**
       * Método que retorna la diferencia entre dos fechas
       * @param type $fecha1
       * @param type $fecha2
       * @param type $tipo
       * @return boolean
       */
      function getDiferenciasFechas($fecha1, $fecha2, $tipo = "d") {
          list($a, $m, $d) = preg_split("[-]", $fecha1);
          list($ah, $mh, $dh) = preg_split("[-]", $fecha2);

          $timestamp1 = mktime(0, 0, 0, $m, $d, $a);
          $timestamp2 = mktime(0, 0, 0, $mh, $dh, $ah);

          $diferencia_segundos = $timestamp1 - $timestamp2;

          switch ($tipo) {
              case "d":
                  //Dias
                  return floor($diferencia_segundos / (60 * 60 * 24));
                  break;
              case "m":
                  //Meses
                  return floor($diferencia_segundos / (60 * 60 * 24 * 30));
                  break;
              case "Y":
                  //Año
                  return floor($diferencia_segundos / (60 * 60 * 24 * 30 * 12));
                  break;
              default:
                  break;
          }
          
          return false;
      }

      function getArrayYears() {
          $anios = array();
          for ($i = 1990; $i <= (int) date("Y"); $i++) {
              $anios[$i] = $i;
          }

          return $anios;
      }

      /**
       * Método que retorna un array con el split de la fecha.. 
       * @param type $fecha
       * @return type : Array con los valores
       */
      public function splitFecha($fecha) {
          list($a, $m, $d) = preg_split("[-]", $fecha);
          return ["anio" => $a, "mes" => $m, "dia" => $d];
      }

      /**
       * Método que compara dos fechas. 
       * @param type $fecha1 : formato date("Y-m-d")
       * @param type $fecha2 : formato date("Y-m-d")
       * @return int
       *    1: $fecha1 > $fecha2
       *    -1: $fecha1 < $fecha2
       *    0: $fecha1 = $fecha2
       */
      public function isMayor($fecha1, $fecha2) {
          list($y1, $m1, $d1) = preg_split("[-]", $fecha1);
          list($y2, $m2, $d2) = preg_split("[-]", $fecha2);

          $mktime1 = mktime(0, 0, 0, $m1, $d1, $y1);
          $mktime2 = mktime(0, 0, 0, $m2, $d2, $y2);


          if ($mktime1 > $mktime2) {
              return 1;
          } elseif ($mktime2 > $mktime1) {
              return -1;
          } else {
              return 0;
          }
      }

      /**
       * Método que retorna el nombre del día según la fecha que trae
       * @param type $fecha : FORMAT (Y-m-d) 
       * @param type $name_short
       * @return type
       */
      public function getNameDayWeek($fecha, $name_short = false) {
          $fecha = strtotime($fecha);

          switch (date('w', $fecha)) {
              case 0: $dia = $name_short ? "Dim" : "Le dimanche";
                  break;
              case 1: $dia = $name_short ? "Lun" : "Lundi";
                  break;
              case 2: $dia = $name_short ? "Mar" : "Mardi";
                  break;
              case 3: $dia = $name_short ? "Mer" : "Le mercredi";
                  break;
              case 4: $dia = $name_short ? "Jen" : "Jeudi";
                  break;
              case 5: $dia = $name_short ? "Ven" : "Vendredi";
                  break;
              case 6: $dia = $name_short ? "Sam" : "Samedi";
                  break;
          }

          return $dia;
      }

  }

?>
