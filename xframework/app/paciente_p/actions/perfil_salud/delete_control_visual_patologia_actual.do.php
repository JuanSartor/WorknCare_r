<?php
  /**
   * Action >> DELETE >> Antecedentes control visual
   */
  $manager = $this->getManager("ManagerPerfilSaludControlVisualAntecedentes");

  $result = $manager->delete($this->request["id"]);

  $this->finish($manager->getMsg());
