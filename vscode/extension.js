// Minimal LSP client wiring for the Gossamer language server.
//
// Activation only triggers on `.gos` buffers. If `gossamer-lsp` is not
// on PATH the start attempt fails silently and the TextMate grammar
// continues to provide syntax highlighting.

const path = require("path");

let client;

async function activate(context) {
  let lc;
  try {
    lc = require("vscode-languageclient/node");
  } catch (_) {
    // vscode-languageclient not installed; LSP support is opt-in.
    // Run `npm install` in the extension directory to enable it.
    return;
  }

  const config = require("vscode").workspace.getConfiguration("gossamer");
  const command = config.get("lsp.command", "gos");
  const args = config.get("lsp.args", ["lsp"]);

  const serverOptions = {
    run: { command, args, transport: lc.TransportKind.stdio },
    debug: { command, args, transport: lc.TransportKind.stdio },
  };

  const clientOptions = {
    documentSelector: [{ scheme: "file", language: "gossamer" }],
    synchronize: {
      configurationSection: "gossamer",
    },
  };

  client = new lc.LanguageClient(
    "gossamer-lsp",
    "Gossamer Language Server",
    serverOptions,
    clientOptions,
  );

  await client.start();
}

function deactivate() {
  if (!client) return undefined;
  return client.stop();
}

module.exports = { activate, deactivate };
