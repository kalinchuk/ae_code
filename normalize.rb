# Ruby 2.6.5
require 'date'

class VehicleType
  VALID_YEARS = 1900..(Date.today.year+2)

  VALID_MAKES = {
    'Ford' => %w(ford fo),
    'Chevrolet' => %w(chevrolet chev)
  }.inject({}) do |make_options,(key,values)|
    values.each { |value| make_options[value] = key }
    make_options
  end.freeze

  VALID_MODELS = {
    'Focus' => %w(focus),
    'Impala' => %w(impala)
  }.inject({}) do |make_options,(key,values)|
    values.each { |value| make_options[value] = key }
    make_options
  end.freeze

  def initialize(data)
    @year = data[:year]
    @make = data[:make]
    @model = data[:model]
    @trim = data[:trim]
    normalize!
  end

  def to_hash
    { year: @year, make: @make, model: @model, trim: @trim }
  end

  private

  def normalize!
    valid = normalize_make
    valid = normalize_year if valid
    valid = normalize_model if valid
    valid = normalize_trim if valid
    valid
  end

  def normalize_make
    @make = VALID_MAKES[@make.downcase] if VALID_MAKES[@make.to_s.downcase]
  end

  def normalize_year
    @year = @year.to_i if VALID_YEARS === @year.to_i
  end

  def normalize_model
    sliced_model = @model.to_s.split[0..-2].join(' ').downcase
    if VALID_MODELS[@model.to_s.downcase]
      @model = VALID_MODELS[@model.downcase]
    elsif VALID_MODELS[sliced_model]
      @trim = @model.split[-1].to_s
      @model = VALID_MODELS[sliced_model]
    end
  end

  def normalize_trim
    @trim = nil if @trim.empty? || @trim == 'blank'
    @trim = @trim.upcase if @trim
  end
end

def normalize_data(input)
  VehicleType.new(input).to_hash
end

examples = [
  [{ :year => '2018', :make => 'fo', :model => 'focus', :trim => 'blank' },
   { :year => 2018, :make => 'Ford', :model => 'Focus', :trim => nil }],
  [{ :year => '200', :make => 'blah', :model => 'foo', :trim => 'bar' },
   { :year => '200', :make => 'blah', :model => 'foo', :trim => 'bar' }],
  [{ :year => '1999', :make => 'Chev', :model => 'IMPALA', :trim => 'st' },
   { :year => 1999, :make => 'Chevrolet', :model => 'Impala', :trim => 'ST' }],
  [{ :year => '2000', :make => 'ford', :model => 'focus se', :trim => '' },
   { :year => 2000, :make => 'Ford', :model => 'Focus', :trim => 'SE' }]
]

examples.each_with_index do |(input, expected_output), index|
  if (output = normalize_data(input)) == expected_output
    puts "Example #{index + 1} passed!"
  else
    puts "Example #{index + 1} failed,
          Expected: #{expected_output.inspect}
          Got:      #{output.inspect}"
  end
end