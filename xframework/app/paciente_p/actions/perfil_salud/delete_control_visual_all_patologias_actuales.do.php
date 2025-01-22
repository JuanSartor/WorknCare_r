<?php
  /**
   * Action >> DELETE >> Antecedentes control visual
   */
  $manager = $this->getManager("ManagerPerfilSaludControlVisualAntecedentes");

  $result = $manager->delete_all_patologias_actuales($this->request["idperfilSaludControlVisual"]);

  $this->finish($manager->getMsg());
