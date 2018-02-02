
class CellList {
  constructor(client) {
    this.client = client;
    this.element = document.createElement('div');
    this.nodes = [];
  }

  insert(cell, pos = null) {
    if (pos !== null && pos < this.nodes.length) {
      let next = nodes[pos];
      this.nodes.splice(pos, 0, cell);
      this.element.insertBefore(nodes[next].element, cell.element);
    } else {
      this.nodes.push(cell);
      this.element.appendChild(cell.element);
    }
  }
}

