
__IEditor__ = new IEditor(
  elm => {
    let editor = CodeMirror.fromTextArea(elm, {
      mode: 'commonlisp',
      lineNumbers: true,
      indentUnit: 2,
      matchBrackets: true,
      viewportMargin: Infinity
    });
    editor.setSize("100%", "auto");
    return editor;
  },
  editor =>
    editor.getValue(),
  (editor, fun) => {
    editor.setOption("extraKeys", {
      "Ctrl-Enter": fun
    });
  }
);

