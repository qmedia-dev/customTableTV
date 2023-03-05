const customTableTV = class {
  constructor(tvField, rows, columns) {
    this.tvField = tvField;
    this.rows = rows || [];
    this.columns = columns || null;

    tvField.style.display = 'none';

    const box = document.createElement('table');
    box.classList.add('custom-table');
    tvField.parentElement.append(box);

    this.box = box;

    this.initialValue();
    this.renderHeader();
    this.renderRows();
  }

  renderRows() {
    const { rows, columns, box } = this;
    Object.entries(rows).forEach(([rowKey, { title, defaultValue: rowDefualt }]) => {
      const row = document.createElement('tr');
      box.append(row);

      const firstColumn = document.createElement('td');
      firstColumn.classList.add('title');
      firstColumn.textContent = title;
      row.append(firstColumn);

      if (!columns) {
        const singleColumn = document.createElement('td');
        row.append(singleColumn);

        const singleinput = document.createElement('input');
        singleinput.type = 'text';
        singleinput.placeholder = rowDefualt || '';
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

      Object.entries(columns).forEach(([columnKey, { defaultValue: columnDefault }]) => {
        const column = document.createElement('td');
        row.append(column);

        const input = document.createElement('input');
        input.type = 'text';
        input.placeholder = columnDefault ? columnDefault : rowDefualt || '';
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
    firstColumn.classList.add('title');
    header.append(firstColumn);

    Object.values(columns).forEach(({ title }) => {
      const column = document.createElement('td');
      column.classList.add('title');
      column.textContent = title;
      header.append(column);
    });
  }

  initialValue() {
    const { tvField, rows, columns } = this;
    const json = tvField.value ? JSON.parse(tvField.value) : {};

    Object.keys(rows).forEach((rowKey) => {
      if (!columns) {
        json[rowKey] = json[rowKey] || '';
        return;
      }

      json[rowKey] = json[rowKey] ? json[rowKey] : {};

      Object.keys(columns).forEach((columnKey) => {
        json[rowKey][columnKey] = json[rowKey][columnKey] || '';
      });
    });

    tvField.value = JSON.stringify(json);
  }

  setValue(value, row, column = null) {
    const { tvField } = this;
    const json = JSON.parse(tvField.value);

    if (!column) {
      json[row] = value;
    } else {
      json[row][column] = value;
    }

    tvField.value = JSON.stringify(json);
  }

  getValue(row, column = null) {
    const { tvField } = this;
    const json = JSON.parse(tvField.value);

    if (!column) return json[row];

    return json[row][column];
  }
};

document.addEventListener('DOMContentLoaded', () => {
  settings.forEach(({ tvId, rows, columns }) => {
    const tvField = document.querySelector(`#tv${tvId}`);
    if (tvField) new customTableTV(tvField, rows, columns);
  });
});
