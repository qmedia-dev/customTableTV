//<?php
/**
 * customTableTV
 * 
 * Create TV with custom table inside
 *
 * @category 	plugin
 * @version 	1.0.0
 * @license 	http://www.gnu.org/copyleft/gpl.html GNU Public License (GPL)
 * @internal	@properties &settings=TV settings;textarea;
 * @internal	@events OnDocFormRender
 * @internal    @legacy_names customTableTV
 * @internal    @installset base
 */

$_CTTV_BASE = 'assets/plugins/customtvtable/';

$_CTTV_URL = MODX_SITE_URL . $_CTTV_BASE;

require(MODX_BASE_PATH. $_CTTV_BASE .'customtvtable.plugin.php');
