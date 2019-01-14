(ns zenchor-web.workspaces
  (:require
    [nubank.workspaces.core :as ws]
    [zenchor-web.demo-ws]))

(defonce init (ws/mount))
