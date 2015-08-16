require 'test_helper'

class ModelTestCase < ActiveSupport::TestCase

  def time_on hours, minutes
    return DateTime.new(2015, 1, 1, hours, minutes, 0, 0).new_offset(0)
  end

  def deny an_expression, fail_message = 'expected false but was true'
    assert_equal false, an_expression, fail_message
  end

  def assert_times_equal a_date_time, another_date_time
    assert_equal a_date_time.to_datetime.new_offset(0), another_date_time.to_datetime.new_offset(0)
  end

end