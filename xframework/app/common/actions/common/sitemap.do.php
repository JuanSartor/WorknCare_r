<?php

 /**
   * Método que genera el sitemap con los programas de salud
   */
  $ManagerSeo = $this->getManager("ManagerXSeo");
  
  $resultado = $ManagerSeo->generate_sitemap();

