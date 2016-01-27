window.editor.on('change', function(instance, change) {
  window.webkit.messageHandlers.notification.postMessage({
    event: 'updateProperty',
    property: 'text',
    value: window.editor.doc.getValue()
  });
});

window.editor.on('cursorActivity', function(instance) {
  window.webkit.messageHandlers.notification.postMessage({
    event: 'updateProperty',
    property: 'cursor',
    value: window.editor.doc.indexFromPos(window.editor.doc.getCursor())
  });
});

window.onload = function () {
  window.webkit.messageHandlers.notification.postMessage({
    event: 'loaded'
  });
};
