# frozen_string_literal: true

require 'test_helper'

class AppointmentTest < ActiveSupport::TestCase
  should 'create a valid appointment' do
    a = build(:appointment)

    assert_difference 'Appointment.count', 1 do
      a.save
    end
  end
end
