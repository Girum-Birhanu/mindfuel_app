const http = require('http');
const httpProxy = require('http-proxy');

// Create a proxy server with custom application logic
const proxy = httpProxy.createProxyServer({
  target: 'https://api.synheart.ai',
  secure: true,
  changeOrigin: true
});

// To modify the proxy connection before data is sent, you can listen
// for the 'proxyReq' event. When the event is fired, you will receive
// the following arguments:
// (http.ClientRequest proxyReq, http.IncomingMessage req,
//  http.ServerResponse res, Object options). This mechanism is useful when
// you need to modify the proxy request before the proxy connection
// is made to the target.
proxy.on('proxyReq', function(proxyReq, req, res, options) {
  // Inject the Tenant ID and Project ID headers!
  proxyReq.setHeader('X-Synheart-Tenant', 'tnt_f4d631cf');
  proxyReq.setHeader('X-Synheart-Project', 'prj_7799f740');
  
  // Also inject the API Key just in case the SDK drops it in unsigned mode
  proxyReq.setHeader('X-API-Key', 'synheart_sk_live_6UjYu5JQdVI8FGQjNC7NHIoFon9aoU9J0w-k8hMxu6M');
  
  console.log(`[PROXY] Forwarding ${req.method} ${req.url}`);
});

proxy.on('proxyRes', function (proxyRes, req, res) {
  let body = [];
  proxyRes.on('data', function (chunk) {
    body.push(chunk);
  });
  proxyRes.on('end', function () {
    body = Buffer.concat(body).toString();
    console.log(`[PROXY] Response from Synheart: ${proxyRes.statusCode} - ${body}`);
  });
});

proxy.on('error', function (err, req, res) {
  console.error('[PROXY ERROR]', err);
  res.writeHead(500, {
    'Content-Type': 'text/plain'
  });
  res.end('Something went wrong. And we are reporting a custom error message.');
});

const server = http.createServer(function(req, res) {
  proxy.web(req, res);
});

console.log("Synheart Proxy Server listening on port 8083");
console.log("Forwarding to https://api.synheart.ai and injecting X-Synheart-Tenant: tnt_f4d631cf");
server.listen(8083);
