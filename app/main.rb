require 'dry/monads'

class Main
  include Dry::Monads[:result, :do]
  def call(input)
    value = Integer(input)

    value = yield double(value)
    value = yield tripple(value)

    Success(value)
  end

  private

  def double(value)
    if value.even?
      Success(value * 2)
    else
      Failure(StandardError.new('not event'))
    end
  end

  def tripple(value)
    if value > 1
      Success(value * 3)
    else
      Success(StandardError.new('less then 1'))
    end
  end
end

main = Main.new
result = main.call(2)

puts result.value
puts 'Hello'
