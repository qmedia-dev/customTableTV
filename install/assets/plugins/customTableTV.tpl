/**
 * customTabletV
 * 
 * Create TV with custom table inside
 *
 * @category 	plugin
 * @version 	1.0.0
 * @license 	http://www.gnu.org/copyleft/gpl.html GNU Public License (GPL)
 * @internal	@properties &settings=TV settings;textarea;
 * @internal	@events OnDocFormRender
 * @internal    @legacy_names customTabletV
 * @internal    @installset base
 */

$settings = isset($settings) ? $settings : [];

/*

--------------------
$settings:
--------------------
[{
	"tvId": 0,
	"rows": "rowsTestPrepare",
	"columns": "columnsTestPrepare"
},
{
	"tvId": 0,
	"rows": "rowsTestPrepare"
}]

--------------------
Prepare должен возвращать:
--------------------
[
	'__id__' => [ 'title' => '____', 'defaultValue' => '____' ],
	'__id__' => [ 'title' => '____', 'defaultValue' => '____' ]
]
*/

$e = &$modx->Event;
if ($e->name == 'OnDocFormRender') {
$output = <<< OUT
<!-- TvTable -->
<script type="text/javascript">
// Обработанные настройки
const settings = [
  // только строки
  {
    tvId: 0,
    rows: {
      0: { title: 'row 0', defaultValue: 'row 0 defaultValue' },
      1: { title: 'row 1', defaultValue: 'row 1 defaultValue' },
    },
  },

  // строки + колонки
  {
    tvId: 1,
    rows: {
      0: { title: 'row 0' },
      1: { title: 'row 1' },
    },
    columns: {
      0: { title: 'column 0', defaultValue: 'column 0 defaultValue' },
      1: { title: 'column 1', defaultValue: 'column 1 defaultValue' },
      2: { title: 'column 2', defaultValue: 'column 2 defaultValue' },
      3: { title: 'column 3', defaultValue: 'column 3 defaultValue' },
    },
  },
];

const customTableTV = class {
  constructor(tvField, rows, columns) {
    this.tvField = tvField;
    this.rows = rows || [];
    this.columns = columns || null;

    tvField.style.display = 'none';

    const box = document.createElement('table');
    tvField.parentElement.append(box);

    this.box = box;

    this.initialValue();
    this.renderHeader();
    this.renderRows();
  }

  renderRows() {
    const { rows, columns, box } = this;
    Object.entries(rows).forEach(([rowKey, { title, defaultValue }]) => {
      const row = document.createElement('tr');
      box.append(row);

      const firstColumn = document.createElement('td');
      row.append(firstColumn);
      firstColumn.style.padding = '4px';
      firstColumn.style.verticalAlign = 'middle';
      firstColumn.style.whiteSpace = 'nowrap';
      firstColumn.style.background = '#f0f0ee';
      firstColumn.textContent = title;

      if (!columns) {
        const singleColumn = document.createElement('td');
        singleColumn.style.padding = '4px';
        row.append(singleColumn);

        const singleinput = document.createElement('input');
        singleinput.type = 'text';
        singleinput.placeholder = defaultValue;
        singleinput.value = this.getValue(rowKey);
        singleColumn.append(singleinput);

        singleinput.addEventListener('change', (e) => {
          const { value } = e.target;
          this.setValue(value, rowKey);
        });

        singleinput.addEventListener('input', (e) => {
          const { value } = e.target;
          this.setValue(value, rowKey);
        });
        return;
      }

      Object.entries(columns).forEach(([columnKey, { defaultValue }]) => {
        const column = document.createElement('td');
        column.style.padding = '4px';
        row.append(column);

        const input = document.createElement('input');
        input.type = 'text';
        input.placeholder = defaultValue;
        input.value = this.getValue(rowKey, columnKey);
        column.append(input);

        input.addEventListener('change', (e) => {
          const { value } = e.target;
          this.setValue(value, rowKey, columnKey);
        });

        input.addEventListener('input', (e) => {
          const { value } = e.target;
          this.setValue(value, rowKey, columnKey);
        });
      });
    });
  }

  renderHeader() {
    const { columns, box } = this;
    if (!columns) return;

    const header = document.createElement('tr');
    box.append(header);

    const firstColumn = document.createElement('td');
    firstColumn.style.padding = '4px';
    firstColumn.style.verticalAlign = 'middle';
    firstColumn.style.whiteSpace = 'nowrap';
    firstColumn.style.background = '#f0f0ee';
    header.append(firstColumn);

    Object.values(columns).forEach(({ title }) => {
      const column = document.createElement('td');
      column.textContent = title;
      column.style.padding = '4px';
      column.style.verticalAlign = 'middle';
      column.style.whiteSpace = 'nowrap';
      column.style.background = '#f0f0ee';
      header.append(column);
    });
  }

  initialValue() {
    const { tvField, rows, columns } = this;
    const json = tvField.value ? JSON.parse(tvField.value) : {};

    Object.entries(rows).forEach(([rowKey, { defaultValue }]) => {
      if (!columns) {
        const rowValue = json[rowKey] ? json[rowKey].value : '';

        json[rowKey] = {
          value: rowValue,
          defaultValue: defaultValue || '',
        };
        return;
      }

      json[rowKey] = json[rowKey] ? json[rowKey] : {};

      Object.entries(columns).forEach(([columnKey, { defaultValue }]) => {
        const columnValue = json[rowKey][columnKey] ? json[rowKey][columnKey].value : '';

        json[rowKey][columnKey] = {
          value: columnValue,
          defaultValue: defaultValue || '',
        };
      });
    });

    tvField.value = JSON.stringify(json);
  }

  setValue(value, row, column = null) {
    const { tvField } = this;
    const json = JSON.parse(tvField.value);

    if (!column) {
      json[row].value = value;
    } else {
      json[row][column].value = value;
    }

    tvField.value = JSON.stringify(json);
  }

  getValue(row, column = null) {
    const { tvField } = this;
    const json = JSON.parse(tvField.value);

    if (!column) return json[row].value;

    return json[row][column].value;
  }
};

document.addEventListener('DOMContentLoaded', function () {
  settings.forEach(({ tvId, rows, columns }) => {
    const tvField = document.querySelector('#tv' + tvId);
    if (tvField) new customTableTV(tvField, rows, columns);
  });
});

</script>
<!-- /TvTable -->
OUT;
$e->output($output);
}
