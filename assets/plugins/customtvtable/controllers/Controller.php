<?php

namespace EvolutionCMS\Plugins\CustomTable;

class Controller
{
    /**
     * @var object|null
     */
    protected static ?object $_instance = null;

    /**
     * @var string
     */
    protected string $path;

    /**
     * @var array
     */
    protected array $config;

    /**
     * @var array
     */
    protected array $data = [];

    /**
     * Constructor
     */
    private function __construct()
    {
        $this->path = evo()->getConfig().'assets/plugins/customtabletv/';
    }

    /**
     * @return Controller
     */
    public static function getInstance() : object
    {
        if (self::$_instance === null) {
            self::$_instance = new self;
        }

        return self::$_instance;
    }

    /**
     * @return void
     */
    private function __clone()
    {

    }

    /**
     * @return void
     */
    private function __wakeup()
    {

    }

    /**
     * @param array $config
     * @return object
     */
    public function setConfig(array $config = []) : object
    {
        if(!empty($config)) {
            foreach ($config as $item_key => $item) {
                if(!empty($item->rows)) {
                    $item->rows = $this->processConfigPrepares(trim($item->rows));
                }
                if(!empty($item->columns)) {
                    $item->columns = $this->processConfigPrepares(trim($item->columns));
                }

                $config[$item_key] = $item;
            }
        }
        $this->config = $config;

        return $this;
    }

    /**
     * @param string $prepare
     * @return array
     */
    protected function processConfigPrepares(string $prepare) : array
    {
        $result = [];
        if(!empty($prepare)) {
            if(strpos($prepare, ',') === false) {
                $result = evo()->runSnippet($prepare);
                if(empty($result)) return [];
            }
        }

        return $result;
    }

    /**
     * @return object
     */
    public function run() : object
    {
        $this->data = [
            '<!-- customTabletV -->',
            '<link rel="stylesheet" href="/'.$this->path.'styles.css">',
            '<script>let settings = '.json_encode($this->config).';</script>',
            '<script src="/'.$this->path.'scripts.js"></script>',
            '<!-- /customTabletV -->',
        ];

        return $this;
    }

    /**
     * @param string $separator
     * @return string
     */
    public function toString(string $separator = '') : string
    {
        return implode('', $this->data);
    }
}