#!/usr/bin/env hy

(import [flask [Flask]])


;; Change the interpreter executable.
;; Werkzeug will now run Hy instead of Python on restarts.
;; This should work as long as "hy" is in the path.
(import sys)
(setv sys.executable "hy")


(def app (Flask __name__))
(setv app.debug True)

(with-decorator (app.route "/")
    (defn get-index []
        (str "Hello World!")))


;; Run the app, but also restart when this file changes:
(kwapply (app.run) {"extra_files" __file__})

