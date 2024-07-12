class SubHeaderService
  class << self
    def search(options = {})
      {
        event: "search",
        type: "search",
        filterKey: "common",
      }.merge(options)
    end

    def add(options = {})
      {
        icon: "fas sysait-circle-plus-l",
        tooltip: "add",
        event: 'new',
        data: options[:data].presence || { argument: options[:argument]}
      }
    end

    def print(options = {})
      {
        icon: "fas fa-print",
        tooltip: "print",
        event: 'print',
        data: {
          argument: options[:argument]
        }
      }
    end
  end
end