<?php

/**
 * 	Dir.php
 *
 * 	Clase que Abstrae el comportamiento y las funcionalidades aplicables a un directorio
 *
 * 	@author Sebastian Balestrini <sbalestrini@gmail.com>
 * 	@version 1.0 
 *
 */
/**
 * class ManagerDBConnections: Clase Administradora de conexiones MySQL
 *
 * 	
 */
require_once(path_helpers("base/files/FilesystemElement.class.php"));

class Dir extends FilesystemElement {

    var $resourse;
    var $path;

    //
    function Dir($path, $mode = 0755) {

        if (is_null($path) || $path == "") {
            return false;
        } else {
            // verificamos que el path exista y sea un diractorio
            // si es directorio 
            if (is_dir($path)) {
                //asignamos el resouce
                $this->resource = opendir($path);
                $this->path = $path;
                return true;
            } else {

                //Creamos el directorio con dicho path				
                if (mkdir($path, $mode)) {
                    $this->resource = opendir($path);
                    $this->path = $path;
                    return true;
                } else {
                    return false;
                }

                //return false
            }
        }
    }

    /**
     * 	@author Emanuel del Barco
     * 	@version 1.0
     * 
     * 	Retorna el pimer archivo q encuentra en un directorio.
     *   si no encontro archivos devuelve vacio 	
     * 	@return string
     */
    function getFirstFile($dir, $pattern = NULL) {

        if (is_dir($dir)) {
            $d = dir($dir);
            while (($entry = $d->read())) {
                if ($entry != "." && $entry != "..") {
                    if (is_file($dir . "/" . $entry)) {
                        if (preg_match("/{$pattern}/i", $entry) > 0) {
                            return $entry;
                        }
                    }//end if 
                }//end if
            }//end while
        }//end if

        return "";
    }

    //by seba
    function changePath($path, $mode = 0755) {
        $this->Dir($path, $mode);
    }

    /**
     * 	@author Sebastian Balestrini
     * 	@version 1.0
     * 
     * 	Cierra un directorio abierto
     * 	
     * 	@return bool
     */
    function close() {
        if ($this->resource) {
            return closedir($this->resource);
        } else {
            return false;
        }
    }

    /**
     * 	@author Sebastian Balestrini
     * 	@version 1.0
     * 
     * 	Devuelve un Array con la estructura de directorios y archivos
     * 	
     * 	@return mixed
     */
    function toArray() {
        
    }

    /**
     * 	@author Sebastian Balestrini
     * 	@version 1.0
     * 
     * 	Determina si el directorio est� vacio
     * 	
     * 	@return bool
     */
    function isEmpty() {
        
    }

    /**
     * 	@author Sebastian Balestrini
     * 	@version 1.0
     * 
     * 	Borra un archivo o directorio
     * 	
     * 	@return bool
     */
    function deleteDir($name = NULL) {

        // Se borra un directorio, todos los subdirectorios .
        // y todos los archivos que se encuentran en el
        //si rebimos $name borramos ese directorio, delo contrario borramos path
        //echo "quiero borrar $name \n";

        if (is_null($name)) {
            $name = $this->path;
        }

        if (is_dir($name)) {
            //abrimos un resourece temporal
            $d = dir($name);
            while (($entry = $d->read())) { // Recorre hasta vaciar el directorio
                if ($entry != "." && $entry != "..") {
                    if (is_file("$name/$entry"))
                        unlink("$name/$entry");
                    else {
                        if (is_dir("$name/$entry")) {
                            $this->deleteDir("$name/$entry");
                        }
                    }
                }
            }
            rmdir($name);
            $d->close();
        } else {

            return;
        }
    }

    /**
     * 	@author Sebastian Balestrini
     * 	@version 1.0
     * 
     * 	Borra un archivo o directorio
     * 	
     * 	@return bool
     */
    function delete() {

        $this->deleteDir($this->path);
    }

