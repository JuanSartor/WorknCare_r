<?php

session_start();

if ($_SESSION["translate"] == true) {
    $_SESSION["translate"] = false;
    echo "translation OFF";
} else {
    $_SESSION["translate"] = true;
    echo "translation ON";
}
?>
