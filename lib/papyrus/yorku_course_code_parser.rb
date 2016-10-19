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


      if code.size == FULL_SIZE || code.size == EXTENDED_SIZE
        # check if right amount of underscores
        return true if code.count("_") == FULL_UNDERSCORE_COUNT || code.count("_") == EXTENDED_UNDERSCORE_COUNT
      end

      # doesn't match any, return false right away
      return false

    end

    ## Takes 2016_AP_POLS_Y_1000__6_C_EN_A_LECT_01 and makes it 2016_AP_POLS_Y_1000__6_C_EN_A
    def unique_code(extended_code)
      if valid?(extended_code)
        return extended_code[0..(FULL_SIZE-1)]
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

    private
    def get_value_from_code(code, position)
      code = "_______"   if code.blank?
      code.split("_")[position]
    end

  end
end
