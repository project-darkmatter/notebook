
class ErrorOutput {
  constructor(base, parent = null) {
    this.element = ErrorOutput.__container__();
    switch (typeof base) {
      case "string":
        this.traceback = base;
        parent.appendChild(this.element);
        break;
      case "object":
        this.traceback = base.innerText;
        base.parentNode.replaceChild(this.element, base);
        break;
    }
    let nodes = ErrorOutput.__traceback__(this.traceback);
    for (let node of nodes) {
      this.element.appendChild(node);
    }
  }

  static __container__() {
    let elm = document.createElement("div");
    elm.style.overflowX = 'scroll';
    elm.classList.add("dm-error-output");
    return elm;
  }

  static __traceback__(text) {
    return CSIToHTML(text);
  }
}
