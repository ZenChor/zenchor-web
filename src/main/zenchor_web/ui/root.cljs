(ns zenchor-web.ui.root
  (:require
    [fulcro.client.dom :as dom :refer [div]]
    [fulcro.client.primitives :as prim :refer [defsc]]
    [zenchor-web.ui.components :as comp]))

(defsc Root [this {:keys [root/message]}]
  {:query         [:root/message]
   :initial-state {:root/message "Hello!"}}
  (div :.ui.segments
    (div :.ui.top.attached.segment
      (div :.content
        "Welcome to Fulcro!"))
    (div :.ui.attached.segment
      (div :.content
        (comp/ui-placeholder {:w 50 :h 50})
        (div message)
        (div "Some content here would be nice.")))))
