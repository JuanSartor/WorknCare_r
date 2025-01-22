<style>
    .partner-logo{
        margin-top:20px;
        display:flex;
        justify-content: center;
    } 

    .partner-logo .social{
        margin:0 20px;
    }

    .utilisateurs a {
        font-size:12px!important;
        line-height: 1 !important;
    }
</style>
<div class="footer-2">
    <div class="okm-container footer-2-inner">


        <div class="okm-row partner-logo">

            <div class="social text-center">
                <a href="https://www.linkedin.com/company/passbienetre/" title="LinkedIn WorknCare" target="_blank">
                    <img src="{$IMGS}footer/linkedin.png" width="45" heigth="45">
                </a>
            </div>
            <div class="social text-center">
                <a href="https://www.facebook.com/PassBienEtre/" title="Facebook WorknCare" target="_blank">
                    <img src="{$IMGS}footer/facebook.png" width="45" heigth="45">
                </a>
            </div>
            <div class="social text-center">
                <a href="https://www.instagram.com/passbienetre/" title="Instagram WorknCare" target="_blank">
                    <img src="{$IMGS}footer/instagram.png" width="45" heigth="45">
                </a>
            </div>
            <div class="social text-center">
                <a href="https://twitter.com/passbienetre"title="Twitter WorknCare" target="_blank">
                    <img src="{$IMGS}footer/twiter.png" width="45" heigth="45">
                </a>
            </div>

        </div>

    </div>

    <div class="">
        <div class="col-xs-12 col-sm-4 col-md-4 col-lg-6 footer-text">
            <span>{"¿Necesita ayuda?"|x_translate}</span>
        </div>
        <div class="col-xs-12 col-sm-4 col-md-4 col-lg-6 footer-text-mail">
            <a href="mailto:support@workncare.io">
                <i class="icon-doctorplus-envelope" style="color:#FFC433"></i>
                <span style="font-size:18px">support@workncare.io</span>
            </a>
        </div>
    </div>

    <div class="okm-row">
        <div class="col-12 footer_copy">

            <div class="okm-row">
                <div class="col-xs-12 col-md-6 col-lg-4 " style="text-align:center">
                    <a href="{$url}Mentions_legales_et_CGUSV.pdf"  rel="nofollow"  target="_blank" title="Conditions d’utilisation des services">Conditions d’utilisation des services</a>
                </div>

                <div class="col-xs-12 col-md-6 col-lg-4 footer-copy text-right"><small>Copyright © {$smarty.now|date_format:"%Y"} WorknCare Tous droits réservés</small></div>
                <div class="col-xs-12 col-md-6 col-lg-4 " style="text-align:center">                    
                    <a href="{$url}Notice_d_information_et_de_consentement_DP.pdf"  rel="nofollow" target="_blank" title="Notice d’information et de consentement">Notice d’information et de consentement</a>
                </div>
            </div>   

        </div>
    </div>
</div>
