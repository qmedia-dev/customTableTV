<?php

include_once __DIR__.'/controllers/Controller.php';
use EvolutionCMS\Plugins\CustomTable\Controller;

$settings = json_decode($settings) ?? [];

$e = evolutionCMS()->event;
if ($e->name == "OnDocFormRender") {
    $controller = Controller::getInstance()
        ->setConfig($settings)
        ->run();
    $data = $controller->toString();

    $e->output($data);
}