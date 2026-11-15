package api

import (
	_ "embed"
	"net/http"
)

// openapiSpec is the full API spec embedded at build time so the binary is
// self-contained and does not need the source tree at runtime.
//
//go:embed openapi.yaml
var openapiSpec []byte

// swaggerUIHTML is the smallest useful Swagger UI page.
// Loads the UI assets from unpkg at runtime, then points them at our own
// /openapi.yaml endpoint. No build step needed.
const swaggerUIHTML = `<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="utf-8" />
	<title>Ancient Dynasties API</title>
	<meta name="viewport" content="width=device-width, initial-scale=1" />
	<link rel="stylesheet" type="text/css" href="https://unpkg.com/swagger-ui-dist@5/swagger-ui.css" />
	<style>
		body { margin: 0; background: #fafafa; }
	</style>
</head>
<body>
	<div id="swagger-ui"></div>
	<script src="https://unpkg.com/swagger-ui-dist@5/swagger-ui-bundle.js" charset="utf-8"></script>
	<script>
		window.ui = SwaggerUIBundle({
			url: '/openapi.yaml',
			dom_id: '#swagger-ui',
			deepLinking: true,
			tryItOutEnabled: true,
		});
	</script>
</body>
</html>
`

// serveOpenAPISpec responds with the embedded openapi.yaml as application/yaml.
func (a *API) serveOpenAPISpec(w http.ResponseWriter, _ *http.Request) {
	w.Header().Set("Content-Type", "application/yaml; charset=utf-8")
	_, _ = w.Write(openapiSpec)
}

// serveDocs responds with the Swagger UI page that renders the spec interactively.
func (a *API) serveDocs(w http.ResponseWriter, _ *http.Request) {
	w.Header().Set("Content-Type", "text/html; charset=utf-8")
	_, _ = w.Write([]byte(swaggerUIHTML))
}
