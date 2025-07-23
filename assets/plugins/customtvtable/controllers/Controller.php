<?php

namespace EvolutionCMS\Plugins\CustomTable;

use EvolutionCMS\Gateway\Helpers\CustomTableHelper;
use EvolutionCMS\Gateway\Models\Evo\SiteContent;

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
        $this->path = __DIR__ . "/../";
        $this->path = str_replace(evo()->getConfig('base_path'), "", $this->path);
    }

    /**
     * @return Controller
     */
    public static function getInstance(): object
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
    public function __wakeup()
    {
    }

    /**
     * @param int $docId
     * @param array $config
     * @return object
     */
    public function setConfig(int $docId, array $config = []): object
    {
        if (!empty($config)) {
            foreach ($config as $item_key => $item) {
                $docHasTv = !empty($item->tvId);

                if ($docHasTv) {
                    if (!empty($item->rows)) {
                        $item->rows = $this->processConfigPrepares(trim($item->rows), $docId);
                    }

                    if (!empty($item->columns)) {
                        $item->columns = $this->processConfigPrepares(trim($item->columns), $docId);
                    }

                    $config[$item_key] = $item;
                }
            }
        }

        $this->config = $config;

        return $this;
    }

    /**
     * @param string $prepare
     * @param int $docId
     * @return array
     */
    protected function processConfigPrepares(string $prepare, int $docId): array
    {
        $result = [];
        $parentId = $_REQUEST['pid'] ?? 0;
        if (!empty($prepare)) {
            if (strpos($prepare, ',') === false) {
                $result = CustomTableHelper::$prepare($docId, $parentId);
                if (empty($result)) return [];
            }
        }

        return $result;
    }

    /**
     * @return object
     */
    public function run(): object
    {
        $this->data = [
            '<!-- customTabletV -->',
            '<link rel="stylesheet" href="/' . $this->path . 'styles.css">',
            '<script>let settings = ' . json_encode($this->config) . ';</script>',
            '<script src="/' . $this->path . 'scripts.js"></script>',
            '<!-- /customTabletV -->',
        ];

        return $this;
    }

    /**
     * @param string $separator
     * @return string
     */
    public function toString(string $separator = ''): string
    {
        return implode('', $this->data);
    }
}
