{
  :en => {
    :time => {
      :formats => {
        :shorter => lambda { |time, _| "#{time.day.ordinalize}, %H:%M" }
      }
    }
  }
}