    function getArrayFiles($dir, $pattern = NULL, $onlyName = true) {

        $result = array();
        if (is_dir($dir)) {
            $d = dir($dir);
            while (($entry = $d->read())) {
                if ($entry != "." && $entry != "..") {

                    if (is_file($dir . "/" . $entry)) {
                        if (is_null($pattern) || preg_match("/{$pattern}/i", $entry) > 0) {
                            if ($onlyName) {
                                $result[] = $entry;
                            } else {
                                $result[] = $dir . "/" . $entry;
                            }
                        }//end if
                    }//end if 
                }//end if
            }//end while
        }//end if
        return $result;
    }

    function countFiles($otherPath = NULL) {

        $dir = $this->path;
        $count = 0;
        if (is_dir($dir)) {
            $d = dir($dir);
            while (($entry = $d->read())) {
                if ($entry != "." && $entry != "..") {

                    if (is_file($dir . "/" . $entry)) {
                        $count++;
                    }//end if 
                }//end if
            }//end while
        }//end if

        return $count;
    }

    /**
     * 	@author Sebastian Balestrini
     * 	@version 1.0
     * 
     * 	Borra el directorio con todo su contenido
     * 	
     * 	@return bool
     */
    function doEmpty($recursivo = false) {

        // si es recursiva la eliminaci�n, se borra todo. 
        // Si no es recursiva solo borra los archivos que contiene y no los directorios            
        //abrimos un resourece temporal
        $d = dir($this->path);
        while (($entry = $d->read())) { // Recorre hasta vaciar el directorio
            if ($entry != "." && $entry != "..") {
                // echo $this->path."$entry";                    
                if (is_file($this->path . "$entry"))
                    unlink($this->path . "$entry");
                else {
                    if (is_dir($this->path . "$entry") && $recursivo) {
                        $this->delete($this->path . "$entry");
                    }
                }
            }
        }

        $d->close();
    }

    /**
     * 	@author Sebastian Balestrini
     * 	@version 1.0
     * 
     * 	Mueve un directrio a una ubicacion en particular
     * 	
     * 	@return bool
     */
    function moveTo($path) {
        
    }

    /**
     * 	@author Sebastian Balestrini
     * 	@version 1.0
     * 
     * 	Copia un directrio a una ubicacion en particular
     * 	
     * 	@return bool
     */
    function copyTo($path) {
        
    }

    /**
     * 	@author Sebastian Balestrini
     * 	@version 1.0
     * 
     * 	busca y devuelve todas las ocurrencias de un archivo o directorio con el texto $string 
     * 	
     * 	@return mixed
     */
    function search($string, $type = "both") {
        
    }

    /**
     * 	@author Sebastian Balestrini
     * 	@version 1.0
     * 
     * 	devuelve una cadena de texto que contiene el path al elemento
     * 	
     * 	@return string
     */
    function getPath() {
        return $this->path;
    }

    /**
     * 	@author Sebastian Balestrini
     * 	@version 1.0
     * 
     * 	devuelve una resource del directorio
     * 	
     * 	@return string
     */
    function getResourse() {
        
    }

    /**
     * 	@author Sebastian Balestrini
     * 	@version 1.0
     * 
     * 	cambia la referencia de la calse a otro directorio. Esta clase se transforma en manejadora de otro directorio
     * 	
     * 	@return string
     */
    function change($path) {
        
    }

    /**
     * 	@author Sebastian Balestrini
     * 	@version 1.0
     * 
     * 	Crea un directorio
     * 	
     * 	@return string
     */
    function mkdir($name) {
        
    }

    /**
     * 	@author Sebastian Balestrini
     * 	@version 1.0
     * 
     * 	Cambia los permisos del directorio
     * 	
     * 	@return string
     */
    function chmod($mod) {
        return chmod($this->path, $mod);
    }

    /**
     * 	@author Sebastian Balestrini
     * 	@version 1.0
     * 
     * 	Cambia el propiedario
     * 	
     * 	@return string
     */
    function chown($own) {
        
    }

    /**
     * 	@author Sebastian Balestrini
     * 	@version 1.0
     * 
     * 	Cambia el grupo
     * 	
     * 	@return string
     */
    function chgrp($grp) {
        
    }

    /**
     * 	@author Sebastian Balestrini
     * 	@version 1.0
     * 
     * 	Cambia todas las propeidades del archivo o solo algunas
     * 	
     * 	@return string
     */
    function chall($mod = NULL, $own = NULL, $grp = NULL) {
        
    }

}

?>
