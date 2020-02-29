(ns monitoring.etc.graphite
  (:require [riemann.config :refer :all]))

(defn add-environment-to-graphite [event] (str "productiona.hosts
  .", (riemann.graphite/graphite-path-percentiles event)))

(def graph (async-queue! :graphite {:queue-size 1000}
            (graphite {:host (System/getenv "GRAPHITE_HOST") :path add-environment-to-graphite})))
