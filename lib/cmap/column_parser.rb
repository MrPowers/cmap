module Cmap; class ColumnParser

  DETECT_KEY = "_:_"

  def initialize(original_name)
    @original_name = original_name
  end

  def column
    parse_input(:first, @original_name)
  end

  def type
    parse_input(:last, "int2")
  end

  private

  def parse_input(position_key, default_value)
    detected = @original_name.include?(DETECT_KEY)

    if detected
      sections = @original_name.split(DETECT_KEY)
      if sections.count == 2
        sections.send(position_key)
      else
        default_value
      end
    else
      default_value
    end
  end

end; end
