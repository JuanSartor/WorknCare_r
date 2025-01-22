<?php
/**
 *  Favoritos del usuario logueado
 *
 **/  
 
 $manager =  $this->getManager("ManagerXadminFavorites");
 
 $favorites = $manager->getFavorites($_SESSION[URL_ROOT][CONTROLLER]['logged_account']["id"]);
 
 $this->assign("favorites",$favorites);
   
?>
