# Allow date objects to do offsets by a time unit
# Date.today + U"1 week" => gives today+1 week

require 'date'

class Date
  alias :unit_date_add :+
  def +(unit)
    case unit
    when Unit
      unit = unit.convert_to('d').round if ['y', 'decade', 'century'].include? unit.units 
      unit_date_add(unit.convert_to('day').scalar)
    else
      unit_date_add(unit)
    end
  end

 
  alias :unit_date_sub :-    
  def -(unit)
    case unit
    when Unit 
      unit = unit.convert_to('d').round if ['y', 'decade', 'century'].include? unit.units 
      unit_date_sub(unit.convert_to('day').scalar)
    else
      unit_date_sub(unit)
    end
  end
  
  def to_unit(other = nil)
    other ? Unit.new(self).convert_to(other) : Unit.new(self)
  end
  alias :unit :to_unit
  
  unless Date.instance_methods.include?(:to_time)
    def to_time
      Time.local(*ParseDate.parsedate(self.to_s))
    end
  end
  
  alias :units_datetime_inspect :inspect
  def inspect(raw = false)
    return self.units_datetime_inspect if raw
    self.to_s
  end
  
  unless Date.instance_methods.include?(:to_date)
    def to_date
      Date.civil(self.year, self.month, self.day)
    end
  end
  
end