<?php

/**
 * 	init.config.php
 * 	Archivo de configuraciones iniciales.
 *
 * 	@author Sebastian Balestrini <sbalestrini@gmail.com>
 * 	@version 3.0
 *
 */
// Configuracion del Carteador de correo


 if ($_SERVER["HTTP_HOST"] == "localhost") {
    define("DEFAULT_EMAIL_HOST", "mail.doctorplus.com.ar");
    define("DEFAULT_EMAIL_FROM", "testmail@doctorplus.com.ar");
    define("DEFAULT_EMAIL_FROM_NAME", utf8_decode("Doctorplus"));
    define("DEFAULT_EMAIL_USERNAME", "testmail@doctorplus.com.ar");
    define("DEFAULT_EMAIL_PASSWORD", "hVP*LfK3kL");
    //define("DEFAULT_CONTACT_EMAIL","info@cursosapp.com.ar");
    define("DEFAULT_CONTACT_EMAIL", "sbalestrini@gmail.com");
    define("ADMIN_EMAIL", "sbalestrini@gmail.com");
} else {

    //define("DEFAULT_EMAIL_HOST", "email-smtp.us-west-2.amazonaws.com");
    define("DEFAULT_EMAIL_FROM", "notifications@workncare.io");
    define("DEFAULT_EMAIL_FROM_NAME", "Notifications WorknCare");
    //define("DEFAULT_EMAIL_USERNAME", "AKIAJQUED63HO5CF43EA");
    //define("DEFAULT_EMAIL_PASSWORD", "AmsunYDloDoVb0xP4mUSOqjxCBAv4YGSbEl1B9nsIVCM");
    define("DEFAULT_CONTACT_EMAIL", "support@workncare.io");
    define("DEFAULT_PAGOS_EMAIL", "support@workncare.io");
    define("DEFAULT_EMAIL_ADMIN", "support@workncare.io");

    /* Amazon SES */
    define("AWS_ACCESS_KEY_ID", "AKIAIJBDT5TFEB44HAIA");
    define("AWS_SECRET_ACCESS_KEY", "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");
  
 /* Twilio SMS */
    define("TWILIO_ACCOUNT_SID", "AC3eeb2dd70b271519912a283bc0cdb3ee");
    define("TWILIO_AUTH_TOKEN", "22bdbff71eea958ddfcfdf254a852c2c");
    define("TWILIO_NUMBER", "+16672132387");
  
    // doctorplus.fr
    //define("SEND_MAIL_API_KEY", "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");
    
    // videoconsulta
    // define("SEND_MAIL_API_KEY", "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");
    
    // doctorplus.eu
    define("SEND_MAIL_API_KEY", "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");
  
}

define("DEFAULT_ERROR_EMAIL", "juansartor92@gmail.com");
