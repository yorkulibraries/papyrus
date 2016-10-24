module Papyrus
  ## SAMPLE 2016_AP_POLS_Y_1000__6_C_EN_A_LECT_01, 2016_AP_POLS_Y_1000__6_C_EN_A_TUTR_04

  class YorkuCourseCodeParser
    EXTENDED_SIZE = 37
    FULL_SIZE = 29
    EXTENDED_UNDERSCORE_COUNT = 11
    FULL_UNDERSCORE_COUNT = 9

    ## Ensures the code is a valid code
    ## Simple string length and underscore count checks.
    def valid?(code)
      ## nil or empty return false right away
      return false if code == nil || code.size == 0


      if code.size == FULL_SIZE || code.size == FULL_SIZE + 1 || code.size == EXTENDED_SIZE || code.size == EXTENDED_SIZE + 1
        # check if right amount of underscores
        return true if code.count("_") == FULL_UNDERSCORE_COUNT || code.count("_") == EXTENDED_UNDERSCORE_COUNT
      end

      # doesn't match any, return false right away
      return false

    end

    ## Takes 2016_AP_POLS_Y_1000__6_C_EN_A_LECT_01 and makes it 2016_AP_POLS_Y_1000__6_C_EN_A
    def unique_code(extended_code)
      if valid?(extended_code)
        return extended_code[0..(FULL_SIZE-1)] if extended_code.size == EXTENDED_SIZE
        return extended_code[0..(FULL_SIZE)] if extended_code.size == EXTENDED_SIZE + 1
        return extended_code if extended_code.size < EXTENDED_SIZE
      else
        return extended_code
      end
    end

    ## TAKES A LIST 2016_AP_POLS_Y_1000__6_C_EN_A_LECT_01, 2016_AP_POLS_Y_1000__6_C_EN_A_TUTR_04 and returns 2016_AP_POLS_Y_1000__6_C_EN_A
    def unique_codes_only(code_list, separator=",")
      unique_list = Array.new

      if code_list != nil && code_list.size >= FULL_SIZE
        code_list.split(separator).each do |code|
          if valid?(code.strip)
            unique_list.push(unique_code(code.strip))
          end
        end
      end

      return unique_list.uniq
    end


    ## Takes 2016_AP_POLS_Y_1000__6_C_EN_A_LECT_01 and retursn POLS_1000
    def short_code(code)
      if valid?(code)
        return "#{get_value_from_code(code, 2)}_#{get_value_from_code(code,4)}"
      else
        return code
      end
    end


    def code_year(code)
      get_value_from_code(code, 0)
    end

    def code_term(code)
      get_value_from_code(code, 3)
    end


    def term_details(code)
      # F W FW Y S SU S1 S2
      year = code_year(code).to_i

      case code_term(code).upcase
      when "F"
        term_name = "Fall #{year}"
        start_date = Date.parse("Sep 1, #{year}")
        end_date = Date.parse("Jan 15, #{year + 1}")
      when "W"
        term_name = "Winter #{year + 1}"
        start_date = Date.parse("Jan 1, #{year + 1}")
        end_date = Date.parse("May 15, #{year + 1}")
      when "FW", "Y"
        term_name = "Year #{year}-#{year + 1}"
        start_date = Date.parse("Sep 1, #{year}")
        end_date = Date.parse("May 15, #{year + 1}")
      when "S", "SU", "S1", "S2"      
        term_name = "Summer #{year + 1}"
        start_date = Date.parse("May 1, #{year + 1}")
        end_date = Date.parse("Sep 15, #{year + 1}")
      else
        term_name = "Full Year #{year}-#{year + 1}"
        start_date = Date.parse("Sep 1, #{year}")
        end_date = Date.parse("Sep 15, #{year + 1}")
      end

      term = Hash.new
      term[:year] = year
      term[:name] = term_name
      term[:start_date] = start_date
      term[:end_date] = end_date

      return term
    end


    private
    def get_value_from_code(code, position)
      code = "_______"   if code.blank?
      code.split("_")[position]
    end

  end
end
