# gossamer-mode.el

Emacs major mode for Gossamer. Font-lock keywords, comments, basic
indentation. No LSP integration yet.

## Install (manual)

```elisp
(add-to-list 'load-path "/path/to/gossamer-site/editors/emacs")
(require 'gossamer-mode)
```

## Install (use-package + straight.el)

```elisp
(use-package gossamer-mode
  :straight (:host github
             :repo "gossamer-lang/gossamer-site"
             :files ("editors/emacs/gossamer-mode.el"))
  :mode "\\.gos\\'")
```

`.gos` files autoload into `gossamer-mode`.
