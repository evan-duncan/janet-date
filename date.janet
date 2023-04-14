
(defn- exec [cmd]
  (def command (string/split " " cmd))
  (def proc (os/spawn command :p {:in :pipe :out :pipe}))
  (def stdout (:read (proc :out) :all))
  (:wait proc)
  (string/trim stdout "\n"))


# TODO: Should this call a C library instead of trying to use a shell? Almost certainly.
(defn parse-date
  `Parse a given string described by the format into an os/date struct`
  [str format]
  (os/date
   (case (os/which)
     (or :macos :freebsd :openbsd :netbsd) (exec (string/join @["date" "-juf" format str "+%s"] " "))
     (or :posix :linux :cygwin) (exec (string/join @["date" "-d" str "+%s"] " "))
     (or :windows :mingw) (exec (string/join @[] " "))
     :web (error "I don't know how to call Date.parse but it would be cool")
     :else (error "Unhandled operating system"))))


(defn iso8601
  `Format os/time numbers and os/date structs into the ISO-8601 format`
  [time-or-date]
  (let [fmt-fn (fn [d] (string/format "%4d-%02d-%02dT%02d:%02d:%02d.000Z"
                                      (d :year)
                                      (+ 1 (d :month))
                                      (+ 1 (d :month-day))
                                      (d :hours)
                                      (d :minutes)
                                      (d :seconds)))]
    (case (type time-or-date)
      :number (fmt-fn (os/date time-or-date false))
      :struct (fmt-fn time-or-date))))


(defn- merge-with [f & colls]
  (reduce2
   (fn [accum el]
     (loop [[k v] :in (pairs el)]
       (if (in accum k)
         (put accum k (f (get accum k) v))
         (put accum k v)))
     accum)
   colls))


(def Duration
  @{:type "Duration"
    :date @{}
    :add (fn [self date]
           (merge-with + (get self :date) date))})

(defn make-duration [&opt date]
  (default date @{})
  (table/setproto @{:date date} Duration))

(defn add-duration [date duration]
  (:add duration (struct/to-table date))
  (table/to-struct (get duration :date)))
