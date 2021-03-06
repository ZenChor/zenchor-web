(ns zenchor-web.server-components.http-server
  (:require
    [zenchor-web.server-components.config :refer [config]]
    [zenchor-web.server-components.middleware :refer [middleware]]
    [mount.core :refer [defstate]]
    [org.httpkit.server :as http-kit]))

(defstate http-server
  :start (http-kit/run-server middleware (:http-kit config))
  :stop (http-server))
