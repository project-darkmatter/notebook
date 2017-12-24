
const DarkmatterError = {
  INITIALIZATION_FAILED: Symbol("Initialization Failed"),
  DEAD_SERVER: Symbol("Server is Dead")
};

class Darkmatter {
  constructor(host, clientId, descripter) {
    this.host = host;
    this.httpUri = `http://${host}`;
    this.clientId = cliendId;
    this.descripter = descripter;
    this.token = null;
  }

  sendTCP(request) {
    console.log("[UP] " + request);
    return new Promise((resolve, reject) => {
      http.put(this.httpUri + '/eval/', request).then(json => {
        console.log("[DOWN] Resolve " + json);
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
        if (json.id && json.id !== this.id) {
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
    const request = EvalClient.makeRequest('darkmatter/eval', {
      code: code,
      outputRendering: outputRendering,
      cellId: cellId,
      optional: optional
    }, this.id, this.descripter);
    return this.request(request);
  }

}
