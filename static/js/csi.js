
const escapeSequenceRegExp = /\u001b\[(\d+(?:;\d+)*)m/;

function CSIToHTML(str) {
  let fg = 'inherit';
  let bg = 'inherit';
  let bold = false;
  let italic = false;
  let underline = false;
  let blink = false;
  let lineThrough = false;
  let list = [];
  let rest = str;

  while(rest.length > 0) {
    let index = rest.search(escapeSequenceRegExp);
    if (index === 0) {
      let result = rest.match(escapeSequenceRegExp);
      rest = rest.slice(result[0].length);
      let options = result[1].split(';');
      for (let option of options) {
        switch (option) {
          case '0':
            fg = 'inherit';
            bg = 'inherit';
            bold = false;
            italic = false;
            underline = false;
            blink = false;
            lineThrough = false;
            break;
          case '1':
            bold = true;
            break;
          case '3':
            italic = true;
            break;
          case '4':
            underline = true;
            break;
          case '5':
            blink = true;
            break;
          case '9':
            lineThrough = true;
            break;
          case '30':
            fg = 'black';
            break;
          case '31':
            fg = 'red';
            break;
          case '32':
            fg = 'green';
            break;
          case '33':
            fg = 'yellow';
            break;
          case '34':
            fg = 'blue';
            break;
          case '35':
            fg = 'magenta';
            break;
          case '36':
            fg = 'cyan';
            break;
          case '37':
            fg = 'white';
            break;
          case '39':
            fg = 'inherit';
            break;
        }
      }
    } else {
      let text;
      if (index >= 0) {
        text = rest.slice(0, index);
        rest = rest.slice(index);
      } else {
        text = rest;
        rest = "";
      }
      if (text.length > 0) {
        let elm = document.createElement('span');
        elm.style.whiteSpace = 'nowrap';
        elm.innerText = text;
        elm.style.color = fg;
        elm.style.backgroundColor = bg;
        if (bold) elm.style.fontWeight = 'bold';
        if (italic) elm.style.fontStyle = 'italic';
        if (underline) elm.style.textDecoration = 'underline';
        if (lineThrough) elm.style.textDecoration = 'line-through';
        if (blink) elm.style.textDecoration = 'blink';
        list.push(elm);
      }
    }
  }
  return list;
}

function replaceCSI(elm) {
  let container = document.createElement('span');
  container.style.overflowX = 'scroll';
  let results = CSIToHTML(elm.innerText);
  for (let result of results) {
    container.appendChild(result);
  }
  elm.parentNode.replaceChild(container, elm);
}
