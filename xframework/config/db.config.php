<?php

/**
 * 	init.config.php
 * 	Archivo de configuraciones iniciales.
 *
 * 	@author Sebastian Balestrini <sbalestrini@gmail.com>
 * 	@version 3.0
 *
 */
//$server_ip = getHostByName(getHostName());

//switch ($server_ip) {
  //  case "172.31.45.250": // PROD
        define("DB_SERVER", "db-doctorplus-francia-produccion.cstgcxo0gsfd.eu-west-3.rds.amazonaws.com");
        define("DB_NAME", "app");
        define("DB_USER", "masterdb");
        define("DB_PASS", "Qwerty_123T1t0_dP");
        define("SERVER_URL", "35.181.30.18");
    //    break;

    //case "172.31.22.58": // FR

      /*  define("DB_SERVER", "dp-fr-test-3.cqdszoyrzxrf.us-east-1.rds.amazonaws.com"); // FIX temporal. cambio de BD
        define("DB_NAME", "app");
        define("DB_USER", "masterdb");
        define("DB_PASS", "Qwerty_123T1t0_dP");
        define("SERVER_URL", "test.doctorplus.eu");
        break;

    default:
        define("DB_SERVER", "10.0.0.254");
        define("DB_NAME", "doctorplus_francia_v2");
        define("DB_USER", "root");
        define("DB_PASS", "qwerty");
        define("SERVER_URL", "localhost");

        break;
}*/
