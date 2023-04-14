(use
 judge
 ../date)


(deftest "iso8601"
  (let [time 1681482992]
    (test (iso8601 time) "2023-04-14T14:36:32.000Z")
    (test (iso8601 (os/date time)) "2023-04-14T14:36:32.000Z")))

(deftest "parse-date"
  (let [parsed (parse-date "01-02-2023" "%m-%d-%Y")]
    (test (parsed :year) 2023)
    (test (+ 1 (parsed :month-day)) 2)
    (test (+ 1 (parsed :month)) 1)))

(deftest "add-duration"
  (test ((add-duration (parse-date "2023" "%Y")
                       (make-duration @{:year 10}))
         :year)
        2033))
