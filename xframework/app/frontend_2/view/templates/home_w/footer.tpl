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
        <div class="okm-row text-center">
            <span>{"¿Necesita ayuda?"|x_translate}</span>
        </div>
        <div class="okm-row">
            <div class="col-xs-12 col-sm-2 col-md-2 col-lg-2 footer-col"></div>
            <div class="col-xs-12 col-sm-4 col-md-4 col-lg-4 footer-col">
                <a href="mailto:support@workncare.io">
                    <figure><i class="icon-doctorplus-envelope"></i></figure>
                    <span>support@workncare.io</span>
                </a>
            </div>
            <div class="col-xs-12 col-sm-4 col-md-4 col-lg-4 footer-col">
                <figure><i class="icon-doctorplus-map-plus-rounded"></i></figure>
                <span>2 bld Henri Becquerel 57970, Yutz (France)</span>
                <span></span>
            </div>
        </div>

        <div class="okm-row partner-logo">

            <div class="social text-center">
                <a href="https://www.linkedin.com/company/passbienetre/" title="LinkedIn Pass bien-être" target="_blank">
                    <i class="fa fa-linkedin" style="margin: 10px; font-size: 30px;"></i>
                </a>
            </div>
            <div class="social text-center">
                <a href="https://www.facebook.com/PassBienEtre/" title="Facebook Pass bien-être" target="_blank">
                    <i class="fa fa-facebook" style="margin: 10px; font-size: 30px;"></i>
                </a>
            </div>
            <div class="social text-center">
                <a href="https://www.instagram.com/passbienetre/" title="Instagram Pass bien-être" target="_blank">
                    <i class="fa fa-instagram" style="margin: 10px; font-size: 30px;"></i>
                </a>
            </div>
            <div class="social text-center">
                <a href="https://twitter.com/passbienetre"title="Twitter Pass bien-être" target="_blank">
                    <i class="fa fa-twitter" style="margin: 10px; font-size: 30px;"></i>
                </a>
            </div>

        </div>

    </div>
    <div class="okm-container okm-row">
        <div class="col-xs-12 col-md-6 col-lg-6 footer-col" style="text-align:center">
            <a href="{$url}Mentions_legales_et_CGUSV.pdf"  rel="nofollow"  target="_blank" title="Conditions d’utilisation des services">Conditions d’utilisation des services</a>
        </div>
        <div class="col-xs-12 col-md-6 col-lg-6 footer-col" style="text-align:center">                    
            <a href="{$url}Notice_d_information_et_de_consentement_DP.pdf"  rel="nofollow" target="_blank" title="Notice d’information et de consentement">Notice d’information et de consentement</a>
        </div>
    </div>
    <div class="okm-container okm-row text-center redes-sociales">



    </div>
    <div class="okm-row">
        <div class="footer-copy text-right"><small>Copyright © {$smarty.now|date_format:"%Y"} DoctorPlus Tous droits réservés</small></div>
    </div>
</div>
