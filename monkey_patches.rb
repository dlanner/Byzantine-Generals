class Array
  # http://stackoverflow.com/a/1909239/2954849
  def majority
    group_by { |i| i}.max { |x,y| x[1].length <=> y[1].length }[0]
  end
  
  def recursive_majority
    values = majority
    case values
    when Fixnum then values
    when Array then values.recursive_majority
    end
  end
end
