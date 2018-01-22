
class IEditor {
  constructor(create, getText, setText, setCtrlSpace) {
    this.create = create;
    this.getText = getText;
    this.setText = setText;
    this.setCtrlSpace = setCtrlSpace;
  }
}

let __IEditor__ = null;

class CodeCell {
  constructor(client, parent, oldChild = null) {
    this.client = client;
    if (oldChild) {
      this.element = oldChild.parentNode;
    } else {
      this.element = CodeCell.__container__();
    }
    parent.appendChild(this.element);
    this.editor = CodeCell.__editor__(this.element, oldChild);
    if (oldChild) {
      __IEditor__.setText(this.editor, oldChild.innerText);
    }
    this.output = null;
    this.active = true;
    this.taskId = null;
    this.initEditor();
  }

  static __container__() {
    let elm = document.createElement('li');
    elm.classList.add('ax-panel');
    elm.classList.add('ax-normal');
    elm.setAttribute('w-1-2', '');
    elm.setAttribute('center', '');
    return elm;
  }

  static __editor__(parent, oldChild = null) {
    let elm = document.createElement('textarea');
    elm.classList.add('dm-editor');
    if (oldChild) {
      parent.replaceChild(elm, oldChild);
    } else {
      parent.appendChild(elm);
    }
    return __IEditor__.create(elm);
  }

  static __output__() {
    let elm = document.createElement('pre');
    elm.classList.add('ax-container');
    elm.classList.add('ax-normal');
    return elm;
  }

  initEditor() {
    __IEditor__.setCtrlSpace(this.editor, this.send.bind(this));
  }

  initOutput() {
    if (this.output === null) {
      this.output = CodeCell.__output__();
      this.element.appendChild(this.output);
    }
  }

  send() {
    let code = __IEditor__.getText(this.editor);
    this.active = false;
    this.client.eval(code, 0).then(json => {
      this.active = true;
      this.taskId = json.result.taskId;
      this.receive();
    });
  }

  receive() {
    this.client.getResult(this.taskId, 0).then(json => {
      if (json.result.status) {
        switch (json.result.content.status) {
          case 'SUCCESS':
            this.initOutput();
            this.output.innerHTML = json.result.content.value + '\n' + json.result.content.output;
            break;
          case 'RUNNING':
            this.initOutput();
            this.output.innerHTML = "\n" + json.result.content.output;
            setTimeout(this.receive.bind(this), 1000);
            break;
          case 'FAILURE':
            this.initOutput();
            this.output.innerHTML = json.result.content.output + '\n' + JSON.stringify(json.result.content.context);
            break;
        }
      } else {
        console.error(json);
      }
    });
  }
}
