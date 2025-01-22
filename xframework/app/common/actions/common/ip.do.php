<?php
    /**
	*	
	*  alta/modificacion de registros
	*
	*	@author Emanuel del Barco
	*
	*/	

    //ejemplo de como utilizar el manager general, pasandole el nombre de la tabal
    //y el nombre de la clave primaria
    $this->start();    

	// Obtengo la IP	
	$ip = $_SERVER["REMOTE_ADDR"];
	
	include(path_libs_php("geoip/geoip.inc"));
	$gi = geoip_open(path_libs_php("geoip/GeoIP.dat"),GEOIP_STANDARD);
	
	echo "<hr>".geoip_country_code_by_addr($gi, $ip) . "-" .
		 geoip_country_name_by_addr($gi, $ip) . "<br><hr>";
	
	geoip_close($gi);
	

?>