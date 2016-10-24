require 'test_helper'
require Rails.root.join("lib", "papyrus", "yorku_course_code_parser.rb")

class Papyrus::YorkuCourseCodeParserTest < ActiveSupport::TestCase
  setup do
    @parser = Papyrus::YorkuCourseCodeParser.new
  end


  should "return true if code is valid, false otherwise" do
    assert @parser.valid?("2016_AP_POLS_Y_1000__6_C_EN_A_LECT_01"), "should be valid"
    assert @parser.valid?("2016_AP_POLS_Y_1000__6_C_EN_A_TUTR_04"), "Should be valid tutorial"

    assert @parser.valid?("2016_AP_POLS_Y_1000__6_C_EN_A"), "should be also be valid, since it's unique"

    assert ! @parser.valid?("POLS_2000"), "Not Valid"
    assert ! @parser.valid?("2016_AP_POLS_Y_1000_6_C_EN_A_LECT_01"), "should be not be valid, missing an _"

    assert ! @parser.valid?("nil"), "not valid"
    assert ! @parser.valid?(""), "not valid"
    assert ! @parser.valid?(nil), "not valid"
  end

  should "return a unique code from extended code or whatever was passed if extended code was not valid" do
    unique_code = "2016_AP_POLS_Y_1000__6_C_EN_A"
    extended_code = "2016_AP_POLS_Y_1000__6_C_EN_A_LECT_01"

    assert_equal unique_code, @parser.unique_code(extended_code), "should return unique code"
    assert_equal unique_code, @parser.unique_code(unique_code), "should return unique code"

    assert_equal "SOMETHING", @parser.unique_code("SOMETHING"), "should return passed string"

    # special case
    unique_code2 = "2016_AP_POLS_FW_1000__6_C_EN_A"
    extended_code2 = "2016_AP_POLS_FW_1000__6_C_EN_A_LECT_01"
    assert_equal unique_code2, @parser.unique_code(extended_code2), "should return unique code with FW"
  end

  should "return SHORT NAME for code, or the passed string if code was not valid" do
    unique_code = "2016_AP_POLS_Y_1000__6_C_EN_A"
    short_code = "POLS_1000"
    extended_code = "2016_AP_POLS_Y_1000__6_C_EN_A_LECT_01"

    assert_equal short_code, @parser.short_code(extended_code), "should return short code"
    assert_equal short_code, @parser.short_code(unique_code), "should return short code"

    assert_equal "SOMETHING", @parser.short_code("SOMETHING"), "should return passed string"
  end


  should "create an array of unique codes ready for use" do
    list = "2016_AP_POLS_Y_1000__6_C_EN_A_LECT_01, 2016_AP_POLS_Y_1000__6_C_EN_A_TUTR_01, 2016_AP_POLS_Y_1100__6_C_EN_A_LECT_01"

    unique_list = @parser.unique_codes_only(list)
    assert_equal 2, unique_list.size, "Should be two unique"
  end

  should "Retrun empty array if lists is empty or too short" do

    unique_list = @parser.unique_codes_only(nil)
    assert_equal 0, unique_list.size, "Should be 0"

    unique_list = @parser.unique_codes_only("2016_AP_POLS_Y_1000__6_C_EN")
    assert_equal 0, unique_list.size, "Should be 0"
  end

  should "Return 1 if one element is in the list" do
    list = "2016_AP_POLS_Y_1000__6_C_EN_A_LECT_01"

    unique_list = @parser.unique_codes_only(list)
    assert_equal 1, unique_list.size, "Should be one unique"
  end

  should "return term details when provided a code" do
    y_code = "2016_AP_POLS_Y_1000__6_C_EN_A"
    fw_code = "2016_AP_POLS_FW_1000__6_C_EN_A"
    f_code = "2016_AP_POLS_F_1000__6_C_EN_A"
    w_code = "2016_AP_POLS_W_1000__6_C_EN_A"
    s_code = "2016_AP_POLS_S_1000__6_C_EN_A"
    u_code = "2016_AP_POLS_U_1000__6_C_EN_A"



    term = @parser.term_details(y_code)
    year = @parser.code_year(y_code).to_i
    assert_equal term[:name], "Year #{year}-#{year + 1}"
    assert_equal term[:start_date], Date.parse("Sep 1, #{year}")
    assert_equal term[:end_date], Date.parse("May 15, #{year + 1}")

    term = @parser.term_details(fw_code)
    year = @parser.code_year(fw_code).to_i
    assert_equal term[:name], "Year #{year}-#{year + 1}"
    assert_equal term[:start_date], Date.parse("Sep 1, #{year}")
    assert_equal term[:end_date], Date.parse("May 15, #{year + 1}")

    term = @parser.term_details(f_code)
    year = @parser.code_year(f_code).to_i
    assert_equal term[:name], "Fall #{year}"
    assert_equal term[:start_date], Date.parse("Sep 1, #{year}")
    assert_equal term[:end_date], Date.parse("Jan 15, #{year + 1}")


    term = @parser.term_details(w_code)
    year = @parser.code_year(w_code).to_i
    assert_equal term[:name], "Winter #{year + 1}"
    assert_equal term[:start_date], Date.parse("Jan 1, #{year + 1}")
    assert_equal term[:end_date], Date.parse("May 15, #{year + 1}")

    term = @parser.term_details(s_code)
    year = @parser.code_year(s_code).to_i
    assert_equal term[:name], "Summer #{year + 1}"
    assert_equal term[:start_date], Date.parse("May 1, #{year + 1}")
    assert_equal term[:end_date], Date.parse("Sep 15, #{year + 1}")

    term = @parser.term_details(u_code)
    year = @parser.code_year(u_code).to_i
    assert_equal term[:name], "Full Year #{year}-#{year + 1}"
    assert_equal term[:start_date], Date.parse("Sep 1, #{year}")
    assert_equal term[:end_date], Date.parse("Sep 15, #{year + 1}")
  end



end
