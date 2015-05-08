{
  :en => {
    :time => {
      :formats => {
        :shorter => lambda { |time, _| "%b #{time.day.ordinalize}, %H:%M" }
      }
    }
  }
}