{$url}xframework/translate/{$translation_file}?v={$smarty.now|date_format:"%j"};
{$url_js_core}/x_ajax.js;
{$url_js_core}/x_crypt.js;
{$url_js_core}/x_form.js?v={$smarty.now|date_format:"%j"};
{$url_js_core}/x_string.js;
{$url_js_core}/x_functions.js;
{$url_js_core}/x_screen.js;
{$url_js_libs}/jqconfirm/jquery-confirm.min.js;
{$url_js_libs}/Flat-UI-master/js/radiocheck.js;
{$url_js_libs}/Flat-UI-master/dist/js/flat-ui.min.js;
{$url_js_libs}/jquery/spin/spin.min.js;
{$url_js_libs}/jquery/spin/jquery.spin.js;
{$url_js_libs}/slick/slick.min.js;
{if $submodulo!="index"}

    {$url_js_libs}/bootstrap-datepicker/moment/moment.min.js;
    {$url_js_libs}/bootstrap-datepicker/js/bootstrap-datetimepicker.min.js;
    {$url_js_libs}/bootstrap-datepicker/js/locales/bootstrap-datetimepicker.fr.js;
    {$url_js_libs}/jquery.bxslider/jquery.bxslider.js;
    {$url_js_libs}/autosuggest/jquery.autocomplete.js;
    {$url_js_libs}/jquery.bxslider/jquery.bxslider.js;
    {$url_js_libs}/closify/js/jquery-ui.min.js;

    {$url_js_libs}/jquery.cookieMessage.min.js;


    {$url_js_libs}/bootbox/bootbox.min.js;

    {$url_js_libs}/jquery/summernote/summernote.min.js;
    {$url_js_libs}/jquery/jquery-validation/jquery.validate.min.js;
    {$url_js_libs}/jquery/jquery-validation/additional-methods.min.js;
    {$url_js_libs}/jquery/jquery-validation/localization/messages_es.js;
    {$url_js_libs}/jquery/jquery.inputmask/jquery.inputmask.bundle.min.js;
    {$url_js_libs}/jQuery-Mask/dist/jquery.mask.min.js;
    {$url_js_libs}/jquery/jquery.clearform/jquery.clearform.js;
    {$url_js_libs}/autosuggest/jquery.autocomplete.js;

    {$url_js_libs}/tags_input/bootstrap-tagsinput.min.js;
    {$url_js_libs}/closify/js/closify-min.js;
    {$url_js_libs}/jquery/modernizr.custom.js;
    {$url_js_libs}/jquery/jquery.dlmenu.js;
    {$url_js_libs}/jquery/jquery.blockUI.js;
    {$url_js_libs}/select2-4.0.0/dist/js/select2.min.js;

    {$url_js_libs}/dropzone/dropzone.js?v=2;

    {$url_js_libs}/lightbox/js/lightbox-2.6.min.js;
    {$url_js_libs}/featherlight/featherlight.min.js;
    {$url_js_libs}/featherlight/featherlight.gallery.min.js;
    {$url_js_libs}/jquery/cropper-master/dist/cropper.min.js;
    {$url_js_libs}/scrollbars/jquery.mCustomScrollbar.concat.min.js;
    {$url_js_libs}/countid/countid.js;
    {$url_js_libs}/typeahead/typeahead.bundle.js;
    {$url_js_libs}/Strength.js-master/src/strength.js;
    {$url_js_libs}/enquire.min.js;
    {$url_js_libs}/coco/assets/libs/jquery-wizard/jquery.easyWizard.js;
    {$url_js_libs}/intl-tel-input/build/js/intlTelInput.js;
    {$url_js_libs}/intl-tel-input/build/js/utils.js;
    {$url_js_libs}/gpopover/jquery.gpopover.js;
    {*

    {$url_js_libs}/intl-tel-input-master/build/js/utils.js;*}
    {*{$url_js_libs}/whatsapp/floating-wpp.min.js;*}
{/if}
