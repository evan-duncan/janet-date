(declare-project
  :name "janet-date"
  :author "Evan Duncan"
  :license "MIT"
  :description ```Date functions for Janet ```
  :version "0.0.0"
  :dependencies [
    {:url "https://github.com/ianthehenry/judge.git"
     :tag "v2.3.1"}
  ])

(declare-source :source ["date.janet"])
