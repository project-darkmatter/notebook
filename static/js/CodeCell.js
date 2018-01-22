
class IEditor {
  constructor(create, getText, setCtrlSpace) {
    this.create = create;
    this.getText = getText;
    this.setCtrlSpace = setCtrlSpace;
  }
}

let __IEditor__ = null;

class CodeCell {
  constructor(client, parent) {
    this.client = client;
    this.element = CodeCell.__container__();
    parent.appendChild(this.element);
    this.editor = CodeCell.__editor__(this.element);
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

  static __editor__(parent) {
    let elm = document.createElement('textarea');
    elm.classList.add('dm-editor');
    parent.appendChild(elm);
    return __IEditor__.create(elm);
  }

  initEditor() {
    __IEditor__.setCtrlSpace(this.editor, this.send.bind(this));
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
        if (json.result.content.status === 'RUNNING') {
          console.log(json.result.content);
          setTimeout(this.receive.bind(this), 10);
        } else {
          console.log(json.result.content.status);
          console.log(json.result.content.value);
          console.log(json.result.content.output);
        }
      } else {
        console.error(json);
      }
    });
  }
}
