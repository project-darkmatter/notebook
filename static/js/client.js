
const DarkmatterError = {
  INITIALIZATION_FAILED: Symbol("Initialization Failed"),
  DEAD_SERVER: Symbol("Server is Dead")
};

class Darkmatter {
  constructor(host, clientId, descripter) {
    this.host = host;
    this.httpUri = `http://${host}`;
    this.clientId = clientId;
    this.descripter = descripter;
    this.token = null;
  }

  static makeRequest(method, params, clientId = null, descripter = "default") {
    let object = {
      "jsonrpc": "2.0",
      "method": method,
      "params": params,
      "descripter": descripter
    };
    if (clientId != null) {
      object.id = clientId;
    }
    return JSON.stringify(object);
  }

  sendTCP(request) {
    console.log("[UP] " + request);
    return new Promise((resolve, reject) => {
      let uri = this.httpUri + '/api/';
      console.log("[UP] Send request to " + uri);
      http.put(uri, request).then(json => {
        console.log("[DOWN] Resolve " + JSON.stringify(json));
        resolve(json);
      }).catch(err => {
        console.log("[DOWN] Reject");
        reject(DarkmatterError.DEAD_SERVER);
      });
    });
  }

  requestUntilSuccessful(request, trueResolve, trueReject) {
    console.log("[UP] Try request...");
    let proc = this.sendTCP.bind(this);
    proc(request)
      .then(json => {
        if (json.id && json.id !== this.clientId) {
          trueReject(new Error("INVALID_ID"));
        } else {
          trueResolve(json);
        }
      })
      .catch(err => {
        console.log(`[DOWN] Request failed (${String(err)})`);
      });
  }

  request(request) {
    return new Promise((resolve, reject) => {
      this.requestUntilSuccessful(request, resolve, reject);
    });
  }


  init(plugins, defaultPackage, trace) {
    console.log("[UP] Initialize server instance on " + this.httpUri);
    const request = Darkmatter.makeRequest('darkmatter/initialize', {
      initializeOptions: {
        plugins: plugins,
        defaultPackage: defaultPackage
      },
      trace: trace
    }, this.id, this.descripter);
    return this.request(request);
  }

  eval(code, cellId, outputRendering = true, optional = null) {
    const request = Darkmatter.makeRequest('darkmatter/eval', {
      code: code,
      outputRendering: outputRendering,
      cellId: cellId,
      optional: optional
    }, this.clientId, this.descripter);
    return this.request(request);
  }

  getResult(taskId, cellId, outputRendering = true, optional = null) {
    const request = Darkmatter.makeRequest('darkmatter/getResult', {
      taskId: taskId
    }, this.clientId, this.descripter);
    return this.request(request);
  }

}
